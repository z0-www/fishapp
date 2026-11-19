import 'dart:convert';
import 'dart:io';

import 'package:archive/archive.dart';
import 'package:drift/native.dart';
import 'package:fishtextadventure/core/database/app_database.dart';
import 'package:fishtextadventure/features/import_center/data/conversation_parsers.dart';
import 'package:fishtextadventure/features/import_center/data/deepseek_share_import_service.dart';
import 'package:fishtextadventure/features/import_center/data/pending_share_repository.dart';
import 'package:fishtextadventure/features/import_center/data/quick_import.dart';
import 'package:fishtextadventure/features/import_center/domain/import_models.dart';
import 'package:fishtextadventure/features/roleplay/data/roleplay_repository.dart';
import 'package:fishtextadventure/features/story_world/data/story_repository.dart';
import 'package:fishtextadventure/features/world_creator/data/world_definition_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;

const _story = '''
雾港手记

**用户**
世界背景：水城港湾
玩家身份：守灯人
地点：北堤
人物：林潮
人物关系：林潮是我的邻居
已发生事件：收到一封旧信

## DeepSeek
地点：南堤
人物：林潮
人物：还未见到的访客
灯塔外起了雾。
''';

IncomingShare _incoming(String id, String text, {String mime = 'text/plain'}) =>
    IncomingShare(
      id: id,
      source: ImportSource.system,
      receivedAt: DateTime.utc(2026),
      text: text,
      mime: mime,
    );

