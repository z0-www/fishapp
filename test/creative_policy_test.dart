import 'dart:convert';
import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fishtextadventure/core/database/app_database.dart';
import 'package:fishtextadventure/features/roleplay/domain/creative_policy.dart';
import 'package:fishtextadventure/features/roleplay/data/content_trace_repository.dart';

void main() {
  final cases = Map<String, dynamic>.from(
    jsonDecode(File('test/fixtures/creative_cases.json').readAsStringSync())
        as Map,
  );
  final policy = FishCreativeFreedomPolicy();
  var falseReject = 0, missed = 0, total = 0, allowed = 0, risk = 0;
  for (final entry in cases.entries) {
    final expected = CreativeDisposition.values.firstWhere(
      (v) => v.name == entry.key,
    );
    for (final item in entry.value as List) {
      total++;
      test('creative boundary $total: ${entry.key}', () {
        final decision = policy.evaluate(item as String);
        if (expected != CreativeDisposition.restrict) {
          allowed++;
          if (!decision.canContinue) falseReject++;
        } else {
          risk++;
          if (decision.canContinue) missed++;
        }
        expect(decision.disposition, expected, reason: item);
      });
    }
  }
  test(
    'at least 100 unique reviewed local fixtures; no model quality claims',
    () {
      expect(total, greaterThanOrEqualTo(100));
      expect(cases.values.expand((v) => v as List).toSet().length, total);
    },
  );
  test(
    'diagnostics store only fixed categories, not raw message or key',
    () async {
      final db = AppDatabase.forTesting(NativeDatabase.memory());
      addTearDown(db.close);
      final repo = ContentTraceRepository(db);
      const private = 'synthetic-private-marker-not-a-real-key';
      for (final source in ContentDecisionSource.values) {
        await repo.record(source, private, requestId: private);
      }
      final traces = await repo.load();
      expect(traces, hasLength(ContentDecisionSource.values.length));
      expect(jsonEncode(traces), isNot(contains(private)));
      expect(
        traces.every(
          (t) => t['code'] == 'unspecified' && t['requestId'] == null,
        ),
        true,
      );
      expect(
        ContentDecisionTrace.labels[ContentDecisionSource.jsonStructure],
        isNot(contains('违规')),
      );
    },
  );
  tearDownAll(() {
    final file = File('build/reports/creative-policy-metrics.json');
    file.parent.createSync(recursive: true);
    file.writeAsStringSync(
      const JsonEncoder.withIndent('  ').convert({
        'evaluation': 'local deterministic intent fixtures only',
        'fixtures': total,
        'normalAndAdjusted': allowed,
        'restricted': risk,
        'falseRejections': falseReject,
        'missedRestrictions': missed,
        'fixtureFalseRejectionRate': allowed == 0
            ? null
            : falseReject / allowed,
        'fixtureMissedRestrictionRate': risk == 0 ? null : missed / risk,
        'actualModelOutOfCharacterRate': null,
        'actualModelStoryInterruptionRate': null,
        'extraApiRequests': 0,
        'extraApiTokens': 0,
        'limitations': 'Hand-labelled finite fixtures, not a general moderation benchmark or real model A/B/C evaluation.',
      }),
    );
  });
}
