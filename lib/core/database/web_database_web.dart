import 'dart:async';

import 'package:drift/drift.dart';
import 'package:drift/wasm.dart';

import '../../platform/web/boot_trace_stub.dart'
    if (dart.library.js_interop) '../../platform/web/boot_trace_web.dart';

const _databaseName = 'fish_text_adventure';
const _probeTimeout = Duration(seconds: 15);
const _openTimeout = Duration(seconds: 20);

/// Web database connection.
///
/// The normal drift opener prefers OPFS. On some Safari versions the OPFS
/// worker/probe can stall indefinitely, so this opener deliberately uses
/// IndexedDB for *new* databases while preserving an already-existing OPFS
/// database if one is found. It never opens an empty replacement when an
/// existing database was detected but cannot be opened.
QueryExecutor openFishDatabase() {
  return DatabaseConnection.delayed(_openWebDatabase());
}

Future<DatabaseConnection> _openWebDatabase() async {
  bootStage('db-probe-start');
  final probe = await WasmDatabase.probe(
    sqlite3Uri: Uri.parse('sqlite3.wasm'),
    driftWorkerUri: Uri.parse('drift_worker.js'),
    databaseName: _databaseName,
  ).timeout(
    _probeTimeout,
    onTimeout: () => throw TimeoutException(
      '数据库 Worker/WASM 探测超过 ${_probeTimeout.inSeconds} 秒',
    ),
  );
  bootStage(
    'db-probe-done',
    'storage=${probe.availableStorages.map((e) => e.name).join(",")}',
  );

  final existing = probe.existingDatabases
      .where((entry) => entry.$2 == _databaseName)
      .toList();
  final selected = _selectImplementation(probe, existing);

  bootStage('db-selected', selected.name);

  final connection = await probe
      .open(selected, _databaseName, enableMigrations: true)
      .timeout(
        _openTimeout,
        onTimeout: () => throw TimeoutException(
          '数据库打开超过 ${_openTimeout.inSeconds} 秒',
        ),
      );
  bootStage('db-open-done', selected.name);
  return connection;
}

WasmStorageImplementation _selectImplementation(
  WasmProbeResult probe,
  List<ExistingDatabase> existing,
) {
  if (existing.isNotEmpty) {
    // Never silently switch storage when a database already exists: that would
    // look like an empty app and could hide the user's stories.
    for (final storage in const [WebStorageApi.opfs, WebStorageApi.indexedDb]) {
      final hasExisting = existing.any((entry) => entry.$1 == storage);
      if (!hasExisting) continue;
      final candidates = probe.availableStorages
          .where((entry) => entry.storageApi == storage)
          .toList();
      if (candidates.isNotEmpty) return candidates.first;
    }
    throw StateError(
      '检测到已有数据库，但当前浏览器无法打开它；为保护存档，未创建空数据库。',
    );
  }

  // New database: IndexedDB is the reliable path on Safari/iOS. The old
  // OPFS-first behavior is what made some Safari launches wait forever.
  final indexedDb = probe.availableStorages
      .where((entry) => entry.storageApi == WebStorageApi.indexedDb)
      .toList();
  if (indexedDb.isNotEmpty) return indexedDb.first;

  final opfs = probe.availableStorages
      .where((entry) => entry.storageApi == WebStorageApi.opfs)
      .toList();
  if (opfs.isNotEmpty) return opfs.first;

  throw StateError(
    '当前浏览器没有可用的 OPFS 或 IndexedDB 持久化存储；'
    '为避免用内存假数据库覆盖存档，启动已停止。',
  );
}
