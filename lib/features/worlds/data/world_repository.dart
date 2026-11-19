import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart';
import '../domain/world.dart';

abstract interface class WorldRepository {
  Future<List<World>> load();
  Future<World> create(String prompt);
}

class SqliteWorldRepository implements WorldRepository {
  SqliteWorldRepository(this.db);
  final AppDatabase db;
  @override
  Future<List<World>> load() async {
    final rows = await (db.select(
      db.worlds,
    )..orderBy([(t) => OrderingTerm.desc(t.createdAt)])).get();
    return rows
        .map(
          (r) => World(
            id: r.id,
            title: r.title,
            genre: r.genre,
            summary: r.summary,
            createdAt: r.createdAt,
          ),
        )
        .toList();
  }

  @override
  Future<World> create(String prompt) async {
    final value = prompt.trim();
    if (value.isEmpty || value.length > 500) {
      throw ArgumentError('世界设想需为 1–500 字');
    }
    final now = DateTime.now();
    final world = World(
      id: now.microsecondsSinceEpoch.toString(),
      title: value.length > 18 ? '${value.substring(0, 18)}…' : value,
      genre: '自定义世界',
      summary: value,
      createdAt: now,
    );
    await db
        .into(db.worlds)
        .insert(
          WorldsCompanion.insert(
            id: world.id,
            title: world.title,
            genre: world.genre,
            summary: world.summary,
            createdAt: now,
          ),
        );
    return world;
  }
}
