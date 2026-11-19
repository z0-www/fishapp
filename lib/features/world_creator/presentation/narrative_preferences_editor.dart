import 'package:material_ui/material_ui.dart';

import '../../roleplay/domain/narrative_preferences.dart';
import '../../roleplay/presentation/narration_controls.dart';

class NarrativePreferencesEditor extends StatelessWidget {
  const NarrativePreferencesEditor({
    super.key,
    required this.value,
    required this.onChanged,
    this.enabled = true,
    this.inherited,
    this.initiallyExpanded = false,
  });
  final Map<String, dynamic> value;
  final bool enabled;
  final bool initiallyExpanded;
  final Map<String, dynamic>? inherited;
  final ValueChanged<Map<String, dynamic>> onChanged;
  @override
  Widget build(BuildContext context) {
    final inherited = this.inherited;
    final override = NarrativePreferences.keys.any(value.containsKey);
    return ExpansionTile(
      title: const Text('叙事表现偏好'),
      tilePadding: EdgeInsets.zero,
      initiallyExpanded: initiallyExpanded,
      children: [
        if (inherited != null)
          SwitchListTile(
            title: const Text('使用此世界的叙事设置'),
            subtitle: const Text('关闭时继承全局的字数、人称和风格'),
            contentPadding: EdgeInsets.zero,
            value: override,
            onChanged: !enabled
                ? null
                : (enabled) {
                    final next = {...value};
                    if (enabled) {
                      next.addAll(
                        NarrativePreferences.resolve([inherited, value])
                            .toJson(),
                      );
                    } else {
                      NarrativePreferences.keys.forEach(next.remove);
                    }
                    onChanged(next);
                  },
          ),
        NarrationControls(
          value: NarrativePreferences.resolve([inherited ?? {}, value]),
          enabled: enabled && (inherited == null || override),
          onChanged: (fields) => onChanged({...value, ...fields}),
        ),
        const SizedBox(height: 16),
        DropdownButtonFormField<String>(
          initialValue: const ['轻松日常', '写实剧情', '成熟题材'].contains(value['tone'])
              ? value['tone'] as String
              : null,
          decoration: const InputDecoration(labelText: '剧情取向（可不设定）'),
          items: const [
            '轻松日常',
            '写实剧情',
            '成熟题材',
          ].map((v) => DropdownMenuItem(value: v, child: Text(v))).toList(),
          onChanged: enabled ? (v) => onChanged({...value, 'tone': v}) : null,
        ),
        for (final entry in const {
          'emotionIntensity': '情感表达强度',
          'conflictIntensity': '冲突强度',
          'horrorIntensity': '恐怖氛围',
          'detailLevel': '描写详细度',
        }.entries)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${entry.value}：${value[entry.key] ?? '未设定'}'),
              Slider(
                value: value[entry.key] is num
                    ? (value[entry.key] as num).clamp(0, 4).toDouble()
                    : 2,
                min: 0,
                max: 4,
                divisions: 4,
                label: value[entry.key]?.toString() ?? '未设定',
                onChanged: enabled
                    ? (v) => onChanged({...value, entry.key: v.round()})
                    : null,
                semanticFormatterCallback: (v) => '${entry.value} ${v.round()}',
              ),
              if (value.containsKey(entry.key))
                TextButton(
                  onPressed: enabled
                      ? () => onChanged({...value}..remove(entry.key))
                      : null,
                  child: const Text('恢复未设定'),
                ),
            ],
          ),
        const Text('仅影响合规虚构表达，不关闭必要限制或改变上游服务规则。成熟题材不代表露骨性内容。'),
      ],
    );
  }
}
