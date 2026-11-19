import '../../wallet/application/wallet_controller.dart';
import '../../wallet/application/wallet_limits.dart';
import '../../../shared/widgets/back_home_button.dart';

import 'dart:convert';

import 'package:crypto/crypto.dart';

import 'dart:async';

import 'package:dio/dio.dart';

import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/widgets/content_frame.dart';
import '../../worlds/application/world_providers.dart';
import '../../roleplay/domain/models.dart';
import '../application/providers.dart';
import '../application/world_suggestion_engine.dart';
import '../data/world_definition_repository.dart';
import '../domain/world_definition.dart';
import 'editors.dart';
import '../../ai/application/ai_providers.dart';
import 'narrative_preferences_editor.dart';
import '../../roleplay/application/narrative_settings.dart';

class WorldCreatorPage extends ConsumerStatefulWidget {
  const WorldCreatorPage({super.key, this.worldId, this.initialDescription});
  final String? worldId, initialDescription;
  @override
  ConsumerState<WorldCreatorPage> createState() => _WorldCreatorPageState();
}

class _WorldCreatorPageState extends ConsumerState<WorldCreatorPage> {
  late WorldDefinition definition;
  late WorldDefinitionRepository repository;
  final fields = <String, TextEditingController>{};
  Timer? timer;
  Future<void> writes = Future.value();
  bool loading = true, busy = false, saved = false, detailed = false;
  int version = 0;
  String? error;
  String draftStatus = '草稿仅保存在本机';
  String locationSearch = '';
  CancelToken? suggestCancellation;
  static const labels = {
    'title': '世界名称',
    'description': '世界背景（可以自然语言描述整个世界）',
    'identity': '玩家身份（可留空）',
    'openingScene': '初始场景（可留空）',
    'genreText': '世界类型标签（自由填写，分行）',
    'era': '时代背景',
    'calendarSystem': '历法（可完全原创）',
    'worldDateTime': '初始时间（按你的历法描述）',
    'startingLocation': '初始地点名称',
    'narrativeText': '叙事风格与偏好',
    'customText': '自由补充设定',
  };
  String get draftId => widget.worldId != null
      ? 'edit-${widget.worldId}'
      : widget.initialDescription?.trim().isNotEmpty == true
      ? 'creator-inspiration-${sha256.convert(utf8.encode(widget.initialDescription!)).toString().substring(0, 24)}'
      : 'creator-new';
  @override
  void initState() {
    super.initState();
    repository = ref.read(worldDefinitionRepositoryProvider);
    for (final k in labels.keys) {
      fields[k] = TextEditingController();
    }
    load();
  }

  Future<void> load() async {
    try {
      final restored = await repository.draft(draftId);
      final base = widget.worldId == null
          ? null
          : await repository.editable(widget.worldId!);
      if (widget.worldId != null && base == null) {
        throw const DefinitionFailure('世界不存在，已有数据未修改。');
      }
      definition = restored?['definition'] is Map
          ? WorldDefinition(
              Map<String, dynamic>.from(restored!['definition'] as Map),
            )
          : base?.definition.copy() ??
                WorldDefinition.empty(
                  'world-${DateTime.now().microsecondsSinceEpoch}',
                );
      version = restored?['baseVersion'] as int? ?? base?.version ?? 0;
      if (base != null && base.version != version) {
        error = '这份草稿基于旧版本。保存会拒绝覆盖。可保留草稿返回，或放弃草稿重新读取当前版本。';
      }
      if (restored == null &&
          widget.initialDescription?.trim().isNotEmpty == true) {
        definition.data['description'] = widget.initialDescription;
      }
      fill();
      if (restored != null) draftStatus = '已恢复本机草稿';
    } catch (e) {
      definition = WorldDefinition.empty(
        'world-${DateTime.now().microsecondsSinceEpoch}',
      );
      error = e is DefinitionFailure ? e.message : '草稿读取失败，请重试。';
    }
    if (mounted) setState(() => loading = false);
  }

