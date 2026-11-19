import 'models.dart';

class WorldStateValidator {
  WorldState validate(
    WorldState original,
    DialoguePacket packet,
    Set<String> allowedSpeakers, {
    String? destination,
  }) {
    final text =
        '${packet.narration}\n${packet.replies.map((r) => r['text']).join('\n')}';
    if (RegExp(r'你(决定|不由自主|心想|感到|答应了|掏出了|已经杀死)').hasMatch(text)) {
      throw const RoleplayFailure('回复替玩家作决定，整轮未提交。');
    }
    final speakers = packet.replies.map((r) => r['speaker'] as String).toList();
    if (speakers.toSet().length != speakers.length ||
        speakers.any((id) => !allowedSpeakers.contains(id))) {
      throw const RoleplayFailure('回复出现不在场或未获发言权的人物。');
    }
    // Secrets belonging to other characters never go into the active prompt.
    for (final c in original.characters.where(
      (c) => !allowedSpeakers.contains(c.id),
    )) {
      for (final secret in c.list('privateKnowledge')) {
        if (secret.length > 3 && text.contains(secret)) {
          throw const RoleplayFailure('回复包含无依据的私人信息，未提交。');
        }
      }
    }
    final p = packet.proposal;
    if (p.keys.any(
      (k) => !['minutes', 'npcMoves', 'playerLocation', 'events'].contains(k),
    )) {
      throw const RoleplayFailure('提案包含不支持的身份、物品或生死变更。');
    }
    final rawMinutes = p['minutes'] ?? 1;
    final minutes =
        rawMinutes is double &&
            rawMinutes.isFinite &&
            rawMinutes == rawMinutes.roundToDouble()
        ? rawMinutes.toInt()
        : rawMinutes;
    if (minutes is! int || minutes < 0 || minutes > 5) {
      throw const RoleplayFailure('世界时间变更不合法。');
    }
    final next = original.copy();
    if (p['playerLocation'] != null) {
      final target = p['playerLocation'];
      if (target != destination ||
          !(original.knownLocations[original.playerLocation] ?? []).contains(
            target,
          )) {
        throw const RoleplayFailure('玩家地点变更需要明确确认且必须相邻。');
      }
      next.data['playerLocation'] = target;
      next.data['currentLocation'] = target;
    }
    final moves = p['npcMoves'] ?? <dynamic>[];
    if (moves is! List || moves.length > 2) {
      throw const RoleplayFailure('人物移动提案无效。');
    }
    for (final move in moves) {
      if (move is! Map ||
          move.keys.any((k) => !['id', 'to', 'reason'].contains(k)) ||
          move['reason'] is! String ||
          (move['reason'] as String).trim().length < 4) {
        throw const RoleplayFailure('人物移动缺少明确原因。');
      }
      final found = original.characters.where((c) => c.id == move['id']);
      if (found.length != 1 ||
          found.single.data['alive'] == false ||
          !(original.knownLocations[found.single.currentLocation] ?? [])
              .contains(move['to'])) {
        throw const RoleplayFailure('人物不能瞬移或无原因复活。');
      }
      final characters = next.data['characters'] as List;
      (characters.firstWhere((c) => c['id'] == move['id'])
              as Map)['currentLocation'] =
          move['to'];
    }
    // Model-written events would be unverified claims. Only local verified turn IDs are facts.
    if (p['events'] != null &&
        (p['events'] is! List || (p['events'] as List).isNotEmpty)) {
      throw const RoleplayFailure('含糊事件不会直接作为世界事实写入。');
    }
    next.data['currentTime'] = original.currentTime
        .add(Duration(minutes: minutes))
        .toIso8601String();
    if (original.data['definitionVersion'] != null) {
      next.data['elapsedMinutes'] =
          (original.data['elapsedMinutes'] as int? ?? 0) + minutes;
    }
    next.data['revision'] = original.revision + 1;
    next.data['presentCharacters'] = next.presentCharacters
        .map((c) => c.id)
        .toList();
    return next;
  }
}

class WorldStateManager {
  String describe(WorldState s) => '${s.displayTime} · ${s.displayLocation}';
}
