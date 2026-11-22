import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiKeyStorageException implements Exception {
  const ApiKeyStorageException();
  @override
  String toString() => kIsWeb
      // The web implementation needs WebCrypto, which browsers only expose in
      // a secure context. Plain-HTTP origins cannot store the key at all.
      ? '浏览器安全存储不可用：请使用 HTTPS（或 localhost）打开网页版，并允许本站点保存数据。原密钥不会被清除。'
      : '安全存储暂时不可用，请解锁设备后重试；原密钥不会主动清除。';
}

/// The only module that may access credentials. No readAll/export/logging.
class ApiKeyStorage {
  ApiKeyStorage({FlutterSecureStorage? storage})
    : _storage =
          storage ??
          const FlutterSecureStorage(
            aOptions: AndroidOptions(
              storageNamespace: 'fish_api_credentials',
              resetOnError: false,
              migrateWithBackup: false,
              keyCipherAlgorithm:
                  KeyCipherAlgorithm.RSA_ECB_OAEPwithSHA_256andMGF1Padding,
              storageCipherAlgorithm: StorageCipherAlgorithm.AES_GCM_NoPadding,
            ),
            iOptions: IOSOptions(
              accountName: 'com.yuzhe.fishtextadventure.api',
              accessibility: KeychainAccessibility.unlocked_this_device,
              synchronizable: false,
            ),
            // Web: AES-GCM encrypted value in localStorage. The wrapping key
            // also lives in the same origin storage; this is browser-grade
            // isolation, not a hardware keystore. Never use a public computer.
            webOptions: WebOptions(
              publicKey: 'fish_web_credentials_v1',
              useSessionStorage: false,
            ),
          );
  static const _name = 'deepseek_api_key_v1';
  final FlutterSecureStorage _storage;

  static bool isValidInput(String value) =>
      RegExp(r'^[\x21-\x7E]{8,512}$').hasMatch(value.trim());

  Future<void> saveApiKey(String value) async {
    if (!isValidInput(value)) {
      throw const FormatException('请输入 8–512 位、不含空格的 API Key');
    }
    try {
      await _storage.write(key: _name, value: value.trim());
    } catch (_) {
      throw const ApiKeyStorageException();
    }
  }

  Future<String?> readApiKey() async {
    try {
      return await _storage.read(key: _name);
    } catch (_) {
      throw const ApiKeyStorageException();
    }
  }

  Future<bool> hasApiKey() async {
    try {
      return await _storage.containsKey(key: _name);
    } catch (_) {
      throw const ApiKeyStorageException();
    }
  }

  Future<void> deleteApiKey() async {
    try {
      await _storage.delete(key: _name);
    } catch (_) {
      throw const ApiKeyStorageException();
    }
  }

  // One platform write replaces the named item; never delete the old item first.
  Future<void> updateApiKey(String value) => saveApiKey(value);
}