void main() {
  const parser = ImportParserRegistry();
  Future<ConversationDraft> parse(IncomingShare input) =>
      parser.parse(input, ImportCancellation(), (_) {});

  test('empty role headings and login metadata do not become stored dialogue', () async {
    await expectLater(
      parse(_incoming('empty-role', '用户：\nAI：')),
      throwsA(isA<ImportFailure>()),
    );
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(db.close);
    final repo = PendingShareRepository(db);
    const json =
        '{"access_token":"session-only","message":{"role":"user","content":"沿岸航线"}}';
    await repo.receive(_incoming('json-metadata', json));
    final stored = (await repo.get('json-metadata'))!.share.text;
    expect(stored, isNot(contains('session-only')));
    expect(stored, contains('沿岸航线'));
  });

  test(
    'wrapped public links deduplicate without being accepted as dialogue',
    () async {
      final db = AppDatabase.forTesting(NativeDatabase.memory());
      addTearDown(db.close);
      final repo = PendingShareRepository(db);
      const link = 'https://chat.deepseek.com/share/sample-qa7';
      final first = _incoming('plain', link);
      final second = _incoming('title', '用 DeepSeek 分享\n雾港旧事\n查看详情：$link/');
      expect(await repo.receive(first), 'plain');
      expect(await repo.receive(second), 'plain');
      final draft = await parse(second);
      expect(draft.sourceUrl, link);
      expect(draft.canSave, isFalse);
      await expectLater(
        QuickImport(repo).restore('plain', draft, includeExcerpt: false),
        throwsA(isA<ImportFailure>()),
      );
      expect(await repo.history(), isEmpty);
      expect(await db.select(db.worlds).get(), isEmpty);
      final containingLink = await parse(
        _incoming('actual', '用户：看看这个 $link\nAI：我看到海上有灯。'),
      );
      expect(containingLink.canSave, isTrue);
      expect(containingLink.messages, hasLength(2));
      await repo.discard('plain');
      expect(await repo.get('plain'), isNull);
    },
  );

  test('one tap stores 22 messages, labels candidates and survives DB reopen', () async {
    final directory = await Directory.systemTemp.createTemp('fish-one-chat-');
    addTearDown(() => directory.delete(recursive: true));
    final file = File(p.join(directory.path, 'story.sqlite'));
    var db = AppDatabase.forTesting(NativeDatabase(file));
    addTearDown(() => db.close());
    var repo = PendingShareRepository(db);
    final text =
        '$_story\n${List.generate(10, (i) => '用户：我记下位置 $i。\nAI：风声渐渐停下 $i。').join('\n')}';
    final share = _incoming('actual-text', text);
    await repo.receive(share);
    final draft = await parse(share);
    expect(draft.messages, hasLength(22));
    expect(draft.messages.map((message) => message.role).toSet(), {
      'user',
      'assistant',
    });
    final id = await QuickImport(repo)
        .restore(share.id, draft, includeExcerpt: false);
    expect(
      await QuickImport(repo).restore(share.id, draft, includeExcerpt: true),
      id,
    );
    await db.close();
    db = AppDatabase.forTesting(NativeDatabase(file));
    repo = PendingShareRepository(db);
    final conversation = (await repo.history()).single;
    expect(conversation.worldId, id);
    final messages = await repo.messages(conversation.id);
    expect(messages.last.body, '风声渐渐停下 9。');
    expect(messages.last.parentId, messages[20].messageId);
    final state = await RoleplayRepository(db).load(id);
    expect(state.displayLocation, '北堤');
    expect(state.characters.single.name, '林潮');
    expect(state.data['importedStoryExcerpt'], isNull);
    final reviewId = 'recovery-${conversation.id}-${messages.last.messageId}';
    final review = await WorldDraftRepository(db).load(reviewId);
    expect(
      review!.facts.any(
        (fact) => fact['text'] == '还未见到的访客' && fact['accepted'] == false,
      ),
      isTrue,
    );
    final timeline = await EventTimeline(db).entries(id);
    expect(
      timeline.where((event) => event['category'] == 'source'),
      hasLength(22),
    );
    expect(
      (await WorldDefinitionRepository(db).latest(id))?.definition.title,
      '雾港手记',
    );
  });

  test(
    'world restore failure rolls back raw archive and job completion',
    () async {
      final db = AppDatabase.forTesting(NativeDatabase.memory());
      addTearDown(db.close);
      final repo = PendingShareRepository(db);
      final share = _incoming('rollback', _story);
      await repo.receive(share);
      await db.customStatement(
        'CREATE TEMP TRIGGER stop_timeline BEFORE INSERT ON timeline_entries '
        "BEGIN SELECT RAISE(ABORT, 'intentional test write failure'); END",
      );
      await expectLater(
        QuickImport(repo)
            .restore(share.id, await parse(share), includeExcerpt: false),
        throwsA(isA<Exception>()),
      );
      expect(await repo.history(), isEmpty);
      expect(await db.select(db.worlds).get(), isEmpty);
      expect((await repo.get(share.id))?.state, 'received');
    },
  );

  test('official ZIP shows titles, then saves only selected session; another title can be picked later', () async {
    final dir = await Directory.systemTemp.createTemp('fish-titles-');
    addTearDown(() => dir.delete(recursive: true));
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(db.close);
    final repo = PendingShareRepository(db);
    Map<String, Object?> session(String id, String title) => {
      'id': id,
      'title': title,
      'current_message_id': 2,
      'messages': [
        {
          'id': 1,
          'role': 'USER',
          'status': 'FINISHED',
          'fragments': [
            {'type': 'REQUEST', 'content': '$title 的开头'},
          ],
        },
        {
          'id': 2,
          'parent_id': 1,
          'role': 'ASSISTANT',
          'status': 'FINISHED',
          'fragments': [
            {'type': 'RESPONSE', 'content': '$title 的结尾'},
          ],
        },
      ],
    };
    final rows = [session('a', '雾港'), session('b', '山城')];
    final archive = Archive()
      ..add(ArchiveFile.string('manifest.json', '{"export_format_version":3}'))
      ..add(
        ArchiveFile.string(
          'chat_session_index.json',
          jsonEncode([
            for (final row in rows)
              {'id': row['id'], 'title': row['title'], 'message_count': 2},
          ]),
        ),
      );
    for (final row in rows) {
      archive.add(
        ArchiveFile.string('chat_sessions/${row['id']}.json', jsonEncode(row)),
      );
    }
    final file = File(
      p.join(dir.path, 'share_inbox', 'native-zip', 'export.zip'),
    );
    await file.create(recursive: true);
    await file.writeAsBytes(ZipEncoder().encode(archive));
    final jobId = await repo.receive(
      IncomingShare(
        id: 'native-zip',
        source: ImportSource.picker,
        receivedAt: DateTime.now(),
        files: [
          ImportedAttachment(
            path: file.path,
            name: 'export.zip',
            mime: 'application/zip',
            size: await file.length(),
          ),
        ],
      ),
    );
    final job = (await repo.get(jobId))!;
    final catalog = await parse(job.share);
    expect(catalog.archiveSessions.map((s) => s.title), ['雾港', '山城']);
    expect(catalog.messages, isEmpty);
    final first = await repo.selectSession(job, catalog.archiveSessions.first);
    final second = await repo.selectSession(job, catalog.archiveSessions.last);
    expect(first, isNot(second));
    expect(await repo.selectSession(job, catalog.archiveSessions.first), first);
    final selected = await parse((await repo.get(second))!.share);
    expect(selected.title, '山城');
    expect(selected.messages.map((m) => m.content).join(), '山城 的开头山城 的结尾');
    expect(selected.attachments, isEmpty);
  });

  test(
    'share snapshots use chosen parent path and label missing selection',
    () {
      final rows = [
        {
          'id': 'branchA',
          'parent_id': 'root',
          'role': 'ASSISTANT',
          'content': '甲',
        },
        {'message_id': 'root', 'role': 'USER', 'content': '启程'},
        {
          'id': 'branchB',
          'parent_id': 'root',
          'role': 'ASSISTANT',
          'content': '乙',
        },
      ];
      final snapshot = DeepSeekShareImportService.parse(
        jsonEncode({
          'code': 0,
          'data': {
            'biz_code': 0,
            'biz_data': {'title': '分岔', 'messages': rows},
          },
        }),
      );
      expect(snapshot.messages.first.id, 'root');
      expect(snapshot.nodeUncertain, isTrue);
      expect(snapshot.warnings.join(), contains('快照'));
      expect(
        QuickImport.branch(snapshot, 'branchA').map((m) => m.content).toList(),
        ['启程', '甲'],
      );
    },
  );
}