  void fill() {
    for (final key in [
      'title',
      'description',
      'openingScene',
      'era',
      'calendarSystem',
      'worldDateTime',
      'startingLocation',
    ]) {
      fields[key]!.text = definition.data[key]?.toString() ?? '';
    }
    fields['identity']!.text =
        (definition.data['playerProfile'] as Map?)?['identity']?.toString() ??
        '';
    fields['genreText']!.text = (definition.data['genreTags'] as List? ?? [])
        .join('\n');
    fields['narrativeText']!.text =
        (definition.data['narrativePreferences'] as Map?)?['style']
            ?.toString() ??
        '';
    fields['customText']!.text =
        (definition.data['customFields'] as Map?)?['text']?.toString() ?? '';
  }

  WorldDefinition snapshot() {
    final d = definition.copy();
    for (final key in [
      'title',
      'description',
      'openingScene',
      'era',
      'calendarSystem',
      'worldDateTime',
      'startingLocation',
    ]) {
      final v = fields[key]!.text;
      d.data[key] = v.trim().isEmpty ? null : v;
    }
    final player = Map<String, dynamic>.from(
      d.data['playerProfile'] as Map? ?? {},
    );
    final identity = fields['identity']!.text;
    if (identity.trim().isEmpty) {
      player.remove('identity');
    } else {
      player['identity'] = identity;
    }
    d.data['playerProfile'] = player.isEmpty ? null : player;
    final tags = fields['genreText']!.text
        .split('\n')
        .map((t) => t.trim())
        .where((t) => t.isNotEmpty)
        .toList();
    d.data['genreTags'] = tags.isEmpty ? null : tags;
    for (final e in {
      'narrativePreferences': 'narrativeText',
      'customFields': 'customText',
    }.entries) {
      final values = Map<String, dynamic>.from(d.data[e.key] as Map? ?? {});
      final key = e.key == 'customFields' ? 'text' : 'style';
      final v = fields[e.value]!.text;
      if (v.trim().isEmpty) {
        values.remove(key);
      } else {
        values[key] = v;
      }
      d.data[e.key] = values.isEmpty ? null : values;
    }
    return d;
  }

  void changed() {
    if (busy || loading) return;
    timer?.cancel();
    timer = Timer(const Duration(milliseconds: 300), flush);
  }

  void flush() {
    if (saved || loading) return;
    final payload = {'definition': snapshot().toJson(), 'baseVersion': version};
    writes = writes
        .then((_) => repository.saveDraft(draftId, payload))
        .then((_) {
          if (mounted) setState(() => draftStatus = '草稿已保存在本机');
        })
        .catchError((_) {
          if (mounted) setState(() => draftStatus = '草稿未保存，请检查是否含凭据或内容过大。');
        });
  }

