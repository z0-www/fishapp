import 'dart:convert';
import 'dart:isolate';
import 'dart:math';
import 'dart:typed_data';

import 'package:crypto/crypto.dart' as hash;
import 'package:cryptography/cryptography.dart';

/// Thrown for a malformed archive, wrong password or size violation.
class YuzheCodecException implements Exception {
  const YuzheCodecException(this.message);
  final String message;
  @override
  String toString() => message;
}

/// In-memory encoder/decoder for the `.yuzhe` v1 container.
///
/// This is the codec used by the browser app and the standalone offline
/// converter. The native app keeps a streaming file adapter over the same
/// frame format; cross-backend tests verify byte compatibility.
///
/// Frame format:
///   "YUZHE" + version(1) + encryptedFlag + [16-byte salt]
///   repeated: uint32 big-endian length + JSON frame
///   final frame: `{"end": "<sha256 of all preceding frames>"}`
///
/// With a password the JSON frames are AES-GCM encrypted; the nonce and AAD
/// are derived from the header and frame index.
class YuzheCodec {
  static const extension = '.yuzhe';
  static const fileLimit = 64 * 1024 * 1024;
  static const frameLimit = 8 * 1024 * 1024;
  static const recordLimit = 100000;
  static const version = 1;
  static final _magic = ascii.encode('YUZHE');
  static final _cipher = AesGcm.with256bits();

