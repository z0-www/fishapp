import 'dart:convert';

import '../../roleplay/domain/models.dart';

class WorldDraft {
  WorldDraft(Map<String, dynamic> data)
    : data = jsonDecode(jsonEncode(data)) as Map<String, dynamic>;
  final Map<String, dynamic> data;
  String get id => data['id'] as String;
  String get conversationId => data['conversationId'] as String;
  String get nodeId => data['nodeId'] as String;
  List<Map<String, dynamic>> get facts => (data['facts'] as List? ?? [])
      .map((v) => Map<String, dynamic>.from(v as Map))
      .toList();
  WorldDraft copy() => WorldDraft(data);
  static const categories = [
    'background',
    'rule',
    'player',
    'npc',
    'relationship',
    'event',
    'promise',
    'secret',
    'item',
    'time',
    'location',
    'thread',
    'scene',
    'unknown',
  ];
  static const kinds = [
    'fact',
    'utterance',
    'inference',
    'rumor',
    'unconfirmed',
    'conflict',
  ];
  static const kindLabels = {
    'fact': '已核实事实',
    'utterance': '人物原话',
    'inference': '推测',
    'rumor': '传闻',
    'unconfirmed': '未确认',
    'conflict': '存在冲突',
  };
  static const labels = {
    'background': '世界背景',
    'rule': '世界硬规则',
    'player': '玩家身份',
    'npc': '人物姓名',
    'relationship': '人物关系',
    'event': '已发生事件',
    'promise': '承诺',
    'secret': '秘密',
    'item': '重要物品',
    'time': '当前时间',
    'location': '当前地点',
    'thread': '未解伏笔',
    'scene': '当前场景',
    'unknown': '未确认内容',
  };
  void validate(Set<String> sourceIds) {
    final ids = <String>{};
    for (final f in facts) {
      if (f['id'] is! String ||
          !ids.add(f['id'] as String) ||
          !['public', 'private', 'unreviewed'].contains(f['visibility'])) {
        throw const RoleplayFailure('审核项编号或可见范围无效。');
      }
      if (!categories.contains(f['category']) ||
          !kinds.contains(f['kind']) ||
          f['text'] is! String ||
          (f['text'] as String).length > 6000 ||
          f['sourceMessageIds'] is! List ||
          (f['sourceMessageIds'] as List).isEmpty ||
          (f['sourceMessageIds'] as List).any(
            (id) => !sourceIds.contains(id),
          ) ||
          f['confidence'] is! num ||
          (f['confidence'] as num) < 0 ||
          (f['confidence'] as num) > 1 ||
          f['owners'] is! List ||
          (f['owners'] as List).any((id) => id is! String)) {
        throw const RoleplayFailure('整理结果缺少有效出处、可信度或知情范围；未应用。');
      }
      if (f['category'] == 'secret' && f['visibility'] == 'public') {
        throw const RoleplayFailure('秘密不得自动公开。');
      }
    }
  }
}

class StoryCheckpoint {
  const StoryCheckpoint(
    this.id,
    this.state,
    this.memorySnapshot,
    this.sourceConversation,
    this.sourceMessageId,
  );
  final String id;
  final WorldState state;
  final List<Map<String, dynamic>> memorySnapshot;
  final String? sourceConversation, sourceMessageId;
}

class WorldSnapshot {
  const WorldSnapshot(this.state);
  final WorldState state;
}

class ConversationBranch {
  const ConversationBranch(
    this.worldId,
    this.parentWorldId,
    this.sourceMessageId,
  );
  final String worldId;
  final String? parentWorldId, sourceMessageId;
}
