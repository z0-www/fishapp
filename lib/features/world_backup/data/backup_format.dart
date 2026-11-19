import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'dart:math';
import 'dart:typed_data';

import 'package:crypto/crypto.dart' as hash;
import 'package:cryptography/cryptography.dart';

class BackupFailure implements Exception {
  const BackupFailure(this.message);
  final String message;
}

class StoryBackupFormat {
  static const extension = '.yuzhe';
  static const fileLimit = 64 * 1024 * 1024;
  static const frameLimit = 8 * 1024 * 1024;
  static const recordLimit = 100000;
  static const version = 1;
  static final _magic = ascii.encode('YUZHE');
  static final _cipher = AesGcm.with256bits();

  static Future<void> write(
    File file,
    Stream<Map<String, Object?>> records, {
    String? password,
  }) async {
    final random = Random.secure();
    final header = Uint8List.fromList([
      ..._magic,
      version,
      password == null ? 0 : 1,
      if (password != null) ...List.generate(16, (_) => random.nextInt(256)),
    ]);
    final secret = password == null ? null : await _derive(password, header);
    final hashResult = _Digest();
    final digest = hash.sha256.startChunkedConversion(hashResult);
    final output = await file.open(mode: FileMode.write);
    var total = header.length;
    var index = 0;
    try {
      await output.writeFrom(header);
      Future<void> frame(Map<String, Object?> row, {bool last = false}) async {
        final bytes = utf8.encode(jsonEncode(row));
        if (bytes.length > frameLimit - 16 || ++index > recordLimit) {
          throw const BackupFailure('世界归档超过单条记录或记录数限制。');
        }
        if (!last) {
          digest.add(_word(bytes.length));
          digest.add(bytes);
        }
        final List<int> encoded;
        if (secret == null) {
          encoded = bytes;
        } else {
          final box = await _cipher.encrypt(
            bytes,
            secretKey: secret,
            nonce: _nonce(header, index),
            aad: [...header, ..._word(index)],
          );
          encoded = [...box.cipherText, ...box.mac.bytes];
        }
        total += 4 + encoded.length;
        if (total > fileLimit) throw const BackupFailure('世界归档超过 64 MiB。');
        await output.writeFrom(_word(encoded.length));
        await output.writeFrom(encoded);
      }

      await for (final record in records) {
        await frame(record);
      }
      digest.close();
      await frame({'end': hashResult.value.toString()}, last: true);
      await output.flush();
    } finally {
      await output.close();
    }
  }

  static Future<bool> isEncrypted(File file) async {
    final input = await file.open();
    try {
      return (await _header(input)).length > 7;
    } finally {
      await input.close();
    }
  }

  static Future<String> read(
    File file,
    Future<void> Function(Map<String, Object?>) onRecord, {
    String? password,
  }) async {
    final size = await file.length();
    if (size > fileLimit) throw const BackupFailure('世界归档超过 64 MiB。');
    final input = await file.open();
    try {
      final header = await _header(input);
      final encrypted = header.length > 7;
      if (encrypted && password == null) {
        throw const BackupFailure('请输入归档密码。');
      }
      final secret = encrypted ? await _derive(password!, header) : null;
      final hashResult = _Digest();
      final digest = hash.sha256.startChunkedConversion(hashResult);
      for (var index = 1; index <= recordLimit; index++) {
        final lengthWord = await _exact(input, 4);
        final length = ByteData.sublistView(lengthWord).getUint32(0);
        if (length < (encrypted ? 18 : 2) ||
            length > frameLimit ||
            length > size - await input.position()) {
          throw const BackupFailure('归档记录损坏或不完整。');
        }
        final encoded = await _exact(input, length);
        final List<int> bytes;
        if (secret == null) {
          bytes = encoded;
        } else {
          bytes = await _cipher.decrypt(
            SecretBox(
              Uint8List.sublistView(encoded, 0, length - 16),
              nonce: _nonce(header, index),
              mac: Mac(Uint8List.sublistView(encoded, length - 16)),
            ),
            secretKey: secret,
            aad: [...header, ..._word(index)],
          );
        }
        final decoded = jsonDecode(utf8.decode(bytes));
        if (decoded is! Map<String, Object?>) {
          throw const BackupFailure('归档记录结构无效。');
        }
        if (decoded.containsKey('end')) {
          digest.close();
          final verified = hashResult.value.toString();
          if (decoded.length != 1 ||
              verified != decoded['end'] ||
              await input.position() != size ||
              (await input.read(1)).isNotEmpty) {
            throw const BackupFailure('归档完整性校验失败。');
          }
          return verified;
        }
        digest.add(_word(bytes.length));
        digest.add(bytes);
        await onRecord(decoded);
      }
      throw const BackupFailure('归档超过记录数限制或缺少完整性校验。');
    } on SecretBoxAuthenticationError {
      throw const BackupFailure('归档密码错误或加密文件损坏。');
    } on FormatException {
      throw const BackupFailure('归档格式损坏。');
    } finally {
      await input.close();
    }
  }

  static Future<Uint8List> _header(RandomAccessFile input) async {
    final base = await _exact(input, 7);
    for (var i = 0; i < _magic.length; i++) {
      if (base[i] != _magic[i]) throw const BackupFailure('这不是鱼者归档。');
    }
    if (base[5] != version || base[6] > 1) {
      throw const BackupFailure('暂不支持这个归档版本，请更新鱼者。');
    }
    return base[6] == 0
        ? base
        : Uint8List.fromList([...base, ...await _exact(input, 16)]);
  }

  static Future<Uint8List> _exact(RandomAccessFile input, int length) async {
    final value = await input.read(length);
    if (value.length != length) throw const BackupFailure('归档文件不完整。');
    return value;
  }

  static Uint8List _word(int number) =>
      (ByteData(4)..setUint32(0, number)).buffer.asUint8List();

  static List<int> _nonce(Uint8List header, int index) => [
    ...header.sublist(7, 15),
    ..._word(index),
  ];

  static Future<SecretKey> _derive(String password, Uint8List header) async {
    if (password.isEmpty || password.length > 256) {
      throw const BackupFailure('归档密码长度应为 1–256 个字符。');
    }
    final salt = header.sublist(7);
    final bytes = await Isolate.run(() async {
      final key = await Pbkdf2(
        macAlgorithm: Hmac.sha256(),
        iterations: 600000,
        bits: 256,
      ).deriveKeyFromPassword(password: password, nonce: salt);
      return key.extractBytes();
    });
    return SecretKey(bytes);
  }
}

class _Digest implements Sink<hash.Digest> {
  late hash.Digest value;
  @override
  void add(hash.Digest data) => value = data;
  @override
  void close() {}
}
