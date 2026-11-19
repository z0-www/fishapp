import 'dart:convert';

import 'package:dio/dio.dart';

import 'narrative_preferences.dart';

class RoleplayFailure implements Exception {
  const RoleplayFailure(this.message, {this.source});
  final String? source;
  final String message;
  @override
  String toString() => message;
}

class TurnCancellation {
  final dio = CancelToken();
  bool cancelled = false;
  void cancel() {
    cancelled = true;
    dio.cancel();
  }

  void check() {
    if (cancelled) throw const RoleplayFailure('已停止生成，未修改世界。');
  }
}

class CharacterProfile {
  CharacterProfile(Map<String, dynamic> value) : data = Map.unmodifiable(value);
  final Map<String, dynamic> data;
  String get id => data['id'] as String;
  String get name => data['name'] as String? ?? '未命名人物';
  String get occupation => data['occupation'] as String? ?? '职业未设定';
  String get currentLocation => data['currentLocation'] as String? ?? '';
  List<String> list(String field) =>
      (data[field] as List? ?? []).cast<String>();
  Map<String, dynamic> toJson() => Map.of(data);
}

class WorldState {
  WorldState(Map<String, dynamic> value)
    : data = jsonDecode(jsonEncode(value)) as Map<String, dynamic>;
  final Map<String, dynamic> data;
  String get worldId => data['worldId'] as String;
  int get revision => (data['revision'] as num).toInt();
  String get playerLocation => data['playerLocation'] as String;
  DateTime get currentTime => DateTime.parse(data['currentTime'] as String);
  Map<String, List<String>> get knownLocations =>
      (data['knownLocations'] as Map).map(
        (k, v) => MapEntry(k as String, (v as List).cast<String>()),
      );
  List<CharacterProfile> get characters => (data['characters'] as List)
      .map((v) => CharacterProfile(Map<String, dynamic>.from(v as Map)))
      .toList();
  List<CharacterProfile> get presentCharacters => characters
      .where(
        (c) =>
            c.data['locationUnspecified'] != true &&
            c.currentLocation == playerLocation &&
            c.data['alive'] != false,
      )
      .toList();
  String get displayLocation =>
      playerLocation.isEmpty ? '地点未设定' : playerLocation;
  String get displayTime => data['definitionVersion'] == null
      ? currentTime.toIso8601String().replaceFirst('T', ' ').substring(0, 16)
      : '${data['calendarSystem'] ?? ''} ${data['worldDateTimeLabel'] ?? '时间未设定'}${(data['elapsedMinutes'] as int? ?? 0) > 0 ? ' · 已经过 ${data['elapsedMinutes']} 分钟（回合计时）' : ''}'
            .trim();
  WorldState copy() => WorldState(data);
}

class PersonalMemory {
  const PersonalMemory({
    required this.id,
    required this.owner,
    required this.text,
    required this.source,
    required this.turn,
    required this.importance,
    this.lastUsed = -100,
  });
  final String id, owner, text, source;
  final int turn, importance, lastUsed;
  Map<String, dynamic> toJson() => {
    'id': id,
    'owner': owner,
    'text': text,
    'source': source,
    'turn': turn,
    'importance': importance,
    'lastUsed': lastUsed,
  };
  factory PersonalMemory.fromJson(Map<String, dynamic> m) => PersonalMemory(
    id: m['id'] as String,
    owner: m['owner'] as String,
    text: m['text'] as String,
    source: m['source'] as String,
    turn: m['turn'] as int,
    importance: m['importance'] as int,
    lastUsed: m['lastUsed'] as int? ?? -100,
  );
}