  @override
  void dispose() {
    timer?.cancel();
    suggestCancellation?.cancel();
    if (!saved && !loading) flush();
    for (final c in fields.values) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> save() async {
    if (busy) return;
    timer?.cancel();
    setState(() {
      busy = true;
      error = null;
    });
    try {
      await writes;
      final d = snapshot();
      final result = await repository.save(
        d,
        expectedVersion: version,
        draftId: draftId,
      );
      saved = true;
      if (!mounted) return;
      ref.invalidate(worldsProvider);
      if (widget.worldId == null) {
        context.go('/play/${result.definition.id}');
      } else {
        context.go('/world/${result.definition.id}');
      }
    } catch (e) {
      if (mounted) {
        setState(
          () => error = e is DefinitionFailure ? e.message : '保存失败，旧设定与剧情仍保留。',
        );
      }
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  Future<void> editList(String key, int? index) async {
    if (busy) return;
    definition = snapshot();
    final rows = definition.entries(key);
    Map<String, dynamic>? value;
    if (key == 'characterProfiles') {
      final c = await CharacterEditor.open(
        context,
        character: index == null ? null : CharacterProfile(rows[index]),
      );
      value = c?.toJson();
    } else if (key == 'worldRules') {
      value = await WorldRuleEditor.open(
        context,
        initial: index == null ? null : rows[index],
      );
    } else if (key == 'locationProfiles') {
      value = await LocationEditor.open(
        context,
        initial: index == null ? null : rows[index],
      );
    } else {
      value = await editFreeFields(
        context,
        title: '人物关系',
        fields: const {
          'from': '人物 A（名称或编号）',
          'to': '人物 B（名称或编号）',
          'description': '关系描述',
        },
        initial: index == null ? null : rows[index],
      );
    }
    if (value == null || !mounted) return;
    if (index == null) {
      rows.add(value);
    } else {
      rows[index] = value;
    }
    setState(() => definition.data[key] = rows);
    changed();
  }

  Future<void> editPlayer() async {
    definition = snapshot();
    final p = await PlayerEditor.open(
      context,
      initial: definition.data['playerProfile'] as Map<String, dynamic>?,
    );
    if (p != null && mounted) {
      setState(() {
        definition.data['playerProfile'] = p;
        fields['identity']!.text = p['identity']?.toString() ?? '';
      });
      changed();
    }
  }

  Future<void> suggest({bool openingOnly = false}) async {
    if (busy) return;
    definition = snapshot();
    final engine = ref.read(worldSuggestionEngineProvider);
    final request = engine.prepare(definition, openingOnly: openingOnly);
    final wallet = ref.read(walletGuardProvider);
    final WalletQuote quote;
    try {
      quote = await wallet.quote(
        engine.config.model,
        request.estimatedTokens,
        1000,
      );
      if (quote.blocked) throw WalletRequestBlocked(quote.notice!);
    } catch (e) {
      if (mounted) {
        setState(
          () => error = e is WalletRequestBlocked ? e.message : '消费计划暂无法读取。',
        );
      }
      return;
    }
    if (!mounted) return;
    final yes = await showDialog<bool>(
      context: context,
      builder: (dialog) => AlertDialog(
        title: Text(openingOnly ? '完善开场前确认' : '完善世界前确认'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('处理范围：名称、背景、玩家档案、初始场景。不发送人物私人秘密、历史对话或密钥。'),
              Text('背景预览：${definition.text('description') ?? '未设定'}'),
              Text(
                '玩家档案：${(request.scope['playerProfile'] as Map?)?.values.join('；') ?? '未设定'}',
              ),
              Text('开场：${request.scope['openingScene'] ?? '未设定'}'),
              Text('输入保守估算 ${request.estimatedTokens} Token，输出上限1000。'),
              Text(
                '预计费用 ${quote.estimated?.toStringAsFixed(6) ?? '未知'} 美元，模型 ${engine.config.model}。确认后才发送一次请求。${quote.notice ?? ''}',
              ),
              const Text('结果需要逐项审核，未选中的建议不会写入；重试需要重新确认。'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialog, false),
            child: const Text('取消'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialog, true),
            child: const Text('确认获取建议'),
          ),
        ],
      ),
    );
    if (yes != true || !mounted) return;
    setState(() => busy = true);
    suggestCancellation = CancelToken();
    try {
      final results = await wallet.dispatch(
        engine.config.model,
        request.estimatedTokens,
        1000,
        () => engine.generate(
          request,
          confirmed: true,
          cancellation: suggestCancellation,
        ),
        approval: quote,
      );
      if (!mounted) return;
      final selected = <int>{};
      final apply = await showDialog<bool>(
        context: context,
        builder: (dialog) => StatefulBuilder(
          builder: (dialog, change) => AlertDialog(
            title: const Text('逐项审核建议'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (final e in results.indexed)
                    CheckboxListTile(
                      value: selected.contains(e.$1),
                      onChanged: (v) => change(() {
                        if (v == true) {
                          selected.add(e.$1);
                        } else {
                          selected.remove(e.$1);
                        }
                      }),
                      title: Text(e.$2.label),
                      subtitle: Text(
                        e.$2.value is Map
                            ? (e.$2.value as Map).values.join('；')
                            : e.$2.value.toString(),
                      ),
                    ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialog, false),
                child: const Text('全部不应用'),
              ),
              FilledButton(
                onPressed: () => Navigator.pop(dialog, true),
                child: const Text('应用选中建议到草稿'),
              ),
            ],
          ),
        ),
      );
      if (apply == true && mounted) {
        setState(() {
          for (final i in selected) {
            definition.data[results[i].field] = results[i].value;
          }
          fill();
        });
        changed();
      }
    } catch (e) {
      if (mounted) {
        setState(
          () => error = e is WalletRequestBlocked
              ? e.message
              : e is DefinitionFailure
              ? e.message
              : '建议未应用；原设定保留。',
        );
      }
    } finally {
      suggestCancellation = null;
      if (mounted) {
        setState(() => busy = false);
        changed();
      }
    }
  }

  Future<void> discardDraft() async {
    final yes = await showDialog<bool>(
      context: context,
      builder: (dialog) => AlertDialog(
        title: const Text('放弃这份草稿？'),
        content: const Text('会移除尚未保存的编辑，读取当前设定版本。已保存的设定与剧情不受影响。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialog, false),
            child: const Text('取消'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialog, true),
            child: const Text('放弃并重新读取'),
          ),
        ],
      ),
    );
    if (yes != true || !mounted) return;
    timer?.cancel();
    await writes;
    await repository.clearDraft(draftId);
    if (!mounted) return;
    setState(() {
      loading = true;
      error = null;
    });
    await load();
  }

