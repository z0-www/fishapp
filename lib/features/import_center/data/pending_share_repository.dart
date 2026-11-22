import 'package:crypto/crypto.dart';

import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:path/path.dart' as p;

import '../../../core/database/app_database.dart';
import '../../../platform/files/local_files.dart';
import '../../../platform/share_intake/share_event_deduplicator.dart';
import '../domain/import_models.dart';

class PendingShareRepository {
  PendingShareRepository(
    this.db, {
    ShareEventDeduplicator? deduplicator,
    this.limits = const ImportLimits(),
  }) : _deduplicator = deduplicator ?? ShareEventDeduplicator();
  final AppDatabase db;
  final ShareEventDeduplicator _deduplicator;
  final ImportLimits limits;
  Future<String> receive(IncomingShare share) async {
    if (share.id.length > 80 ||
        !RegExp(r'^[A-Za-z0-9-]+$').hasMatch(share.id) ||
        utf8.encode(share.text).length > limits.textBytes ||
        share.files.length > limits.fileCount) {
      throw const ImportFailure('分享内容超过限制或编号无效。');
    }
    var total = 0;
    for (final file in share.files) {
      if (LocalFiles.isMemoryRef(file.path)) {
        // Browser selection: the bytes live in the session vault, so there is
        // no path to traverse. Sizes still must match the declared metadata.
        try {
          final size = await LocalFiles.length(file.path);
          total += size;
          if (size > limits.fileBytes ||
              total > limits.eventBytes ||
              size != file.size) {
            throw const ImportFailure('文件读取不完整或超过限制。');
          }
        } on ImportFailure {
          rethrow;
        } catch (_) {
          throw const ImportFailure('文件已失效，请重新选择后再导入。');
        }
        continue;
      }
      // Only random, native-owned event directories are valid file sources.
      if (!p.isAbsolute(file.path) ||
          p.basename(p.dirname(file.path)) != share.id ||
          p.basename(p.dirname(p.dirname(file.path))) != 'share_inbox' ||
          p.split(file.path).contains('..')) {
        throw const ImportFailure('文件不在安全暂存区内。');
      }
      final actual = await File(file.path).resolveSymbolicLinks();
      if (p.normalize(actual) != p.normalize(file.path)) {
        throw const ImportFailure('不接受暂存区的符号链接。');
      }
      final size = await File(actual).length();
      total += size;
      if (size > limits.fileBytes ||
          total > limits.eventBytes ||
          size != file.size) {
        throw const ImportFailure('文件读取不完整或超过限制。');
      }
    }
    final fingerprint = await _deduplicator.fingerprint(share);
    final legacy = await _deduplicator.fingerprint(share, canonical: false);
    return db.transaction(() async {
      final old =
          await (db.select(db.pendingImports)..where(
                (t) =>
                    t.id.equals(share.id) |
                    t.fingerprint.equals(fingerprint) |
                    t.fingerprint.equals(legacy),
              ))
              .get()
              .then((rows) => rows.firstOrNull);
      if (old != null) return old.id;
      await db
          .into(db.pendingImports)
          .insert(
            PendingImportsCompanion.insert(
              id: share.id,
              fingerprint: fingerprint,
              payload: jsonEncode(_payloadForStorage(share)),
              state: 'received',
              receivedAt: share.receivedAt,
            ),
          );
      return share.id;
    });
  }

  Map<String, dynamic> _payloadForStorage(IncomingShare share) {
    final payload = share.toJson();
    if (share.text.trimLeft().startsWith('{')) {
      try {
        payload['text'] = jsonEncode(
          safeImportMetadata(jsonDecode(share.text)),
        );
      } on FormatException {
        // A free-text transcript beginning with a brace remains free text.
      }
    }
    return payload;
  }

  ImportJob _map(PendingImport row) => ImportJob(
    id: row.id,
    state: row.state,
    share: IncomingShare.fromJson(
      jsonDecode(row.payload) as Map<String, dynamic>,
    ),
    error: row.safeError,
  );
  Future<String> selectSession(ImportJob original, ArchiveSession session) =>
      db.transaction(() async {
        final digest = sha256
            .convert(
              utf8.encode(
                jsonEncode([
                  await _deduplicator.fingerprint(original.share),
                  session.id,
                ]),
              ),
            )
            .toString();
        final id = 'zip-$digest';
        if (await get(id) == null) {
          await db
              .into(db.pendingImports)
              .insert(
                PendingImportsCompanion.insert(
                  id: id,
                  fingerprint: digest,
                  state: 'received',
                  receivedAt: DateTime.now(),
                  payload: jsonEncode(
                    IncomingShare(
                      id: original.share.id,
                      source: original.share.source,
                      receivedAt: original.share.receivedAt,
                      mime: original.share.mime,
                      files: original.share.files,
                      archiveSession: session.id,
                    ).toJson(),
                  ),
                ),
              );
        }
        return id;
      });

  Future<void> pause(String id) async {
    await (db.update(db.pendingImports)..where(
          (row) =>
              row.id.equals(id) &
              row.state.isIn(['received', 'processing', 'preview', 'failed']),
        ))
        .write(const PendingImportsCompanion(state: Value('paused')));
  }

  Future<void> discard(String id) => db.transaction(() async {
    final found = await get(id);
    if (found == null ||
        found.state == 'saved' ||
        found.share.files.isNotEmpty) {
      return;
    }
    await (db.delete(
      db.pendingImports,
    )..where((row) => row.id.equals(id))).go();
  });

