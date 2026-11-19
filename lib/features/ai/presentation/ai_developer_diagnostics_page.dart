import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/app_version.dart';
import '../../../shared/widgets/content_frame.dart';
import '../../roleplay/data/content_trace_repository.dart';
import '../../roleplay/domain/creative_policy.dart';
import '../../usage/usage_repository.dart';
import '../application/ai_providers.dart';
import '../data/deepseek_error_handler.dart';

class AiDeveloperDiagnosticsPage extends ConsumerWidget {
  const AiDeveloperDiagnosticsPage({super.key});

  Future<void> _copy(BuildContext context, String summary) async {
    var copied = false;
    try {
      await Clipboard.setData(ClipboardData(text: summary));
      copied = true;
    } catch (_) {}
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(copied ? '脱敏诊断已复制' : '暂时无法复制，请截图记录')),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = ref.watch(deepSeekConfigProvider);
    final version = appBuildName ?? appVersion;
    final build = appBuildNumber;
    final versionLabel = build == null ? version : '$version+$build';
    final diagnostics = ref.watch(apiDiagnosticsProvider);
    final recent = ref.watch(usageMetricsProvider);
    final receipt = diagnostics.receipt;
    final latest = switch (diagnostics.lastError) {
      final error? => _Evidence(
        title: '本次运行最近错误',
        model: config.model,
        httpStatus: diagnostics.lastFailureHttpStatus,
        error: DeepSeekErrorHandler.diagnosticMessage(error),
      ),
      null when receipt != null => _Evidence(
        title: '本次运行最近连接测试',
        model: receipt.model,
        receivedModel: true,
        httpStatus: receipt.httpStatus,
        input: receipt.usage['prompt_tokens'],
        output: receipt.usage['completion_tokens'],
        cache: receipt.usage['prompt_cache_hit_tokens'],
      ),
      _ => null,
    };
    final saved = [
      for (final row in (recent.asData?.value ?? const []).take(12))
        _Evidence(
          title: row['type'] == UsageRepository.awaitingUsage
              ? '请求用量待确认'
              : '服务端用量记录',
          model: row['model'],
          httpStatus: row['httpStatus'],
          input: row['inputTokens'],
          output: row['outputTokens'],
          cache: row['cacheTokens'],
          at: row['requestedAt'],
        ),
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text(config.isAndroidReleaseValidation ? '接入验收记录' : '开发诊断'),
      ),
      body: SafeArea(
        child: ContentFrame(
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              Text(
                '鱼者文游 V$versionLabel',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Text(switch ((
                config.permitsDirectCalls,
                config.isAndroidReleaseValidation,
                config.releaseAllowed,
              )) {
                (false, _, _) => '当前构建未启用真实直连',
                (true, true, _) => 'Android Release 接入验收已启用',
                (true, false, true) => '正式版真实直连已启用',
                _ => '原生真实直连开发测试已启用',
              }),
              for (final reason in config.restrictions) Text(reason),
              const SizedBox(height: 16),
              const Text('HTTP 状态来自请求响应。生成或存档失败时，即使收到 HTTP 200，也需结合错误与聊天记录判断。'),
              if (latest != null) _EvidenceTile(latest),
              const SizedBox(height: 12),
              Text('本机最近请求', style: Theme.of(context).textTheme.titleMedium),
              if (recent.isLoading) const LinearProgressIndicator(),
              if (recent.hasError) const Text('暂时无法读取本机诊断。'),
              if (recent.hasValue && saved.isEmpty) const Text('还没有本机请求记录。'),
              for (final item in saved) _EvidenceTile(item),
              if (latest != null || saved.isNotEmpty)
                OutlinedButton.icon(
                  icon: const Icon(Icons.copy_outlined),
                  label: const Text('复制脱敏诊断'),
                  onPressed: () => _copy(
                    context,
                    [
                      '鱼者文游 V$versionLabel',
                      if (latest != null) latest.summary,
                      ...saved.map((item) => item.summary),
                    ].join('\n\n'),
                  ),
                ),
              ExpansionTile(
                title: const Text('本地诊断分类'),
                children: [
                  ref
                      .watch(contentTracesProvider)
                      .when(
                        loading: () => const SizedBox.shrink(),
                        error: (_, _) => const Text('诊断暂不可用'),
                        data: (rows) => Column(
                          children: [
                            if (rows.isEmpty) const Text('暂无失败分类；不记录聊天正文和密钥'),
                            for (final row in rows)
                              ListTile(
                                title: Text(
                                  ContentDecisionTrace
                                      .labels[ContentDecisionSource.values
                                      .firstWhere(
                                        (v) => v.name == row['source'],
                                        orElse: () =>
                                            ContentDecisionSource.network,
                                      )]!,
                                ),
                                subtitle: Text(row['at'].toString()),
                              ),
                          ],
                        ),
                      ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Evidence {
  const _Evidence({
    required this.title,
    this.model,
    this.receivedModel = false,
    this.httpStatus,
    this.input,
    this.output,
    this.cache,
    this.at,
    this.error,
  });

  final String title;
  final bool receivedModel;
  final Object? model, httpStatus, input, output, cache, at;
  final String? error;

  static String _token(Object? value) =>
      value is int && value >= 0 ? '$value' : '未取得';

  String get detail {
    final rawModel = model;
    final rawStatus = httpStatus;
    final rawTime = at;
    final parsedTime = rawTime is String ? DateTime.tryParse(rawTime) : null;
    final safeModel =
        rawModel is String &&
            RegExp(r'^deepseek-[a-zA-Z0-9._-]{1,80}$').hasMatch(rawModel) &&
            !rawModel.toLowerCase().contains('sk-')
        ? rawModel
        : '未取得';
    return [
      if (parsedTime != null) parsedTime.toLocal().toString(),
      rawStatus is int && rawStatus >= 100 && rawStatus <= 599
          ? 'HTTP $rawStatus'
          : 'HTTP 状态未取得',
      '${receivedModel ? '响应模型' : '模型'} $safeModel',
      '实际 Token · 输入 ${_token(input)} · 输出 ${_token(output)} · 缓存命中 ${_token(cache)}',
      ?error,
    ].join('\n');
  }

  String get summary => '$title\n$detail';
}

class _EvidenceTile extends StatelessWidget {
  const _EvidenceTile(this.evidence);
  final _Evidence evidence;

  @override
  Widget build(BuildContext context) => ListTile(
    contentPadding: EdgeInsets.zero,
    title: Text(evidence.title),
    subtitle: SelectableText(evidence.detail),
  );
}