  Widget input(String key, {int lines = 1}) => Padding(
    padding: const EdgeInsets.only(top: 16),
    child: TextField(
      key: Key('world-$key'),
      controller: fields[key],
      enabled: !busy,
      minLines: lines,
      maxLines: lines + 3,
      maxLength: key == 'description' || key == 'openingScene' ? 20000 : 4000,
      onChanged: (_) => changed(),
      decoration: InputDecoration(labelText: labels[key]),
    ),
  );
  Widget listing(String key, String title) {
    var rows = definition.entries(key);
    if (key == 'locationProfiles' && locationSearch.isNotEmpty) {
      rows = rows
          .where((r) => (r['name']?.toString() ?? '').contains(locationSearch))
          .toList();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            TextButton(
              onPressed: busy ? null : () => editList(key, null),
              child: const Text('添加'),
            ),
          ],
        ),
        if (key == 'locationProfiles')
          TextField(
            onChanged: (v) => setState(() => locationSearch = v),
            decoration: const InputDecoration(labelText: '搜索地点'),
          ),
        for (final row in rows)
          ListTile(
            title: Text(
              row['name']?.toString() ??
                  row['text']?.toString() ??
                  row['description']?.toString() ??
                  '未命名设定',
            ),
            subtitle: key == 'worldRules'
                ? Text(
                    {
                          'fact': '世界事实',
                          'preference': '创作偏好',
                          'open': '开放设定',
                        }[row['kind']] ??
                        '',
                  )
                : null,
            onTap: busy
                ? null
                : () => editList(
                    key,
                    definition
                        .entries(key)
                        .indexWhere((r) => r['id'] == row['id']),
                  ),
            trailing: IconButton(
              tooltip: '移除此设定',
              onPressed: busy
                  ? null
                  : () {
                      setState(() {
                        final all = definition.entries(key)
                          ..removeWhere((r) => r['id'] == row['id']);
                        definition.data[key] = all.isEmpty ? null : all;
                      });
                      changed();
                    },
              icon: const Icon(Icons.remove_circle_outline),
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      leading: const BackHomeButton(),
      title: Text(widget.worldId == null ? '新建自由世界' : '编辑世界设定'),
    ),
    body: SafeArea(
      child: ContentFrame(
        child: loading
            ? const Center(child: CircularProgressIndicator())
            : ListView(
                padding: const EdgeInsets.all(24),
                children: [
                  const Card(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Text(
                        '告诉我你想创造怎样的世界。可以只写几句话，空白内容会保持“未设定”，不会自动套用模板。',
                        style: TextStyle(height: 1.7),
                      ),
                    ),
                  ),
                  Wrap(
                    spacing: 8,
                    children: [
                      ChoiceChip(
                        label: const Text('快速创建'),
                        selected: !detailed,
                        onSelected: busy
                            ? null
                            : (_) => setState(() => detailed = false),
                      ),
                      ChoiceChip(
                        label: const Text('详细自定义'),
                        selected: detailed,
                        onSelected: busy
                            ? null
                            : (_) => setState(() => detailed = true),
                      ),
                      ActionChip(
                        label: const Text('从已有对话导入'),
                        onPressed: busy ? null : () => context.push('/imports'),
                      ),
                    ],
                  ),
                  input('title'),
                  input('description', lines: 3),
                  input('identity'),
                  input('openingScene', lines: 2),
                  ExpansionTile(
                    key: ValueKey(detailed),
                    title: const Text('更多设定'),
                    initiallyExpanded: detailed,
                    children: [
                      for (final key in [
                        'genreText',
                        'era',
                        'calendarSystem',
                        'worldDateTime',
                        'startingLocation',
                      ])
                        input(key),
                      OutlinedButton(
                        onPressed: busy ? null : editPlayer,
                        child: const Text('编辑完整玩家档案（可全部留空）'),
                      ),
                      listing('characterProfiles', '人物'),
                      listing('relationships', '人物关系'),
                      listing('worldRules', '世界规则'),
                      listing('locationProfiles', '地点'),
                      input('narrativeText', lines: 2),
                      NarrativePreferencesEditor(
                        enabled: !busy,
                        inherited:
                            ref
                                .watch(globalNarrativePreferencesProvider)
                                .asData
                                ?.value ??
                            {},
                        value: Map<String, dynamic>.from(
                          definition.data['narrativePreferences'] as Map? ?? {},
                        ),
                        onChanged: (value) {
                          setState(
                            () =>
                                definition.data['narrativePreferences'] = value,
                          );
                          changed();
                        },
                      ),
                      input('customText', lines: 2),
                    ],
                  ),
                  if (widget.worldId != null)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Text('保存将新增设定版本。历史记录保留，叙事偏好从下一轮生效。'),
                    ),
                  const SizedBox(height: 20),
                  FilledButton(
                    onPressed: busy ? null : save,
                    child: Text(
                      busy
                          ? '正在处理…'
                          : widget.worldId == null
                          ? '创建并进入世界'
                          : '保存为新设定版本',
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text('填写、草稿和本地保存不调用 AI。'),
                  Text(draftStatus),
                  TextButton(
                    onPressed: busy ? null : discardDraft,
                    child: const Text('放弃草稿并重新读取'),
                  ),
                  if (error != null)
                    Text(error!, style: const TextStyle(color: Colors.red)),
                  OutlinedButton(
                    onPressed:
                        busy || ref.watch(aiActionUnavailableProvider) != null
                        ? null
                        : () => suggest(),
                    child: const Text('AI 帮我完善世界'),
                  ),
                  TextButton(
                    onPressed:
                        busy || ref.watch(aiActionUnavailableProvider) != null
                        ? null
                        : () => suggest(openingOnly: true),
                    child: const Text('AI 帮我完善开场'),
                  ),
                  if (busy)
                    TextButton(
                      onPressed: () => suggestCancellation?.cancel(),
                      child: const Text('停止建议请求'),
                    ),
                ],
              ),
      ),
    ),
  );
}
