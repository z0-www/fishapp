import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';

import '../domain/narrative_preferences.dart';

class NarrationControls extends StatefulWidget {
  const NarrationControls({
    super.key,
    required this.value,
    required this.onChanged,
    this.enabled = true,
  });

  final NarrativePreferences value;
  final ValueChanged<Map<String, dynamic>> onChanged;
  final bool enabled;

  @override
  State<NarrationControls> createState() => _NarrationControlsState();
}

class _NarrationControlsState extends State<NarrationControls> {
  late final _words = TextEditingController(
    text: widget.value.targetWords.toString(),
  );

  @override
  void didUpdateWidget(covariant NarrationControls oldWidget) {
    super.didUpdateWidget(oldWidget);
    final words = widget.value.targetWords;
    if (words != oldWidget.value.targetWords &&
        int.tryParse(_words.text) != words) {
      _words.text = '$words';
    }
  }

  @override
  void dispose() {
    _words.dispose();
    super.dispose();
  }

  void _change(String key, Object value) => widget.onChanged({key: value});

  @override
  Widget build(BuildContext context) {
    final value = widget.value;
    const minimum = NarrativePreferences.minWords;
    const maximum = NarrativePreferences.maxWords;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: _words,
          enabled: widget.enabled,
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.done,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(4),
          ],
          decoration: const InputDecoration(
            labelText: '目标字数（100–3000）',
            suffixText: '字',
          ),
          onChanged: (text) {
            final number = int.tryParse(text);
            if (number != null && number >= minimum && number <= maximum) {
              _change('targetWords', number);
            }
          },
          onSubmitted: (text) {
            final words = (int.tryParse(text) ?? value.targetWords).clamp(
              minimum,
              maximum,
            );
            _words.text = '$words';
            _change('targetWords', words);
          },
        ),
        Slider(
          value: value.targetWords.toDouble(),
          min: minimum.toDouble(),
          max: maximum.toDouble(),
          label: '${value.targetWords} 字',
          semanticFormatterCallback: (v) => '${v.round()} 字',
          onChanged: widget.enabled
              ? (v) => _change('targetWords', v.round())
              : null,
        ),
        Wrap(
          spacing: 8,
          runSpacing: 4,
          children: [
            for (final words in const [300, 800, 1500, 3000])
              ChoiceChip(
                label: Text('$words 字'),
                selected: value.targetWords == words,
                onSelected: widget.enabled
                    ? (_) {
                        _words.text = '$words';
                        _change('targetWords', words);
                      }
                    : null,
              ),
          ],
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<NarrativePerspective>(
          key: ValueKey(value.perspective),
          decoration: const InputDecoration(labelText: '旁白人称'),
          isExpanded: true,
          initialValue: value.perspective,
          items: [
            for (final item in NarrativePerspective.values)
              DropdownMenuItem(value: item, child: Text(item.label)),
          ],
          onChanged: widget.enabled
              ? (item) {
                  if (item != null) _change('pointOfView', item.name);
                }
              : null,
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<NarrativeStyle>(
          key: ValueKey(value.style),
          decoration: const InputDecoration(labelText: '叙事风格'),
          isExpanded: true,
          initialValue: value.style,
          items: [
            for (final item in NarrativeStyle.values)
              DropdownMenuItem(value: item, child: Text(item.label)),
          ],
          onChanged: widget.enabled
              ? (item) {
                  if (item != null) _change('narrationStyle', item.name);
                }
              : null,
        ),
      ],
    );
  }
}
