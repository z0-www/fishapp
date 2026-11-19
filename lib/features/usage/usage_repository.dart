import '../wallet/application/wallet_limits.dart';
import 'price_schedule.dart';
import 'price_schedule_provider.dart';

import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/database/app_database.dart';
import '../worlds/application/world_providers.dart';
import 'price_table.dart';

class UsageRepository {
  UsageRepository(this.db, {this.priceSchedule});
  final AppDatabase db;
  final Future<WalletPriceSchedule?> Function()? priceSchedule;

  Future<WalletSpending> spendingSince(DateTime since) =>
      db.transaction(() async {
        final end = since.add(const Duration(days: 1));
        final statement = await db
            .customSelect(
              'SELECT COALESCE(SUM(CASE WHEN estimated_usd IS NOT NULL AND '
              '(cache_tokens IS NOT NULL OR input_tokens = 0) THEN estimated_usd ELSE 0 END), 0.0) AS usd, '
              'COALESCE(SUM(CASE WHEN estimated_usd IS NULL OR '
              '(cache_tokens IS NULL AND input_tokens > 0) THEN 1 ELSE 0 END), 0) AS unknown '
              'FROM usage_records WHERE requested_at >= ? AND requested_at < ?',
              variables: [Variable(since), Variable(end)],
              readsFrom: {db.usageRecords},
            )
            .getSingle();
        final requests =
            await (db.select(db.worldDrafts)..where(
                  (row) =>
                      row.id.like('usage-request-%') &
                      row.updatedAt.isBiggerOrEqualValue(since) &
                      row.updatedAt.isSmallerThanValue(end),
                ))
                .get();
        var unconfirmed = 0;
        for (final row in requests) {
          try {
            if ((jsonDecode(row.payload) as Map)['type'] == awaitingUsage) {
              unconfirmed++;
            }
          } catch (_) {
            unconfirmed++;
          }
        }
        return WalletSpending(
          statement.read<double>('usd'),
          statement.read<int>('unknown') + unconfirmed,
        );
      });
  Future<List<UsageRecord>> load() => (db.select(
    db.usageRecords,
  )..orderBy([(t) => OrderingTerm.desc(t.requestedAt)])).get();

  Future<List<Map<String, dynamic>>> metrics() async =>
      (await (db.select(db.worldDrafts)
                ..where((t) => t.id.like('usage-request-%'))
                ..orderBy([(t) => OrderingTerm.desc(t.updatedAt)])
                ..limit(100))
              .get())
          .map((r) => Map<String, dynamic>.from(jsonDecode(r.payload) as Map))
          .toList();

  static const awaitingUsage = 'usage-unconfirmed-v1';

  Future<void> markAwaitingUsage({
    required String requestId,
    required String model,
    String? worldId,
  }) async {
    await db
        .into(db.worldDrafts)
        .insert(
          WorldDraftsCompanion.insert(
            id: 'usage-request-$requestId',
            payload: jsonEncode({
              'type': awaitingUsage,
              'model': model,
              'worldId': worldId,
              'requestedAt': DateTime.now().toUtc().toIso8601String(),
            }),
            updatedAt: DateTime.now(),
          ),
        );
  }

  Future<void> discardAwaitingUsage(String requestId) async {
    await (db.delete(
      db.worldDrafts,
    )..where((t) => t.id.equals('usage-request-$requestId'))).go();
  }

  Future<void> record({
    required DateTime requestedAt,
    required String model,
    required int inputTokens,
    required int outputTokens,
    int? cacheTokens,
    PriceTable? price,
    String? requestId,
    String? worldId,
    int? estimatedInput,
    int? fullHistoryEstimate,
    int? httpStatus,
    int? elapsedMs,
  }) async {
    if (inputTokens < 0 ||
        outputTokens < 0 ||
        (cacheTokens ?? 0) < 0 ||
        (cacheTokens ?? 0) > inputTokens) {
      throw ArgumentError('Token 数值异常');
    }
    final getSchedule = priceSchedule;
    final currentPrice = getSchedule == null
        ? price
        : (await getSchedule())?.priceAt(requestedAt, model);
    final estimate =
        currentPrice?.model == model &&
            (getSchedule == null || cacheTokens != null || inputTokens == 0)
        ? currentPrice?.estimate(
            requestedAt: requestedAt,
            input: inputTokens,
            output: outputTokens,
            cached: cacheTokens ?? 0,
          )
        : null;
    await db.transaction(() async {
      final usageId = await db
          .into(db.usageRecords)
          .insert(
            UsageRecordsCompanion.insert(
              requestedAt: requestedAt,
              model: model,
              inputTokens: inputTokens,
              outputTokens: outputTokens,
              cacheTokens: Value(cacheTokens),
              estimatedUsd: Value(estimate),
              priceVersion: Value(
                estimate == null ? null : currentPrice?.version,
              ),
            ),
          );
      if (requestId != null) {
        await db
            .into(db.worldDrafts)
            .insertOnConflictUpdate(
              WorldDraftsCompanion.insert(
                id: 'usage-request-$requestId',
                payload: jsonEncode({
                  'type': 'usage-metrics-v1',
                  'usageId': usageId,
                  'model': model,
                  'requestedAt': requestedAt.toUtc().toIso8601String(),
                  'httpStatus': ?httpStatus,
                  'elapsedMs': ?elapsedMs,
                  'worldId': worldId,
                  'estimatedInput': estimatedInput,
                  'fullHistoryBytesEstimate': fullHistoryEstimate,
                  'inputTokens': inputTokens,
                  'outputTokens': outputTokens,
                  'cacheTokens': cacheTokens,
                  'estimatedUsd': estimate,
                  'actualBilledUsd': null,
                  'priceVersion': estimate == null
                      ? null
                      : currentPrice?.version,
                  'estimator': 'utf8-bytes-plus-overhead; not model tokenizer',
                }),
                updatedAt: DateTime.now(),
              ),
            );
      }
    });
  }
}

final usageRepositoryProvider = Provider<UsageRepository>((ref) {
  final schedule = ref.watch(walletPriceProvider.future);
  return UsageRepository(
    ref.watch(databaseProvider),
    priceSchedule: () => schedule,
  );
});
final usageProvider = FutureProvider<List<UsageRecord>>(
  (ref) => ref.watch(usageRepositoryProvider).load(),
);

final usageMetricsProvider = FutureProvider(
  (ref) => ref.watch(usageRepositoryProvider).metrics(),
);
