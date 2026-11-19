import 'models.dart';

class CharacterEngine {
  static const _editableProfileFields = [
    'name',
    'age',
    'gender',
    'occupation',
    'background',
    'personalityTraits',
    'values',
    'beliefs',
    'personalGoals',
    'fears',
    'desires',
    'likes',
    'dislikes',
    'speechStyle',
    'speechExamples',
    'publicKnowledge',
    'knownCharacters',
    'personalMemories',
  ];

  // The saved scene still owns location, activity, relationships and any
  // other state that can evolve after the world opens.
  Map<String, dynamic> applyProfileEdit(
    CharacterProfile inStory,
    CharacterProfile authored,
  ) => inStory.toJson()
    ..addEntries(
      [
        ..._editableProfileFields,
        'privateKnowledge',
      ].map((field) => MapEntry(field, authored.data[field])),
    );

  Map<String, dynamic> card(CharacterProfile c) => {
    for (final k in [
      'id',
      ..._editableProfileFields,
      'emotionalState',
      'relationshipToPlayer',
      'currentActivity',
    ])
      k: c.data[k],
  };
}

class CharacterDecisionEngine {
  String decide(CharacterProfile c, String action) {
    final trust =
        (c.data['relationshipToPlayer'] as Map?)?['trust'] as int? ?? 0;
    final risk =
        action.contains('全部') ||
        action.contains('秘密') ||
        action.contains('保证') ||
        action.contains('交给');
    if (risk && trust < 2) {
      return c.list('values').contains('保密')
          ? '追问依据，隐去私人资料；不要无理由敌视'
          : '提出条件，先核实风险与收益';
    }
    if (action.contains('承诺')) return '记录亲自听到的承诺，不把承诺当已兑现事实';
    if (RegExp(r'难过|伤心|失落|哭|低落').hasMatch(action)) {
      return '注意情绪线索，按本人性格与当前关系回应，不强制安慰或和解；不替玩家定义感受';
    }
    if (RegExp(r'喜欢|想念|拥抱|爱你').hasMatch(action)) {
      return '按既有关系、本人意愿和边界回应亲近；不自动提升关系，也不无理由敌视';
    }
    return c.list('personalGoals').isEmpty
        ? '按自己的职业与情绪简短回应'
        : '围绕目标“${c.list('personalGoals').first}”行动；可以自然结束或提出问题';
  }

  List<CharacterProfile> speakers(WorldState state, String? addressed) {
    final present = state.presentCharacters;
    if (addressed != null) {
      return present.where((c) => c.id == addressed).take(1).toList();
    }
    final ordered = List<CharacterProfile>.of(present)
      ..sort((a, b) => a.id.compareTo(b.id));
    return ordered.take(1).toList();
  }
}
