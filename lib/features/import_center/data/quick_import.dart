import 'dart:convert';

import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart';
import '../../story_world/data/story_repository.dart';
import '../../story_world/domain/story_models.dart';
import '../../world_creator/domain/world_definition.dart';
import '../domain/import_models.dart';
import 'pending_share_repository.dart';
import 'story_parsers.dart';
import 'share_link.dart';

class QuickImport {
  QuickImport(this.repository);
  final PendingShareRepository repository;

  static bool readable(ImportedMessage message) =>
      message.content.trim().isNotEmpty &&
      (message.role != 'unknown' || ShareLink.inText(message.content) == null);

  static List<ImportedMessage> branch(ConversationDraft draft, String? node) {
    final end =
        node ??
        draft.currentMessageId ??
        draft.messages.where(readable).lastOrNull?.id;
    if (end == null) return [];
    final result = ConversationNormalizer().branch(
      draft.messages,
      end,
      (m) => m.id,
      (m) => m.parentId,
    );
    final last = result.lastIndexWhere(readable);
    return last < 0 ? [] : result.take(last + 1).toList();
  }

  static List<Map<String, dynamic>> candidates(List<ImportedMessage> branch) {
    final picked = <Map<String, dynamic>>[];
    final seen = <(String, String)>{};
    const labels = {
      '世界背景': 'background',
      '玩家身份': 'player',
      '地点': 'location',
      '当前位置': 'location',
      '人物': 'npc',
      'NPC': 'npc',
      '人物关系': 'relationship',
      '已发生事件': 'event',
    };
    final expression = RegExp(
      r'^\s*(?:[-*]\s+)?(世界背景|玩家身份|当前位置|地点|人物关系|人物|NPC|已发生事件)\s*[:：]\s*(\S[^\r\n]{0,199})$',
      multiLine: true,
    );
    // Newer player declarations take precedence for singular fields.
    final assigned = <String>{};
    final recent = branch.reversed;
    for (final message in [
      ...recent.where((message) => message.role == 'user'),
      ...recent.where((message) => message.role == 'assistant'),
    ]) {
      for (final match in expression.allMatches(message.content)) {
        final type = labels[match[1]]!;
        final value = match[2]!.trim();
        if (WorldDefinitionExchange.containsCredential(value) ||
            RegExp(r'秘密|私密|只有.+知道|https?://').hasMatch(value) ||
            !seen.add((type, value))) {
          continue;
        }
        final singular = type == 'player' || type == 'location';
        final accepted =
            message.role == 'user' && (!singular || assigned.add(type));
        picked.add({
          'id': 'quick-${picked.length}',
          'category': type,
          'text': value,
          'kind': accepted ? 'fact' : 'unconfirmed',
          'accepted': accepted,
          'visibility': accepted ? 'public' : 'unreviewed',
          'owners': <String>[],
          'sourceMessageIds': [message.id],
          'confidence': accepted ? 1.0 : .4,
        });
        if (picked.length == 32) return picked;
      }
    }
    return picked;
  }

  Future<String> restore(
    String jobId,
    ConversationDraft draft, {
    String? selectedNode,
    required bool includeExcerpt,
  }) async {
    final chosen = branch(draft, selectedNode);
    if (!draft.canSave || chosen.isEmpty) {
      throw const ImportFailure('尚未取得可恢复的对话正文。');
    }
    final db = repository.db;
    return db.transaction(() async {
      final saved = await repository.save(
        jobId,
        draft,
        ImportDestination.history,
        selectedNode: chosen.last.id,
      );
      final previous = saved.worldId;
      if (previous != null) return previous;
      final evidence = candidates(chosen);
      final review = WorldDraft({
        'id': 'recovery-${saved.conversationId}-${chosen.last.id}',
        'conversationId': saved.conversationId,
        'nodeId': chosen.last.id,
        'title': draft.title,
        'facts': evidence,
        'includeSourceExcerpt': includeExcerpt,
      });
      final world = await WorldRecoveryService(db)
          .recover(review, confirmed: true, includeMessageTimeline: true);
      await (db.update(db.importedConversations)
            ..where((row) => row.id.equals(saved.conversationId)))
          .write(ImportedConversationsCompanion(worldId: Value(world)));
      final context = jsonEncode({
        'type': 'quick-import-v1',
        'node': chosen.last.id,
      });
      await db
          .into(db.derivedImportResults)
          .insert(
            DerivedImportResultsCompanion.insert(
              conversationId: saved.conversationId,
              derivedJson: context,
              createdAt: DateTime.now(),
            ),
          );
      return world;
    });
  }
}
