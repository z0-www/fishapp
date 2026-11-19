import 'dart:convert';

import '../domain/world.dart';

/// Explicit world-field allowlist; never archive database or secure storage.
abstract final class WorldExportService {
  static String encode(List<World> worlds) => jsonEncode({
    'format': 'fish-worlds-v1',
    'worlds': worlds
        .map(
          (w) => {
            'id': w.id,
            'title': w.title,
            'genre': w.genre,
            'summary': w.summary,
            'createdAt': w.createdAt.toIso8601String(),
          },
        )
        .toList(),
  });
}
