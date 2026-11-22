import 'dart:convert';
import 'dart:io';

import 'package:archive/archive.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:fish_converter/fish_converter.dart';
import 'package:fishtextadventure/core/database/app_database.dart';
import 'package:fishtextadventure/features/world_backup/data/backup_format.dart';
import 'package:fishtextadventure/features/story_world/data/story_repository.dart';
import 'package:fishtextadventure/features/world_backup/data/story_backup.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yuzhe_codec/yuzhe_codec.dart';

/// V1.2.1 compatibility tests.
///
/// Every positive case goes through the real converter parser/archive builder
/// and the main app's real StoryBackup inspector/restorer. No mock restorer is
/// used here.
void main() {
  late Directory temp;
  var sequence = 0;

  setUp(() async {
    temp = await Directory.systemTemp.createTemp('fish-v121-');
  });
  tearDown(() async {
    await temp.delete(recursive: true);
  });

  Future<_Restored> restore(
    ConvertSession session, {
    String? password,
    AppDatabase? existingDb,
    StoryBackup? existingBackup,
  }) async {
    final output = await buildYuzhe(
      session,
      password: password,
      now: DateTime.utc(2026, 2, 3, 4, 5, 6),
    );
    final file = File('${temp.path}/archive-${sequence++}.yuzhe');
    await file.writeAsBytes(output.bytes);
    final db = existingDb ?? AppDatabase.forTesting(NativeDatabase.memory());
    if (existingDb == null) addTearDown(db.close);
    final backup =
        existingBackup ??
        StoryBackup(db, Directory('${temp.path}/attachments-${sequence++}'));
    final preview = await backup.inspect(file, password: password);
    final worldId = await backup.restore(file, preview, password: password);
    final messages = await (db.select(
      db.importedMessages,
    )..orderBy([(t) => OrderingTerm.asc(t.ordinal)])).get();
    final worlds = await db.select(db.worlds).get();
    final checkpoints = await db.select(db.storyCheckpoints).get();
    final branches = await db.select(db.storyBranches).get();
    final timeline = await (db.select(db.timelineEntries)..orderBy([(t) => OrderingTerm.asc(t.id)])).get();
    return _Restored(
      db: db,
      backup: backup,
      file: file,
      preview: preview,
      worldId: worldId,
      messages: messages,
      worlds: worlds,
      checkpoints: checkpoints,
      branches: branches,
      timeline: timeline,
    );
  }

  test('100 messages preserve count, roles, bodies, order and timestamps',
      () async {
    final source = <String, Object?>{
      'version': '1.0',
      'sessions': [
        {
          'id': 'hundred',
          'name': '一百条消息',
          'createdAt': '2026-01-02T03:04:05Z',
          'messages': [
            for (var i = 0; i < 100; i++)
              {
                'id': 'source-$i',
                'role': switch (i % 4) {
                  0 => 'human',
                  1 => 'ai',
                  2 => 'system',
                  _ => 'tool',
                },
                'content': i == 0
                    ? '第一行\n第二行 “引号” \\ 中文'
                    : '消息 $i：多行文本\n第二行 <tag> & 特殊字符',
                if (i % 10 == 0) 'timestamp': '2026-01-02T03:04:${i ~/ 10}Z',
              },
          ],
        },
      ],
    };
    final parsed = parseConversationFile(
      'hundred.json',
      utf8.encode(jsonEncode(source)),
    );
    final session = parsed.sessions.single;
    expect(session.messages, hasLength(100));
    expect(session.messages.map((m) => m.role), [
      for (var i = 0; i < 100; i++)
        switch (i % 4) {
          0 => 'user',
          1 => 'assistant',
          2 => 'system',
          _ => 'tool',
        },
    ]);

    final restored = await restore(session);
    expect(restored.messages, hasLength(100));
    expect(restored.messages.map((m) => m.role), session.messages.map((m) => m.role));
    expect(
      restored.messages.map((m) => m.body),
      session.messages.map((m) => m.content),
    );
    expect(restored.messages.map((m) => m.ordinal), List.generate(100, (i) => i));
    expect(restored.messages.map((m) => m.messageId).toSet(), hasLength(100));
    expect(restored.timeline, hasLength(100));
    expect(restored.checkpoints, hasLength(1));
    expect(restored.branches, hasLength(1));
    expect(restored.branches.single.parentWorldId, null);
    expect(restored.branches.single.worldId, restored.worldId);
    for (var i = 0; i < 100; i += 10) {
      expect(restored.messages[i].rawJson, contains('2026-01-02T03:04:'));
      final timeline = jsonDecode(restored.timeline[i].payload) as Map;
      expect(timeline['sourceTimestamp'], isA<String>());
    }
    final events = await EventTimeline(restored.db).entries(restored.worldId);
    expect(events, hasLength(100));
    expect(
      events.map((event) => event['sourceOrdinal']),
      List.generate(100, (i) => i),
    );
    expect(restored.worlds.single.createdAt.toUtc(), DateTime.parse('2026-01-02T03:04:05Z'));
  });

  test('1000 messages survive conversion and real app restore', () async {
    final source = <String, Object?>{
      'sessions': [
        {
          'id': 'thousand',
          'name': '一千条消息',
          'messages': [
            for (var i = 0; i < 1000; i++)
              {
                'id': 's-$i',
                'role': i.isEven ? 'user' : 'assistant',
                'content': i == 999 ? '最后一条：END' : '第 $i 条消息',
              },
          ],
        },
      ],
    };
    final parsed = parseConversationFile(
      'thousand.json',
      utf8.encode(jsonEncode(source)),
    );
    final session = parsed.sessions.single;
    expect(session.messages, hasLength(1000));
    final restored = await restore(session);
    expect(restored.messages, hasLength(1000));
    expect(restored.messages.first.body, '第 0 条消息');
    expect(restored.messages.last.body, '最后一条：END');
    expect(restored.messages.last.ordinal, 999);
    expect(restored.messages.map((m) => m.role).toSet(), {'user', 'assistant'});
    expect(restored.messages.map((m) => m.ordinal), List.generate(1000, (i) => i));
    expect(restored.timeline, hasLength(1000));
  });

  test('empty and missing message bodies are kept, not dropped', () async {
    final source = <String, Object?>{
      'sessions': [
        {
          'id': 'empty-body',
          'name': '空正文',
          'messages': [
            {'role': 'user', 'content': ''},
            {'role': 'assistant'},
            {'role': 'user', 'content': '非空正文'},
            {'role': 'assistant', 'content': '   '},
          ],
        },
      ],
    };
    final parsed = parseConversationFile(
      'empty.json',
      utf8.encode(jsonEncode(source)),
    );
    final session = parsed.sessions.single;
    expect(session.messages, hasLength(4));
    expect(session.messages.map((m) => m.content), ['', '', '非空正文', '   ']);
    final restored = await restore(session);
    expect(restored.messages, hasLength(4));
    expect(restored.messages.map((m) => m.body), ['', '', '非空正文', '   ']);
  });

  test('TXT role-labelled dialogue restores through the real app', () async {
    const text = '''
User: 你好，旅人。
Assistant: 欢迎来到雾港。
User: 这里发生了什么？
Assistant: 灯塔已经熄灭三天了。
''';
    final parsed = parseConversationFile('dialogue.txt', utf8.encode(text));
    final session = parsed.sessions.single;
    expect(session.messages, hasLength(4));
    expect(session.messages.map((m) => m.role), [
      'user',
      'assistant',
      'user',
      'assistant',
    ]);
    final restored = await restore(session);
    expect(restored.messages, hasLength(4));
    expect(restored.messages.map((m) => m.body), [
      '你好，旅人。',
      '欢迎来到雾港。',
      '这里发生了什么？',
      '灯塔已经熄灭三天了。',
    ]);
  });

  test('combined multi-session .yuzhe imports all worlds in one restore', () async {
    final parsed = parseConversationFile(
      'bundle.json',
      utf8.encode(jsonEncode({
        'sessions': [
          for (var s = 0; s < 3; s++)
            {
              'id': 'bundle-$s',
              'name': '合并会话$s',
              'messages': [
                {'role': 'user', 'content': 'BU$s'},
                {'role': 'assistant', 'content': 'BA$s'},
              ],
            },
        ],
      })),
    );
    final output = await buildYuzheBundle(parsed.sessions);
    final file = File('${temp.path}/bundle.yuzhe');
    await file.writeAsBytes(output.bytes);
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(db.close);
    final backup = StoryBackup(db, Directory('${temp.path}/bundle-att'));
    final preview = await backup.inspect(file);
    expect(preview.titles, ['合并会话0', '合并会话1', '合并会话2']);
    expect(preview.counts['worlds'], 3);
    expect(preview.counts['imported_messages'], 6);
    final primary = await backup.restore(file, preview);
    expect(await db.select(db.worlds).get(), hasLength(3));
    expect(await db.select(db.importedMessages).get(), hasLength(6));
    expect(primary, isNotEmpty);
    expect(
      (await db.select(db.importedMessages).get()).map((m) => m.body).toSet(),
      {'BU0', 'BA0', 'BU1', 'BA1', 'BU2', 'BA2'},
    );
  });

  test('extended multi-session ZIP still contains independent archives',
      () async {
    final source = <String, Object?>{
      'sessions': [
        for (var s = 0; s < 3; s++)
          {
            'id': 'multi-$s',
            'name': '会话$s',
            'messages': [
              {'role': 'user', 'content': 'U$s'},
              {'role': 'assistant', 'content': 'A$s'},
            ],
          },
      ],
    };
    final parsed = parseConversationFile(
      'multi.json',
      utf8.encode(jsonEncode(source)),
    );
    expect(parsed.sessions, hasLength(3));
    final bundle = await buildYuzheZip(parsed.sessions);
    final zip = ZipDecoder().decodeBytes(bundle.bytes);
    final files = zip.files.where((f) => f.name.endsWith('.yuzhe')).toList();
    expect(bundle.count, 3);
    expect(files, hasLength(3));
    expect(files.map((f) => f.name).toSet(), hasLength(3));

    final db = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(db.close);
    final backup = StoryBackup(db, Directory('${temp.path}/multi-attachments'));
    for (final entry in files) {
      final file = File('${temp.path}/${entry.name}');
      await file.writeAsBytes(entry.content as List<int>);
      final preview = await backup.inspect(file);
      expect(preview.counts['imported_messages'], 2);
      await backup.restore(file, preview);
    }
    expect(await db.select(db.worlds).get(), hasLength(3));
    expect(await db.select(db.importedMessages).get(), hasLength(6));
    expect(
      (await db.select(db.importedMessages).get()).map((m) => m.body).toSet(),
      {'U0', 'A0', 'U1', 'A1', 'U2', 'A2'},
    );
  });

  test('encrypted archive requires password and still restores', () async {
    final source = <String, Object?>{
      'sessions': [
        {
          'id': 'encrypted',
          'name': '加密归档',
          'messages': [
            {'role': 'user', 'content': '只有密码能看到的正文'},
            {'role': 'assistant', 'content': '加密回复'},
          ],
        },
      ],
    };
    final session = parseConversationFile(
      'encrypted.json',
      utf8.encode(jsonEncode(source)),
    ).sessions.single;
    final output = await buildYuzhe(session, password: 'V121-test-password');
    final file = File('${temp.path}/encrypted.yuzhe');
    await file.writeAsBytes(output.bytes);
    expect(await StoryBackupFormat.isEncrypted(file), isTrue);
    expect(
      latin1.decode(output.bytes),
      isNot(contains('只有密码能看到的正文')),
    );

    final db = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(db.close);
    final backup = StoryBackup(db, Directory('${temp.path}/encrypted-att'));
    await expectLater(
      backup.inspect(file, password: 'wrong-password'),
      throwsA(isA<BackupFailure>()),
    );
    final preview = await backup.inspect(file, password: 'V121-test-password');
    await backup.restore(file, preview, password: 'V121-test-password');
    final messages = await db.select(db.importedMessages).get();
    expect(messages.map((m) => m.body), ['只有密码能看到的正文', '加密回复']);
  });

  test('duplicate restore is rejected without adding a second world', () async {
    final session = parseConversationFile(
      'duplicate.json',
      utf8.encode(jsonEncode({
        'sessions': [
          {
            'id': 'duplicate',
            'name': '重复导入',
            'messages': [
              {'role': 'user', 'content': '只导入一次'},
            ],
          },
        ],
      })),
    ).sessions.single;
    final restored = await restore(session);
    final before = (await restored.db.select(restored.db.worlds).get()).length;
    await expectLater(
      restored.backup.restore(restored.file, restored.preview),
      throwsA(isA<BackupFailure>()),
    );
    expect((await restored.db.select(restored.db.worlds).get()).length, before);
  });

  test('corrupt archive after preview rolls back without polluting worlds',
      () async {
    final session = parseConversationFile(
      'rollback.json',
      utf8.encode(jsonEncode({
        'sessions': [
          {
            'id': 'rollback',
            'name': '回滚测试',
            'messages': [
              {'role': 'user', 'content': '回滚正文'},
            ],
          },
        ],
      })),
    ).sessions.single;
    final output = await buildYuzhe(session);
    final file = File('${temp.path}/rollback.yuzhe');
    await file.writeAsBytes(output.bytes);
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(db.close);
    final backup = StoryBackup(db, Directory('${temp.path}/rollback-att'));
    final preview = await backup.inspect(file);
    final bytes = await file.readAsBytes();
    bytes[bytes.length - 3] ^= 1;
    await file.writeAsBytes(bytes);
    await expectLater(
      backup.restore(file, preview),
      throwsA(isA<BackupFailure>()),
    );
    expect(await db.select(db.worlds).get(), isEmpty);
  });

  test('malformed files and oversize input fail closed', () {
    expect(
      () => parseConversationFile('broken.json', utf8.encode('{broken')),
      throwsA(isA<ConversionException>()),
    );
    expect(
      () => parseConversationFile(
        'broken.zip',
        Uint8List.fromList([0x50, 0x4b, 0x03, 0x04, 1, 2, 3]),
      ),
      throwsA(isA<ConversionException>()),
    );
    expect(
      () => parseConversationFile(
        'invalid-utf8.txt',
        Uint8List.fromList([0xff, 0xfe, 0xfd]),
      ),
      throwsA(isA<ConversionException>()),
    );
    expect(
      () => parseConversationFile('huge.txt', Uint8List(33 * 1024 * 1024)),
      throwsA(isA<ConversionException>()),
    );
  });

  test('APK-generated V1.2.1 archive restores in the real app', () async {
    final sample = File('converter/test-files/v121-apk-generated.yuzhe');
    expect(await sample.exists(), isTrue);
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(db.close);
    final backup = StoryBackup(db, Directory('${temp.path}/apk-att'));
    final preview = await backup.inspect(sample);
    expect(preview.titles, ['雨夜茶馆 · 测试']);
    expect(preview.counts['imported_messages'], 5);
    final worldId = await backup.restore(sample, preview);
    final rows = await (db.select(
      db.importedMessages,
    )..orderBy([(t) => OrderingTerm.asc(t.ordinal)])).get();
    expect(rows.map((m) => m.role), [
      'system',
      'user',
      'assistant',
      'user',
      'assistant',
    ]);
    expect(rows[2].body, contains('雨声很大'));
    final definition = await db.select(db.worldDefinitions).getSingle();
    expect(
      ((jsonDecode(definition.payload) as Map)['customFields'] as Map)['converter']['version'],
      '1.2.1',
    );
    expect(await EventTimeline(db).entries(worldId), hasLength(5));
  });

  test('V1.2.1 metadata is written into the real app schema', () async {
    final session = parseConversationFile(
      'version.json',
      utf8.encode(jsonEncode({
        'sessions': [
          {
            'id': 'version',
            'name': '版本测试',
            'messages': [
              {'role': 'user', 'content': '版本正文'},
            ],
          },
        ],
      })),
    ).sessions.single;
    final restored = await restore(session);
    final definition = await restored.db.select(restored.db.worldDefinitions).getSingle();
    final definitionJson = jsonDecode(definition.payload) as Map;
    final converter = (definitionJson['customFields'] as Map)['converter'] as Map;
    expect(converter['version'], '1.2.1');
    final derived = await restored.db.select(restored.db.derivedImportResults).getSingle();
    expect(
      (jsonDecode(derived.derivedJson) as Map)['version'],
      '1.2.1',
    );
    // Container format and main backup format stay at version 1.
    expect(YuzheCodec.version, 1);
    expect(StoryBackupFormat.version, 1);
  });

  test('converter source/version and service-worker cache are V1.2.1', () {
    final pubspec = File('converter/pubspec.yaml').readAsStringSync();
    final sw = File('converter/web/service_worker.js').readAsStringSync();
    final webMain = File('converter/web/main.dart').readAsStringSync();
    final footer = File('converter/web/index.html').readAsStringSync();
    expect(pubspec, contains('version: 1.2.1'));
    expect(sw, contains("CACHE = 'fish-converter-v1.2.1-mobile'"));
    expect(webMain, contains("_swCache = 'fish-converter-v1.2.1-mobile'"));
    expect(footer, contains('V1.2.1'));
  });
}

class _Restored {
  const _Restored({
    required this.db,
    required this.backup,
    required this.file,
    required this.preview,
    required this.worldId,
    required this.messages,
    required this.worlds,
    required this.checkpoints,
    required this.branches,
    required this.timeline,
  });
  final AppDatabase db;
  final StoryBackup backup;
  final File file;
  final BackupPreview preview;
  final String worldId;
  final List<ImportedMessageRow> messages;
  final List<WorldRow> worlds;
  final List<StoryCheckpointRow> checkpoints;
  final List<StoryBranche> branches;
  final List<TimelineEntry> timeline;
}
