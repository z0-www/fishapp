import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../shared/widgets/content_frame.dart';
import '../../world_creator/application/providers.dart';
import '../../world_creator/presentation/narrative_preferences_editor.dart';
import '../application/narrative_settings.dart';

class NarrativeSettingsPage extends ConsumerStatefulWidget {
  const NarrativeSettingsPage({super.key});

  @override
  ConsumerState<NarrativeSettingsPage> createState() =>
      _NarrativeSettingsPageState();
}

class _NarrativeSettingsPageState extends ConsumerState<NarrativeSettingsPage> {
  Map<String, dynamic>? _edited;
  bool _saving = false;

  Future<void> _save() async {
    final changes = _edited;
    if (_saving || changes == null) return;
    setState(() => _saving = true);
    try {
      await ref
          .read(worldDefinitionRepositoryProvider)
          .saveDraft(globalNarrativePreferenceKey, changes);
      if (!mounted) return;
      ref.invalidate(globalNarrativePreferencesProvider);
      setState(() => _edited = null);
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('叙事偏好已保存，下轮生效')));
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('叙事偏好未保存，请重试')));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('叙事偏好')),
    body: SafeArea(
      child: ContentFrame(
        child: ref
            .watch(globalNarrativePreferencesProvider)
            .when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, _) => Center(
                child: TextButton(
                  onPressed: () =>
                      ref.invalidate(globalNarrativePreferencesProvider),
                  child: const Text('无法读取偏好，点击重试'),
                ),
              ),
              data: (saved) => ListView(
                padding: const EdgeInsets.all(24),
                children: [
                  const Text('用于未自定义叙事的世界，从下一轮生效。'),
                  NarrativePreferencesEditor(
                    value: _edited ?? saved,
                    enabled: !_saving,
                    initiallyExpanded: true,
                    onChanged: (value) => setState(() => _edited = value),
                  ),
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: _saving || _edited == null ? null : _save,
                    child: const Text('保存全局偏好'),
                  ),
                ],
              ),
            ),
      ),
    ),
  );
}
