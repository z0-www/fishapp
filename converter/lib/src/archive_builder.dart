import 'dart:convert';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:crypto/crypto.dart';
import 'package:yuzhe_codec/yuzhe_codec.dart';

import 'models.dart';
import 'parser.dart';

class ConversionOutput {
  ConversionOutput({
    required this.bytes,
    required this.fileName,
    required this.title,
    required this.messageCount,
    required this.warnings,
  });
  final Uint8List bytes;
  final String fileName;
  final String title;
  final int messageCount;
  final List<String> warnings;
}

class MultiConversionOutput {
  MultiConversionOutput({required this.bytes, required this.fileName, required this.count});
  final Uint8List bytes;
  final String fileName;
  final int count;
}

const _converterVersion = '1.2.1';
const _converterName = '鱼者文离线对话转换器';
const _maxArchiveBody = 32 * 1024 * 1024;

/// Builds a `.yuzhe` archive that follows the app's v1 backup schema.
///
/// Messages are preserved verbatim. The world and NPC sections are deliberately
/// minimal: Chatbox conversations do not contain a FishTextAdventure world,
/// so the converter does not invent NPCs, locations or memories. Generated
/// defaults are named in `customFields.converter.generatedDefaults`.
Future<ConversionOutput> buildYuzhe(
  ConvertSession session, {
  String? password,
  DateTime? now,
}) async {
  final clock = now ?? DateTime.now();
  final raw = session.messages;
  if (raw.isEmpty) {
    throw const ConversionException('会话没有消息，未生成归档。');
  }
  var bodyBytes = 0;
  for (final message in raw) {
    bodyBytes += utf8.encode(message.content).length;
    if (containsCredential(message.content)) {
      throw const ConversionException(
        '对话正文包含疑似 API Key；已停止，不会把密钥写进 .yuzhe。',
      );
    }
    if (containsCredential(message.rawJson)) {
      throw const ConversionException(
        '消息元数据包含疑似 API Key；已停止。请先在源导出中移除该字段。',
      );
    }
  }
  if (bodyBytes > _maxArchiveBody) {
    throw const ConversionException('消息正文合计超过 32 MiB，未生成归档。');
  }

  final safeTitle = _title(session.title);
  final description =
      '由$_converterName 从 ${session.format} 导入。源对话没有提供完整世界设定；'
      '世界背景、地点、NPC、规则和记忆未由转换器编造，当前保持未设定。';
  final worldId = 'converter-${_digest(session, raw)}';
  final conversationId = 'conversation-$worldId';
  final jobId = 'converter-job-$worldId';
  final checkpointId = 'checkpoint-$worldId';
  final nowMs = clock.millisecondsSinceEpoch;
  final nowSeconds = nowMs ~/ 1000;
  final createdAtMs = _dateMillis(session.createdAt) ?? nowMs;
  final createdAt = createdAtMs ~/ 1000;
  final definition = <String, dynamic>{
    'id': worldId,
    'schemaVersion': 1,
    'title': safeTitle,
    'description': description,
    'genreTags': const ['导入对话'],
    'era': null,
    'calendarSystem': null,
    'worldDateTime': null,
    'startingLocation': null,
    'playerProfile': null,
    'worldRules': const <Map<String, dynamic>>[],
    'characterProfiles': const <Map<String, dynamic>>[],
    'locationProfiles': const <Map<String, dynamic>>[],
    'relationships': const <Map<String, dynamic>>[],
    'narrativePreferences': null,
    'openingScene': null,
    'customFields': {
      'converter': {
        'name': _converterName,
        'version': _converterVersion,
        'sourceFormat': session.format,
        'sourceFile': session.sourceName,
        'sourceSessionId': session.id,
        'sourceModel': session.model,
        'sourceCreatedAt': session.createdAt,
        'generatedDefaults': const [
          'worldId',
          'description',
          'genreTags',
          'emptyCharacters',
          'emptyLocations',
          'emptyWorldRules',
          'emptyMemories',
          'currentTime',
          'startingLocation',
        ],
        'note': '世界/NPC/记忆未由转换器编造；只保留原始对话消息。',
      },
    },
    'createdAt': DateTime.fromMillisecondsSinceEpoch(createdAtMs).toUtc().toIso8601String(),
    'updatedAt': clock.toUtc().toIso8601String(),
  };

  final state = <String, dynamic>{
    'worldId': worldId,
    'revision': 0,
    'definitionVersion': 1,
    'definitionSnapshot': definition,
    'currentTime': DateTime.utc(1970).toIso8601String(),
    'elapsedMinutes': 0,
    'worldDateTimeLabel': null,
    'calendarSystem': null,
    'currentLocation': '',
    'playerLocation': '',
    'playerProfile': null,
    'characters': const <Map<String, dynamic>>[],
    'presentCharacters': const <String>[],
    'knownLocations': <String, List<String>>{},
    'knownItems': <String, dynamic>{},
    'importantEvents': const <String>[],
    'activePlotThreads': const <String>[],
    'worldRules': const <Map<String, dynamic>>[],
    'openingScene': null,
    'recovery': {
      'conversationId': conversationId,
      'nodeId': raw.last.id,
      'factCount': 0,
      'unknownCount': 0,
    },
    'recoveredFacts': const <Map<String, dynamic>>[],
    'importedRecent': [
      for (final message in raw
          .where((m) => m.role == 'user' || m.role == 'assistant')
          .toList()
          .reversed
          .take(6)
          .toList()
          .reversed)
        {'id': message.id, 'role': message.role, 'content': message.content},
    ],
    'importedRecentPublic': true,
    'importedStoryExcerpt': [
      for (final message in raw
          .where((m) => m.role == 'user' || m.role == 'assistant')
          .toList()
          .reversed
          .take(4)
          .toList()
          .reversed)
        {'id': message.id, 'role': message.role, 'text': message.content},
    ],
  };

  final rows = <Map<String, Object?>>[
    {'primary': worldId},
    {
      'table': 'worlds',
      'row': {
        'id': worldId,
        'title': safeTitle,
        'genre': '导入对话',
        'summary': description,
        'created_at': createdAt,
      },
    },
    {
      'table': 'pending_imports',
      'row': {
        'id': jobId,
        'fingerprint': _digest(session, raw),
        'payload': jsonEncode({
          'id': jobId,
          'source': 'converter',
          'receivedAt': nowMs,
          'text': '',
          'mime': 'text/plain',
          'files': const [],
          'error': null,
        }),
        'state': 'saved',
        'safe_error': null,
        'received_at': nowSeconds,
      },
    },
    {
      'table': 'imported_conversations',
      'row': {
        'id': conversationId,
        'job_id': jobId,
        'title': safeTitle,
        'source': 'converter',
        'world_id': worldId,
        'current_message_id': raw.last.id,
        'created_at': createdAt,
      },
    },
    for (final entry in raw.indexed)
      {
        'table': 'imported_messages',
        'row': {
          'conversation_id': conversationId,
          'message_id': entry.$2.id,
          'parent_id': _parentId(raw, entry.$1),
          'role': entry.$2.role,
          'body': entry.$2.content,
          'raw_json': _sanitizeRaw(entry.$2.rawJson),
          'ordinal': entry.$1,
        },
      },
    {
      'table': 'derived_import_results',
      'row': {
        'id': 1,
        'conversation_id': conversationId,
        'derived_json': jsonEncode({
          'type': 'converter-v1',
          'converter': _converterName,
          'version': _converterVersion,
          'sourceFormat': session.format,
          'sourceFile': session.sourceName,
          'warnings': session.warnings,
        }),
        'created_at': nowSeconds,
      },
    },
    {
      'table': 'roleplay_saves',
      'row': {
        'world_id': worldId,
        'revision': 0,
        'payload': jsonEncode(state),
      },
    },
    {
      'table': 'world_definitions',
      'row': {
        'world_id': worldId,
        'version': 1,
        'payload': jsonEncode(definition),
        'saved_at': nowSeconds,
      },
    },
    {
      'table': 'story_checkpoints',
      'row': {
        'id': checkpointId,
        'world_id': worldId,
        'revision': 0,
        'payload': jsonEncode({'state': state, 'memories': const []}),
        'source_conversation': conversationId,
        'source_message_id': raw.last.id,
        'created_at': nowSeconds,
      },
    },
    {
      'table': 'story_branches',
      'row': {
        'world_id': worldId,
        'parent_world_id': null,
        'checkpoint_id': checkpointId,
        'source_conversation': conversationId,
        'source_message_id': raw.last.id,
      },
    },
    for (final entry in raw.indexed)
      {
        'table': 'timeline_entries',
        'row': {
          'id': '$worldId-source-${entry.$1.toString().padLeft(6, '0')}',
          'world_id': worldId,
          'revision': 0,
          'payload': jsonEncode({
            'category': 'source',
            'kind': 'record',
            'sourceRole': entry.$2.role,
            'text': entry.$2.content,
            if (entry.$2.timestamp != null) 'sourceTimestamp': entry.$2.timestamp,
            'sourceMessageIds': [entry.$2.id],
            'sourceOrdinal': entry.$1,
            'converter': _converterName,
          }),
        },
      },
  ];

  final bytes = await YuzheCodec.encode(
    Stream<Map<String, Object?>>.fromIterable(rows),
    password: password,
  );
  final safeName = _fileName(safeTitle);
  return ConversionOutput(
    bytes: bytes,
    fileName: '$safeName.yuzhe',
    title: safeTitle,
    messageCount: raw.length,
    warnings: [...session.warnings],
  );
}

