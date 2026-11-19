import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/app_database.dart';
import '../data/world_repository.dart';
import '../domain/world.dart';

const startEmpty = bool.fromEnvironment('FISH_START_EMPTY');
final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});
final repositoryProvider = Provider<WorldRepository>(
  (ref) => SqliteWorldRepository(ref.watch(databaseProvider)),
);
final worldsProvider = FutureProvider<List<World>>((ref) async {
  final repository = ref.watch(repositoryProvider);
  return repository.load();
});
