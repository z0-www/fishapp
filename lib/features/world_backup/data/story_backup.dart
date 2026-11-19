import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:archive/archive_io.dart';
import 'package:crypto/crypto.dart';
import 'package:drift/drift.dart';
import 'package:path/path.dart' as p;

import '../../../core/database/app_database.dart';
import '../../world_creator/domain/world_definition.dart';
import '../../import_center/data/story_parsers.dart';
import 'backup_format.dart';

class BackupPreview {
  const BackupPreview(
    this.fingerprint,
    this.titles,
    this.counts,
    this.missingFiles,
  );
  final String fingerprint;
  final List<String> titles;
  final Map<String, int> counts;
  final int missingFiles;
}

/// The v1 archive schema is independent of the internal Drift schema version.
class StoryBackup {
  StoryBackup(this.db, this.attachmentsDirectory);
  final AppDatabase db;
  final Directory attachmentsDirectory;
  static const _attachmentLimit = 16 * 1024 * 1024;
  static const _chunkLimit = 128 * 1024;
  static const _tables = <String, String>{
    'worlds': 'id title genre summary created_at',
    'pending_imports': 'id fingerprint payload state safe_error received_at',
    'imported_conversations':
        'id job_id title source world_id current_message_id created_at',
    'imported_messages':
        'conversation_id message_id parent_id role body raw_json ordinal',
    'imported_attachments':
        'id conversation_id private_path display_name mime byte_size digest',
    'derived_import_results': 'id conversation_id derived_json created_at',
    'roleplay_saves': 'world_id revision payload',
    'roleplay_turns': 'id world_id base_revision action speaker context_json state response_json mock created_at',
    'roleplay_memories': 'id world_id owner payload',
    'world_definitions': 'world_id version payload saved_at',
    'story_checkpoints': 'id world_id revision payload source_conversation source_message_id created_at',
    'story_branches': 'world_id parent_world_id checkpoint_id source_conversation source_message_id',
    'timeline_entries': 'id world_id revision payload',
    'context_summaries': 'world_id owner version through_revision payload',
  };
  static final _privateField = RegExp(
    r'^(api[_-]?key|authorization|access[_-]?token|refresh[_-]?token|cookie|password)$',
    caseSensitive: false,
  );

  Future<void> export(
    File destination,
    String worldId, {
    String? password,
  }) async {
    try {
      await destination.create(exclusive: true);
    } on PathExistsException {
      throw const BackupFailure('备份目标文件已存在。');
    }
    try {
      await db.transaction(() async {
        await StoryBackupFormat.write(
          destination,
          _snapshot(worldId),
          password: password,
        );
      });
    } catch (_) {
      if (await destination.exists()) await destination.delete();
      rethrow;
    }
  }

  Future<BackupPreview> inspect(File source, {String? password}) async {
    final decoded = _BackupScan();
    final fingerprint = await StoryBackupFormat.read(
      source,
      decoded.read,
      password: password,
    );
    decoded.finish();
    return BackupPreview(
      fingerprint,
      List.unmodifiable(decoded.titles),
      Map.unmodifiable(decoded.counts),
      decoded.missingFiles,
    );
  }

  Future<String> restore(
    File source,
    BackupPreview review, {
    String? password,
  }) async {
    final prefix = 'restore-${_newId()}';
    final dir = Directory(p.join(attachmentsDirectory.path, prefix));
    final session = _BackupScan(
      onChunk: (id, bytes) async {
        await dir.create(recursive: true);
        await File(p.join(dir.path, id))
            .writeAsBytes(bytes, mode: FileMode.append);
      },
      onRow: (table, row) => _insert(table, row, prefix, dir),
    );
    final marker = 'backup-import-${review.fingerprint}';
    try {
      return await db.transaction(() async {
        if (await (db.select(
              db.worldDrafts,
            )..where((t) => t.id.equals(marker))).getSingleOrNull() !=
            null) {
          throw const BackupFailure('这份归档已经导入。');
        }
        final fingerprint = await StoryBackupFormat.read(
          source,
          session.read,
          password: password,
        );
        session.finish();
        if (fingerprint != review.fingerprint) {
          throw const BackupFailure('文件已在预览后变化，请重新预览。');
        }
        await _validateReferences(prefix);
        await db
            .into(db.worldDrafts)
            .insert(
              WorldDraftsCompanion.insert(
                id: marker,
                payload: '{}',
                updatedAt: DateTime.now(),
              ),
            );
        return _linked(prefix, session.primary!);
      });
    } catch (_) {
      if (await dir.exists()) {
        try {
          await dir.delete(recursive: true);
        } on FileSystemException {
          // This import owns the random destination and all of its files.
        }
      }
      rethrow;
    }
  }

