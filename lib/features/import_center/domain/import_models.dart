enum ImportSource { system, picker, paste }

enum ImportDestination { history, newWorld, existingWorld }

class ImportLimits {
  const ImportLimits({
    this.textBytes = 512 * 1024,
    this.fileBytes = 64 * 1024 * 1024,
    this.eventBytes = 128 * 1024 * 1024,
    this.fileCount = 16,
  });
  final int textBytes, fileBytes, eventBytes, fileCount;
}

class ImportedAttachment {
  const ImportedAttachment({
    required this.path,
    required this.name,
    required this.mime,
    required this.size,
    this.sha256 = '',
    this.isImage = false,
  });
  final String path, name, mime, sha256;
  final int size;
  final bool isImage;
  Map<String, dynamic> toJson() => {
    'path': path,
    'name': name,
    'mime': mime,
    'size': size,
    'sha256': sha256,
    'isImage': isImage,
  };
  factory ImportedAttachment.fromJson(Map<String, dynamic> m) =>
      ImportedAttachment(
        path: m['path'] as String,
        name: m['name'] as String,
        mime: m['mime'] as String,
        size: (m['size'] as num).toInt(),
        sha256: m['sha256'] as String? ?? '',
        isImage: m['isImage'] == true,
      );
}

class IncomingShare {
  const IncomingShare({
    required this.id,
    required this.source,
    required this.receivedAt,
    this.text = '',
    this.mime = 'text/plain',
    this.files = const [],
    this.error,
    this.archiveSession,
  });
  final String id, text, mime;
  final String? archiveSession;
  final ImportSource source;
  final DateTime receivedAt;
  final List<ImportedAttachment> files;
  final String? error;
  Map<String, dynamic> toJson() => {
    'id': id,
    'source': source.name,
    'receivedAt': receivedAt.millisecondsSinceEpoch,
    'text': text,
    'mime': mime,
    'files': files.map((f) => f.toJson()).toList(),
    'error': error,
    'archiveSession': archiveSession,
  };
  factory IncomingShare.fromJson(Map<String, dynamic> m) => IncomingShare(
    id: m['id'] as String,
    source: ImportSource.values.firstWhere(
      (v) => v.name == m['source'],
      orElse: () => ImportSource.system,
    ),
    receivedAt: DateTime.fromMillisecondsSinceEpoch(
      (m['receivedAt'] as num).toInt(),
    ),
    text: m['text'] as String? ?? '',
    mime: m['mime'] as String? ?? 'text/plain',
    files: (m['files'] as List? ?? [])
        .map(
          (f) =>
              ImportedAttachment.fromJson(Map<String, dynamic>.from(f as Map)),
        )
        .toList(),
    error: m['error'] as String?,
    archiveSession: m['archiveSession'] as String?,
  );
}

class ImportedMessage {
  const ImportedMessage({
    required this.id,
    required this.role,
    required this.content,
    required this.rawJson,
    this.parentId,
  });
  final String id, role, content, rawJson;
  final String? parentId;
}

class ArchiveSession {
  const ArchiveSession(this.id, this.title, this.messageCount);
  final String id, title;
  final int messageCount;
}

class ConversationDraft {
  const ConversationDraft({
    required this.title,
    required this.messages,
    this.attachments = const [],
    this.warnings = const [],
    this.currentMessageId,
    this.branches,
    this.canSave = true,
    this.rawDocument,
    this.sourceUrl,
    this.archiveSessions = const [],
    this.nodeUncertain = false,
  });
  final List<ArchiveSession> archiveSessions;
  final bool nodeUncertain;
  final String title;
  final List<ImportedMessage> messages;
  final List<ImportedAttachment> attachments;
  final List<String> warnings;
  final String? currentMessageId;
  final int? branches;
  final bool canSave;
  final String? rawDocument, sourceUrl;
}

class ImportJob {
  const ImportJob({
    required this.id,
    required this.state,
    required this.share,
    this.error,
  });
  final String id, state;
  final IncomingShare share;
  final String? error;
}

class ImportResult {
  const ImportResult({
    required this.jobId,
    required this.conversationId,
    this.worldId,
  });
  final String jobId, conversationId;
  final String? worldId;
}

class ImportCancelled implements Exception {
  const ImportCancelled();
}

class ImportFailure implements Exception {
  const ImportFailure(this.message);
  final String message;
  @override
  String toString() => message;
}

class ImportCancellation {
  bool _cancelled = false;
  void cancel() => _cancelled = true;
  void check() {
    if (_cancelled) throw const ImportCancelled();
  }
}

/// Excludes login metadata from copied structured exports. User-authored text
/// is kept as text and never treated as account or transport state.
Object? safeImportMetadata(Object? value) {
  const forbidden = {
    'authorization',
    'cookie',
    'cookies',
    'setcookie',
    'sessiontoken',
    'accesstoken',
    'refreshtoken',
    'idtoken',
    'apikey',
    'bearertoken',
    'password',
    'logintoken',
    'sessioncookie',
  };
  if (value is Map) {
    return {
      for (final entry in value.entries)
        if (!forbidden.contains(
          entry.key.toString().toLowerCase().replaceAll(RegExp(r'[_-]'), ''),
        ))
          entry.key: safeImportMetadata(entry.value),
    };
  }
  if (value is List) return value.map(safeImportMetadata).toList();
  return value;
}