  static Future<Uint8List> encode(
    Stream<Map<String, Object?>> records, {
    String? password,
    bool useIsolate = false,
  }) async {
    final random = Random.secure();
    final header = Uint8List.fromList([
      ..._magic,
      version,
      password == null ? 0 : 1,
      if (password != null) ...List.generate(16, (_) => random.nextInt(256)),
    ]);
    final secret = password == null
        ? null
        : await _derive(password, header, useIsolate: useIsolate);
    final hashResult = _Digest();
    final digest = hash.sha256.startChunkedConversion(hashResult);
    final output = BytesBuilder(copy: false);
    var total = header.length;
    var index = 0;
    output.add(header);

    Future<void> frame(Map<String, Object?> row, {bool last = false}) async {
      final bytes = utf8.encode(jsonEncode(row));
      if (bytes.length > frameLimit - 16 || ++index > recordLimit) {
        throw const YuzheCodecException('世界归档超过单条记录或记录数限制。');
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
      if (total > fileLimit) {
        throw const YuzheCodecException('世界归档超过 64 MiB。');
      }
      output.add(_word(encoded.length));
      output.add(encoded);
    }

    await for (final record in records) {
      await frame(record);
    }
    digest.close();
    await frame({'end': hashResult.value.toString()}, last: true);
    return output.takeBytes();
  }

  static Future<String> decode(
    Uint8List bytes,
    Future<void> Function(Map<String, Object?>) onRecord, {
    String? password,
    bool useIsolate = false,
  }) async {
    try {
      return await _decode(
        bytes,
        onRecord,
        password: password,
        useIsolate: useIsolate,
      );
    } on SecretBoxAuthenticationError {
      throw const YuzheCodecException('归档密码错误或加密文件损坏。');
    } on FormatException {
      throw const YuzheCodecException('归档格式损坏。');
    }
  }

  static Future<bool> isEncrypted(Uint8List bytes) async {
    if (bytes.length < 7) {
      throw const YuzheCodecException('归档文件不完整。');
    }
    for (var i = 0; i < _magic.length; i++) {
      if (bytes[i] != _magic[i]) {
        throw const YuzheCodecException('这不是鱼者归档。');
      }
    }
    if (bytes[5] != version || bytes[6] > 1) {
      throw const YuzheCodecException('暂不支持这个归档版本，请更新鱼者。');
    }
    return bytes[6] == 1;
  }

  static Future<String> _decode(
    Uint8List bytes,
    Future<void> Function(Map<String, Object?>) onRecord, {
    String? password,
    required bool useIsolate,
  }) async {
    final reader = _MemoryReader(bytes);
    final size = bytes.length;
    if (size > fileLimit) {
      throw const YuzheCodecException('世界归档超过 64 MiB。');
    }
    final header = await _header(reader);
    final encrypted = header.length > 7;
    if (encrypted && password == null) {
      throw const YuzheCodecException('请输入归档密码。');
    }
    final secret = encrypted
        ? await _derive(password!, header, useIsolate: useIsolate)
        : null;
    final hashResult = _Digest();
    final digest = hash.sha256.startChunkedConversion(hashResult);
    for (var index = 1; index <= recordLimit; index++) {
      final lengthWord = await _exact(reader, 4);
      final length = ByteData.sublistView(lengthWord).getUint32(0);
      if (length < (encrypted ? 18 : 2) ||
          length > frameLimit ||
          length > size - reader.position) {
        throw const YuzheCodecException('归档记录损坏或不完整。');
      }
      final encoded = await _exact(reader, length);
      final List<int> frameBytes;
      if (secret == null) {
        frameBytes = encoded;
      } else {
        frameBytes = await _cipher.decrypt(
          SecretBox(
            Uint8List.sublistView(encoded, 0, length - 16),
            nonce: _nonce(header, index),
            mac: Mac(Uint8List.sublistView(encoded, length - 16)),
          ),
          secretKey: secret,
          aad: [...header, ..._word(index)],
        );
      }
      final decoded = jsonDecode(utf8.decode(frameBytes));
      if (decoded is! Map<String, Object?>) {
        throw const YuzheCodecException('归档记录结构无效。');
      }
      if (decoded.containsKey('end')) {
        digest.close();
        final verified = hashResult.value.toString();
        if (decoded.length != 1 ||
            verified != decoded['end'] ||
            reader.position != size ||
            (await reader.read(1)).isNotEmpty) {
          throw const YuzheCodecException('归档完整性校验失败。');
        }
        return verified;
      }
      digest.add(_word(frameBytes.length));
      digest.add(frameBytes);
      await onRecord(decoded);
    }
    throw const YuzheCodecException('归档超过记录数限制或缺少完整性校验。');
  }

  static Future<Uint8List> _header(_MemoryReader input) async {
    final base = await _exact(input, 7);
    for (var i = 0; i < _magic.length; i++) {
      if (base[i] != _magic[i]) {
        throw const YuzheCodecException('这不是鱼者归档。');
      }
    }
    if (base[5] != version || base[6] > 1) {
      throw const YuzheCodecException('暂不支持这个归档版本，请更新鱼者。');
    }
    return base[6] == 0
        ? base
        : Uint8List.fromList([...base, ...await _exact(input, 16)]);
  }

  static Future<Uint8List> _exact(_MemoryReader input, int length) async {
    final value = await input.read(length);
    if (value.length != length) {
      throw const YuzheCodecException('归档文件不完整。');
    }
    return value;
  }

  static Uint8List _word(int number) =>
      (ByteData(4)..setUint32(0, number)).buffer.asUint8List();

  static List<int> _nonce(Uint8List header, int index) => [
    ...header.sublist(7, 15),
    ..._word(index),
  ];

  static Future<SecretKey> _derive(
    String password,
    Uint8List header, {
    required bool useIsolate,
  }) async {
    if (password.isEmpty || password.length > 256) {
      throw const YuzheCodecException('归档密码长度应为 1–256 个字符。');
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

    // Browsers cannot spawn isolates; the native app passes true to avoid
    // blocking its UI thread. The converter is a web build and passes false.
    final bytes = useIsolate ? await Isolate.run(derive) : await derive();
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

class _MemoryReader {
  _MemoryReader(this.bytes);
  final Uint8List bytes;
  var _offset = 0;
  int get position => _offset;
  Future<Uint8List> read(int count) async {
    if (count <= 0 || _offset >= bytes.length) return Uint8List(0);
    final end = min(_offset + count, bytes.length);
    final value = Uint8List.sublistView(bytes, _offset, end);
    _offset = end;
    return value;
  }
}