  Stream<Map<String, Object?>> _snapshot(String primary) async* {
    if (await (db.select(
          db.worlds,
        )..where((t) => t.id.equals(primary))).getSingleOrNull() ==
        null) {
      throw const BackupFailure('归档世界不存在。');
    }
    final worldIds = <String>{primary};
    var frontier = [primary];
    while (frontier.isNotEmpty) {
      final args = frontier.map(Variable<String>.new).toList();
      final placeholders = _slots(frontier.length);
      final edges = await db
          .customSelect(
            'SELECT DISTINCT w.id FROM worlds w JOIN story_branches b ON '
            '(w.id=b.world_id AND b.parent_world_id IN ($placeholders)) OR '
            '(w.id=b.parent_world_id AND b.world_id IN ($placeholders)) LIMIT 257',
            variables: [...args, ...args],
          )
          .get();
      frontier = edges
          .map((r) => r.read<String>('id'))
          .where(worldIds.add)
          .toList();
      if (worldIds.length > 256) throw const BackupFailure('关联世界超过归档限制。');
    }
    yield {'primary': primary};
    final worldParams = worldIds.map(Variable<String>.new).toList();
    final inWorlds = 'IN (${_slots(worldIds.length)})';
    final conversations =
        '''
      SELECT id FROM imported_conversations WHERE world_id $inWorlds
      UNION SELECT source_conversation FROM story_branches WHERE world_id $inWorlds
      UNION SELECT source_conversation FROM story_checkpoints WHERE world_id $inWorlds
    ''';
    final conversationParams = [...worldParams, ...worldParams, ...worldParams];
    for (final table in _tables.keys) {
      final (where, params) = switch (table) {
        'worlds' => ('id $inWorlds', worldParams),
        'pending_imports' => (
          'id IN (SELECT job_id FROM imported_conversations WHERE id IN ($conversations))',
          conversationParams,
        ),
        'imported_conversations' => (
          'id IN ($conversations)',
          conversationParams,
        ),
        'imported_messages' ||
        'imported_attachments' ||
        'derived_import_results' => (
          'conversation_id IN ($conversations)',
          conversationParams,
        ),
        _ => ('world_id $inWorlds', worldParams),
      };
      var rowId = 0;
      while (true) {
        final result = await db
            .customSelect(
              'SELECT rowid AS archive_rowid, ${_columns(table).join(', ')} '
              'FROM $table WHERE rowid > ? AND ($where) ORDER BY rowid LIMIT 4',
              variables: [Variable<int>(rowId), ...params],
            )
            .get();
        if (result.isEmpty) break;
        for (final item in result) {
          rowId = item.read<int>('archive_rowid');
          final row = Map<String, Object?>.from(item.data)
            ..remove('archive_rowid');
          if (table == 'imported_attachments') {
            final fileId = 'file-${row['id']}';
            final source = await _localAttachment(row);
            row['private_path'] = source == null ? '' : fileId;
            if (source != null) yield* _chunks(source, fileId);
          }
          if (table == 'imported_conversations' &&
              !worldIds.contains(row['world_id'])) {
            row['world_id'] = null;
          }
          if (table == 'story_branches' &&
              !worldIds.contains(row['parent_world_id'])) {
            row['parent_world_id'] = null;
            row['checkpoint_id'] = null;
          }
          if (table == 'pending_imports') {
            final payload = jsonDecode(row['payload'] as String) as Map;
            row['payload'] = jsonEncode({
              ...payload,
              'files': [],
              'error': null,
            });
            row['safe_error'] = null;
          }
          if (table == 'roleplay_turns' && row['state'] == 'running') {
            row['state'] = 'failed';
          }
          for (final key in ['raw_json', 'derived_json']) {
            if (row[key] case final String raw) {
              row[key] = jsonEncode(_scrub(jsonDecode(raw)));
            }
          }
          _checkCredential(row);
          yield {'table': table, 'row': row};
        }
      }
    }
  }