/// Packages multiple `.yuzhe` files into one ZIP for multi-session exports.
Future<MultiConversionOutput> buildYuzheZip(
  List<ConvertSession> sessions, {
  String? password,
  DateTime? now,
}) async {
  if (sessions.isEmpty) throw const ConversionException('没有选中会话。');
  final archive = Archive();
  final used = <String>{};
  final warnings = <String>[];
  for (final session in sessions) {
    final output = await buildYuzhe(session, password: password, now: now);
    var name = output.fileName;
    var suffix = 2;
    while (!used.add(name)) {
      name = '${_fileName(output.title)}-$suffix.yuzhe';
      suffix++;
    }
    archive.addFile(ArchiveFile(name, output.bytes.length, output.bytes));
    warnings.addAll(output.warnings.map((w) => '${output.title}: $w'));
  }
  final zipped = ZipEncoder().encode(archive);
  return MultiConversionOutput(
    bytes: Uint8List.fromList(zipped),
    fileName: '鱼者文游-转换结果-${sessions.length}个会话.zip',
    count: sessions.length,
  );
}

/// Builds one container with one linked world per selected session.
///
/// Unlike the ZIP bundle, this file is accepted directly by the main app's
/// `StoryBackup` restore page and creates all selected worlds in one import.
Future<ConversionOutput> buildYuzheBundle(
  List<ConvertSession> sessions, {
  String? password,
  DateTime? now,
}) async {
  if (sessions.isEmpty) throw const ConversionException('没有选中会话。');
  const tableOrder = <String>[
    'worlds',
    'pending_imports',
    'imported_conversations',
    'imported_messages',
    'imported_attachments',
    'derived_import_results',
    'roleplay_saves',
    'roleplay_turns',
    'roleplay_memories',
    'world_definitions',
    'story_checkpoints',
    'story_branches',
    'timeline_entries',
    'context_summaries',
  ];
  final byTable = <String, List<Map<String, Object?>>>{};
  final warnings = <String>[];
  String? primary;
  var messageCount = 0;
  for (final session in sessions) {
    final one = await buildYuzhe(session, password: password, now: now);
    messageCount += one.messageCount;
    warnings.addAll(one.warnings.map((w) => '${one.title}: $w'));
    final rows = <Map<String, Object?>>[];
    await YuzheCodec.decode(
      one.bytes,
      (row) async => rows.add(row),
      password: password,
    );
    for (final row in rows) {
      if (row['primary'] case final String value) {
        primary ??= value;
        continue;
      }
      final table = row['table'];
      if (table is! String || !tableOrder.contains(table)) {
        throw const ConversionException('内部归档结构不完整，未生成合并归档。');
      }
      byTable.putIfAbsent(table, () => []).add(row);
    }
  }
  if (primary == null) {
    throw const ConversionException('没有可合并的世界。');
  }
  final records = <Map<String, Object?>>[
    {'primary': primary},
    for (final table in tableOrder)
      ...?byTable[table],
  ];
  final bytes = await YuzheCodec.encode(
    Stream<Map<String, Object?>>.fromIterable(records),
    password: password,
  );
  return ConversionOutput(
    bytes: bytes,
    fileName: '鱼者文游-多会话合并-${sessions.length}个会话.yuzhe',
    title: '多会话合并',
    messageCount: messageCount,
    warnings: warnings,
  );
}