  Future<ImportJob?> get(String id) async {
    final row = await (db.select(
      db.pendingImports,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
    return row == null ? null : _map(row);
  }

  Future<List<ImportJob>> pending() async =>
      (await (db.select(db.pendingImports)
                ..where((t) => t.state.isNotValue('saved'))
                ..orderBy([(t) => OrderingTerm.desc(t.receivedAt)])
                ..limit(50))
              .get())
          .map(_map)
          .toList();
  Future<void> mark(String id, String state, {String? error}) =>
      (db.update(db.pendingImports)..where((t) => t.id.equals(id))).write(
        PendingImportsCompanion(state: Value(state), safeError: Value(error)),
      );
  Future<List<ImportedConversationRow>> history({String? worldId}) {
    final query = db.select(db.importedConversations)
      ..orderBy([(t) => OrderingTerm.desc(t.createdAt)])
      ..limit(50);
    if (worldId != null) query.where((t) => t.worldId.equals(worldId));
    return query.get();
  }

  Future<ImportedConversationRow?> conversation(String jobId) => (db.select(
    db.importedConversations,
  )..where((t) => t.jobId.equals(jobId))).getSingleOrNull();
  Future<List<ImportedMessageRow>> messages(String id) =>
      (db.select(db.importedMessages)
            ..where((t) => t.conversationId.equals(id))
            ..orderBy([(t) => OrderingTerm.asc(t.ordinal)]))
          .get();
  Future<List<({String role, String body})>> readableMessages(String id) async {
    final table = db.importedMessages;
    final rows =
        await (db.selectOnly(table)
              ..addColumns([table.role, table.body])
              ..where(table.conversationId.equals(id))
              ..orderBy([OrderingTerm.asc(table.ordinal)]))
            .get();
    return [
      for (final row in rows)
        (role: row.read(table.role)!, body: row.read(table.body)!),
    ];
  }

  Future<bool> isPublicShare(String id) async {
    final table = db.derivedImportResults;
    final rows =
        await (db.selectOnly(table)
              ..addColumns([table.id])
              ..where(
                table.conversationId.equals(id) &
                    table.derivedJson.like('{"type":"public-share-raw-v1",%'),
              )
              ..limit(1))
            .get();
    return rows.isNotEmpty;
  }

  Future<List<ImportedAttachmentRow>> attachments(String id) => (db.select(
    db.importedAttachments,
  )..where((t) => t.conversationId.equals(id))).get();
  Future<ImportResult> save(
    String id,
    ConversationDraft draft,
    ImportDestination destination, {
    String? worldId,
    String? selectedNode,
  }) async {
    if (!draft.canSave) throw const ImportFailure('格式尚未完成转换，不能确认为对话。');
    return db.transaction(() async {
      final old = await conversation(id);
      if (old != null) {
        return ImportResult(
          jobId: id,
          conversationId: old.id,
          worldId: old.worldId,
        );
      }
      final job = await get(id);
      if (job == null) throw const ImportFailure('暂存记录不存在。');
      var target = worldId;
      if (destination == ImportDestination.newWorld) {
        target = 'import-world-$id';
        await db
            .into(db.worlds)
            .insert(
              WorldsCompanion.insert(
                id: target,
                title: draft.title,
                genre: '迁移世界',
                summary: '从本地导入记录创建；未调用 AI。',
                createdAt: DateTime.now(),
              ),
            );
      } else if (destination == ImportDestination.existingWorld) {
        if (target == null ||
            await (db.select(
                  db.worlds,
                )..where((t) => t.id.equals(target!))).getSingleOrNull() ==
                null) {
          throw const ImportFailure('请选择一个存在的世界。');
        }
      } else {
        target = null;
      }
      final conversationId = 'conversation-$id';
      await db
          .into(db.importedConversations)
          .insert(
            ImportedConversationsCompanion.insert(
              id: conversationId,
              jobId: id,
              title: draft.title,
              source: job.share.source.name,
              worldId: Value(target),
              currentMessageId: Value(selectedNode ?? draft.currentMessageId),
              createdAt: DateTime.now(),
            ),
          );
      for (final entry in draft.messages.indexed) {
        final message = entry.$2;
        await db
            .into(db.importedMessages)
            .insert(
              ImportedMessagesCompanion.insert(
                conversationId: conversationId,
                messageId: message.id,
                parentId: Value(message.parentId),
                role: message.role,
                body: message.content,
                rawJson: message.rawJson,
                ordinal: entry.$1,
              ),
            );
      }
      for (final attachment in draft.attachments) {
        await db
            .into(db.importedAttachments)
            .insert(
              ImportedAttachmentsCompanion.insert(
                conversationId: conversationId,
                privatePath: attachment.path,
                displayName: attachment.name,
                mime: attachment.mime,
                byteSize: attachment.size,
                digest: attachment.sha256,
              ),
            );
      }
      if (draft.rawDocument != null) {
        await db
            .into(db.derivedImportResults)
            .insert(
              DerivedImportResultsCompanion.insert(
                conversationId: conversationId,
                derivedJson: jsonEncode({
                  'type': 'public-share-raw-v1',
                  'raw': draft.rawDocument,
                  'sourceUrl': draft.sourceUrl,
                  'warnings': draft.warnings,
                }),
                createdAt: DateTime.now(),
              ),
            );
      }
      await mark(id, 'saved');
      return ImportResult(
        jobId: id,
        conversationId: conversationId,
        worldId: target,
      );
    });
  }
}