  Future<_Attachment?> _localAttachment(Map<String, Object?> row) async {
    final location = row['private_path'] as String;
    final length = row['byte_size'] as int;
    if (length < 0 || length > _attachmentLimit || location.isEmpty) {
      return null;
    }
    final separator = location.indexOf(
      '::',
      Platform.isWindows ? min(location.length, 2) : 0,
    );
    final sourcePath = separator < 0
        ? location
        : location.substring(0, separator);
    if (!p.isAbsolute(sourcePath)) return null;
    final inbox = p.basename(p.dirname(p.dirname(sourcePath))) == 'share_inbox';
    if (!inbox && !p.isWithin(attachmentsDirectory.path, sourcePath)) {
      return null;
    }
    final file = File(sourcePath);
    if (!await file.exists() ||
        p.normalize(await file.resolveSymbolicLinks()) !=
            p.normalize(sourcePath)) {
      return null;
    }
    final size = await file.length();
    if (separator < 0) {
      // The source ZIP may include unrelated account exports. Package the
      // selected message rows and their individual attachments instead.
      final name = row['display_name'] as String;
      if (name.toLowerCase().endsWith('.zip') ||
          (row['mime'] as String).contains('zip')) {
        return null;
      }
      final expected = row['digest'] as String;
      if (size != length ||
          (expected.isNotEmpty &&
              (await sha256.bind(file.openRead()).first).toString() !=
                  expected)) {
        return null;
      }
      return _Attachment(file);
    }
    final entryName = location.substring(separator + 2);
    if (!DeepSeekArchiveParser.safePath(entryName)) return null;
    if (size > StoryBackupFormat.fileLimit) return null;
    final input = InputFileStream(sourcePath);
    try {
      final entry = ZipDecoder()
          .decodeStream(input, verify: true, throwOnError: true)
          .findFile(entryName);
      if (entry == null || !entry.isFile || entry.size != length) {
        input.closeSync();
        return null;
      }
      return _Attachment(file, entry: entry, archive: input);
    } catch (_) {
      input.closeSync();
      return null;
    }
  }

  Stream<Map<String, Object?>> _chunks(_Attachment source, String id) async* {
    try {
      final entry = source.entry;
      if (entry == null) {
        await for (final bytes in source.file.openRead()) {
          yield {'file': id, 'data': base64Encode(bytes)};
        }
      } else {
        final bytes = entry.content;
        if (bytes.length != entry.size || bytes.length > _attachmentLimit) {
          throw const BackupFailure('附件内容无法完整读取。');
        }
        for (var index = 0; index < bytes.length; index += _chunkLimit) {
          yield {
            'file': id,
            'data': base64Encode(
              bytes.sublist(index, min(index + _chunkLimit, bytes.length)),
            ),
          };
        }
      }
    } finally {
      source.archive?.closeSync();
    }
  }