class DialoguePacket {
  const DialoguePacket({
    required this.narration,
    required this.replies,
    required this.proposal,
  });
  final String narration;
  final List<Map<String, dynamic>> replies;
  final Map<String, dynamic> proposal;
  Map<String, dynamic> toJson() => {
    'narration': narration,
    'replies': replies,
    'proposal': proposal,
  };
  factory DialoguePacket.parse(
    String body, {
    Map<String, String> speakerAliases = const {},
  }) {
    if (body.length > 24000) {
      throw const RoleplayFailure('回复过长，未提交状态。');
    }
    var source = body.trim();
    if (source.isEmpty) {
      throw const RoleplayFailure('模型返回空内容（JSON 输出可能被过滤或截断），本轮未提交。');
    }
    // Accept a single outer Markdown fence. Other prose is a protocol error.
    final fence = RegExp(
      r'^```(?:json)?\s*([\s\S]*?)\s*```$',
      caseSensitive: false,
    ).firstMatch(source);
    if (fence != null) source = fence.group(1)!.trim();
    final Map<String, dynamic> m;
    try {
      final decoded = jsonDecode(source);
      if (decoded is! Map) throw const FormatException();
      m = Map<String, dynamic>.from(decoded);
    } catch (_) {
      throw const RoleplayFailure('模型输出不是有效 JSON；本轮未提交，请重试。');
    }
    try {
      if (m.keys.any(
        (k) => !['narration', 'replies', 'proposal'].contains(k),
      )) {
        throw const FormatException();
      }
      final rawNarration = m['narration'];
      final rawReplies = m['replies'];
      final rawProposal = m['proposal'];
      if (rawNarration != null && rawNarration is! String ||
          rawReplies != null && rawReplies is! List ||
          rawProposal != null && rawProposal is! Map) {
        throw const FormatException();
      }
      final replies = <Map<String, dynamic>>[];
      for (final value in rawReplies as List? ?? const []) {
        if (value is! Map) throw const FormatException();
        final reply = Map<String, dynamic>.from(value);
        final speaker = reply['speaker'], text = reply['text'];
        if (reply.keys.any((k) => !['speaker', 'text'].contains(k)) ||
            speaker is! String ||
            text is! String) {
          throw const FormatException();
        }
        final trimmed = speaker.trim();
        // Exact character-name aliases are safe; no fuzzy or positional IDs.
        reply['speaker'] = speakerAliases[trimmed] ?? trimmed;
        if ((reply['speaker'] as String).isEmpty) {
          throw const FormatException();
        }
        replies.add(reply);
      }
      final narration = rawNarration as String? ?? '';
      final visibleText = [
        narration,
        for (final reply in replies) reply['text'],
      ].join('\n');
      if (replies.length > 2 ||
          visibleText.length > 22000 ||
          NarrativePreferences.countWords(visibleText) > 6000 ||
          (narration.trim().isEmpty && replies.isEmpty)) {
        throw const FormatException();
      }
      return DialoguePacket(
        narration: narration,
        replies: replies,
        proposal: Map<String, dynamic>.from(rawProposal as Map? ?? const {}),
      );
    } catch (_) {
      throw const RoleplayFailure('回复协议无效；未提交正文或状态。');
    }
  }
}

class DialogueOutput {
  const DialogueOutput(
    this.body, {
    this.inputTokens,
    this.outputTokens,
    this.cacheTokens,
    this.model,
    this.issue,
    this.issueSource,
    this.httpStatus,
    this.elapsedMs,
  });
  final String body;
  final String? model, issue, issueSource;
  final int? inputTokens, outputTokens, cacheTokens, httpStatus, elapsedMs;
}

class TurnPlan {
  const TurnPlan({
    required this.id,
    required this.state,
    required this.action,
    required this.speaker,
    required this.messages,
    required this.memoryIds,
    required this.tokens,
    required this.mode,
    this.maxOutputTokens = 1200,
    this.destination,
    this.characterDefinitionVersion,
  });
  final String id, action, speaker, mode;
  final WorldState state;
  final List<Map<String, String>> messages;
  final List<String> memoryIds;
  final int tokens, maxOutputTokens;
  final String? destination;
  final int? characterDefinitionVersion;
}
