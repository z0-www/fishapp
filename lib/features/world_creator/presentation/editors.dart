import 'package:material_ui/material_ui.dart';

import '../../roleplay/domain/models.dart';

Future<Map<String, dynamic>?> editFreeFields(
  BuildContext context, {
  required String title,
  required Map<String, String> fields,
  Map<String, dynamic>? initial,
  Set<String> lists = const {},
  bool npc = false,
  bool rule = false,
}) => showDialog<Map<String, dynamic>>(
  context: context,
  builder: (_) => _FreeEditor(
    title: title,
    fields: fields,
    initial: initial,
    lists: lists,
    npc: npc,
    rule: rule,
  ),
);

class _FreeEditor extends StatefulWidget {
  const _FreeEditor({
    required this.title,
    required this.fields,
    this.initial,
    this.lists = const {},
    this.npc = false,
    this.rule = false,
  });
  final String title;
  final Map<String, String> fields;
  final Map<String, dynamic>? initial;
  final Set<String> lists;
  final bool npc, rule;
  @override
  State<_FreeEditor> createState() => _FreeEditorState();
}

class _FreeEditorState extends State<_FreeEditor> {
  late final Map<String, TextEditingController> inputs;
  late bool present;
  late String kind;
  @override
  void initState() {
    super.initState();
    inputs = {
      for (final k in widget.fields.keys)
        k: TextEditingController(
          text: widget.initial?[k] is List
              ? (widget.initial![k] as List).join('\n')
              : widget.initial?[k] is Map
              ? (widget.initial![k] as Map)['description']?.toString() ?? ''
              : widget.initial?[k]?.toString() ?? '',
        ),
    };
    present = widget.initial?['presentAtOpening'] == true;
    kind = widget.initial?['kind'] as String? ?? 'fact';
  }

  @override
  void dispose() {
    for (final c in inputs.values) {
      c.dispose();
    }
    super.dispose();
  }

  void save() {
    final result = Map<String, dynamic>.from(widget.initial ?? {});
    result['id'] ??= 'entry-${DateTime.now().microsecondsSinceEpoch}';
    for (final e in inputs.entries) {
      final value = e.value.text.trim();
      if (value.isEmpty) {
        result.remove(e.key);
      } else if (widget.lists.contains(e.key)) {
        result[e.key] = value
            .split('\n')
            .map((s) => s.trim())
            .where((s) => s.isNotEmpty)
            .toList();
      } else if (e.key == 'relationshipToPlayer') {
        result[e.key] = {...?result[e.key] as Map?, 'description': value};
      } else {
        result[e.key] = value;
      }
    }
    if (widget.npc) result['presentAtOpening'] = present;
    if (widget.rule) result['kind'] = kind;
    Navigator.pop(context, result);
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: Text(widget.title),
    content: SizedBox(
      width: 500,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('可以只填部分内容；空白表示尚未设定。'),
            if (widget.rule)
              DropdownButtonFormField<String>(
                initialValue: kind,
                items: const [
                  DropdownMenuItem(value: 'fact', child: Text('不可随意违反的世界事实')),
                  DropdownMenuItem(
                    value: 'preference',
                    child: Text('可调整的创作偏好'),
                  ),
                  DropdownMenuItem(value: 'open', child: Text('尚未确定的开放设定')),
                ],
                onChanged: (v) => setState(() => kind = v!),
              ),
            for (final e in widget.fields.entries)
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: TextField(
                  controller: inputs[e.key],
                  minLines: 1,
                  maxLines: 4,
                  maxLength: 4000,
                  decoration: InputDecoration(
                    labelText: e.value,
                    helperText: widget.lists.contains(e.key)
                        ? '多项内容可以分行填写'
                        : null,
                  ),
                ),
              ),
            if (widget.npc)
              CheckboxListTile(
                value: present,
                onChanged: (v) => setState(() => present = v!),
                title: const Text('明确设为初始场景中的在场人物'),
                subtitle: const Text('未勾选且未填地点时，不猜测人物在哪里。'),
              ),
          ],
        ),
      ),
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: const Text('取消'),
      ),
      FilledButton(onPressed: save, child: const Text('保存设定')),
    ],
  );
}

class CharacterEditor {
  static Future<CharacterProfile?> open(
    BuildContext context, {
    CharacterProfile? character,
  }) async {
    final result = await editFreeFields(
      context,
      title: '人物设定',
      npc: true,
      initial: character?.toJson(),
      fields: const {
        'name': '姓名',
        'age': '年龄（可自由描述）',
        'gender': '性别（可不填）',
        'occupation': '身份 / 职业',
        'background': '人物背景',
        'personalityTraits': '性格特点',
        'values': '价值观',
        'beliefs': '观点与信念',
        'personalGoals': '个人目标',
        'fears': '担忧',
        'desires': '愿望',
        'likes': '喜好',
        'dislikes': '不喜欢的事',
        'speechStyle': '语言风格',
        'speechExamples': '示例台词',
        'emotionalState': '初始情绪',
        'relationshipToPlayer': '与玩家的初始关系',
        'currentLocation': '初始地点',
        'currentActivity': '正在做的事',
        'privateKnowledge': '私人秘密（只给此人物）',
        'publicKnowledge': '公开知识',
        'knownCharacters': '认识的人物',
        'personalMemories': '用户预设的个人经历',
      },
      lists: const {
        'personalityTraits',
        'values',
        'beliefs',
        'personalGoals',
        'fears',
        'desires',
        'likes',
        'dislikes',
        'speechExamples',
        'privateKnowledge',
        'publicKnowledge',
        'knownCharacters',
        'personalMemories',
      },
    );
    return result == null ? null : CharacterProfile(result);
  }
}

class WorldRuleEditor {
  static Future<Map<String, dynamic>?> open(
    BuildContext context, {
    Map<String, dynamic>? initial,
  }) => editFreeFields(
    context,
    title: '世界规则',
    rule: true,
    initial: initial,
    fields: const {'category': '分类（例如力量、科技、社会、历史、禁止事项）', 'text': '规则内容'},
  );
}

class LocationEditor {
  static Future<Map<String, dynamic>?> open(
    BuildContext context, {
    Map<String, dynamic>? initial,
  }) => editFreeFields(
    context,
    title: '地点设定',
    initial: initial,
    fields: const {
      'name': '地点名称',
      'description': '地点介绍',
      'region': '所属区域',
      'importantCharacters': '重要人物',
      'specialRules': '特殊规则',
      'connections': '可以直接前往的地点名称',
    },
    lists: const {'importantCharacters', 'connections'},
  );
}

class PlayerEditor {
  static Future<Map<String, dynamic>?> open(
    BuildContext context, {
    Map<String, dynamic>? initial,
  }) => editFreeFields(
    context,
    title: '玩家身份',
    initial: initial,
    fields: const {
      'name': '姓名',
      'age': '年龄',
      'appearance': '外貌',
      'identity': '身份',
      'occupation': '职业',
      'background': '背景',
      'abilities': '能力',
      'items': '随身物品',
      'goals': '个人目标',
      'customText': '自由补充设定',
    },
  );
}