  Future<void> _insert(
    String table,
    Map<String, Object?> row,
    String prefix,
    Directory dir,
  ) async {
    final columns = _columns(table);
    for (final key in [
      'world_id',
      'parent_world_id',
      'job_id',
      'conversation_id',
      'source_conversation',
      'checkpoint_id',
    ]) {
      if (row[key] case final String value) row[key] = _linked(prefix, value);
    }
    if (row['id'] case final String id) row['id'] = _linked(prefix, id);
    if (table == 'pending_imports') {
      row['fingerprint'] = row['id'];
      row['payload'] = jsonEncode({
        ...(jsonDecode(row['payload'] as String) as Map),
        'id': row['id'],
        'files': [],
        'error': null,
      });
      row['state'] = 'saved';
    }
    if (table == 'imported_attachments' || table == 'derived_import_results') {
      columns.remove('id');
    }
    if (table == 'imported_attachments') {
      final id = row['private_path'] as String;
      row['private_path'] = id.isEmpty ? '' : p.join(dir.path, id);
      if (id.isNotEmpty && row['byte_size'] == 0) {
        await File(row['private_path'] as String).create(recursive: true);
      }
    }
    if (table == 'roleplay_saves' ||
        table == 'roleplay_memories' ||
        table == 'world_definitions' ||
        table == 'story_checkpoints' ||
        table == 'context_summaries') {
      final payload = jsonDecode(row['payload'] as String) as Map;
      void mapState(Map state) {
        state['worldId'] = row['world_id'];
        if (state['recovery'] case final Map recovery) {
          if (recovery['conversationId'] case final String id) {
            recovery['conversationId'] = _linked(prefix, id);
          }
        }
        if (state['definitionSnapshot'] case final Map definition) {
          definition['id'] = row['world_id'];
        }
      }

      if (table == 'roleplay_saves') mapState(payload);
      if (table == 'world_definitions') payload['id'] = row['world_id'];
      if (table == 'roleplay_memories') payload['id'] = row['id'];
      if (table == 'story_checkpoints') {
        mapState(payload['state'] as Map);
        for (final memory in payload['memories'] as List) {
          memory['id'] = _linked(prefix, memory['id'] as String);
        }
      }
      if (table == 'context_summaries' && payload['entries'] is List) {
        for (final entry in payload['entries'] as List) {
          entry['id'] = _linked(prefix, entry['id'] as String);
        }
      }
      row['payload'] = jsonEncode(payload);
    }
    await db.customStatement(
      'INSERT INTO $table (${columns.join(', ')}) VALUES (${_slots(columns.length)})',
      columns.map((name) => row[name]).toList(),
    );
  }

  Future<void> _validateReferences(String prefix) async {
    for (final (table, column, target) in [
      for (final table in _tables.keys.where(
        (t) => _tables[t]!.split(' ').contains('world_id'),
      ))
        (table, 'world_id', 'worlds'),
      ('story_branches', 'parent_world_id', 'worlds'),
      ('story_branches', 'checkpoint_id', 'story_checkpoints'),
      ('story_branches', 'source_conversation', 'imported_conversations'),
      ('story_checkpoints', 'source_conversation', 'imported_conversations'),
      ('imported_conversations', 'job_id', 'pending_imports'),
      ('imported_messages', 'conversation_id', 'imported_conversations'),
      ('imported_attachments', 'conversation_id', 'imported_conversations'),
      ('derived_import_results', 'conversation_id', 'imported_conversations'),
    ]) {
      final invalid = await db
          .customSelect(
            'SELECT 1 FROM $table r LEFT JOIN $target t ON r.$column=t.id '
            'WHERE r.$column GLOB ? AND t.id IS NULL LIMIT 1',
            variables: [Variable<String>('$prefix-*')],
          )
          .getSingleOrNull();
      if (invalid != null) throw const BackupFailure('归档引用不完整，未导入任何世界。');
    }
  }

  static Object? _scrub(Object? value) => switch (value) {
    final Map values => {
      for (final entry in values.entries)
        if (!_privateField.hasMatch(entry.key.toString()))
          entry.key: _scrub(entry.value),
    },
    final List values => values.map(_scrub).toList(),
    _ => value,
  };

  static void _checkCredential(Map<String, Object?> row) {
    if (row.values.whereType<String>().any(
      WorldDefinitionExchange.containsCredential,
    )) {
      throw const BackupFailure('档案检测到疑似 API Key，请先移除相关文本再备份或恢复。');
    }
  }

