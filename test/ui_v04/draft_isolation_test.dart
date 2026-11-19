import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:fishtextadventure/app/app.dart';
import 'package:fishtextadventure/app/router.dart';
import 'package:fishtextadventure/core/database/app_database.dart';
import 'package:fishtextadventure/features/worlds/application/world_providers.dart';
import 'package:fishtextadventure/features/world_creator/data/world_definition_repository.dart';
import 'package:fishtextadventure/features/world_creator/domain/world_definition.dart';

void main() {
  testWidgets(
    'advanced inspirations keep separate drafts and preserve an older unfinished draft',
    (tester) async {
      late AppDatabase db;
      await tester.runAsync(() async {
        db = AppDatabase.forTesting(NativeDatabase.memory());
        final old = WorldDefinition.empty('unfinished');
        old.data['title'] = '原先未完成的世界';
        await WorldDefinitionRepository(db).saveDraft('creator-new', {
          'definition': old.toJson(),
          'baseVersion': 0,
        });
      });
      final container = ProviderContainer(
        overrides: [databaseProvider.overrideWithValue(db)],
      );
      final router = container.read(routerProvider);
      router.go('/create?prompt=first');
      await tester.pumpWidget(
        UncontrolledProviderScope(container: container, child: const FishApp()),
      );
      await tester.pumpAndSettle();
      expect(
        tester
            .widget<TextField>(find.byKey(const Key('world-description')))
            .controller!
            .text,
        'first',
      );
      await tester.enterText(find.byKey(const Key('world-title')), '第一份灵感草稿');
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pumpAndSettle();
      router.go('/create?prompt=second');
      await tester.pumpAndSettle();
      expect(
        tester
            .widget<TextField>(find.byKey(const Key('world-description')))
            .controller!
            .text,
        'second',
      );
      expect(
        tester
            .widget<TextField>(find.byKey(const Key('world-title')))
            .controller!
            .text,
        isEmpty,
      );
      router.go('/create?prompt=first');
      await tester.pumpAndSettle();
      expect(
        tester
            .widget<TextField>(find.byKey(const Key('world-title')))
            .controller!
            .text,
        '第一份灵感草稿',
      );
      expect(
        (await WorldDefinitionRepository(db)
            .draft('creator-new'))!['definition']['title'],
        '原先未完成的世界',
      );
      expect(await db.select(db.worlds).get(), isEmpty);
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pumpAndSettle();
      container.dispose();
      await tester.runAsync(db.close);
    },
  );
}
