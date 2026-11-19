import 'package:dio/dio.dart';

import '../../../core/database/app_database.dart';
import '../domain/story_models.dart';
import 'extraction_pipeline.dart';

/// Local, descriptive measurements, never a claim to reproduce another model.
/// Raw quotations/secrets are not placed in global style instructions.
class StyleDNAExtractor {
  Map<String, dynamic> extract(List<ImportedMessageRow> messages) {
    final prose = messages
        .where((m) => m.role == 'assistant' && m.body.trim().isNotEmpty)
        .toList();
    final paragraphs = prose
        .expand((m) => m.body.split(RegExp(r'\n\s*\n|\n')))
        .where((p) => p.trim().isNotEmpty)
        .toList();
    final average = paragraphs.isEmpty
        ? 0
        : (paragraphs.fold<int>(0, (n, p) => n + p.runes.length) /
                  paragraphs.length)
              .round();
    final dialogueLines = paragraphs
        .where((p) => RegExp(r'^[“「]|^[^：:\n]{1,12}[：:]').hasMatch(p.trim()))
        .length;
    return {
      'algorithm': 'local-style-metrics-v1',
      'apiRequests': 0,
      'sourceMessageIds': prose.reversed
          .take(24)
          .map((m) => m.messageId)
          .toList()
          .reversed
          .toList(),
      'assistantMessagesMeasured': prose.length,
      'averageParagraphCharacters': average,
      'dialogueLineRatio': paragraphs.isEmpty
          ? 0
          : dialogueLines / paragraphs.length,
      'guidance': average == 0
          ? '原文不足，叙事节奏未确定。'
          : average <= 90
          ? '参考原文短段落节奏，允许自然停顿。'
          : '参考原文较长段落节奏，保持阅读连贯。',
      'limitations': '仅为本地节奏统计；人物情感、共同经历和语言习惯须按有出处的审核项确认，不推定事实。',
    };
  }
}

/// Existing provenance/review pipeline remains authoritative.
class ConversationToWorldEngine extends WorldExtractionPipeline {
  ConversationToWorldEngine(super.config, super.storage, super.usage);
  Future<WorldDraft> convert(
    ExtractionPlan plan,
    List<ImportedMessageRow> branch, {
    required bool confirmed,
    CancelToken? cancellation,
    void Function(int, int)? progress,
    Future<void> Function(int)? checkSegment,
  }) async {
    final draft = await extract(
      plan,
      confirmed: confirmed,
      cancellation: cancellation,
      progress: progress,
      checkSegment: checkSegment,
    );
    draft.data['styleDNA'] = StyleDNAExtractor().extract(branch);
    draft.data['styleConfirmed'] = false;
    return draft;
  }
}
