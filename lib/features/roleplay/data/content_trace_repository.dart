import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/app_database.dart';
import '../../worlds/application/world_providers.dart';
import '../domain/creative_policy.dart';

class ContentTraceRepository {
  ContentTraceRepository(this.db);
  final AppDatabase db;
  static int _lastId = 0;

  /// Only fixed codes and identifiers; no action, prompt, response or raw error.
  Future<void> record(
    ContentDecisionSource source,
    String code, {
    String? requestId,
  }) async {
    final now = DateTime.now();
    final current = now.microsecondsSinceEpoch;
    _lastId = current > _lastId ? current : _lastId + 1;
    const allowedCodes = {
      'minor-sexual-exploitation',
      'explicit-sexual-content',
      'actionable-real-harm',
      'targeted-abuse',
      'turn-not-committed',
      'quality-review',
      'unspecified',
    };
    final trace = ContentDecisionTrace(
      source,
      allowedCodes.contains(code) ? code : 'unspecified',
      at: now,
      requestId:
          requestId != null && RegExp(r'^turn-[0-9]{1,30}$').hasMatch(requestId)
          ? requestId
          : null,
    );
    await db
        .into(db.worldDrafts)
        .insertOnConflictUpdate(
          WorldDraftsCompanion.insert(
            id: 'content-trace-$_lastId',
            payload: jsonEncode(trace.toJson()),
            updatedAt: now,
          ),
        );
    final old =
        await (db.select(db.worldDrafts)
              ..where((t) => t.id.like('content-trace-%'))
              ..orderBy([(t) => OrderingTerm.desc(t.id)])
              ..limit(1000, offset: 100))
            .get();
    if (old.isNotEmpty) {
      await (db.delete(
        db.worldDrafts,
      )..where((t) => t.id.isIn(old.map((r) => r.id)))).go();
    }
  }

  Future<List<Map<String, dynamic>>> load() async =>
      (await (db.select(db.worldDrafts)
                ..where((t) => t.id.like('content-trace-%'))
                ..orderBy([(t) => OrderingTerm.desc(t.id)])
                ..limit(20))
              .get())
          .map((r) => Map<String, dynamic>.from(jsonDecode(r.payload) as Map))
          .toList();
}

final contentTracesProvider = FutureProvider(
  (ref) => ContentTraceRepository(ref.watch(databaseProvider)).load(),
);
