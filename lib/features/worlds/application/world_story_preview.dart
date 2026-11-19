import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../roleplay/application/providers.dart';
import '../../roleplay/data/roleplay_repository.dart';

final worldStoryPreviewProvider = FutureProvider.autoDispose.family(
  (ref, String worldId) =>
      WorldStoryPreview.load(ref.watch(roleplayRepositoryProvider), worldId),
);

class WorldStoryPreview {
  const WorldStoryPreview({this.excerpt, this.node, this.playedAt});

  final String? excerpt, node;
  final DateTime? playedAt;
  bool get hasStory => node != null;

  static String? _excerpt(String? text) {
    final clean = text?.trim();
    if (clean == null || clean.isEmpty) return null;
    final prefix = String.fromCharCodes(clean.runes.take(320));
    return prefix.length < clean.length ? '$prefix…' : prefix;
  }

  static Future<WorldStoryPreview> load(
    RoleplayRepository repository,
    String worldId,
  ) async {
    final last = (await repository.history(worldId, limit: 1)).firstOrNull;
    if (last != null) {
      String? prose;
      try {
        final response = jsonDecode(last.responseJson ?? '{}') as Map;
        prose = _excerpt(response['narration'] as String?);
        if (prose == null && response['replies'] is List) {
          for (final reply in response['replies'] as List) {
            if (reply is Map && reply['text'] is String) {
              prose = _excerpt(reply['text'] as String);
              if (prose != null) break;
            }
          }
        }
      } on FormatException {
        // Some older nodes have an opaque response. Their saved action remains.
      } on TypeError {
        // Other versions use a different response shape.
      }
      return WorldStoryPreview(
        excerpt: prose ?? _excerpt(last.action),
        node: '第 ${last.baseRevision + 1} 轮',
        playedAt: last.createdAt,
      );
    }
    final state = await repository.loadIfExists(worldId);
    if (state == null) return const WorldStoryPreview();
    final imported = state.data['importedRecent'];
    final recovery = state.data['recovery'];
    if (recovery is Map || (imported is List && imported.isNotEmpty)) {
      final rows = imported is List ? imported.reversed : const [];
      final message = rows
          .whereType<Map>()
          .map((row) => row['content'])
          .whereType<String>()
          .map(_excerpt)
          .whereType<String>()
          .firstOrNull;
      return WorldStoryPreview(excerpt: message, node: '导入故事的续写节点');
    }
    return state.revision > 0
        ? WorldStoryPreview(node: '第 ${state.revision} 轮')
        : const WorldStoryPreview();
  }
}
