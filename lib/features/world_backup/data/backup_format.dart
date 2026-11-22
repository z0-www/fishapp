import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'dart:math';
import 'dart:typed_data';

import 'package:crypto/crypto.dart' as hash;
import 'package:cryptography/cryptography.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:yuzhe_codec/yuzhe_codec.dart';

class BackupFailure implements Exception {
  const BackupFailure(this.message);
  final String message;
}

/// The `.yuzhe` container: magic header + length-prefixed JSON frames, with an
/// optional AES-GCM envelope and a SHA-256 chain for integrity.
///
/// The same codec serves native files (streamed through [RandomAccessFile]) and
/// browsers (in-memory bytes), so Android/iOS/Web archives stay byte-compatible.
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
    final writer = _FileWriter(await file.open(mode: FileMode.write));
    try {
      await _write(writer, records, password: password);
      await writer.flush();
    } finally {
      await writer.close();
    }
  }

  /// Encodes an archive fully in memory for browser downloads.
  static Future<Uint8List> encodeBytes(
    Stream<Map<String, Object?>> records, {
    String? password,
  }) async {
    try {
      return await YuzheCodec.encode(
        records,
        password: password,
        useIsolate: !kIsWeb,
      );
    } on YuzheCodecException catch (error) {
      throw BackupFailure(error.message);
    }
  }

  static Future<bool> isEncrypted(File file) async {
    final reader = _FileReader(file);
    try {
      return (await _header(reader)).length > 7;
    } finally {
      await reader.close();
    }
  }

  static Future<bool> isEncryptedBytes(Uint8List bytes) async {
    try {
      return await YuzheCodec.isEncrypted(bytes);
    } on YuzheCodecException catch (error) {
      throw BackupFailure(error.message);
    }
  }

  static Future<String> read(
    File file,
    Future<void> Function(Map<String, Object?>) onRecord, {
    String? password,
  }) async {
    final reader = _FileReader(file);
    try {
      return await _read(reader, onRecord, password: password);
    } finally {
      await reader.close();
    }
  }

  /// Decodes an archive held in browser memory.
  static Future<String> decodeBytes(
    Uint8List bytes,
    Future<void> Function(Map<String, Object?>) onRecord, {
    String? password,
  }) async {
    try {
      return await YuzheCodec.decode(
        bytes,
        onRecord,
        password: password,
        useIsolate: !kIsWeb,
      );
    } on YuzheCodecException catch (error) {
      throw BackupFailure(error.message);
    }
  }

  static Future<void> _write(
    _ByteWriter output,
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
    var total = header.length;
    var index = 0;
    await output.add(header);
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
      await output.add(_word(encoded.length));
      await output.add(encoded);
    }

    await for (final record in records) {
      await frame(record);
    }
    digest.close();
    await frame({'end': hashResult.value.toString()}, last: true);
  }

  static Future<String> _read(
    _ByteReader input,
    Future<void> Function(Map<String, Object?>) onRecord, {
    String? password,
  }) async {
    try {
      return await _decode(input, onRecord, password: password);
    } on SecretBoxAuthenticationError {
      throw const BackupFailure('归档密码错误或加密文件损坏。');
    } on FormatException {
      throw const BackupFailure('归档格式损坏。');
    }
  }

  static Future<String> _decode(
    _ByteReader input,
    Future<void> Function(Map<String, Object?>) onRecord, {
    String? password,
  }) async {
    final size = input.size;
    if (size > fileLimit) throw const BackupFailure('世界归档超过 64 MiB。');
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
          length > size - input.position) {
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
            input.position != size ||
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
  }

  static Future<Uint8List> _header(_ByteReader input) async {
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

  static Future<Uint8List> _exact(_ByteReader input, int length) async {
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
    Future<List<int>> derive() async {
      final key = await Pbkdf2(
        macAlgorithm: Hmac.sha256(),
        iterations: 600000,
        bits: 256,
      ).deriveKeyFromPassword(password: password, nonce: salt);
      return key.extractBytes();
    }

    // Browsers have no isolates; the WebCrypto PBKDF2 implementation keeps the
    // iterations off the pure-Dart hot path.
    final bytes = kIsWeb ? await derive() : await Isolate.run(derive);
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

abstract interface class _ByteWriter {
  Future<void> add(List<int> bytes);
  Future<void> flush();
  Future<void> close();
}

class _FileWriter implements _ByteWriter {
  _FileWriter(this.file);
  final RandomAccessFile file;
  @override
  Future<void> add(List<int> bytes) => file.writeFrom(bytes);
  @override
  Future<void> flush() => file.flush();
  @override
  Future<void> close() => file.close();
}

abstract interface class _ByteReader {
  int get size;
  int get position;
  Future<Uint8List> read(int count);
  Future<void> close();
}

class _FileReader implements _ByteReader {
  _FileReader(File file) : _file = file, _raf = file.openSync();
  final File _file;
  final RandomAccessFile _raf;
  late final int _size = _file.lengthSync();
  @override
  int get size => _size;
  @override
  int get position => _raf.positionSync();
  @override
  Future<Uint8List> read(int count) async => _raf.read(count);
  @override
  Future<void> close() => _raf.close();
}