  static List<String> _columns(String table) => _tables[table]!.split(' ');
  static String _slots(int count) => List.filled(count, '?').join(', ');
  static String _linked(String prefix, String original) =>
      '$prefix-${sha256.convert(utf8.encode(original))}';
  static String _newId() {
    final random = Random.secure();
    return List.generate(
      16,
      (_) => random.nextInt(256).toRadixString(16).padLeft(2, '0'),
    ).join();
  }
}

class _Attachment {
  const _Attachment(this.file, {this.entry, this.archive});
  final File file;
  final ArchiveFile? entry;
  final InputFileStream? archive;
}

class _BackupScan {
  _BackupScan({this.onChunk, this.onRow});
  final Future<void> Function(String, List<int>)? onChunk;
  final Future<void> Function(String, Map<String, Object?>)? onRow;
  final titles = <String>[];
  final worldIds = <String>{};
  final restoredFiles = <String>{};
  final counts = <String, int>{};
  String? primary, file;
  int length = 0, tableIndex = 0, missingFiles = 0;

  Future<void> read(Map<String, Object?> record) async {
    if (primary == null) {
      if (record['primary'] case final String value
          when record.length == 1 && value.isNotEmpty) {
        primary = value;
        return;
      }
      throw const BackupFailure('归档缺少世界标头。');
    }
    if (record['file'] case final String id) {
      if (record.length != 2 ||
          !_fileId(id) ||
          (file != null && file != id) ||
          restoredFiles.contains(id) ||
          record['data'] is! String ||
          (record['data'] as String).length > 180000) {
        throw const BackupFailure('附件记录无效。');
      }
      final bytes = base64Decode(record['data'] as String);
      length += bytes.length;
      if (bytes.isEmpty ||
          bytes.length > StoryBackup._chunkLimit ||
          length > StoryBackup._attachmentLimit) {
        throw const BackupFailure('附件超过归档限制。');
      }
      file = id;
      await onChunk?.call(id, bytes);
      return;
    }
    final table = record['table'];
    final row = record['row'];
    if (record.length != 2 ||
        table is! String ||
        !StoryBackup._tables.containsKey(table) ||
        row is! Map<String, Object?>) {
      throw const BackupFailure('归档含未知记录。');
    }
    final index = StoryBackup._tables.keys.toList().indexOf(table);
    final columns = StoryBackup._columns(table);
    if (index < tableIndex ||
        row.length != columns.length ||
        !columns.every(row.containsKey) ||
        row.values.any(
          (value) => value != null && value is! String && value is! int,
        )) {
      throw const BackupFailure('归档记录顺序或字段无效。');
    }
    tableIndex = index;
    StoryBackup._checkCredential(row);
    if (table == 'worlds') {
      if (row['id'] is! String ||
          row['title'] is! String ||
          worldIds.length >= 256 ||
          !worldIds.add(row['id'] as String)) {
        throw const BackupFailure('归档世界标识或名称无效。');
      }
      titles.add(row['title'] as String);
    }
    if (table == 'imported_attachments') {
      final id = row['private_path'];
      if (id == '' && file == null) {
        missingFiles++;
      } else if (id is! String ||
          !_fileId(id) ||
          (file != id && (file != null || row['byte_size'] != 0)) ||
          row['byte_size'] != length ||
          !restoredFiles.add(id)) {
        throw const BackupFailure('附件数据不完整或重复。');
      }
      file = null;
      length = 0;
    } else if (file != null) {
      throw const BackupFailure('附件缺少对应记录。');
    }
    counts.update(table, (amount) => amount + 1, ifAbsent: () => 1);
    await onRow?.call(table, row);
  }

  void finish() {
    if (!worldIds.contains(primary) || file != null) {
      throw const BackupFailure('归档缺少主世界或附件记录。');
    }
  }

  static bool _fileId(String id) => RegExp(r'^file-[0-9]{1,18}$').hasMatch(id);
}