String? _parentId(List<ConvertMessage> messages, int index) {
  if (index == 0) return null;
  final rawParent = messages[index].parentId;
  if (rawParent != null) {
    for (final candidate in messages.take(index)) {
      if (candidate.originalId == rawParent) return candidate.id;
    }
  }
  return messages[index - 1].id;
}

String _title(String value) {
  final clean = value.replaceAll(RegExp(r'[\r\n\t]+'), ' ').trim();
  if (clean.isEmpty) return 'Chatbox 对话';
  final runes = clean.runes.toList();
  return String.fromCharCodes(runes.take(100));
}

String _fileName(String title) {
  final clean = title
      .replaceAll(RegExp(r'[\\/:*?"<>|\r\n\t]'), '_')
      .replaceAll(RegExp(r'\s+'), ' ')
      .trim();
  if (clean.isEmpty) return '鱼者文游-对话导入';
  final runes = clean.runes.toList();
  return String.fromCharCodes(runes.take(80));
}

String _digest(ConvertSession session, List<ConvertMessage> messages) {
  final value = [
    session.sourceName,
    session.id,
    session.title,
    messages.length,
    messages.isEmpty ? '' : messages.first.content,
    messages.isEmpty ? '' : messages.last.content,
  ].join('\u0000');
  return sha256.convert(utf8.encode(value)).toString().substring(0, 16);
}

int? _dateMillis(String? value) {
  if (value == null) return null;
  final parsed = DateTime.tryParse(value);
  if (parsed != null) return parsed.millisecondsSinceEpoch;
  final number = int.tryParse(value);
  if (number == null) return null;
  return number > 100000000000 ? number : number * 1000;
}

String _sanitizeRaw(String rawJson) {
  try {
    final decoded = jsonDecode(rawJson);
    return jsonEncode(_scrub(decoded));
  } catch (_) {
    return rawJson;
  }
}

Object? _scrub(Object? value) {
  const forbidden = {
    'authorization',
    'apikey',
    'api_key',
    'access_token',
    'refresh_token',
    'cookie',
    'password',
    'bearer',
  };
  if (value is Map) {
    return {
      for (final entry in value.entries)
        if (!forbidden.contains(entry.key.toString().toLowerCase().replaceAll(RegExp(r'[_-]'), '')))
          entry.key: _scrub(entry.value),
    };
  }
  if (value is List) return value.map(_scrub).toList();
  return value;
}
