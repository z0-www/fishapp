import 'package:drift/drift.dart';
import 'web_database_stub.dart'
    if (dart.library.js_interop) 'web_database_web.dart';
part 'app_database.g.dart';

@DataClassName('WorldRow')
class Worlds extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  TextColumn get genre => text()();
  TextColumn get summary => text()();
  DateTimeColumn get createdAt => dateTime()();
  @override
  Set<Column> get primaryKey => {id};
}

class UsageRecords extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get requestedAt => dateTime()();
  TextColumn get model => text()();
  IntColumn get inputTokens => integer()();
  IntColumn get outputTokens => integer()();
  IntColumn get cacheTokens => integer().nullable()();
  RealColumn get estimatedUsd => real().nullable()();
  TextColumn get priceVersion => text().nullable()();
}

class PendingImports extends Table {
  TextColumn get id => text()();
  TextColumn get fingerprint => text().unique()();
  TextColumn get payload => text()();
  TextColumn get state => text()();
  TextColumn get safeError => text().nullable()();
  DateTimeColumn get receivedAt => dateTime()();
  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('ImportedConversationRow')
class ImportedConversations extends Table {
  TextColumn get id => text()();
  TextColumn get jobId => text().unique()();
  TextColumn get title => text()();
  TextColumn get source => text()();
  TextColumn get worldId => text().nullable().references(Worlds, #id)();
  TextColumn get currentMessageId => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('ImportedMessageRow')
class ImportedMessages extends Table {
  TextColumn get conversationId =>
      text().references(ImportedConversations, #id)();
  TextColumn get messageId => text()();
  TextColumn get parentId => text().nullable()();
  TextColumn get role => text()();
  TextColumn get body => text()();
  TextColumn get rawJson => text()();
  IntColumn get ordinal => integer()();
  @override
  Set<Column> get primaryKey => {conversationId, messageId};
}

@DataClassName('ImportedAttachmentRow')
class ImportedAttachments extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get conversationId =>
      text().references(ImportedConversations, #id)();
  TextColumn get privatePath => text()();
  TextColumn get displayName => text()();
  TextColumn get mime => text()();
  IntColumn get byteSize => integer()();
  TextColumn get digest => text()();
}

class DerivedImportResults extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get conversationId =>
      text().references(ImportedConversations, #id)();
  TextColumn get derivedJson => text()();
  DateTimeColumn get createdAt => dateTime()();
}

class RoleplaySaves extends Table {
  TextColumn get worldId => text().references(Worlds, #id)();
  IntColumn get revision => integer()();
  TextColumn get payload => text()();
  @override
  Set<Column> get primaryKey => {worldId};
}

class RoleplayTurns extends Table {
  TextColumn get id => text()();
  TextColumn get worldId => text().references(Worlds, #id)();
  IntColumn get baseRevision => integer()();
  TextColumn get action => text()();
  TextColumn get speaker => text()();
  TextColumn get contextJson => text()();
  TextColumn get state => text()();
  TextColumn get responseJson => text().nullable()();
  /// Historical source flag retained for existing saves. New turns use false.
  BoolColumn get mock => boolean()();
  DateTimeColumn get createdAt => dateTime()();
  @override
  Set<Column> get primaryKey => {id};
}

class RoleplayMemories extends Table {
  TextColumn get id => text()();
  TextColumn get worldId => text().references(Worlds, #id)();
  TextColumn get owner => text()();
  TextColumn get payload => text()();
  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('WorldDefinitionRow')
class WorldDefinitions extends Table {
  TextColumn get worldId => text().references(Worlds, #id)();
  IntColumn get version => integer()();
  TextColumn get payload => text()();
  DateTimeColumn get savedAt => dateTime()();
  @override
  Set<Column> get primaryKey => {worldId, version};
}

@DataClassName('WorldDraftRow')
class WorldDrafts extends Table {
  TextColumn get id => text()();
  TextColumn get payload => text()();
  DateTimeColumn get updatedAt => dateTime()();
  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('StoryCheckpointRow')
class StoryCheckpoints extends Table {
  TextColumn get id => text()();
  TextColumn get worldId => text().references(Worlds, #id)();
  IntColumn get revision => integer()();
  TextColumn get payload => text()();
  TextColumn get sourceConversation => text().nullable()();
  TextColumn get sourceMessageId => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  @override
  Set<Column> get primaryKey => {id};
}

class StoryBranches extends Table {
  TextColumn get worldId => text().references(Worlds, #id)();
  TextColumn get parentWorldId => text().nullable()();
  TextColumn get checkpointId => text().nullable()();
  TextColumn get sourceConversation => text().nullable()();
  TextColumn get sourceMessageId => text().nullable()();
  @override
  Set<Column> get primaryKey => {worldId};
}

class TimelineEntries extends Table {
  TextColumn get id => text()();
  TextColumn get worldId => text().references(Worlds, #id)();
  IntColumn get revision => integer()();
  TextColumn get payload => text()();
  @override
  Set<Column> get primaryKey => {id};
}

class ContextSummaries extends Table {
  TextColumn get worldId => text().references(Worlds, #id)();
  TextColumn get owner => text()();
  IntColumn get version => integer()();
  IntColumn get throughRevision => integer()();
  TextColumn get payload => text()();
  @override
  Set<Column> get primaryKey => {worldId, owner, version};
}

@DriftDatabase(
  tables: [
    Worlds,
    UsageRecords,
    PendingImports,
    ImportedConversations,
    ImportedMessages,
    ImportedAttachments,
    DerivedImportResults,
    RoleplaySaves,
    RoleplayTurns,
    RoleplayMemories,
    StoryCheckpoints,
    StoryBranches,
    TimelineEntries,
    ContextSummaries,
    WorldDefinitions,
    WorldDrafts,
  ],
)
class AppDatabase extends _$AppDatabase {
  /// Web builds use the bundled sqlite3 WebAssembly module and drift worker so
  /// the same schema, migrations and SQL run as on Android/iOS. New web
  /// databases use IndexedDB for Safari reliability; an existing OPFS database
  /// is detected and kept instead of being replaced by an empty one.
  AppDatabase() : super(openFishDatabase());
  AppDatabase.forTesting(super.executor);
  @override
  int get schemaVersion => 6;
  @override
  MigrationStrategy get migration => MigrationStrategy(
    onUpgrade: (m, from, to) async {
      if (from < 6) {
        await m.createTable(storyCheckpoints);
        await m.createTable(storyBranches);
        await m.createTable(timelineEntries);
        await m.createTable(contextSummaries);
      }
      if (from < 5) {
        await m.createTable(worldDefinitions);
        await m.createTable(worldDrafts);
      }
      if (from < 4) {
        await m.createTable(roleplaySaves);
        await m.createTable(roleplayTurns);
        await m.createTable(roleplayMemories);
      }
      if (from < 2) await m.createTable(usageRecords);
      if (from < 3) {
        await m.createTable(pendingImports);
        await m.createTable(importedConversations);
        await m.createTable(importedMessages);
        await m.createTable(importedAttachments);
        await m.createTable(derivedImportResults);
      }
    },
  );
}
