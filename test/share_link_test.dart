import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fishtextadventure/core/database/app_database.dart';
import 'package:fishtextadventure/features/import_center/data/deepseek_share_import_service.dart';
import 'package:fishtextadventure/features/import_center/data/pending_share_repository.dart';
import 'package:fishtextadventure/features/import_center/domain/import_models.dart';
import 'package:fishtextadventure/features/story_world/data/story_repository.dart';

const link = 'https://chat.deepseek.com/share/fixture-123';
Map<String, dynamic> fixture({bool partial = false}) => {
  'code': 0,
  'data': {
    'biz_code': 0,
    'biz_data': {
      'title': '灯塔旧事',
      'current_message_id': 3,
      'messages': [
        {
          'id': 1,
          'parent_id': partial ? 88 : null,
          'role': 'USER',
          'created_at': 1700000000,
          'fragments': [
            {'type': 'REQUEST', 'content': '世界背景：雾港\n玩家身份：记者\n地点：灯塔'},
          ],
        },
        {
          'id': 2,
          'parent_id': 1,
          'role': 'ASSISTANT',
          'created_at': 1700000001,
          'attachments': [
            {
              'id': 'attachment-1',
              'name': '旧照片',
              'url': 'https://untrusted.invalid/picture',
            },
          ],
          'fragments': [
            {'type': 'THINK', 'content': '不可作为剧情的内部片段'},
            {
              'type': 'SEARCH',
              'results': [
                {'url': 'https://untrusted.invalid/'},
              ],
            },
            {'type': 'RESPONSE', 'content': '场景：海雾里传来敲门声。'},
          ],
        },
        {
          'id': 3,
          'parent_id': 2,
          'role': 'USER',
          'fragments': [
            {'type': 'REQUEST', 'content': '我在门外等候。'},
          ],
        },
        {
          'id': 4,
          'parent_id': 2,
          'role': 'USER',
          'fragments': [
            {'type': 'REQUEST', 'content': '另一个分支：离开灯塔。'},
          ],
        },
      ],
    },
  },
};

