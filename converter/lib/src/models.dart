import 'dart:typed_data';

/// One message parsed from a source conversation.
class ConvertMessage {
  ConvertMessage({
    required this.id,
    required this.role,
    required this.content,
    required this.rawJson,
    this.parentId,
    this.timestamp,
    this.model,
    this.originalId,
  });
  final String id;
  final String role;
  final String content;
  final String rawJson;
  final String? parentId;
  final String? timestamp;
  final String? model;
  final String? originalId;
}

/// One selectable conversation/session.
class ConvertSession {
  ConvertSession({
    required this.id,
    required this.title,
    required this.format,
    required this.messages,
    required this.sourceName,
    this.model,
    this.createdAt,
    List<String>? warnings,
  }) : warnings = warnings ?? <String>[];
  final String id;
  final String title;
  final String format;
  final String sourceName;
  final List<ConvertMessage> messages;
  final String? model;
  final String? createdAt;
  final List<String> warnings;

  int get userCount => messages.where((m) => m.role == 'user').length;
  int get assistantCount =>
      messages.where((m) => m.role == 'assistant').length;
  int get systemCount => messages.where((m) => m.role == 'system').length;
  int get otherCount => messages.length - userCount - assistantCount - systemCount;
}

class ParseResult {
  ParseResult({required this.format, required this.sessions, List<String>? warnings})
    : warnings = warnings ?? <String>[];
  final String format;
  final List<ConvertSession> sessions;
  final List<String> warnings;
}

class ConversionException implements Exception {
  const ConversionException(this.message);
  final String message;
  @override
  String toString() => message;
}

typedef SourceBytes = Uint8List;
