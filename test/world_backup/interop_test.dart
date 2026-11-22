import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:fishtextadventure/features/world_backup/data/backup_format.dart';
import 'package:flutter_test/flutter_test.dart';

/// Native file backend and browser memory backend are two adapters over one
/// codec. This test proves an archive written by one can be read by the other,
/// which is the requirement for Android -> Web and Web -> Android `.yuzhe`
/// migration.
void main() {
  late Directory temp;
  late File file;

  setUp(() async {
    temp = await Directory.systemTemp.createTemp('fish-yuzhe-interop-');
    file = File('${temp.path}/interop.yuzhe');
  });
  tearDown(() async {
    await temp.delete(recursive: true);
  });

  Stream<Map<String, Object?>> records() async* {
    yield {'primary': 'world-interop'};
    yield {
      'table': 'worlds',
      'row': {
        'id': 'world-interop',
        'title': '潮汐图书馆',
        'genre': '幻想',
        'summary': '海面下的图书馆',
        'created_at': 0,
      },
    };
    yield {
      'table': 'roleplay_saves',
      'row': {
        'world_id': 'world-interop',
        'revision': 1,
        'payload': jsonEncode({'worldId': 'world-interop', 'revision': 1}),
      },
    };
  }

  Future<(String, List<Map<String, Object?>>)> readFile(
    File source, {
    String? password,
  }) async {
    final rows = <Map<String, Object?>>[];
    final fingerprint = await StoryBackupFormat.read(
      source,
      (row) async {
        rows.add(row);
      },
      password: password,
    );
    return (fingerprint, rows);
  }

  Future<(String, List<Map<String, Object?>>)> readBytes(
    Uint8List bytes, {
    String? password,
  }) async {
    final rows = <Map<String, Object?>>[];
    final fingerprint = await StoryBackupFormat.decodeBytes(
      bytes,
      (row) async {
        rows.add(row);
      },
      password: password,
    );
    return (fingerprint, rows);
  }

  test('native file archive is readable from browser memory bytes', () async {
    await StoryBackupFormat.write(file, records());
    final fromFile = await readFile(file);
    final fromMemory = await readBytes(await file.readAsBytes());

    expect(fromMemory.$1, fromFile.$1);
    expect(fromMemory.$2, fromFile.$2);
    expect(fromFile.$2.first, {'primary': 'world-interop'});
    expect(fromFile.$2.length, 3);
  });

  test('browser memory archive is readable through the native file reader',
      () async {
    final bytes = await StoryBackupFormat.encodeBytes(records());
    final fromMemory = await readBytes(bytes);
    await File('${temp.path}/from-web.yuzhe').writeAsBytes(bytes);
    final fromFile = await readFile(File('${temp.path}/from-web.yuzhe'));

    expect(fromFile.$1, fromMemory.$1);
    expect(fromFile.$2, fromMemory.$2);
  });

  test('password-protected memory archive interoperates with file reader',
      () async {
    final bytes = await StoryBackupFormat.encodeBytes(
      records(),
      password: '跨端密码-2026',
    );
    final encrypted = File('${temp.path}/encrypted.yuzhe');
    await encrypted.writeAsBytes(bytes);
    final fromFile = await readFile(encrypted, password: '跨端密码-2026');
    final fromMemory = await readBytes(bytes, password: '跨端密码-2026');

    expect(fromFile.$1, fromMemory.$1);
    expect(fromMemory.$2, fromFile.$2);

    await expectLater(
      readBytes(bytes, password: '错误密码'),
      throwsA(isA<BackupFailure>()),
    );
    expect(await StoryBackupFormat.isEncryptedBytes(bytes), isTrue);
  });
}