class ShareAdapter implements HttpClientAdapter {
  ShareAdapter({this.status = 200, this.body, this.fail = false});
  final int status;
  final String? body;
  final bool fail;
  int calls = 0;
  RequestOptions? last;
  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    calls++;
    last = options;
    if (fail) {
      throw DioException(
        requestOptions: options,
        message: 'sensitive raw error',
        type: DioExceptionType.connectionError,
      );
    }
    return ResponseBody.fromString(
      body ?? jsonEncode(fixture()),
      status,
      headers: {
        'content-type': ['application/json'],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

void main() {
  test('message_id aliases preserve parent references and fragments', () {
    final data = fixture();
    final rows = data['data']['biz_data']['messages'] as List;
    for (final row in rows.cast<Map>()) {
      row['message_id'] = row.remove('id').toString();
    }
    final draft = DeepSeekShareImportService.parse(jsonEncode(data));
    expect(draft.messages[1].parentId, '1');
    expect(draft.messages[1].content, contains('敲门声'));
    expect(draft.currentMessageId, '3');
    rows.first['id'] = 'different';
    expect(
      () => DeepSeekShareImportService.parse(jsonEncode(data)),
      throwsA(isA<ImportFailure>()),
    );
  });

  test('share without story text does not produce a saveable conversation', () {
    final data = fixture();
    for (final row
        in (data['data']['biz_data']['messages'] as List).cast<Map>()) {
      row['fragments'] = [
        {'type': 'THINK', 'content': 'internal only'},
      ];
    }
    expect(
      () => DeepSeekShareImportService.parse(jsonEncode(data)),
      throwsA(
        isA<ImportFailure>().having(
          (failure) => failure.message,
          'message',
          contains('正文'),
        ),
      ),
    );
  });

  test('only exact official HTTPS share paths accepted', () {
    expect(DeepSeekShareImportService.shareId(link), 'fixture-123');
    for (final bad in [
      'http://chat.deepseek.com/share/fixture-123',
      'https://chat.deepseek.com.evil.test/share/fixture-123',
      'https://user@chat.deepseek.com/share/fixture-123',
      'https://chat.deepseek.com:444/share/fixture-123',
      '$link?redirect=https://evil.test',
      '$link#extra',
      'https://chat.deepseek.com/a/chat/private-123',
      'https://127.0.0.1/share/fixture-123',
      'https://chat.deepseek.com/share/%2e%2e/private',
    ]) {
      expect(DeepSeekShareImportService.accepts(bad), false, reason: bad);
    }
  });
  test('unconfirmed or unpermitted reads send zero requests', () async {
    final adapter = ShareAdapter();
    final service = DeepSeekShareImportService(adapter: adapter);
    addTearDown(service.close);
    await expectLater(
      service.fetch(link, confirmed: false),
      throwsA(isA<ImportFailure>()),
    );
    await expectLater(
      service.fetch(link, confirmed: true),
      throwsA(isA<ImportFailure>()),
    );
    expect(adapter.calls, 0);
  });
  test(
    'permitted contract fetch anonymous, no cookies, no redirects',
    () async {
      final adapter = ShareAdapter();
      final service = DeepSeekShareImportService(
        adapter: adapter,
        accessPermitted: true,
      );
      addTearDown(service.close);
      final draft = await service.fetch(link, confirmed: true);
      expect(adapter.calls, 1);
      expect(adapter.last!.uri.host, 'chat.deepseek.com');
      expect(adapter.last!.uri.queryParameters, {'share_id': 'fixture-123'});
      expect(
        adapter.last!.headers.keys.map((v) => v.toLowerCase()),
        isNot(contains('authorization')),
      );
      expect(
        adapter.last!.headers.keys.map((v) => v.toLowerCase()),
        isNot(contains('cookie')),
      );
      expect(adapter.last!.followRedirects, false);
      expect(draft.messages.length, 4);
    },
  );
  for (final status in [301, 401, 403, 404, 410, 500]) {
    test('HTTP $status preserves local files with safe error', () async {
      final adapter = ShareAdapter(
        status: status,
        body: 'private error details',
      );
      final service = DeepSeekShareImportService(
        adapter: adapter,
        accessPermitted: true,
      );
      addTearDown(service.close);
      await expectLater(
        service.fetch(link, confirmed: true),
        throwsA(
          isA<ImportFailure>().having(
            (e) => e.message,
            'safe',
            isNot(contains('private error')),
          ),
        ),
      );
      expect(adapter.calls, 1);
    });
  }
  test('zero is a real parent when message zero exists, not a missing-root sentinel', () {
    final data = fixture();
    final rows = (data['data'] as Map)['biz_data']['messages'] as List;
    rows.first['id'] = 0;
    rows[1]['parent_id'] = 0;
    final draft = DeepSeekShareImportService.parse(jsonEncode(data));
    expect(draft.messages[1].parentId, '0');
    expect(draft.messages.first.parentId, null);
  });
  test('invalid and partial shares never invent text; metadata survives', () {
    final raw = jsonEncode(fixture(partial: true));
    final d = DeepSeekShareImportService.parse(raw);
    expect(d.rawDocument, raw);
    expect(d.messages.first.parentId, null);
    expect(d.messages[1].content, '场景：海雾里传来敲门声。');
    expect(d.messages[1].rawJson, contains('created_at'));
    expect(d.messages[1].rawJson, contains('attachment-1'));
    expect(d.messages[1].content, isNot(contains('内部片段')));
    expect(d.branches, 1);
    expect(d.currentMessageId, '3');
    expect(d.warnings.join(), contains('不完整导入'));
    expect(d.warnings.join(), contains('缺失父节点'));
    expect(
      () => DeepSeekShareImportService.parse(
        '{"code":0,"data":{"biz_code":1,"biz_data":null}}',
      ),
      throwsA(isA<ImportFailure>()),
    );
  });
  test('cycles duplicates malformed and excessive payload rejected', () {
    final data = fixture();
    ((data['data'] as Map)['biz_data']['messages'] as List).first['parent_id'] =
        3;
    expect(
      () => DeepSeekShareImportService.parse(jsonEncode(data)),
      throwsA(isA<ImportFailure>()),
    );
    final duplicate = fixture();
    ((duplicate['data'] as Map)['biz_data']['messages'] as List)[1]['id'] = 1;
    expect(
      () => DeepSeekShareImportService.parse(jsonEncode(duplicate)),
      throwsA(isA<ImportFailure>()),
    );
    expect(
      () => DeepSeekShareImportService.parse('not json'),
      throwsA(isA<ImportFailure>()),
    );
    expect(
      () => DeepSeekShareImportService.parse(
        'x' * (DeepSeekShareImportService.maxBytes + 1),
      ),
      throwsA(isA<ImportFailure>()),
    );
  });
  test('duplicate saves are idempotent; raw response and selected branch persisted', () async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(db.close);
    final repo = PendingShareRepository(db);
    final id = await repo.receive(
      IncomingShare(
        id: 'fixture-share',
        source: ImportSource.paste,
        receivedAt: DateTime(2026),
        text: link,
      ),
    );
    final raw = jsonEncode(fixture());
    final d = DeepSeekShareImportService.parse(raw);
    final a = await repo.save(id, d, ImportDestination.history);
    final b = await repo.save(id, d, ImportDestination.history);
    expect(a.conversationId, b.conversationId);
    expect(await repo.messages(a.conversationId), hasLength(4));
    final stored = await db.select(db.derivedImportResults).get();
    expect(stored, hasLength(1));
    expect(jsonDecode(stored.single.derivedJson)['raw'], raw);
    final branch = await ConversationImportService(db)
        .branch(a.conversationId, '3');
    expect(branch.map((m) => m.messageId), ['1', '2', '3']);
    expect(await db.select(db.worlds).get(), isEmpty);
  });
}
