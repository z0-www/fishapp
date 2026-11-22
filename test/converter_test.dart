import 'dart:convert';
import 'dart:io';

import 'package:archive/archive.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:fish_converter/fish_converter.dart';
import 'package:fishtextadventure/core/database/app_database.dart';
import 'package:fishtextadventure/features/roleplay/application/dialogue_engine.dart';
import 'package:fishtextadventure/features/roleplay/application/turn_coordinator.dart';
import 'package:fishtextadventure/features/roleplay/data/roleplay_repository.dart';
import 'package:fishtextadventure/features/roleplay/domain/models.dart';
import 'package:fishtextadventure/features/usage/usage_repository.dart';
import 'package:fishtextadventure/features/world_backup/data/story_backup.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late Directory temp;

  setUp(() async {
    temp = await Directory.systemTemp.createTemp('fish-converter-test-');
  });
  tearDown(() async {
    await temp.delete(recursive: true);
  });

  test('Chatbox JSON -> yuzhe -> existing StoryBackup restore', () async {
    final source = jsonEncode({
      'version': '1.0',
      'sessions': [
        {
          'id': 'session-a',
          'name': '雨夜茶馆',
          'model': 'deepseek-chat',
          'createdAt': '2026-01-02T03:04:05Z',
          'messages': [
            {'id': 'a1', 'role': 'system', 'content': '你是一个叙述者。'},
            {'id': 'a2', 'role': 'user', 'content': '我推门进入茶馆。'},
            {
              'id': 'a3',
              'role': 'assistant',
              'content': '雨水从屋檐落下。\n掌柜抬头看了你一眼。',
            },
            {'id': 'a4', 'role': 'user', 'content': '我要一杯热茶。'},
            {'id': 'a5', 'role': 'assistant', 'content': '“稍等。”'},
          ],
        },
      ],
    });
    final parsed = parseConversationFile(
      'chatbox-export.json',
      utf8.encode(source),
    );
    expect(parsed.sessions, hasLength(1));
    final session = parsed.sessions.single;
    expect(session.title, '雨夜茶馆');
    expect(session.messages.map((m) => m.role), [
      'system',
      'user',
      'assistant',
      'user',
      'assistant',
    ]);
    expect(session.messages[2].content, contains('\n掌柜'));

    final output = await buildYuzhe(session, now: DateTime.utc(2026, 2, 3));
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(db.close);
    final archive = File('${temp.path}/chatbox.yuzhe');
    await archive.writeAsBytes(output.bytes);

    final backup = StoryBackup(db, Directory('${temp.path}/attachments'));
    final preview = await backup.inspect(archive);
    expect(preview.titles, ['雨夜茶馆']);
    expect(preview.missingFiles, 0);
    expect(preview.counts['imported_messages'], 5);

    final worldId = await backup.restore(archive, preview);
    final rows =
        await (db.select(db.importedMessages)
              ..orderBy([(t) => OrderingTerm.asc(t.ordinal)]))
            .get();
    expect(rows.map((r) => r.role), [
      'system',
      'user',
      'assistant',
      'user',
      'assistant',
    ]);
    expect(rows.map((r) => r.body), [
      '你是一个叙述者。',
      '我推门进入茶馆。',
      '雨水从屋檐落下。\n掌柜抬头看了你一眼。',
      '我要一杯热茶。',
      '“稍等。”',
    ]);
    expect(rows.map((r) => r.ordinal), [0, 1, 2, 3, 4]);
    expect(rows[1].parentId, rows[0].messageId);
    expect(rows[2].parentId, rows[1].messageId);

    final worlds = await db.select(db.worlds).get();
    expect(worlds.single.id, worldId);
    expect(worlds.single.title, '雨夜茶馆');
    final definition = await db.select(db.worldDefinitions).getSingle();
    expect(definition.version, 1);
    final definitionJson = jsonDecode(definition.payload) as Map;
    expect(definitionJson['title'], '雨夜茶馆');
    expect((definitionJson['customFields'] as Map)['converter'], isA<Map>());
    expect(
      ((definitionJson['customFields'] as Map)['converter'] as Map)[
          'generatedDefaults'],
      contains('emptyCharacters'),
    );
    expect((definitionJson['characterProfiles'] as List), isEmpty);

    final state = await RoleplayRepository(db).load(worldId);
    expect(state.revision, 0);
    expect((state.data['importedRecent'] as List), isNotEmpty);
    expect(
      (state.data['importedRecent'] as List).last['content'],
      '“稍等。”',
    );
    expect(await db.select(db.roleplayMemories).get(), isEmpty);
    expect(await db.select(db.storyCheckpoints).get(), hasLength(1));
    expect(await db.select(db.storyBranches).get(), hasLength(1));
    expect(await db.select(db.timelineEntries).get(), hasLength(5));

    // The restored world can prepare the next turn with prior Chatbox context.
    final coordinator = TurnCoordinator(
      RoleplayRepository(db),
      _FakeDialogue(),
      UsageRepository(db),
    );
    final plan = await coordinator.prepare(worldId, '我在窗边坐下。');
    expect(plan.messages.last['content'], '我在窗边坐下。');
    expect(
      plan.messages.any((m) => m['content'] == '我推门进入茶馆。'),
      isTrue,
    );
    expect(plan.speaker, 'narrator');
  });

  test('Chatbox Markdown -> yuzhe keeps roles and multiline text', () async {
    final markdown = '''
# 海边的信

**User:** 我沿着海岸走。

**Assistant:** 潮水退去，沙上有一封信。
信纸被盐打湿。

**User:** 我打开它。

**Assistant:** 里面只有一句话：
“回家吧。”
''';
    final parsed = parseConversationFile(
      'chatbox-export.md',
      utf8.encode(markdown),
    );
    final session = parsed.sessions.single;
    expect(session.title, '海边的信');
    expect(session.messages, hasLength(4));
    expect(session.messages.map((m) => m.role), [
      'user',
      'assistant',
      'user',
      'assistant',
    ]);
    expect(session.messages[1].content, contains('信纸被盐打湿。'));
    expect(session.messages[1].content, startsWith('潮水退去'));

    final output = await buildYuzhe(session);
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(db.close);
    final archive = File('${temp.path}/markdown.yuzhe');
    await archive.writeAsBytes(output.bytes);
    final backup = StoryBackup(db, Directory('${temp.path}/attachments'));
    final preview = await backup.inspect(archive);
    final worldId = await backup.restore(archive, preview);
    final rows =
        await (db.select(db.importedMessages)
              ..orderBy([(t) => OrderingTerm.asc(t.ordinal)]))
            .get();
    expect(rows.map((r) => r.role), ['user', 'assistant', 'user', 'assistant']);
    expect(rows[1].body, contains('信纸被盐打湿。'));
    final restoredState = await RoleplayRepository(db).load(worldId);
    expect(restoredState.worldId, worldId);
  });

  test('browser-generated example archive restores in the existing app', () async {
    final sample = File('converter/examples/chatbox-sample.yuzhe');
    expect(await sample.exists(), isTrue);
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(db.close);
    final backup = StoryBackup(db, Directory('${temp.path}/attachments'));
    final preview = await backup.inspect(sample);
    expect(preview.titles, ['雨夜测试']);
    expect(preview.counts['imported_messages'], 5);
    final worldId = await backup.restore(sample, preview);
    final rows =
        await (db.select(db.importedMessages)
              ..orderBy([(t) => OrderingTerm.asc(t.ordinal)]))
            .get();
    expect(rows.map((r) => r.role), [
      'system',
      'user',
      'assistant',
      'user',
      'assistant',
    ]);
    expect(rows[2].body, '雨声很大。\n掌柜抬头。');
    expect((await RoleplayRepository(db).load(worldId)).worldId, worldId);
  });

  test('Chatbox backup ZIP is detected by content and converted', () async {
    final sessionJson = jsonEncode({
      'id': 'zip-session',
      'name': '压缩包会话',
      'messages': [
        {'role': 'user', 'content': 'ZIP 里的用户消息'},
        {'role': 'assistant', 'content': 'ZIP 里的 AI 消息'},
      ],
    });
    final archive = Archive()
      ..addFile(ArchiveFile('manifest.json', utf8.encode(jsonEncode({
        'format': 'chatbox-backup',
        'formatVersion': 2,
      })).length, utf8.encode(jsonEncode({
        'format': 'chatbox-backup',
        'formatVersion': 2,
      }))))
      ..addFile(ArchiveFile(
        'sessions/zip-session.json',
        utf8.encode(sessionJson).length,
        utf8.encode(sessionJson),
      ));
    final zip = Uint8List.fromList(ZipEncoder().encode(archive));
    final parsed = parseConversationFile('backup.zip', zip);
    expect(parsed.format, 'Chatbox 备份 ZIP');
    expect(parsed.sessions.single.title, '压缩包会话');
    expect(parsed.sessions.single.messages, hasLength(2));

    final output = await buildYuzhe(parsed.sessions.single);
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(db.close);
    final archiveFile = File('${temp.path}/zip.yuzhe');
    await archiveFile.writeAsBytes(output.bytes);
    final backup = StoryBackup(db, Directory('${temp.path}/attachments'));
    final preview = await backup.inspect(archiveFile);
    final worldId = await backup.restore(archiveFile, preview);
    expect(await RoleplayRepository(db).load(worldId), isA<WorldState>());
  });

  test('Chatbox Markdown H1 export + H2 sessions/object sessions', () async {
    final markdown = '''
# Chatbox 导出

## 会话甲

**User:** 甲的问题
**Assistant:** 甲的回答

## 会话乙

**User:** 乙的问题
**Assistant:** 乙的回答
''';
    final markdownResult = parseConversationFile(
      'export.md',
      utf8.encode(markdown),
    );
    expect(markdownResult.sessions, hasLength(2));
    expect(markdownResult.sessions.map((s) => s.title), ['会话甲', '会话乙']);
    expect(markdownResult.sessions.first.messages, hasLength(2));

    final objectJson = jsonEncode({
      'sessions': {
        'a': {
          'name': '对象甲',
          'messages': [
            {'role': 'user', 'content': 'A'},
            {'role': 'assistant', 'content': 'B'},
          ],
        },
        'b': {
          'name': '对象乙',
          'messages': [
            {'role': 'user', 'content': 'C'},
          ],
        },
      },
    });
    final objectResult = parseConversationFile(
      'object.json',
      utf8.encode(objectJson),
    );
    expect(objectResult.sessions, hasLength(2));
    expect(objectResult.sessions.map((s) => s.title), ['对象甲', '对象乙']);
  });

  test('Chatbox v1 chat-sessions-list/contentParts and history warning', () async {
    final source = jsonEncode({
      'configVersion': 15,
      'chat-sessions-list': [
        {'id': 'v1-session', 'name': '旧版结构测试'},
      ],
      'session:v1-session': {
        'id': 'v1-session',
        'name': '旧版结构测试',
        'messages': [
          {
            'role': 'user',
            'contentParts': [
              {'type': 'text', 'text': '旧版用户正文'},
              {'type': 'image', 'storageKey': 'picture:a'},
            ],
          },
          {
            'role': 'assistant',
            'contentParts': [
              {'type': 'text', 'text': '旧版 AI 正文'},
            ],
          },
        ],
        'threads': [
          {
            'id': 'history',
            'messages': [
              {
                'role': 'user',
                'contentParts': [
                  {'type': 'text', 'text': '历史分支消息'},
                ],
              },
            ],
          },
        ],
      },
    });
    final parsed = parseConversationFile(
      'chatbox-v1.json',
      utf8.encode(source),
    );
    final session = parsed.sessions.single;
    expect(parsed.format, 'Chatbox JSON（旧版）');
    expect(session.messages.map((m) => m.role), ['user', 'assistant']);
    expect(session.messages.map((m) => m.content), ['旧版用户正文', '旧版 AI 正文']);
    expect(
      session.warnings.any((w) => w.contains('历史线程')),
      isTrue,
    );
    expect(
      session.warnings.any((w) => w.contains('图片/附件')),
      isTrue,
    );
  });

  test('multiple sessions and unknown files', () async {
    final json = jsonEncode({
      'sessions': [
        {
          'id': 'one',
          'name': '会话一',
          'messages': [
            {'role': 'user', 'content': '甲'},
            {'role': 'assistant', 'content': '乙'},
          ],
        },
        {
          'id': 'two',
          'name': '会话二',
          'messages': [
            {'role': 'user', 'content': '丙'},
          ],
        },
      ],
    });
    final parsed = parseConversationFile('multi.json', utf8.encode(json));
    expect(parsed.sessions, hasLength(2));
    final zip = await buildYuzheZip(parsed.sessions);
    expect(zip.bytes, isNotEmpty);
    expect(zip.count, 2);

    expect(
      () => parseConversationFile('settings.json', utf8.encode('{"settings":{}}')),
      throwsA(isA<ConversionException>()),
    );
    expect(
      () => parseConversationFile('plain.txt', utf8.encode('hello world')),
      throwsA(isA<ConversionException>()),
    );
  });
}

class _FakeDialogue implements DialogueEngine {
  @override
  Future<DialogueOutput> generate(
    TurnPlan plan,
    TurnCancellation cancellation,
  ) async => const DialogueOutput('{}');
}
