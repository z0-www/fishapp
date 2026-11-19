// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $WorldsTable extends Worlds with TableInfo<$WorldsTable, WorldRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WorldsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _genreMeta = const VerificationMeta('genre');
  @override
  late final GeneratedColumn<String> genre = GeneratedColumn<String>(
    'genre',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _summaryMeta = const VerificationMeta(
    'summary',
  );
  @override
  late final GeneratedColumn<String> summary = GeneratedColumn<String>(
    'summary',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, title, genre, summary, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'worlds';
  @override
  VerificationContext validateIntegrity(
    Insertable<WorldRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('genre')) {
      context.handle(
        _genreMeta,
        genre.isAcceptableOrUnknown(data['genre']!, _genreMeta),
      );
    } else if (isInserting) {
      context.missing(_genreMeta);
    }
    if (data.containsKey('summary')) {
      context.handle(
        _summaryMeta,
        summary.isAcceptableOrUnknown(data['summary']!, _summaryMeta),
      );
    } else if (isInserting) {
      context.missing(_summaryMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WorldRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WorldRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      genre: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}genre'],
      )!,
      summary: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}summary'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $WorldsTable createAlias(String alias) {
    return $WorldsTable(attachedDatabase, alias);
  }
}

class WorldRow extends DataClass implements Insertable<WorldRow> {
  final String id;
  final String title;
  final String genre;
  final String summary;
  final DateTime createdAt;
  const WorldRow({
    required this.id,
    required this.title,
    required this.genre,
    required this.summary,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    map['genre'] = Variable<String>(genre);
    map['summary'] = Variable<String>(summary);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  WorldsCompanion toCompanion(bool nullToAbsent) {
    return WorldsCompanion(
      id: Value(id),
      title: Value(title),
      genre: Value(genre),
      summary: Value(summary),
      createdAt: Value(createdAt),
    );
  }

  factory WorldRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WorldRow(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      genre: serializer.fromJson<String>(json['genre']),
      summary: serializer.fromJson<String>(json['summary']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'genre': serializer.toJson<String>(genre),
      'summary': serializer.toJson<String>(summary),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  WorldRow copyWith({
    String? id,
    String? title,
    String? genre,
    String? summary,
    DateTime? createdAt,
  }) => WorldRow(
    id: id ?? this.id,
    title: title ?? this.title,
    genre: genre ?? this.genre,
    summary: summary ?? this.summary,
    createdAt: createdAt ?? this.createdAt,
  );
  WorldRow copyWithCompanion(WorldsCompanion data) {
    return WorldRow(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      genre: data.genre.present ? data.genre.value : this.genre,
      summary: data.summary.present ? data.summary.value : this.summary,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WorldRow(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('genre: $genre, ')
          ..write('summary: $summary, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, title, genre, summary, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WorldRow &&
          other.id == this.id &&
          other.title == this.title &&
          other.genre == this.genre &&
          other.summary == this.summary &&
          other.createdAt == this.createdAt);
}

class WorldsCompanion extends UpdateCompanion<WorldRow> {
  final Value<String> id;
  final Value<String> title;
  final Value<String> genre;
  final Value<String> summary;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const WorldsCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.genre = const Value.absent(),
    this.summary = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WorldsCompanion.insert({
    required String id,
    required String title,
    required String genre,
    required String summary,
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       title = Value(title),
       genre = Value(genre),
       summary = Value(summary),
       createdAt = Value(createdAt);
  static Insertable<WorldRow> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? genre,
    Expression<String>? summary,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (genre != null) 'genre': genre,
      if (summary != null) 'summary': summary,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WorldsCompanion copyWith({
    Value<String>? id,
    Value<String>? title,
    Value<String>? genre,
    Value<String>? summary,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return WorldsCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      genre: genre ?? this.genre,
      summary: summary ?? this.summary,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (genre.present) {
      map['genre'] = Variable<String>(genre.value);
    }
    if (summary.present) {
      map['summary'] = Variable<String>(summary.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WorldsCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('genre: $genre, ')
          ..write('summary: $summary, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $UsageRecordsTable extends UsageRecords
    with TableInfo<$UsageRecordsTable, UsageRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UsageRecordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _requestedAtMeta = const VerificationMeta(
    'requestedAt',
  );
  @override
  late final GeneratedColumn<DateTime> requestedAt = GeneratedColumn<DateTime>(
    'requested_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _modelMeta = const VerificationMeta('model');
  @override
  late final GeneratedColumn<String> model = GeneratedColumn<String>(
    'model',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _inputTokensMeta = const VerificationMeta(
    'inputTokens',
  );
  @override
  late final GeneratedColumn<int> inputTokens = GeneratedColumn<int>(
    'input_tokens',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _outputTokensMeta = const VerificationMeta(
    'outputTokens',
  );
  @override
  late final GeneratedColumn<int> outputTokens = GeneratedColumn<int>(
    'output_tokens',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cacheTokensMeta = const VerificationMeta(
    'cacheTokens',
  );
  @override
  late final GeneratedColumn<int> cacheTokens = GeneratedColumn<int>(
    'cache_tokens',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _estimatedUsdMeta = const VerificationMeta(
    'estimatedUsd',
  );
  @override
  late final GeneratedColumn<double> estimatedUsd = GeneratedColumn<double>(
    'estimated_usd',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _priceVersionMeta = const VerificationMeta(
    'priceVersion',
  );
  @override
  late final GeneratedColumn<String> priceVersion = GeneratedColumn<String>(
    'price_version',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    requestedAt,
    model,
    inputTokens,
    outputTokens,
    cacheTokens,
    estimatedUsd,
    priceVersion,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'usage_records';
  @override
  VerificationContext validateIntegrity(
    Insertable<UsageRecord> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('requested_at')) {
      context.handle(
        _requestedAtMeta,
        requestedAt.isAcceptableOrUnknown(
          data['requested_at']!,
          _requestedAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_requestedAtMeta);
    }
    if (data.containsKey('model')) {
      context.handle(
        _modelMeta,
        model.isAcceptableOrUnknown(data['model']!, _modelMeta),
      );
    } else if (isInserting) {
      context.missing(_modelMeta);
    }
    if (data.containsKey('input_tokens')) {
      context.handle(
        _inputTokensMeta,
        inputTokens.isAcceptableOrUnknown(
          data['input_tokens']!,
          _inputTokensMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_inputTokensMeta);
    }
    if (data.containsKey('output_tokens')) {
      context.handle(
        _outputTokensMeta,
        outputTokens.isAcceptableOrUnknown(
          data['output_tokens']!,
          _outputTokensMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_outputTokensMeta);
    }
    if (data.containsKey('cache_tokens')) {
      context.handle(
        _cacheTokensMeta,
        cacheTokens.isAcceptableOrUnknown(
          data['cache_tokens']!,
          _cacheTokensMeta,
        ),
      );
    }
    if (data.containsKey('estimated_usd')) {
      context.handle(
        _estimatedUsdMeta,
        estimatedUsd.isAcceptableOrUnknown(
          data['estimated_usd']!,
          _estimatedUsdMeta,
        ),
      );
    }
    if (data.containsKey('price_version')) {
      context.handle(
        _priceVersionMeta,
        priceVersion.isAcceptableOrUnknown(
          data['price_version']!,
          _priceVersionMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UsageRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UsageRecord(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      requestedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}requested_at'],
      )!,
      model: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}model'],
      )!,
      inputTokens: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}input_tokens'],
      )!,
      outputTokens: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}output_tokens'],
      )!,
      cacheTokens: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cache_tokens'],
      ),
      estimatedUsd: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}estimated_usd'],
      ),
      priceVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}price_version'],
      ),
    );
  }

  @override
  $UsageRecordsTable createAlias(String alias) {
    return $UsageRecordsTable(attachedDatabase, alias);
  }
}

class UsageRecord extends DataClass implements Insertable<UsageRecord> {
  final int id;
  final DateTime requestedAt;
  final String model;
  final int inputTokens;
  final int outputTokens;
  final int? cacheTokens;
  final double? estimatedUsd;
  final String? priceVersion;
  const UsageRecord({
    required this.id,
    required this.requestedAt,
    required this.model,
    required this.inputTokens,
    required this.outputTokens,
    this.cacheTokens,
    this.estimatedUsd,
    this.priceVersion,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['requested_at'] = Variable<DateTime>(requestedAt);
    map['model'] = Variable<String>(model);
    map['input_tokens'] = Variable<int>(inputTokens);
    map['output_tokens'] = Variable<int>(outputTokens);
    if (!nullToAbsent || cacheTokens != null) {
      map['cache_tokens'] = Variable<int>(cacheTokens);
    }
    if (!nullToAbsent || estimatedUsd != null) {
      map['estimated_usd'] = Variable<double>(estimatedUsd);
    }
    if (!nullToAbsent || priceVersion != null) {
      map['price_version'] = Variable<String>(priceVersion);
    }
    return map;
  }

  UsageRecordsCompanion toCompanion(bool nullToAbsent) {
    return UsageRecordsCompanion(
      id: Value(id),
      requestedAt: Value(requestedAt),
      model: Value(model),
      inputTokens: Value(inputTokens),
      outputTokens: Value(outputTokens),
      cacheTokens: cacheTokens == null && nullToAbsent
          ? const Value.absent()
          : Value(cacheTokens),
      estimatedUsd: estimatedUsd == null && nullToAbsent
          ? const Value.absent()
          : Value(estimatedUsd),
      priceVersion: priceVersion == null && nullToAbsent
          ? const Value.absent()
          : Value(priceVersion),
    );
  }

  factory UsageRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UsageRecord(
      id: serializer.fromJson<int>(json['id']),
      requestedAt: serializer.fromJson<DateTime>(json['requestedAt']),
      model: serializer.fromJson<String>(json['model']),
      inputTokens: serializer.fromJson<int>(json['inputTokens']),
      outputTokens: serializer.fromJson<int>(json['outputTokens']),
      cacheTokens: serializer.fromJson<int?>(json['cacheTokens']),
      estimatedUsd: serializer.fromJson<double?>(json['estimatedUsd']),
      priceVersion: serializer.fromJson<String?>(json['priceVersion']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'requestedAt': serializer.toJson<DateTime>(requestedAt),
      'model': serializer.toJson<String>(model),
      'inputTokens': serializer.toJson<int>(inputTokens),
      'outputTokens': serializer.toJson<int>(outputTokens),
      'cacheTokens': serializer.toJson<int?>(cacheTokens),
      'estimatedUsd': serializer.toJson<double?>(estimatedUsd),
      'priceVersion': serializer.toJson<String?>(priceVersion),
    };
  }

  UsageRecord copyWith({
    int? id,
    DateTime? requestedAt,
    String? model,
    int? inputTokens,
    int? outputTokens,
    Value<int?> cacheTokens = const Value.absent(),
    Value<double?> estimatedUsd = const Value.absent(),
    Value<String?> priceVersion = const Value.absent(),
  }) => UsageRecord(
    id: id ?? this.id,
    requestedAt: requestedAt ?? this.requestedAt,
    model: model ?? this.model,
    inputTokens: inputTokens ?? this.inputTokens,
    outputTokens: outputTokens ?? this.outputTokens,
    cacheTokens: cacheTokens.present ? cacheTokens.value : this.cacheTokens,
    estimatedUsd: estimatedUsd.present ? estimatedUsd.value : this.estimatedUsd,
    priceVersion: priceVersion.present ? priceVersion.value : this.priceVersion,
  );
  UsageRecord copyWithCompanion(UsageRecordsCompanion data) {
    return UsageRecord(
      id: data.id.present ? data.id.value : this.id,
      requestedAt: data.requestedAt.present
          ? data.requestedAt.value
          : this.requestedAt,
      model: data.model.present ? data.model.value : this.model,
      inputTokens: data.inputTokens.present
          ? data.inputTokens.value
          : this.inputTokens,
      outputTokens: data.outputTokens.present
          ? data.outputTokens.value
          : this.outputTokens,
      cacheTokens: data.cacheTokens.present
          ? data.cacheTokens.value
          : this.cacheTokens,
      estimatedUsd: data.estimatedUsd.present
          ? data.estimatedUsd.value
          : this.estimatedUsd,
      priceVersion: data.priceVersion.present
          ? data.priceVersion.value
          : this.priceVersion,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UsageRecord(')
          ..write('id: $id, ')
          ..write('requestedAt: $requestedAt, ')
          ..write('model: $model, ')
          ..write('inputTokens: $inputTokens, ')
          ..write('outputTokens: $outputTokens, ')
          ..write('cacheTokens: $cacheTokens, ')
          ..write('estimatedUsd: $estimatedUsd, ')
          ..write('priceVersion: $priceVersion')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    requestedAt,
    model,
    inputTokens,
    outputTokens,
    cacheTokens,
    estimatedUsd,
    priceVersion,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UsageRecord &&
          other.id == this.id &&
          other.requestedAt == this.requestedAt &&
          other.model == this.model &&
          other.inputTokens == this.inputTokens &&
          other.outputTokens == this.outputTokens &&
          other.cacheTokens == this.cacheTokens &&
          other.estimatedUsd == this.estimatedUsd &&
          other.priceVersion == this.priceVersion);
}

class UsageRecordsCompanion extends UpdateCompanion<UsageRecord> {
  final Value<int> id;
  final Value<DateTime> requestedAt;
  final Value<String> model;
  final Value<int> inputTokens;
  final Value<int> outputTokens;
  final Value<int?> cacheTokens;
  final Value<double?> estimatedUsd;
  final Value<String?> priceVersion;
  const UsageRecordsCompanion({
    this.id = const Value.absent(),
    this.requestedAt = const Value.absent(),
    this.model = const Value.absent(),
    this.inputTokens = const Value.absent(),
    this.outputTokens = const Value.absent(),
    this.cacheTokens = const Value.absent(),
    this.estimatedUsd = const Value.absent(),
    this.priceVersion = const Value.absent(),
  });
  UsageRecordsCompanion.insert({
    this.id = const Value.absent(),
    required DateTime requestedAt,
    required String model,
    required int inputTokens,
    required int outputTokens,
    this.cacheTokens = const Value.absent(),
    this.estimatedUsd = const Value.absent(),
    this.priceVersion = const Value.absent(),
  }) : requestedAt = Value(requestedAt),
       model = Value(model),
       inputTokens = Value(inputTokens),
       outputTokens = Value(outputTokens);
  static Insertable<UsageRecord> custom({
    Expression<int>? id,
    Expression<DateTime>? requestedAt,
    Expression<String>? model,
    Expression<int>? inputTokens,
    Expression<int>? outputTokens,
    Expression<int>? cacheTokens,
    Expression<double>? estimatedUsd,
    Expression<String>? priceVersion,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (requestedAt != null) 'requested_at': requestedAt,
      if (model != null) 'model': model,
      if (inputTokens != null) 'input_tokens': inputTokens,
      if (outputTokens != null) 'output_tokens': outputTokens,
      if (cacheTokens != null) 'cache_tokens': cacheTokens,
      if (estimatedUsd != null) 'estimated_usd': estimatedUsd,
      if (priceVersion != null) 'price_version': priceVersion,
    });
  }

  UsageRecordsCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? requestedAt,
    Value<String>? model,
    Value<int>? inputTokens,
    Value<int>? outputTokens,
    Value<int?>? cacheTokens,
    Value<double?>? estimatedUsd,
    Value<String?>? priceVersion,
  }) {
    return UsageRecordsCompanion(
      id: id ?? this.id,
      requestedAt: requestedAt ?? this.requestedAt,
      model: model ?? this.model,
      inputTokens: inputTokens ?? this.inputTokens,
      outputTokens: outputTokens ?? this.outputTokens,
      cacheTokens: cacheTokens ?? this.cacheTokens,
      estimatedUsd: estimatedUsd ?? this.estimatedUsd,
      priceVersion: priceVersion ?? this.priceVersion,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (requestedAt.present) {
      map['requested_at'] = Variable<DateTime>(requestedAt.value);
    }
    if (model.present) {
      map['model'] = Variable<String>(model.value);
    }
    if (inputTokens.present) {
      map['input_tokens'] = Variable<int>(inputTokens.value);
    }
    if (outputTokens.present) {
      map['output_tokens'] = Variable<int>(outputTokens.value);
    }
    if (cacheTokens.present) {
      map['cache_tokens'] = Variable<int>(cacheTokens.value);
    }
    if (estimatedUsd.present) {
      map['estimated_usd'] = Variable<double>(estimatedUsd.value);
    }
    if (priceVersion.present) {
      map['price_version'] = Variable<String>(priceVersion.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UsageRecordsCompanion(')
          ..write('id: $id, ')
          ..write('requestedAt: $requestedAt, ')
          ..write('model: $model, ')
          ..write('inputTokens: $inputTokens, ')
          ..write('outputTokens: $outputTokens, ')
          ..write('cacheTokens: $cacheTokens, ')
          ..write('estimatedUsd: $estimatedUsd, ')
          ..write('priceVersion: $priceVersion')
          ..write(')'))
        .toString();
  }
}

class $PendingImportsTable extends PendingImports
    with TableInfo<$PendingImportsTable, PendingImport> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PendingImportsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fingerprintMeta = const VerificationMeta(
    'fingerprint',
  );
  @override
  late final GeneratedColumn<String> fingerprint = GeneratedColumn<String>(
    'fingerprint',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _payloadMeta = const VerificationMeta(
    'payload',
  );
  @override
  late final GeneratedColumn<String> payload = GeneratedColumn<String>(
    'payload',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _stateMeta = const VerificationMeta('state');
  @override
  late final GeneratedColumn<String> state = GeneratedColumn<String>(
    'state',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _safeErrorMeta = const VerificationMeta(
    'safeError',
  );
  @override
  late final GeneratedColumn<String> safeError = GeneratedColumn<String>(
    'safe_error',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _receivedAtMeta = const VerificationMeta(
    'receivedAt',
  );
  @override
  late final GeneratedColumn<DateTime> receivedAt = GeneratedColumn<DateTime>(
    'received_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    fingerprint,
    payload,
    state,
    safeError,
    receivedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'pending_imports';
  @override
  VerificationContext validateIntegrity(
    Insertable<PendingImport> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('fingerprint')) {
      context.handle(
        _fingerprintMeta,
        fingerprint.isAcceptableOrUnknown(
          data['fingerprint']!,
          _fingerprintMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_fingerprintMeta);
    }
    if (data.containsKey('payload')) {
      context.handle(
        _payloadMeta,
        payload.isAcceptableOrUnknown(data['payload']!, _payloadMeta),
      );
    } else if (isInserting) {
      context.missing(_payloadMeta);
    }
    if (data.containsKey('state')) {
      context.handle(
        _stateMeta,
        state.isAcceptableOrUnknown(data['state']!, _stateMeta),
      );
    } else if (isInserting) {
      context.missing(_stateMeta);
    }
    if (data.containsKey('safe_error')) {
      context.handle(
        _safeErrorMeta,
        safeError.isAcceptableOrUnknown(data['safe_error']!, _safeErrorMeta),
      );
    }
    if (data.containsKey('received_at')) {
      context.handle(
        _receivedAtMeta,
        receivedAt.isAcceptableOrUnknown(data['received_at']!, _receivedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_receivedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PendingImport map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PendingImport(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      fingerprint: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}fingerprint'],
      )!,
      payload: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload'],
      )!,
      state: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}state'],
      )!,
      safeError: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}safe_error'],
      ),
      receivedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}received_at'],
      )!,
    );
  }

  @override
  $PendingImportsTable createAlias(String alias) {
    return $PendingImportsTable(attachedDatabase, alias);
  }
}

class PendingImport extends DataClass implements Insertable<PendingImport> {
  final String id;
  final String fingerprint;
  final String payload;
  final String state;
  final String? safeError;
  final DateTime receivedAt;
  const PendingImport({
    required this.id,
    required this.fingerprint,
    required this.payload,
    required this.state,
    this.safeError,
    required this.receivedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['fingerprint'] = Variable<String>(fingerprint);
    map['payload'] = Variable<String>(payload);
    map['state'] = Variable<String>(state);
    if (!nullToAbsent || safeError != null) {
      map['safe_error'] = Variable<String>(safeError);
    }
    map['received_at'] = Variable<DateTime>(receivedAt);
    return map;
  }

  PendingImportsCompanion toCompanion(bool nullToAbsent) {
    return PendingImportsCompanion(
      id: Value(id),
      fingerprint: Value(fingerprint),
      payload: Value(payload),
      state: Value(state),
      safeError: safeError == null && nullToAbsent
          ? const Value.absent()
          : Value(safeError),
      receivedAt: Value(receivedAt),
    );
  }

  factory PendingImport.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PendingImport(
      id: serializer.fromJson<String>(json['id']),
      fingerprint: serializer.fromJson<String>(json['fingerprint']),
      payload: serializer.fromJson<String>(json['payload']),
      state: serializer.fromJson<String>(json['state']),
      safeError: serializer.fromJson<String?>(json['safeError']),
      receivedAt: serializer.fromJson<DateTime>(json['receivedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'fingerprint': serializer.toJson<String>(fingerprint),
      'payload': serializer.toJson<String>(payload),
      'state': serializer.toJson<String>(state),
      'safeError': serializer.toJson<String?>(safeError),
      'receivedAt': serializer.toJson<DateTime>(receivedAt),
    };
  }

  PendingImport copyWith({
    String? id,
    String? fingerprint,
    String? payload,
    String? state,
    Value<String?> safeError = const Value.absent(),
    DateTime? receivedAt,
  }) => PendingImport(
    id: id ?? this.id,
    fingerprint: fingerprint ?? this.fingerprint,
    payload: payload ?? this.payload,
    state: state ?? this.state,
    safeError: safeError.present ? safeError.value : this.safeError,
    receivedAt: receivedAt ?? this.receivedAt,
  );
  PendingImport copyWithCompanion(PendingImportsCompanion data) {
    return PendingImport(
      id: data.id.present ? data.id.value : this.id,
      fingerprint: data.fingerprint.present
          ? data.fingerprint.value
          : this.fingerprint,
      payload: data.payload.present ? data.payload.value : this.payload,
      state: data.state.present ? data.state.value : this.state,
      safeError: data.safeError.present ? data.safeError.value : this.safeError,
      receivedAt: data.receivedAt.present
          ? data.receivedAt.value
          : this.receivedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PendingImport(')
          ..write('id: $id, ')
          ..write('fingerprint: $fingerprint, ')
          ..write('payload: $payload, ')
          ..write('state: $state, ')
          ..write('safeError: $safeError, ')
          ..write('receivedAt: $receivedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, fingerprint, payload, state, safeError, receivedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PendingImport &&
          other.id == this.id &&
          other.fingerprint == this.fingerprint &&
          other.payload == this.payload &&
          other.state == this.state &&
          other.safeError == this.safeError &&
          other.receivedAt == this.receivedAt);
}

class PendingImportsCompanion extends UpdateCompanion<PendingImport> {
  final Value<String> id;
  final Value<String> fingerprint;
  final Value<String> payload;
  final Value<String> state;
  final Value<String?> safeError;
  final Value<DateTime> receivedAt;
  final Value<int> rowid;
  const PendingImportsCompanion({
    this.id = const Value.absent(),
    this.fingerprint = const Value.absent(),
    this.payload = const Value.absent(),
    this.state = const Value.absent(),
    this.safeError = const Value.absent(),
    this.receivedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PendingImportsCompanion.insert({
    required String id,
    required String fingerprint,
    required String payload,
    required String state,
    this.safeError = const Value.absent(),
    required DateTime receivedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       fingerprint = Value(fingerprint),
       payload = Value(payload),
       state = Value(state),
       receivedAt = Value(receivedAt);
  static Insertable<PendingImport> custom({
    Expression<String>? id,
    Expression<String>? fingerprint,
    Expression<String>? payload,
    Expression<String>? state,
    Expression<String>? safeError,
    Expression<DateTime>? receivedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (fingerprint != null) 'fingerprint': fingerprint,
      if (payload != null) 'payload': payload,
      if (state != null) 'state': state,
      if (safeError != null) 'safe_error': safeError,
      if (receivedAt != null) 'received_at': receivedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PendingImportsCompanion copyWith({
    Value<String>? id,
    Value<String>? fingerprint,
    Value<String>? payload,
    Value<String>? state,
    Value<String?>? safeError,
    Value<DateTime>? receivedAt,
    Value<int>? rowid,
  }) {
    return PendingImportsCompanion(
      id: id ?? this.id,
      fingerprint: fingerprint ?? this.fingerprint,
      payload: payload ?? this.payload,
      state: state ?? this.state,
      safeError: safeError ?? this.safeError,
      receivedAt: receivedAt ?? this.receivedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (fingerprint.present) {
      map['fingerprint'] = Variable<String>(fingerprint.value);
    }
    if (payload.present) {
      map['payload'] = Variable<String>(payload.value);
    }
    if (state.present) {
      map['state'] = Variable<String>(state.value);
    }
    if (safeError.present) {
      map['safe_error'] = Variable<String>(safeError.value);
    }
    if (receivedAt.present) {
      map['received_at'] = Variable<DateTime>(receivedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PendingImportsCompanion(')
          ..write('id: $id, ')
          ..write('fingerprint: $fingerprint, ')
          ..write('payload: $payload, ')
          ..write('state: $state, ')
          ..write('safeError: $safeError, ')
          ..write('receivedAt: $receivedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ImportedConversationsTable extends ImportedConversations
    with TableInfo<$ImportedConversationsTable, ImportedConversationRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ImportedConversationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _jobIdMeta = const VerificationMeta('jobId');
  @override
  late final GeneratedColumn<String> jobId = GeneratedColumn<String>(
    'job_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
    'source',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _worldIdMeta = const VerificationMeta(
    'worldId',
  );
  @override
  late final GeneratedColumn<String> worldId = GeneratedColumn<String>(
    'world_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES worlds (id)',
    ),
  );
  static const VerificationMeta _currentMessageIdMeta = const VerificationMeta(
    'currentMessageId',
  );
  @override
  late final GeneratedColumn<String> currentMessageId = GeneratedColumn<String>(
    'current_message_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    jobId,
    title,
    source,
    worldId,
    currentMessageId,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'imported_conversations';
  @override
  VerificationContext validateIntegrity(
    Insertable<ImportedConversationRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('job_id')) {
      context.handle(
        _jobIdMeta,
        jobId.isAcceptableOrUnknown(data['job_id']!, _jobIdMeta),
      );
    } else if (isInserting) {
      context.missing(_jobIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('source')) {
      context.handle(
        _sourceMeta,
        source.isAcceptableOrUnknown(data['source']!, _sourceMeta),
      );
    } else if (isInserting) {
      context.missing(_sourceMeta);
    }
    if (data.containsKey('world_id')) {
      context.handle(
        _worldIdMeta,
        worldId.isAcceptableOrUnknown(data['world_id']!, _worldIdMeta),
      );
    }
    if (data.containsKey('current_message_id')) {
      context.handle(
        _currentMessageIdMeta,
        currentMessageId.isAcceptableOrUnknown(
          data['current_message_id']!,
          _currentMessageIdMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ImportedConversationRow map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ImportedConversationRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      jobId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}job_id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      source: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source'],
      )!,
      worldId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}world_id'],
      ),
      currentMessageId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}current_message_id'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $ImportedConversationsTable createAlias(String alias) {
    return $ImportedConversationsTable(attachedDatabase, alias);
  }
}

class ImportedConversationRow extends DataClass
    implements Insertable<ImportedConversationRow> {
  final String id;
  final String jobId;
  final String title;
  final String source;
  final String? worldId;
  final String? currentMessageId;
  final DateTime createdAt;
  const ImportedConversationRow({
    required this.id,
    required this.jobId,
    required this.title,
    required this.source,
    this.worldId,
    this.currentMessageId,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['job_id'] = Variable<String>(jobId);
    map['title'] = Variable<String>(title);
    map['source'] = Variable<String>(source);
    if (!nullToAbsent || worldId != null) {
      map['world_id'] = Variable<String>(worldId);
    }
    if (!nullToAbsent || currentMessageId != null) {
      map['current_message_id'] = Variable<String>(currentMessageId);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  ImportedConversationsCompanion toCompanion(bool nullToAbsent) {
    return ImportedConversationsCompanion(
      id: Value(id),
      jobId: Value(jobId),
      title: Value(title),
      source: Value(source),
      worldId: worldId == null && nullToAbsent
          ? const Value.absent()
          : Value(worldId),
      currentMessageId: currentMessageId == null && nullToAbsent
          ? const Value.absent()
          : Value(currentMessageId),
      createdAt: Value(createdAt),
    );
  }

  factory ImportedConversationRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ImportedConversationRow(
      id: serializer.fromJson<String>(json['id']),
      jobId: serializer.fromJson<String>(json['jobId']),
      title: serializer.fromJson<String>(json['title']),
      source: serializer.fromJson<String>(json['source']),
      worldId: serializer.fromJson<String?>(json['worldId']),
      currentMessageId: serializer.fromJson<String?>(json['currentMessageId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'jobId': serializer.toJson<String>(jobId),
      'title': serializer.toJson<String>(title),
      'source': serializer.toJson<String>(source),
      'worldId': serializer.toJson<String?>(worldId),
      'currentMessageId': serializer.toJson<String?>(currentMessageId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  ImportedConversationRow copyWith({
    String? id,
    String? jobId,
    String? title,
    String? source,
    Value<String?> worldId = const Value.absent(),
    Value<String?> currentMessageId = const Value.absent(),
    DateTime? createdAt,
  }) => ImportedConversationRow(
    id: id ?? this.id,
    jobId: jobId ?? this.jobId,
    title: title ?? this.title,
    source: source ?? this.source,
    worldId: worldId.present ? worldId.value : this.worldId,
    currentMessageId: currentMessageId.present
        ? currentMessageId.value
        : this.currentMessageId,
    createdAt: createdAt ?? this.createdAt,
  );
  ImportedConversationRow copyWithCompanion(
    ImportedConversationsCompanion data,
  ) {
    return ImportedConversationRow(
      id: data.id.present ? data.id.value : this.id,
      jobId: data.jobId.present ? data.jobId.value : this.jobId,
      title: data.title.present ? data.title.value : this.title,
      source: data.source.present ? data.source.value : this.source,
      worldId: data.worldId.present ? data.worldId.value : this.worldId,
      currentMessageId: data.currentMessageId.present
          ? data.currentMessageId.value
          : this.currentMessageId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ImportedConversationRow(')
          ..write('id: $id, ')
          ..write('jobId: $jobId, ')
          ..write('title: $title, ')
          ..write('source: $source, ')
          ..write('worldId: $worldId, ')
          ..write('currentMessageId: $currentMessageId, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    jobId,
    title,
    source,
    worldId,
    currentMessageId,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ImportedConversationRow &&
          other.id == this.id &&
          other.jobId == this.jobId &&
          other.title == this.title &&
          other.source == this.source &&
          other.worldId == this.worldId &&
          other.currentMessageId == this.currentMessageId &&
          other.createdAt == this.createdAt);
}

class ImportedConversationsCompanion
    extends UpdateCompanion<ImportedConversationRow> {
  final Value<String> id;
  final Value<String> jobId;
  final Value<String> title;
  final Value<String> source;
  final Value<String?> worldId;
  final Value<String?> currentMessageId;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const ImportedConversationsCompanion({
    this.id = const Value.absent(),
    this.jobId = const Value.absent(),
    this.title = const Value.absent(),
    this.source = const Value.absent(),
    this.worldId = const Value.absent(),
    this.currentMessageId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ImportedConversationsCompanion.insert({
    required String id,
    required String jobId,
    required String title,
    required String source,
    this.worldId = const Value.absent(),
    this.currentMessageId = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       jobId = Value(jobId),
       title = Value(title),
       source = Value(source),
       createdAt = Value(createdAt);
  static Insertable<ImportedConversationRow> custom({
    Expression<String>? id,
    Expression<String>? jobId,
    Expression<String>? title,
    Expression<String>? source,
    Expression<String>? worldId,
    Expression<String>? currentMessageId,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (jobId != null) 'job_id': jobId,
      if (title != null) 'title': title,
      if (source != null) 'source': source,
      if (worldId != null) 'world_id': worldId,
      if (currentMessageId != null) 'current_message_id': currentMessageId,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ImportedConversationsCompanion copyWith({
    Value<String>? id,
    Value<String>? jobId,
    Value<String>? title,
    Value<String>? source,
    Value<String?>? worldId,
    Value<String?>? currentMessageId,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return ImportedConversationsCompanion(
      id: id ?? this.id,
      jobId: jobId ?? this.jobId,
      title: title ?? this.title,
      source: source ?? this.source,
      worldId: worldId ?? this.worldId,
      currentMessageId: currentMessageId ?? this.currentMessageId,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (jobId.present) {
      map['job_id'] = Variable<String>(jobId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (worldId.present) {
      map['world_id'] = Variable<String>(worldId.value);
    }
    if (currentMessageId.present) {
      map['current_message_id'] = Variable<String>(currentMessageId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ImportedConversationsCompanion(')
          ..write('id: $id, ')
          ..write('jobId: $jobId, ')
          ..write('title: $title, ')
          ..write('source: $source, ')
          ..write('worldId: $worldId, ')
          ..write('currentMessageId: $currentMessageId, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ImportedMessagesTable extends ImportedMessages
    with TableInfo<$ImportedMessagesTable, ImportedMessageRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ImportedMessagesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _conversationIdMeta = const VerificationMeta(
    'conversationId',
  );
  @override
  late final GeneratedColumn<String> conversationId = GeneratedColumn<String>(
    'conversation_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES imported_conversations (id)',
    ),
  );
  static const VerificationMeta _messageIdMeta = const VerificationMeta(
    'messageId',
  );
  @override
  late final GeneratedColumn<String> messageId = GeneratedColumn<String>(
    'message_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _parentIdMeta = const VerificationMeta(
    'parentId',
  );
  @override
  late final GeneratedColumn<String> parentId = GeneratedColumn<String>(
    'parent_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _roleMeta = const VerificationMeta('role');
  @override
  late final GeneratedColumn<String> role = GeneratedColumn<String>(
    'role',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _bodyMeta = const VerificationMeta('body');
  @override
  late final GeneratedColumn<String> body = GeneratedColumn<String>(
    'body',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _rawJsonMeta = const VerificationMeta(
    'rawJson',
  );
  @override
  late final GeneratedColumn<String> rawJson = GeneratedColumn<String>(
    'raw_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ordinalMeta = const VerificationMeta(
    'ordinal',
  );
  @override
  late final GeneratedColumn<int> ordinal = GeneratedColumn<int>(
    'ordinal',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    conversationId,
    messageId,
    parentId,
    role,
    body,
    rawJson,
    ordinal,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'imported_messages';
  @override
  VerificationContext validateIntegrity(
    Insertable<ImportedMessageRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('conversation_id')) {
      context.handle(
        _conversationIdMeta,
        conversationId.isAcceptableOrUnknown(
          data['conversation_id']!,
          _conversationIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_conversationIdMeta);
    }
    if (data.containsKey('message_id')) {
      context.handle(
        _messageIdMeta,
        messageId.isAcceptableOrUnknown(data['message_id']!, _messageIdMeta),
      );
    } else if (isInserting) {
      context.missing(_messageIdMeta);
    }
    if (data.containsKey('parent_id')) {
      context.handle(
        _parentIdMeta,
        parentId.isAcceptableOrUnknown(data['parent_id']!, _parentIdMeta),
      );
    }
    if (data.containsKey('role')) {
      context.handle(
        _roleMeta,
        role.isAcceptableOrUnknown(data['role']!, _roleMeta),
      );
    } else if (isInserting) {
      context.missing(_roleMeta);
    }
    if (data.containsKey('body')) {
      context.handle(
        _bodyMeta,
        body.isAcceptableOrUnknown(data['body']!, _bodyMeta),
      );
    } else if (isInserting) {
      context.missing(_bodyMeta);
    }
    if (data.containsKey('raw_json')) {
      context.handle(
        _rawJsonMeta,
        rawJson.isAcceptableOrUnknown(data['raw_json']!, _rawJsonMeta),
      );
    } else if (isInserting) {
      context.missing(_rawJsonMeta);
    }
    if (data.containsKey('ordinal')) {
      context.handle(
        _ordinalMeta,
        ordinal.isAcceptableOrUnknown(data['ordinal']!, _ordinalMeta),
      );
    } else if (isInserting) {
      context.missing(_ordinalMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {conversationId, messageId};
  @override
  ImportedMessageRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ImportedMessageRow(
      conversationId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}conversation_id'],
      )!,
      messageId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}message_id'],
      )!,
      parentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}parent_id'],
      ),
      role: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}role'],
      )!,
      body: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}body'],
      )!,
      rawJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}raw_json'],
      )!,
      ordinal: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}ordinal'],
      )!,
    );
  }

  @override
  $ImportedMessagesTable createAlias(String alias) {
    return $ImportedMessagesTable(attachedDatabase, alias);
  }
}

class ImportedMessageRow extends DataClass
    implements Insertable<ImportedMessageRow> {
  final String conversationId;
  final String messageId;
  final String? parentId;
  final String role;
  final String body;
  final String rawJson;
  final int ordinal;
  const ImportedMessageRow({
    required this.conversationId,
    required this.messageId,
    this.parentId,
    required this.role,
    required this.body,
    required this.rawJson,
    required this.ordinal,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['conversation_id'] = Variable<String>(conversationId);
    map['message_id'] = Variable<String>(messageId);
    if (!nullToAbsent || parentId != null) {
      map['parent_id'] = Variable<String>(parentId);
    }
    map['role'] = Variable<String>(role);
    map['body'] = Variable<String>(body);
    map['raw_json'] = Variable<String>(rawJson);
    map['ordinal'] = Variable<int>(ordinal);
    return map;
  }

  ImportedMessagesCompanion toCompanion(bool nullToAbsent) {
    return ImportedMessagesCompanion(
      conversationId: Value(conversationId),
      messageId: Value(messageId),
      parentId: parentId == null && nullToAbsent
          ? const Value.absent()
          : Value(parentId),
      role: Value(role),
      body: Value(body),
      rawJson: Value(rawJson),
      ordinal: Value(ordinal),
    );
  }

  factory ImportedMessageRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ImportedMessageRow(
      conversationId: serializer.fromJson<String>(json['conversationId']),
      messageId: serializer.fromJson<String>(json['messageId']),
      parentId: serializer.fromJson<String?>(json['parentId']),
      role: serializer.fromJson<String>(json['role']),
      body: serializer.fromJson<String>(json['body']),
      rawJson: serializer.fromJson<String>(json['rawJson']),
      ordinal: serializer.fromJson<int>(json['ordinal']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'conversationId': serializer.toJson<String>(conversationId),
      'messageId': serializer.toJson<String>(messageId),
      'parentId': serializer.toJson<String?>(parentId),
      'role': serializer.toJson<String>(role),
      'body': serializer.toJson<String>(body),
      'rawJson': serializer.toJson<String>(rawJson),
      'ordinal': serializer.toJson<int>(ordinal),
    };
  }

  ImportedMessageRow copyWith({
    String? conversationId,
    String? messageId,
    Value<String?> parentId = const Value.absent(),
    String? role,
    String? body,
    String? rawJson,
    int? ordinal,
  }) => ImportedMessageRow(
    conversationId: conversationId ?? this.conversationId,
    messageId: messageId ?? this.messageId,
    parentId: parentId.present ? parentId.value : this.parentId,
    role: role ?? this.role,
    body: body ?? this.body,
    rawJson: rawJson ?? this.rawJson,
    ordinal: ordinal ?? this.ordinal,
  );
  ImportedMessageRow copyWithCompanion(ImportedMessagesCompanion data) {
    return ImportedMessageRow(
      conversationId: data.conversationId.present
          ? data.conversationId.value
          : this.conversationId,
      messageId: data.messageId.present ? data.messageId.value : this.messageId,
      parentId: data.parentId.present ? data.parentId.value : this.parentId,
      role: data.role.present ? data.role.value : this.role,
      body: data.body.present ? data.body.value : this.body,
      rawJson: data.rawJson.present ? data.rawJson.value : this.rawJson,
      ordinal: data.ordinal.present ? data.ordinal.value : this.ordinal,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ImportedMessageRow(')
          ..write('conversationId: $conversationId, ')
          ..write('messageId: $messageId, ')
          ..write('parentId: $parentId, ')
          ..write('role: $role, ')
          ..write('body: $body, ')
          ..write('rawJson: $rawJson, ')
          ..write('ordinal: $ordinal')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    conversationId,
    messageId,
    parentId,
    role,
    body,
    rawJson,
    ordinal,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ImportedMessageRow &&
          other.conversationId == this.conversationId &&
          other.messageId == this.messageId &&
          other.parentId == this.parentId &&
          other.role == this.role &&
          other.body == this.body &&
          other.rawJson == this.rawJson &&
          other.ordinal == this.ordinal);
}

class ImportedMessagesCompanion extends UpdateCompanion<ImportedMessageRow> {
  final Value<String> conversationId;
  final Value<String> messageId;
  final Value<String?> parentId;
  final Value<String> role;
  final Value<String> body;
  final Value<String> rawJson;
  final Value<int> ordinal;
  final Value<int> rowid;
  const ImportedMessagesCompanion({
    this.conversationId = const Value.absent(),
    this.messageId = const Value.absent(),
    this.parentId = const Value.absent(),
    this.role = const Value.absent(),
    this.body = const Value.absent(),
    this.rawJson = const Value.absent(),
    this.ordinal = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ImportedMessagesCompanion.insert({
    required String conversationId,
    required String messageId,
    this.parentId = const Value.absent(),
    required String role,
    required String body,
    required String rawJson,
    required int ordinal,
    this.rowid = const Value.absent(),
  }) : conversationId = Value(conversationId),
       messageId = Value(messageId),
       role = Value(role),
       body = Value(body),
       rawJson = Value(rawJson),
       ordinal = Value(ordinal);
  static Insertable<ImportedMessageRow> custom({
    Expression<String>? conversationId,
    Expression<String>? messageId,
    Expression<String>? parentId,
    Expression<String>? role,
    Expression<String>? body,
    Expression<String>? rawJson,
    Expression<int>? ordinal,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (conversationId != null) 'conversation_id': conversationId,
      if (messageId != null) 'message_id': messageId,
      if (parentId != null) 'parent_id': parentId,
      if (role != null) 'role': role,
      if (body != null) 'body': body,
      if (rawJson != null) 'raw_json': rawJson,
      if (ordinal != null) 'ordinal': ordinal,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ImportedMessagesCompanion copyWith({
    Value<String>? conversationId,
    Value<String>? messageId,
    Value<String?>? parentId,
    Value<String>? role,
    Value<String>? body,
    Value<String>? rawJson,
    Value<int>? ordinal,
    Value<int>? rowid,
  }) {
    return ImportedMessagesCompanion(
      conversationId: conversationId ?? this.conversationId,
      messageId: messageId ?? this.messageId,
      parentId: parentId ?? this.parentId,
      role: role ?? this.role,
      body: body ?? this.body,
      rawJson: rawJson ?? this.rawJson,
      ordinal: ordinal ?? this.ordinal,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (conversationId.present) {
      map['conversation_id'] = Variable<String>(conversationId.value);
    }
    if (messageId.present) {
      map['message_id'] = Variable<String>(messageId.value);
    }
    if (parentId.present) {
      map['parent_id'] = Variable<String>(parentId.value);
    }
    if (role.present) {
      map['role'] = Variable<String>(role.value);
    }
    if (body.present) {
      map['body'] = Variable<String>(body.value);
    }
    if (rawJson.present) {
      map['raw_json'] = Variable<String>(rawJson.value);
    }
    if (ordinal.present) {
      map['ordinal'] = Variable<int>(ordinal.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ImportedMessagesCompanion(')
          ..write('conversationId: $conversationId, ')
          ..write('messageId: $messageId, ')
          ..write('parentId: $parentId, ')
          ..write('role: $role, ')
          ..write('body: $body, ')
          ..write('rawJson: $rawJson, ')
          ..write('ordinal: $ordinal, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ImportedAttachmentsTable extends ImportedAttachments
    with TableInfo<$ImportedAttachmentsTable, ImportedAttachmentRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ImportedAttachmentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _conversationIdMeta = const VerificationMeta(
    'conversationId',
  );
  @override
  late final GeneratedColumn<String> conversationId = GeneratedColumn<String>(
    'conversation_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES imported_conversations (id)',
    ),
  );
  static const VerificationMeta _privatePathMeta = const VerificationMeta(
    'privatePath',
  );
  @override
  late final GeneratedColumn<String> privatePath = GeneratedColumn<String>(
    'private_path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _displayNameMeta = const VerificationMeta(
    'displayName',
  );
  @override
  late final GeneratedColumn<String> displayName = GeneratedColumn<String>(
    'display_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _mimeMeta = const VerificationMeta('mime');
  @override
  late final GeneratedColumn<String> mime = GeneratedColumn<String>(
    'mime',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _byteSizeMeta = const VerificationMeta(
    'byteSize',
  );
  @override
  late final GeneratedColumn<int> byteSize = GeneratedColumn<int>(
    'byte_size',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _digestMeta = const VerificationMeta('digest');
  @override
  late final GeneratedColumn<String> digest = GeneratedColumn<String>(
    'digest',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    conversationId,
    privatePath,
    displayName,
    mime,
    byteSize,
    digest,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'imported_attachments';
  @override
  VerificationContext validateIntegrity(
    Insertable<ImportedAttachmentRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('conversation_id')) {
      context.handle(
        _conversationIdMeta,
        conversationId.isAcceptableOrUnknown(
          data['conversation_id']!,
          _conversationIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_conversationIdMeta);
    }
    if (data.containsKey('private_path')) {
      context.handle(
        _privatePathMeta,
        privatePath.isAcceptableOrUnknown(
          data['private_path']!,
          _privatePathMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_privatePathMeta);
    }
    if (data.containsKey('display_name')) {
      context.handle(
        _displayNameMeta,
        displayName.isAcceptableOrUnknown(
          data['display_name']!,
          _displayNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_displayNameMeta);
    }
    if (data.containsKey('mime')) {
      context.handle(
        _mimeMeta,
        mime.isAcceptableOrUnknown(data['mime']!, _mimeMeta),
      );
    } else if (isInserting) {
      context.missing(_mimeMeta);
    }
    if (data.containsKey('byte_size')) {
      context.handle(
        _byteSizeMeta,
        byteSize.isAcceptableOrUnknown(data['byte_size']!, _byteSizeMeta),
      );
    } else if (isInserting) {
      context.missing(_byteSizeMeta);
    }
    if (data.containsKey('digest')) {
      context.handle(
        _digestMeta,
        digest.isAcceptableOrUnknown(data['digest']!, _digestMeta),
      );
    } else if (isInserting) {
      context.missing(_digestMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ImportedAttachmentRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ImportedAttachmentRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      conversationId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}conversation_id'],
      )!,
      privatePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}private_path'],
      )!,
      displayName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}display_name'],
      )!,
      mime: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}mime'],
      )!,
      byteSize: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}byte_size'],
      )!,
      digest: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}digest'],
      )!,
    );
  }

  @override
  $ImportedAttachmentsTable createAlias(String alias) {
    return $ImportedAttachmentsTable(attachedDatabase, alias);
  }
}

class ImportedAttachmentRow extends DataClass
    implements Insertable<ImportedAttachmentRow> {
  final int id;
  final String conversationId;
  final String privatePath;
  final String displayName;
  final String mime;
  final int byteSize;
  final String digest;
  const ImportedAttachmentRow({
    required this.id,
    required this.conversationId,
    required this.privatePath,
    required this.displayName,
    required this.mime,
    required this.byteSize,
    required this.digest,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['conversation_id'] = Variable<String>(conversationId);
    map['private_path'] = Variable<String>(privatePath);
    map['display_name'] = Variable<String>(displayName);
    map['mime'] = Variable<String>(mime);
    map['byte_size'] = Variable<int>(byteSize);
    map['digest'] = Variable<String>(digest);
    return map;
  }

  ImportedAttachmentsCompanion toCompanion(bool nullToAbsent) {
    return ImportedAttachmentsCompanion(
      id: Value(id),
      conversationId: Value(conversationId),
      privatePath: Value(privatePath),
      displayName: Value(displayName),
      mime: Value(mime),
      byteSize: Value(byteSize),
      digest: Value(digest),
    );
  }

  factory ImportedAttachmentRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ImportedAttachmentRow(
      id: serializer.fromJson<int>(json['id']),
      conversationId: serializer.fromJson<String>(json['conversationId']),
      privatePath: serializer.fromJson<String>(json['privatePath']),
      displayName: serializer.fromJson<String>(json['displayName']),
      mime: serializer.fromJson<String>(json['mime']),
      byteSize: serializer.fromJson<int>(json['byteSize']),
      digest: serializer.fromJson<String>(json['digest']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'conversationId': serializer.toJson<String>(conversationId),
      'privatePath': serializer.toJson<String>(privatePath),
      'displayName': serializer.toJson<String>(displayName),
      'mime': serializer.toJson<String>(mime),
      'byteSize': serializer.toJson<int>(byteSize),
      'digest': serializer.toJson<String>(digest),
    };
  }

  ImportedAttachmentRow copyWith({
    int? id,
    String? conversationId,
    String? privatePath,
    String? displayName,
    String? mime,
    int? byteSize,
    String? digest,
  }) => ImportedAttachmentRow(
    id: id ?? this.id,
    conversationId: conversationId ?? this.conversationId,
    privatePath: privatePath ?? this.privatePath,
    displayName: displayName ?? this.displayName,
    mime: mime ?? this.mime,
    byteSize: byteSize ?? this.byteSize,
    digest: digest ?? this.digest,
  );
  ImportedAttachmentRow copyWithCompanion(ImportedAttachmentsCompanion data) {
    return ImportedAttachmentRow(
      id: data.id.present ? data.id.value : this.id,
      conversationId: data.conversationId.present
          ? data.conversationId.value
          : this.conversationId,
      privatePath: data.privatePath.present
          ? data.privatePath.value
          : this.privatePath,
      displayName: data.displayName.present
          ? data.displayName.value
          : this.displayName,
      mime: data.mime.present ? data.mime.value : this.mime,
      byteSize: data.byteSize.present ? data.byteSize.value : this.byteSize,
      digest: data.digest.present ? data.digest.value : this.digest,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ImportedAttachmentRow(')
          ..write('id: $id, ')
          ..write('conversationId: $conversationId, ')
          ..write('privatePath: $privatePath, ')
          ..write('displayName: $displayName, ')
          ..write('mime: $mime, ')
          ..write('byteSize: $byteSize, ')
          ..write('digest: $digest')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    conversationId,
    privatePath,
    displayName,
    mime,
    byteSize,
    digest,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ImportedAttachmentRow &&
          other.id == this.id &&
          other.conversationId == this.conversationId &&
          other.privatePath == this.privatePath &&
          other.displayName == this.displayName &&
          other.mime == this.mime &&
          other.byteSize == this.byteSize &&
          other.digest == this.digest);
}

class ImportedAttachmentsCompanion
    extends UpdateCompanion<ImportedAttachmentRow> {
  final Value<int> id;
  final Value<String> conversationId;
  final Value<String> privatePath;
  final Value<String> displayName;
  final Value<String> mime;
  final Value<int> byteSize;
  final Value<String> digest;
  const ImportedAttachmentsCompanion({
    this.id = const Value.absent(),
    this.conversationId = const Value.absent(),
    this.privatePath = const Value.absent(),
    this.displayName = const Value.absent(),
    this.mime = const Value.absent(),
    this.byteSize = const Value.absent(),
    this.digest = const Value.absent(),
  });
  ImportedAttachmentsCompanion.insert({
    this.id = const Value.absent(),
    required String conversationId,
    required String privatePath,
    required String displayName,
    required String mime,
    required int byteSize,
    required String digest,
  }) : conversationId = Value(conversationId),
       privatePath = Value(privatePath),
       displayName = Value(displayName),
       mime = Value(mime),
       byteSize = Value(byteSize),
       digest = Value(digest);
  static Insertable<ImportedAttachmentRow> custom({
    Expression<int>? id,
    Expression<String>? conversationId,
    Expression<String>? privatePath,
    Expression<String>? displayName,
    Expression<String>? mime,
    Expression<int>? byteSize,
    Expression<String>? digest,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (conversationId != null) 'conversation_id': conversationId,
      if (privatePath != null) 'private_path': privatePath,
      if (displayName != null) 'display_name': displayName,
      if (mime != null) 'mime': mime,
      if (byteSize != null) 'byte_size': byteSize,
      if (digest != null) 'digest': digest,
    });
  }

  ImportedAttachmentsCompanion copyWith({
    Value<int>? id,
    Value<String>? conversationId,
    Value<String>? privatePath,
    Value<String>? displayName,
    Value<String>? mime,
    Value<int>? byteSize,
    Value<String>? digest,
  }) {
    return ImportedAttachmentsCompanion(
      id: id ?? this.id,
      conversationId: conversationId ?? this.conversationId,
      privatePath: privatePath ?? this.privatePath,
      displayName: displayName ?? this.displayName,
      mime: mime ?? this.mime,
      byteSize: byteSize ?? this.byteSize,
      digest: digest ?? this.digest,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (conversationId.present) {
      map['conversation_id'] = Variable<String>(conversationId.value);
    }
    if (privatePath.present) {
      map['private_path'] = Variable<String>(privatePath.value);
    }
    if (displayName.present) {
      map['display_name'] = Variable<String>(displayName.value);
    }
    if (mime.present) {
      map['mime'] = Variable<String>(mime.value);
    }
    if (byteSize.present) {
      map['byte_size'] = Variable<int>(byteSize.value);
    }
    if (digest.present) {
      map['digest'] = Variable<String>(digest.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ImportedAttachmentsCompanion(')
          ..write('id: $id, ')
          ..write('conversationId: $conversationId, ')
          ..write('privatePath: $privatePath, ')
          ..write('displayName: $displayName, ')
          ..write('mime: $mime, ')
          ..write('byteSize: $byteSize, ')
          ..write('digest: $digest')
          ..write(')'))
        .toString();
  }
}

class $DerivedImportResultsTable extends DerivedImportResults
    with TableInfo<$DerivedImportResultsTable, DerivedImportResult> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DerivedImportResultsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _conversationIdMeta = const VerificationMeta(
    'conversationId',
  );
  @override
  late final GeneratedColumn<String> conversationId = GeneratedColumn<String>(
    'conversation_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES imported_conversations (id)',
    ),
  );
  static const VerificationMeta _derivedJsonMeta = const VerificationMeta(
    'derivedJson',
  );
  @override
  late final GeneratedColumn<String> derivedJson = GeneratedColumn<String>(
    'derived_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    conversationId,
    derivedJson,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'derived_import_results';
  @override
  VerificationContext validateIntegrity(
    Insertable<DerivedImportResult> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('conversation_id')) {
      context.handle(
        _conversationIdMeta,
        conversationId.isAcceptableOrUnknown(
          data['conversation_id']!,
          _conversationIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_conversationIdMeta);
    }
    if (data.containsKey('derived_json')) {
      context.handle(
        _derivedJsonMeta,
        derivedJson.isAcceptableOrUnknown(
          data['derived_json']!,
          _derivedJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_derivedJsonMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DerivedImportResult map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DerivedImportResult(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      conversationId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}conversation_id'],
      )!,
      derivedJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}derived_json'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $DerivedImportResultsTable createAlias(String alias) {
    return $DerivedImportResultsTable(attachedDatabase, alias);
  }
}

class DerivedImportResult extends DataClass
    implements Insertable<DerivedImportResult> {
  final int id;
  final String conversationId;
  final String derivedJson;
  final DateTime createdAt;
  const DerivedImportResult({
    required this.id,
    required this.conversationId,
    required this.derivedJson,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['conversation_id'] = Variable<String>(conversationId);
    map['derived_json'] = Variable<String>(derivedJson);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  DerivedImportResultsCompanion toCompanion(bool nullToAbsent) {
    return DerivedImportResultsCompanion(
      id: Value(id),
      conversationId: Value(conversationId),
      derivedJson: Value(derivedJson),
      createdAt: Value(createdAt),
    );
  }

  factory DerivedImportResult.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DerivedImportResult(
      id: serializer.fromJson<int>(json['id']),
      conversationId: serializer.fromJson<String>(json['conversationId']),
      derivedJson: serializer.fromJson<String>(json['derivedJson']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'conversationId': serializer.toJson<String>(conversationId),
      'derivedJson': serializer.toJson<String>(derivedJson),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  DerivedImportResult copyWith({
    int? id,
    String? conversationId,
    String? derivedJson,
    DateTime? createdAt,
  }) => DerivedImportResult(
    id: id ?? this.id,
    conversationId: conversationId ?? this.conversationId,
    derivedJson: derivedJson ?? this.derivedJson,
    createdAt: createdAt ?? this.createdAt,
  );
  DerivedImportResult copyWithCompanion(DerivedImportResultsCompanion data) {
    return DerivedImportResult(
      id: data.id.present ? data.id.value : this.id,
      conversationId: data.conversationId.present
          ? data.conversationId.value
          : this.conversationId,
      derivedJson: data.derivedJson.present
          ? data.derivedJson.value
          : this.derivedJson,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DerivedImportResult(')
          ..write('id: $id, ')
          ..write('conversationId: $conversationId, ')
          ..write('derivedJson: $derivedJson, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, conversationId, derivedJson, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DerivedImportResult &&
          other.id == this.id &&
          other.conversationId == this.conversationId &&
          other.derivedJson == this.derivedJson &&
          other.createdAt == this.createdAt);
}

class DerivedImportResultsCompanion
    extends UpdateCompanion<DerivedImportResult> {
  final Value<int> id;
  final Value<String> conversationId;
  final Value<String> derivedJson;
  final Value<DateTime> createdAt;
  const DerivedImportResultsCompanion({
    this.id = const Value.absent(),
    this.conversationId = const Value.absent(),
    this.derivedJson = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  DerivedImportResultsCompanion.insert({
    this.id = const Value.absent(),
    required String conversationId,
    required String derivedJson,
    required DateTime createdAt,
  }) : conversationId = Value(conversationId),
       derivedJson = Value(derivedJson),
       createdAt = Value(createdAt);
  static Insertable<DerivedImportResult> custom({
    Expression<int>? id,
    Expression<String>? conversationId,
    Expression<String>? derivedJson,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (conversationId != null) 'conversation_id': conversationId,
      if (derivedJson != null) 'derived_json': derivedJson,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  DerivedImportResultsCompanion copyWith({
    Value<int>? id,
    Value<String>? conversationId,
    Value<String>? derivedJson,
    Value<DateTime>? createdAt,
  }) {
    return DerivedImportResultsCompanion(
      id: id ?? this.id,
      conversationId: conversationId ?? this.conversationId,
      derivedJson: derivedJson ?? this.derivedJson,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (conversationId.present) {
      map['conversation_id'] = Variable<String>(conversationId.value);
    }
    if (derivedJson.present) {
      map['derived_json'] = Variable<String>(derivedJson.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DerivedImportResultsCompanion(')
          ..write('id: $id, ')
          ..write('conversationId: $conversationId, ')
          ..write('derivedJson: $derivedJson, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $RoleplaySavesTable extends RoleplaySaves
    with TableInfo<$RoleplaySavesTable, RoleplaySave> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RoleplaySavesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _worldIdMeta = const VerificationMeta(
    'worldId',
  );
  @override
  late final GeneratedColumn<String> worldId = GeneratedColumn<String>(
    'world_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES worlds (id)',
    ),
  );
  static const VerificationMeta _revisionMeta = const VerificationMeta(
    'revision',
  );
  @override
  late final GeneratedColumn<int> revision = GeneratedColumn<int>(
    'revision',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _payloadMeta = const VerificationMeta(
    'payload',
  );
  @override
  late final GeneratedColumn<String> payload = GeneratedColumn<String>(
    'payload',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [worldId, revision, payload];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'roleplay_saves';
  @override
  VerificationContext validateIntegrity(
    Insertable<RoleplaySave> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('world_id')) {
      context.handle(
        _worldIdMeta,
        worldId.isAcceptableOrUnknown(data['world_id']!, _worldIdMeta),
      );
    } else if (isInserting) {
      context.missing(_worldIdMeta);
    }
    if (data.containsKey('revision')) {
      context.handle(
        _revisionMeta,
        revision.isAcceptableOrUnknown(data['revision']!, _revisionMeta),
      );
    } else if (isInserting) {
      context.missing(_revisionMeta);
    }
    if (data.containsKey('payload')) {
      context.handle(
        _payloadMeta,
        payload.isAcceptableOrUnknown(data['payload']!, _payloadMeta),
      );
    } else if (isInserting) {
      context.missing(_payloadMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {worldId};
  @override
  RoleplaySave map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RoleplaySave(
      worldId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}world_id'],
      )!,
      revision: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}revision'],
      )!,
      payload: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload'],
      )!,
    );
  }

  @override
  $RoleplaySavesTable createAlias(String alias) {
    return $RoleplaySavesTable(attachedDatabase, alias);
  }
}

class RoleplaySave extends DataClass implements Insertable<RoleplaySave> {
  final String worldId;
  final int revision;
  final String payload;
  const RoleplaySave({
    required this.worldId,
    required this.revision,
    required this.payload,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['world_id'] = Variable<String>(worldId);
    map['revision'] = Variable<int>(revision);
    map['payload'] = Variable<String>(payload);
    return map;
  }

  RoleplaySavesCompanion toCompanion(bool nullToAbsent) {
    return RoleplaySavesCompanion(
      worldId: Value(worldId),
      revision: Value(revision),
      payload: Value(payload),
    );
  }

  factory RoleplaySave.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RoleplaySave(
      worldId: serializer.fromJson<String>(json['worldId']),
      revision: serializer.fromJson<int>(json['revision']),
      payload: serializer.fromJson<String>(json['payload']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'worldId': serializer.toJson<String>(worldId),
      'revision': serializer.toJson<int>(revision),
      'payload': serializer.toJson<String>(payload),
    };
  }

  RoleplaySave copyWith({String? worldId, int? revision, String? payload}) =>
      RoleplaySave(
        worldId: worldId ?? this.worldId,
        revision: revision ?? this.revision,
        payload: payload ?? this.payload,
      );
  RoleplaySave copyWithCompanion(RoleplaySavesCompanion data) {
    return RoleplaySave(
      worldId: data.worldId.present ? data.worldId.value : this.worldId,
      revision: data.revision.present ? data.revision.value : this.revision,
      payload: data.payload.present ? data.payload.value : this.payload,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RoleplaySave(')
          ..write('worldId: $worldId, ')
          ..write('revision: $revision, ')
          ..write('payload: $payload')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(worldId, revision, payload);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RoleplaySave &&
          other.worldId == this.worldId &&
          other.revision == this.revision &&
          other.payload == this.payload);
}

class RoleplaySavesCompanion extends UpdateCompanion<RoleplaySave> {
  final Value<String> worldId;
  final Value<int> revision;
  final Value<String> payload;
  final Value<int> rowid;
  const RoleplaySavesCompanion({
    this.worldId = const Value.absent(),
    this.revision = const Value.absent(),
    this.payload = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RoleplaySavesCompanion.insert({
    required String worldId,
    required int revision,
    required String payload,
    this.rowid = const Value.absent(),
  }) : worldId = Value(worldId),
       revision = Value(revision),
       payload = Value(payload);
  static Insertable<RoleplaySave> custom({
    Expression<String>? worldId,
    Expression<int>? revision,
    Expression<String>? payload,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (worldId != null) 'world_id': worldId,
      if (revision != null) 'revision': revision,
      if (payload != null) 'payload': payload,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RoleplaySavesCompanion copyWith({
    Value<String>? worldId,
    Value<int>? revision,
    Value<String>? payload,
    Value<int>? rowid,
  }) {
    return RoleplaySavesCompanion(
      worldId: worldId ?? this.worldId,
      revision: revision ?? this.revision,
      payload: payload ?? this.payload,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (worldId.present) {
      map['world_id'] = Variable<String>(worldId.value);
    }
    if (revision.present) {
      map['revision'] = Variable<int>(revision.value);
    }
    if (payload.present) {
      map['payload'] = Variable<String>(payload.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RoleplaySavesCompanion(')
          ..write('worldId: $worldId, ')
          ..write('revision: $revision, ')
          ..write('payload: $payload, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RoleplayTurnsTable extends RoleplayTurns
    with TableInfo<$RoleplayTurnsTable, RoleplayTurn> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RoleplayTurnsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _worldIdMeta = const VerificationMeta(
    'worldId',
  );
  @override
  late final GeneratedColumn<String> worldId = GeneratedColumn<String>(
    'world_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES worlds (id)',
    ),
  );
  static const VerificationMeta _baseRevisionMeta = const VerificationMeta(
    'baseRevision',
  );
  @override
  late final GeneratedColumn<int> baseRevision = GeneratedColumn<int>(
    'base_revision',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _actionMeta = const VerificationMeta('action');
  @override
  late final GeneratedColumn<String> action = GeneratedColumn<String>(
    'action',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _speakerMeta = const VerificationMeta(
    'speaker',
  );
  @override
  late final GeneratedColumn<String> speaker = GeneratedColumn<String>(
    'speaker',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _contextJsonMeta = const VerificationMeta(
    'contextJson',
  );
  @override
  late final GeneratedColumn<String> contextJson = GeneratedColumn<String>(
    'context_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _stateMeta = const VerificationMeta('state');
  @override
  late final GeneratedColumn<String> state = GeneratedColumn<String>(
    'state',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _responseJsonMeta = const VerificationMeta(
    'responseJson',
  );
  @override
  late final GeneratedColumn<String> responseJson = GeneratedColumn<String>(
    'response_json',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _mockMeta = const VerificationMeta('mock');
  @override
  late final GeneratedColumn<bool> mock = GeneratedColumn<bool>(
    'mock',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("mock" IN (0, 1))',
    ),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    worldId,
    baseRevision,
    action,
    speaker,
    contextJson,
    state,
    responseJson,
    mock,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'roleplay_turns';
  @override
  VerificationContext validateIntegrity(
    Insertable<RoleplayTurn> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('world_id')) {
      context.handle(
        _worldIdMeta,
        worldId.isAcceptableOrUnknown(data['world_id']!, _worldIdMeta),
      );
    } else if (isInserting) {
      context.missing(_worldIdMeta);
    }
    if (data.containsKey('base_revision')) {
      context.handle(
        _baseRevisionMeta,
        baseRevision.isAcceptableOrUnknown(
          data['base_revision']!,
          _baseRevisionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_baseRevisionMeta);
    }
    if (data.containsKey('action')) {
      context.handle(
        _actionMeta,
        action.isAcceptableOrUnknown(data['action']!, _actionMeta),
      );
    } else if (isInserting) {
      context.missing(_actionMeta);
    }
    if (data.containsKey('speaker')) {
      context.handle(
        _speakerMeta,
        speaker.isAcceptableOrUnknown(data['speaker']!, _speakerMeta),
      );
    } else if (isInserting) {
      context.missing(_speakerMeta);
    }
    if (data.containsKey('context_json')) {
      context.handle(
        _contextJsonMeta,
        contextJson.isAcceptableOrUnknown(
          data['context_json']!,
          _contextJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_contextJsonMeta);
    }
    if (data.containsKey('state')) {
      context.handle(
        _stateMeta,
        state.isAcceptableOrUnknown(data['state']!, _stateMeta),
      );
    } else if (isInserting) {
      context.missing(_stateMeta);
    }
    if (data.containsKey('response_json')) {
      context.handle(
        _responseJsonMeta,
        responseJson.isAcceptableOrUnknown(
          data['response_json']!,
          _responseJsonMeta,
        ),
      );
    }
    if (data.containsKey('mock')) {
      context.handle(
        _mockMeta,
        mock.isAcceptableOrUnknown(data['mock']!, _mockMeta),
      );
    } else if (isInserting) {
      context.missing(_mockMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RoleplayTurn map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RoleplayTurn(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      worldId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}world_id'],
      )!,
      baseRevision: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}base_revision'],
      )!,
      action: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}action'],
      )!,
      speaker: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}speaker'],
      )!,
      contextJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}context_json'],
      )!,
      state: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}state'],
      )!,
      responseJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}response_json'],
      ),
      mock: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}mock'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $RoleplayTurnsTable createAlias(String alias) {
    return $RoleplayTurnsTable(attachedDatabase, alias);
  }
}

class RoleplayTurn extends DataClass implements Insertable<RoleplayTurn> {
  final String id;
  final String worldId;
  final int baseRevision;
  final String action;
  final String speaker;
  final String contextJson;
  final String state;
  final String? responseJson;
  final bool mock;
  final DateTime createdAt;
  const RoleplayTurn({
    required this.id,
    required this.worldId,
    required this.baseRevision,
    required this.action,
    required this.speaker,
    required this.contextJson,
    required this.state,
    this.responseJson,
    required this.mock,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['world_id'] = Variable<String>(worldId);
    map['base_revision'] = Variable<int>(baseRevision);
    map['action'] = Variable<String>(action);
    map['speaker'] = Variable<String>(speaker);
    map['context_json'] = Variable<String>(contextJson);
    map['state'] = Variable<String>(state);
    if (!nullToAbsent || responseJson != null) {
      map['response_json'] = Variable<String>(responseJson);
    }
    map['mock'] = Variable<bool>(mock);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  RoleplayTurnsCompanion toCompanion(bool nullToAbsent) {
    return RoleplayTurnsCompanion(
      id: Value(id),
      worldId: Value(worldId),
      baseRevision: Value(baseRevision),
      action: Value(action),
      speaker: Value(speaker),
      contextJson: Value(contextJson),
      state: Value(state),
      responseJson: responseJson == null && nullToAbsent
          ? const Value.absent()
          : Value(responseJson),
      mock: Value(mock),
      createdAt: Value(createdAt),
    );
  }

  factory RoleplayTurn.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RoleplayTurn(
      id: serializer.fromJson<String>(json['id']),
      worldId: serializer.fromJson<String>(json['worldId']),
      baseRevision: serializer.fromJson<int>(json['baseRevision']),
      action: serializer.fromJson<String>(json['action']),
      speaker: serializer.fromJson<String>(json['speaker']),
      contextJson: serializer.fromJson<String>(json['contextJson']),
      state: serializer.fromJson<String>(json['state']),
      responseJson: serializer.fromJson<String?>(json['responseJson']),
      mock: serializer.fromJson<bool>(json['mock']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'worldId': serializer.toJson<String>(worldId),
      'baseRevision': serializer.toJson<int>(baseRevision),
      'action': serializer.toJson<String>(action),
      'speaker': serializer.toJson<String>(speaker),
      'contextJson': serializer.toJson<String>(contextJson),
      'state': serializer.toJson<String>(state),
      'responseJson': serializer.toJson<String?>(responseJson),
      'mock': serializer.toJson<bool>(mock),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  RoleplayTurn copyWith({
    String? id,
    String? worldId,
    int? baseRevision,
    String? action,
    String? speaker,
    String? contextJson,
    String? state,
    Value<String?> responseJson = const Value.absent(),
    bool? mock,
    DateTime? createdAt,
  }) => RoleplayTurn(
    id: id ?? this.id,
    worldId: worldId ?? this.worldId,
    baseRevision: baseRevision ?? this.baseRevision,
    action: action ?? this.action,
    speaker: speaker ?? this.speaker,
    contextJson: contextJson ?? this.contextJson,
    state: state ?? this.state,
    responseJson: responseJson.present ? responseJson.value : this.responseJson,
    mock: mock ?? this.mock,
    createdAt: createdAt ?? this.createdAt,
  );
  RoleplayTurn copyWithCompanion(RoleplayTurnsCompanion data) {
    return RoleplayTurn(
      id: data.id.present ? data.id.value : this.id,
      worldId: data.worldId.present ? data.worldId.value : this.worldId,
      baseRevision: data.baseRevision.present
          ? data.baseRevision.value
          : this.baseRevision,
      action: data.action.present ? data.action.value : this.action,
      speaker: data.speaker.present ? data.speaker.value : this.speaker,
      contextJson: data.contextJson.present
          ? data.contextJson.value
          : this.contextJson,
      state: data.state.present ? data.state.value : this.state,
      responseJson: data.responseJson.present
          ? data.responseJson.value
          : this.responseJson,
      mock: data.mock.present ? data.mock.value : this.mock,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RoleplayTurn(')
          ..write('id: $id, ')
          ..write('worldId: $worldId, ')
          ..write('baseRevision: $baseRevision, ')
          ..write('action: $action, ')
          ..write('speaker: $speaker, ')
          ..write('contextJson: $contextJson, ')
          ..write('state: $state, ')
          ..write('responseJson: $responseJson, ')
          ..write('mock: $mock, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    worldId,
    baseRevision,
    action,
    speaker,
    contextJson,
    state,
    responseJson,
    mock,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RoleplayTurn &&
          other.id == this.id &&
          other.worldId == this.worldId &&
          other.baseRevision == this.baseRevision &&
          other.action == this.action &&
          other.speaker == this.speaker &&
          other.contextJson == this.contextJson &&
          other.state == this.state &&
          other.responseJson == this.responseJson &&
          other.mock == this.mock &&
          other.createdAt == this.createdAt);
}

class RoleplayTurnsCompanion extends UpdateCompanion<RoleplayTurn> {
  final Value<String> id;
  final Value<String> worldId;
  final Value<int> baseRevision;
  final Value<String> action;
  final Value<String> speaker;
  final Value<String> contextJson;
  final Value<String> state;
  final Value<String?> responseJson;
  final Value<bool> mock;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const RoleplayTurnsCompanion({
    this.id = const Value.absent(),
    this.worldId = const Value.absent(),
    this.baseRevision = const Value.absent(),
    this.action = const Value.absent(),
    this.speaker = const Value.absent(),
    this.contextJson = const Value.absent(),
    this.state = const Value.absent(),
    this.responseJson = const Value.absent(),
    this.mock = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RoleplayTurnsCompanion.insert({
    required String id,
    required String worldId,
    required int baseRevision,
    required String action,
    required String speaker,
    required String contextJson,
    required String state,
    this.responseJson = const Value.absent(),
    required bool mock,
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       worldId = Value(worldId),
       baseRevision = Value(baseRevision),
       action = Value(action),
       speaker = Value(speaker),
       contextJson = Value(contextJson),
       state = Value(state),
       mock = Value(mock),
       createdAt = Value(createdAt);
  static Insertable<RoleplayTurn> custom({
    Expression<String>? id,
    Expression<String>? worldId,
    Expression<int>? baseRevision,
    Expression<String>? action,
    Expression<String>? speaker,
    Expression<String>? contextJson,
    Expression<String>? state,
    Expression<String>? responseJson,
    Expression<bool>? mock,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (worldId != null) 'world_id': worldId,
      if (baseRevision != null) 'base_revision': baseRevision,
      if (action != null) 'action': action,
      if (speaker != null) 'speaker': speaker,
      if (contextJson != null) 'context_json': contextJson,
      if (state != null) 'state': state,
      if (responseJson != null) 'response_json': responseJson,
      if (mock != null) 'mock': mock,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RoleplayTurnsCompanion copyWith({
    Value<String>? id,
    Value<String>? worldId,
    Value<int>? baseRevision,
    Value<String>? action,
    Value<String>? speaker,
    Value<String>? contextJson,
    Value<String>? state,
    Value<String?>? responseJson,
    Value<bool>? mock,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return RoleplayTurnsCompanion(
      id: id ?? this.id,
      worldId: worldId ?? this.worldId,
      baseRevision: baseRevision ?? this.baseRevision,
      action: action ?? this.action,
      speaker: speaker ?? this.speaker,
      contextJson: contextJson ?? this.contextJson,
      state: state ?? this.state,
      responseJson: responseJson ?? this.responseJson,
      mock: mock ?? this.mock,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (worldId.present) {
      map['world_id'] = Variable<String>(worldId.value);
    }
    if (baseRevision.present) {
      map['base_revision'] = Variable<int>(baseRevision.value);
    }
    if (action.present) {
      map['action'] = Variable<String>(action.value);
    }
    if (speaker.present) {
      map['speaker'] = Variable<String>(speaker.value);
    }
    if (contextJson.present) {
      map['context_json'] = Variable<String>(contextJson.value);
    }
    if (state.present) {
      map['state'] = Variable<String>(state.value);
    }
    if (responseJson.present) {
      map['response_json'] = Variable<String>(responseJson.value);
    }
    if (mock.present) {
      map['mock'] = Variable<bool>(mock.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RoleplayTurnsCompanion(')
          ..write('id: $id, ')
          ..write('worldId: $worldId, ')
          ..write('baseRevision: $baseRevision, ')
          ..write('action: $action, ')
          ..write('speaker: $speaker, ')
          ..write('contextJson: $contextJson, ')
          ..write('state: $state, ')
          ..write('responseJson: $responseJson, ')
          ..write('mock: $mock, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RoleplayMemoriesTable extends RoleplayMemories
    with TableInfo<$RoleplayMemoriesTable, RoleplayMemory> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RoleplayMemoriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _worldIdMeta = const VerificationMeta(
    'worldId',
  );
  @override
  late final GeneratedColumn<String> worldId = GeneratedColumn<String>(
    'world_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES worlds (id)',
    ),
  );
  static const VerificationMeta _ownerMeta = const VerificationMeta('owner');
  @override
  late final GeneratedColumn<String> owner = GeneratedColumn<String>(
    'owner',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _payloadMeta = const VerificationMeta(
    'payload',
  );
  @override
  late final GeneratedColumn<String> payload = GeneratedColumn<String>(
    'payload',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, worldId, owner, payload];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'roleplay_memories';
  @override
  VerificationContext validateIntegrity(
    Insertable<RoleplayMemory> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('world_id')) {
      context.handle(
        _worldIdMeta,
        worldId.isAcceptableOrUnknown(data['world_id']!, _worldIdMeta),
      );
    } else if (isInserting) {
      context.missing(_worldIdMeta);
    }
    if (data.containsKey('owner')) {
      context.handle(
        _ownerMeta,
        owner.isAcceptableOrUnknown(data['owner']!, _ownerMeta),
      );
    } else if (isInserting) {
      context.missing(_ownerMeta);
    }
    if (data.containsKey('payload')) {
      context.handle(
        _payloadMeta,
        payload.isAcceptableOrUnknown(data['payload']!, _payloadMeta),
      );
    } else if (isInserting) {
      context.missing(_payloadMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RoleplayMemory map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RoleplayMemory(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      worldId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}world_id'],
      )!,
      owner: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}owner'],
      )!,
      payload: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload'],
      )!,
    );
  }

  @override
  $RoleplayMemoriesTable createAlias(String alias) {
    return $RoleplayMemoriesTable(attachedDatabase, alias);
  }
}

class RoleplayMemory extends DataClass implements Insertable<RoleplayMemory> {
  final String id;
  final String worldId;
  final String owner;
  final String payload;
  const RoleplayMemory({
    required this.id,
    required this.worldId,
    required this.owner,
    required this.payload,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['world_id'] = Variable<String>(worldId);
    map['owner'] = Variable<String>(owner);
    map['payload'] = Variable<String>(payload);
    return map;
  }

  RoleplayMemoriesCompanion toCompanion(bool nullToAbsent) {
    return RoleplayMemoriesCompanion(
      id: Value(id),
      worldId: Value(worldId),
      owner: Value(owner),
      payload: Value(payload),
    );
  }

  factory RoleplayMemory.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RoleplayMemory(
      id: serializer.fromJson<String>(json['id']),
      worldId: serializer.fromJson<String>(json['worldId']),
      owner: serializer.fromJson<String>(json['owner']),
      payload: serializer.fromJson<String>(json['payload']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'worldId': serializer.toJson<String>(worldId),
      'owner': serializer.toJson<String>(owner),
      'payload': serializer.toJson<String>(payload),
    };
  }

  RoleplayMemory copyWith({
    String? id,
    String? worldId,
    String? owner,
    String? payload,
  }) => RoleplayMemory(
    id: id ?? this.id,
    worldId: worldId ?? this.worldId,
    owner: owner ?? this.owner,
    payload: payload ?? this.payload,
  );
  RoleplayMemory copyWithCompanion(RoleplayMemoriesCompanion data) {
    return RoleplayMemory(
      id: data.id.present ? data.id.value : this.id,
      worldId: data.worldId.present ? data.worldId.value : this.worldId,
      owner: data.owner.present ? data.owner.value : this.owner,
      payload: data.payload.present ? data.payload.value : this.payload,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RoleplayMemory(')
          ..write('id: $id, ')
          ..write('worldId: $worldId, ')
          ..write('owner: $owner, ')
          ..write('payload: $payload')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, worldId, owner, payload);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RoleplayMemory &&
          other.id == this.id &&
          other.worldId == this.worldId &&
          other.owner == this.owner &&
          other.payload == this.payload);
}

class RoleplayMemoriesCompanion extends UpdateCompanion<RoleplayMemory> {
  final Value<String> id;
  final Value<String> worldId;
  final Value<String> owner;
  final Value<String> payload;
  final Value<int> rowid;
  const RoleplayMemoriesCompanion({
    this.id = const Value.absent(),
    this.worldId = const Value.absent(),
    this.owner = const Value.absent(),
    this.payload = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RoleplayMemoriesCompanion.insert({
    required String id,
    required String worldId,
    required String owner,
    required String payload,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       worldId = Value(worldId),
       owner = Value(owner),
       payload = Value(payload);
  static Insertable<RoleplayMemory> custom({
    Expression<String>? id,
    Expression<String>? worldId,
    Expression<String>? owner,
    Expression<String>? payload,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (worldId != null) 'world_id': worldId,
      if (owner != null) 'owner': owner,
      if (payload != null) 'payload': payload,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RoleplayMemoriesCompanion copyWith({
    Value<String>? id,
    Value<String>? worldId,
    Value<String>? owner,
    Value<String>? payload,
    Value<int>? rowid,
  }) {
    return RoleplayMemoriesCompanion(
      id: id ?? this.id,
      worldId: worldId ?? this.worldId,
      owner: owner ?? this.owner,
      payload: payload ?? this.payload,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (worldId.present) {
      map['world_id'] = Variable<String>(worldId.value);
    }
    if (owner.present) {
      map['owner'] = Variable<String>(owner.value);
    }
    if (payload.present) {
      map['payload'] = Variable<String>(payload.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RoleplayMemoriesCompanion(')
          ..write('id: $id, ')
          ..write('worldId: $worldId, ')
          ..write('owner: $owner, ')
          ..write('payload: $payload, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $StoryCheckpointsTable extends StoryCheckpoints
    with TableInfo<$StoryCheckpointsTable, StoryCheckpointRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StoryCheckpointsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _worldIdMeta = const VerificationMeta(
    'worldId',
  );
  @override
  late final GeneratedColumn<String> worldId = GeneratedColumn<String>(
    'world_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES worlds (id)',
    ),
  );
  static const VerificationMeta _revisionMeta = const VerificationMeta(
    'revision',
  );
  @override
  late final GeneratedColumn<int> revision = GeneratedColumn<int>(
    'revision',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _payloadMeta = const VerificationMeta(
    'payload',
  );
  @override
  late final GeneratedColumn<String> payload = GeneratedColumn<String>(
    'payload',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceConversationMeta =
      const VerificationMeta('sourceConversation');
  @override
  late final GeneratedColumn<String> sourceConversation =
      GeneratedColumn<String>(
        'source_conversation',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _sourceMessageIdMeta = const VerificationMeta(
    'sourceMessageId',
  );
  @override
  late final GeneratedColumn<String> sourceMessageId = GeneratedColumn<String>(
    'source_message_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    worldId,
    revision,
    payload,
    sourceConversation,
    sourceMessageId,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'story_checkpoints';
  @override
  VerificationContext validateIntegrity(
    Insertable<StoryCheckpointRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('world_id')) {
      context.handle(
        _worldIdMeta,
        worldId.isAcceptableOrUnknown(data['world_id']!, _worldIdMeta),
      );
    } else if (isInserting) {
      context.missing(_worldIdMeta);
    }
    if (data.containsKey('revision')) {
      context.handle(
        _revisionMeta,
        revision.isAcceptableOrUnknown(data['revision']!, _revisionMeta),
      );
    } else if (isInserting) {
      context.missing(_revisionMeta);
    }
    if (data.containsKey('payload')) {
      context.handle(
        _payloadMeta,
        payload.isAcceptableOrUnknown(data['payload']!, _payloadMeta),
      );
    } else if (isInserting) {
      context.missing(_payloadMeta);
    }
    if (data.containsKey('source_conversation')) {
      context.handle(
        _sourceConversationMeta,
        sourceConversation.isAcceptableOrUnknown(
          data['source_conversation']!,
          _sourceConversationMeta,
        ),
      );
    }
    if (data.containsKey('source_message_id')) {
      context.handle(
        _sourceMessageIdMeta,
        sourceMessageId.isAcceptableOrUnknown(
          data['source_message_id']!,
          _sourceMessageIdMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  StoryCheckpointRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StoryCheckpointRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      worldId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}world_id'],
      )!,
      revision: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}revision'],
      )!,
      payload: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload'],
      )!,
      sourceConversation: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_conversation'],
      ),
      sourceMessageId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_message_id'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $StoryCheckpointsTable createAlias(String alias) {
    return $StoryCheckpointsTable(attachedDatabase, alias);
  }
}

class StoryCheckpointRow extends DataClass
    implements Insertable<StoryCheckpointRow> {
  final String id;
  final String worldId;
  final int revision;
  final String payload;
  final String? sourceConversation;
  final String? sourceMessageId;
  final DateTime createdAt;
  const StoryCheckpointRow({
    required this.id,
    required this.worldId,
    required this.revision,
    required this.payload,
    this.sourceConversation,
    this.sourceMessageId,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['world_id'] = Variable<String>(worldId);
    map['revision'] = Variable<int>(revision);
    map['payload'] = Variable<String>(payload);
    if (!nullToAbsent || sourceConversation != null) {
      map['source_conversation'] = Variable<String>(sourceConversation);
    }
    if (!nullToAbsent || sourceMessageId != null) {
      map['source_message_id'] = Variable<String>(sourceMessageId);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  StoryCheckpointsCompanion toCompanion(bool nullToAbsent) {
    return StoryCheckpointsCompanion(
      id: Value(id),
      worldId: Value(worldId),
      revision: Value(revision),
      payload: Value(payload),
      sourceConversation: sourceConversation == null && nullToAbsent
          ? const Value.absent()
          : Value(sourceConversation),
      sourceMessageId: sourceMessageId == null && nullToAbsent
          ? const Value.absent()
          : Value(sourceMessageId),
      createdAt: Value(createdAt),
    );
  }

  factory StoryCheckpointRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StoryCheckpointRow(
      id: serializer.fromJson<String>(json['id']),
      worldId: serializer.fromJson<String>(json['worldId']),
      revision: serializer.fromJson<int>(json['revision']),
      payload: serializer.fromJson<String>(json['payload']),
      sourceConversation: serializer.fromJson<String?>(
        json['sourceConversation'],
      ),
      sourceMessageId: serializer.fromJson<String?>(json['sourceMessageId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'worldId': serializer.toJson<String>(worldId),
      'revision': serializer.toJson<int>(revision),
      'payload': serializer.toJson<String>(payload),
      'sourceConversation': serializer.toJson<String?>(sourceConversation),
      'sourceMessageId': serializer.toJson<String?>(sourceMessageId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  StoryCheckpointRow copyWith({
    String? id,
    String? worldId,
    int? revision,
    String? payload,
    Value<String?> sourceConversation = const Value.absent(),
    Value<String?> sourceMessageId = const Value.absent(),
    DateTime? createdAt,
  }) => StoryCheckpointRow(
    id: id ?? this.id,
    worldId: worldId ?? this.worldId,
    revision: revision ?? this.revision,
    payload: payload ?? this.payload,
    sourceConversation: sourceConversation.present
        ? sourceConversation.value
        : this.sourceConversation,
    sourceMessageId: sourceMessageId.present
        ? sourceMessageId.value
        : this.sourceMessageId,
    createdAt: createdAt ?? this.createdAt,
  );
  StoryCheckpointRow copyWithCompanion(StoryCheckpointsCompanion data) {
    return StoryCheckpointRow(
      id: data.id.present ? data.id.value : this.id,
      worldId: data.worldId.present ? data.worldId.value : this.worldId,
      revision: data.revision.present ? data.revision.value : this.revision,
      payload: data.payload.present ? data.payload.value : this.payload,
      sourceConversation: data.sourceConversation.present
          ? data.sourceConversation.value
          : this.sourceConversation,
      sourceMessageId: data.sourceMessageId.present
          ? data.sourceMessageId.value
          : this.sourceMessageId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StoryCheckpointRow(')
          ..write('id: $id, ')
          ..write('worldId: $worldId, ')
          ..write('revision: $revision, ')
          ..write('payload: $payload, ')
          ..write('sourceConversation: $sourceConversation, ')
          ..write('sourceMessageId: $sourceMessageId, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    worldId,
    revision,
    payload,
    sourceConversation,
    sourceMessageId,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StoryCheckpointRow &&
          other.id == this.id &&
          other.worldId == this.worldId &&
          other.revision == this.revision &&
          other.payload == this.payload &&
          other.sourceConversation == this.sourceConversation &&
          other.sourceMessageId == this.sourceMessageId &&
          other.createdAt == this.createdAt);
}

class StoryCheckpointsCompanion extends UpdateCompanion<StoryCheckpointRow> {
  final Value<String> id;
  final Value<String> worldId;
  final Value<int> revision;
  final Value<String> payload;
  final Value<String?> sourceConversation;
  final Value<String?> sourceMessageId;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const StoryCheckpointsCompanion({
    this.id = const Value.absent(),
    this.worldId = const Value.absent(),
    this.revision = const Value.absent(),
    this.payload = const Value.absent(),
    this.sourceConversation = const Value.absent(),
    this.sourceMessageId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  StoryCheckpointsCompanion.insert({
    required String id,
    required String worldId,
    required int revision,
    required String payload,
    this.sourceConversation = const Value.absent(),
    this.sourceMessageId = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       worldId = Value(worldId),
       revision = Value(revision),
       payload = Value(payload),
       createdAt = Value(createdAt);
  static Insertable<StoryCheckpointRow> custom({
    Expression<String>? id,
    Expression<String>? worldId,
    Expression<int>? revision,
    Expression<String>? payload,
    Expression<String>? sourceConversation,
    Expression<String>? sourceMessageId,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (worldId != null) 'world_id': worldId,
      if (revision != null) 'revision': revision,
      if (payload != null) 'payload': payload,
      if (sourceConversation != null) 'source_conversation': sourceConversation,
      if (sourceMessageId != null) 'source_message_id': sourceMessageId,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  StoryCheckpointsCompanion copyWith({
    Value<String>? id,
    Value<String>? worldId,
    Value<int>? revision,
    Value<String>? payload,
    Value<String?>? sourceConversation,
    Value<String?>? sourceMessageId,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return StoryCheckpointsCompanion(
      id: id ?? this.id,
      worldId: worldId ?? this.worldId,
      revision: revision ?? this.revision,
      payload: payload ?? this.payload,
      sourceConversation: sourceConversation ?? this.sourceConversation,
      sourceMessageId: sourceMessageId ?? this.sourceMessageId,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (worldId.present) {
      map['world_id'] = Variable<String>(worldId.value);
    }
    if (revision.present) {
      map['revision'] = Variable<int>(revision.value);
    }
    if (payload.present) {
      map['payload'] = Variable<String>(payload.value);
    }
    if (sourceConversation.present) {
      map['source_conversation'] = Variable<String>(sourceConversation.value);
    }
    if (sourceMessageId.present) {
      map['source_message_id'] = Variable<String>(sourceMessageId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StoryCheckpointsCompanion(')
          ..write('id: $id, ')
          ..write('worldId: $worldId, ')
          ..write('revision: $revision, ')
          ..write('payload: $payload, ')
          ..write('sourceConversation: $sourceConversation, ')
          ..write('sourceMessageId: $sourceMessageId, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $StoryBranchesTable extends StoryBranches
    with TableInfo<$StoryBranchesTable, StoryBranche> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StoryBranchesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _worldIdMeta = const VerificationMeta(
    'worldId',
  );
  @override
  late final GeneratedColumn<String> worldId = GeneratedColumn<String>(
    'world_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES worlds (id)',
    ),
  );
  static const VerificationMeta _parentWorldIdMeta = const VerificationMeta(
    'parentWorldId',
  );
  @override
  late final GeneratedColumn<String> parentWorldId = GeneratedColumn<String>(
    'parent_world_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _checkpointIdMeta = const VerificationMeta(
    'checkpointId',
  );
  @override
  late final GeneratedColumn<String> checkpointId = GeneratedColumn<String>(
    'checkpoint_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sourceConversationMeta =
      const VerificationMeta('sourceConversation');
  @override
  late final GeneratedColumn<String> sourceConversation =
      GeneratedColumn<String>(
        'source_conversation',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _sourceMessageIdMeta = const VerificationMeta(
    'sourceMessageId',
  );
  @override
  late final GeneratedColumn<String> sourceMessageId = GeneratedColumn<String>(
    'source_message_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    worldId,
    parentWorldId,
    checkpointId,
    sourceConversation,
    sourceMessageId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'story_branches';
  @override
  VerificationContext validateIntegrity(
    Insertable<StoryBranche> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('world_id')) {
      context.handle(
        _worldIdMeta,
        worldId.isAcceptableOrUnknown(data['world_id']!, _worldIdMeta),
      );
    } else if (isInserting) {
      context.missing(_worldIdMeta);
    }
    if (data.containsKey('parent_world_id')) {
      context.handle(
        _parentWorldIdMeta,
        parentWorldId.isAcceptableOrUnknown(
          data['parent_world_id']!,
          _parentWorldIdMeta,
        ),
      );
    }
    if (data.containsKey('checkpoint_id')) {
      context.handle(
        _checkpointIdMeta,
        checkpointId.isAcceptableOrUnknown(
          data['checkpoint_id']!,
          _checkpointIdMeta,
        ),
      );
    }
    if (data.containsKey('source_conversation')) {
      context.handle(
        _sourceConversationMeta,
        sourceConversation.isAcceptableOrUnknown(
          data['source_conversation']!,
          _sourceConversationMeta,
        ),
      );
    }
    if (data.containsKey('source_message_id')) {
      context.handle(
        _sourceMessageIdMeta,
        sourceMessageId.isAcceptableOrUnknown(
          data['source_message_id']!,
          _sourceMessageIdMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {worldId};
  @override
  StoryBranche map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StoryBranche(
      worldId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}world_id'],
      )!,
      parentWorldId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}parent_world_id'],
      ),
      checkpointId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}checkpoint_id'],
      ),
      sourceConversation: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_conversation'],
      ),
      sourceMessageId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_message_id'],
      ),
    );
  }

  @override
  $StoryBranchesTable createAlias(String alias) {
    return $StoryBranchesTable(attachedDatabase, alias);
  }
}

class StoryBranche extends DataClass implements Insertable<StoryBranche> {
  final String worldId;
  final String? parentWorldId;
  final String? checkpointId;
  final String? sourceConversation;
  final String? sourceMessageId;
  const StoryBranche({
    required this.worldId,
    this.parentWorldId,
    this.checkpointId,
    this.sourceConversation,
    this.sourceMessageId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['world_id'] = Variable<String>(worldId);
    if (!nullToAbsent || parentWorldId != null) {
      map['parent_world_id'] = Variable<String>(parentWorldId);
    }
    if (!nullToAbsent || checkpointId != null) {
      map['checkpoint_id'] = Variable<String>(checkpointId);
    }
    if (!nullToAbsent || sourceConversation != null) {
      map['source_conversation'] = Variable<String>(sourceConversation);
    }
    if (!nullToAbsent || sourceMessageId != null) {
      map['source_message_id'] = Variable<String>(sourceMessageId);
    }
    return map;
  }

  StoryBranchesCompanion toCompanion(bool nullToAbsent) {
    return StoryBranchesCompanion(
      worldId: Value(worldId),
      parentWorldId: parentWorldId == null && nullToAbsent
          ? const Value.absent()
          : Value(parentWorldId),
      checkpointId: checkpointId == null && nullToAbsent
          ? const Value.absent()
          : Value(checkpointId),
      sourceConversation: sourceConversation == null && nullToAbsent
          ? const Value.absent()
          : Value(sourceConversation),
      sourceMessageId: sourceMessageId == null && nullToAbsent
          ? const Value.absent()
          : Value(sourceMessageId),
    );
  }

  factory StoryBranche.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StoryBranche(
      worldId: serializer.fromJson<String>(json['worldId']),
      parentWorldId: serializer.fromJson<String?>(json['parentWorldId']),
      checkpointId: serializer.fromJson<String?>(json['checkpointId']),
      sourceConversation: serializer.fromJson<String?>(
        json['sourceConversation'],
      ),
      sourceMessageId: serializer.fromJson<String?>(json['sourceMessageId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'worldId': serializer.toJson<String>(worldId),
      'parentWorldId': serializer.toJson<String?>(parentWorldId),
      'checkpointId': serializer.toJson<String?>(checkpointId),
      'sourceConversation': serializer.toJson<String?>(sourceConversation),
      'sourceMessageId': serializer.toJson<String?>(sourceMessageId),
    };
  }

  StoryBranche copyWith({
    String? worldId,
    Value<String?> parentWorldId = const Value.absent(),
    Value<String?> checkpointId = const Value.absent(),
    Value<String?> sourceConversation = const Value.absent(),
    Value<String?> sourceMessageId = const Value.absent(),
  }) => StoryBranche(
    worldId: worldId ?? this.worldId,
    parentWorldId: parentWorldId.present
        ? parentWorldId.value
        : this.parentWorldId,
    checkpointId: checkpointId.present ? checkpointId.value : this.checkpointId,
    sourceConversation: sourceConversation.present
        ? sourceConversation.value
        : this.sourceConversation,
    sourceMessageId: sourceMessageId.present
        ? sourceMessageId.value
        : this.sourceMessageId,
  );
  StoryBranche copyWithCompanion(StoryBranchesCompanion data) {
    return StoryBranche(
      worldId: data.worldId.present ? data.worldId.value : this.worldId,
      parentWorldId: data.parentWorldId.present
          ? data.parentWorldId.value
          : this.parentWorldId,
      checkpointId: data.checkpointId.present
          ? data.checkpointId.value
          : this.checkpointId,
      sourceConversation: data.sourceConversation.present
          ? data.sourceConversation.value
          : this.sourceConversation,
      sourceMessageId: data.sourceMessageId.present
          ? data.sourceMessageId.value
          : this.sourceMessageId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StoryBranche(')
          ..write('worldId: $worldId, ')
          ..write('parentWorldId: $parentWorldId, ')
          ..write('checkpointId: $checkpointId, ')
          ..write('sourceConversation: $sourceConversation, ')
          ..write('sourceMessageId: $sourceMessageId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    worldId,
    parentWorldId,
    checkpointId,
    sourceConversation,
    sourceMessageId,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StoryBranche &&
          other.worldId == this.worldId &&
          other.parentWorldId == this.parentWorldId &&
          other.checkpointId == this.checkpointId &&
          other.sourceConversation == this.sourceConversation &&
          other.sourceMessageId == this.sourceMessageId);
}

class StoryBranchesCompanion extends UpdateCompanion<StoryBranche> {
  final Value<String> worldId;
  final Value<String?> parentWorldId;
  final Value<String?> checkpointId;
  final Value<String?> sourceConversation;
  final Value<String?> sourceMessageId;
  final Value<int> rowid;
  const StoryBranchesCompanion({
    this.worldId = const Value.absent(),
    this.parentWorldId = const Value.absent(),
    this.checkpointId = const Value.absent(),
    this.sourceConversation = const Value.absent(),
    this.sourceMessageId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  StoryBranchesCompanion.insert({
    required String worldId,
    this.parentWorldId = const Value.absent(),
    this.checkpointId = const Value.absent(),
    this.sourceConversation = const Value.absent(),
    this.sourceMessageId = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : worldId = Value(worldId);
  static Insertable<StoryBranche> custom({
    Expression<String>? worldId,
    Expression<String>? parentWorldId,
    Expression<String>? checkpointId,
    Expression<String>? sourceConversation,
    Expression<String>? sourceMessageId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (worldId != null) 'world_id': worldId,
      if (parentWorldId != null) 'parent_world_id': parentWorldId,
      if (checkpointId != null) 'checkpoint_id': checkpointId,
      if (sourceConversation != null) 'source_conversation': sourceConversation,
      if (sourceMessageId != null) 'source_message_id': sourceMessageId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  StoryBranchesCompanion copyWith({
    Value<String>? worldId,
    Value<String?>? parentWorldId,
    Value<String?>? checkpointId,
    Value<String?>? sourceConversation,
    Value<String?>? sourceMessageId,
    Value<int>? rowid,
  }) {
    return StoryBranchesCompanion(
      worldId: worldId ?? this.worldId,
      parentWorldId: parentWorldId ?? this.parentWorldId,
      checkpointId: checkpointId ?? this.checkpointId,
      sourceConversation: sourceConversation ?? this.sourceConversation,
      sourceMessageId: sourceMessageId ?? this.sourceMessageId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (worldId.present) {
      map['world_id'] = Variable<String>(worldId.value);
    }
    if (parentWorldId.present) {
      map['parent_world_id'] = Variable<String>(parentWorldId.value);
    }
    if (checkpointId.present) {
      map['checkpoint_id'] = Variable<String>(checkpointId.value);
    }
    if (sourceConversation.present) {
      map['source_conversation'] = Variable<String>(sourceConversation.value);
    }
    if (sourceMessageId.present) {
      map['source_message_id'] = Variable<String>(sourceMessageId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StoryBranchesCompanion(')
          ..write('worldId: $worldId, ')
          ..write('parentWorldId: $parentWorldId, ')
          ..write('checkpointId: $checkpointId, ')
          ..write('sourceConversation: $sourceConversation, ')
          ..write('sourceMessageId: $sourceMessageId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TimelineEntriesTable extends TimelineEntries
    with TableInfo<$TimelineEntriesTable, TimelineEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TimelineEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _worldIdMeta = const VerificationMeta(
    'worldId',
  );
  @override
  late final GeneratedColumn<String> worldId = GeneratedColumn<String>(
    'world_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES worlds (id)',
    ),
  );
  static const VerificationMeta _revisionMeta = const VerificationMeta(
    'revision',
  );
  @override
  late final GeneratedColumn<int> revision = GeneratedColumn<int>(
    'revision',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _payloadMeta = const VerificationMeta(
    'payload',
  );
  @override
  late final GeneratedColumn<String> payload = GeneratedColumn<String>(
    'payload',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, worldId, revision, payload];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'timeline_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<TimelineEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('world_id')) {
      context.handle(
        _worldIdMeta,
        worldId.isAcceptableOrUnknown(data['world_id']!, _worldIdMeta),
      );
    } else if (isInserting) {
      context.missing(_worldIdMeta);
    }
    if (data.containsKey('revision')) {
      context.handle(
        _revisionMeta,
        revision.isAcceptableOrUnknown(data['revision']!, _revisionMeta),
      );
    } else if (isInserting) {
      context.missing(_revisionMeta);
    }
    if (data.containsKey('payload')) {
      context.handle(
        _payloadMeta,
        payload.isAcceptableOrUnknown(data['payload']!, _payloadMeta),
      );
    } else if (isInserting) {
      context.missing(_payloadMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TimelineEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TimelineEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      worldId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}world_id'],
      )!,
      revision: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}revision'],
      )!,
      payload: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload'],
      )!,
    );
  }

  @override
  $TimelineEntriesTable createAlias(String alias) {
    return $TimelineEntriesTable(attachedDatabase, alias);
  }
}

class TimelineEntry extends DataClass implements Insertable<TimelineEntry> {
  final String id;
  final String worldId;
  final int revision;
  final String payload;
  const TimelineEntry({
    required this.id,
    required this.worldId,
    required this.revision,
    required this.payload,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['world_id'] = Variable<String>(worldId);
    map['revision'] = Variable<int>(revision);
    map['payload'] = Variable<String>(payload);
    return map;
  }

  TimelineEntriesCompanion toCompanion(bool nullToAbsent) {
    return TimelineEntriesCompanion(
      id: Value(id),
      worldId: Value(worldId),
      revision: Value(revision),
      payload: Value(payload),
    );
  }

  factory TimelineEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TimelineEntry(
      id: serializer.fromJson<String>(json['id']),
      worldId: serializer.fromJson<String>(json['worldId']),
      revision: serializer.fromJson<int>(json['revision']),
      payload: serializer.fromJson<String>(json['payload']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'worldId': serializer.toJson<String>(worldId),
      'revision': serializer.toJson<int>(revision),
      'payload': serializer.toJson<String>(payload),
    };
  }

  TimelineEntry copyWith({
    String? id,
    String? worldId,
    int? revision,
    String? payload,
  }) => TimelineEntry(
    id: id ?? this.id,
    worldId: worldId ?? this.worldId,
    revision: revision ?? this.revision,
    payload: payload ?? this.payload,
  );
  TimelineEntry copyWithCompanion(TimelineEntriesCompanion data) {
    return TimelineEntry(
      id: data.id.present ? data.id.value : this.id,
      worldId: data.worldId.present ? data.worldId.value : this.worldId,
      revision: data.revision.present ? data.revision.value : this.revision,
      payload: data.payload.present ? data.payload.value : this.payload,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TimelineEntry(')
          ..write('id: $id, ')
          ..write('worldId: $worldId, ')
          ..write('revision: $revision, ')
          ..write('payload: $payload')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, worldId, revision, payload);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TimelineEntry &&
          other.id == this.id &&
          other.worldId == this.worldId &&
          other.revision == this.revision &&
          other.payload == this.payload);
}

class TimelineEntriesCompanion extends UpdateCompanion<TimelineEntry> {
  final Value<String> id;
  final Value<String> worldId;
  final Value<int> revision;
  final Value<String> payload;
  final Value<int> rowid;
  const TimelineEntriesCompanion({
    this.id = const Value.absent(),
    this.worldId = const Value.absent(),
    this.revision = const Value.absent(),
    this.payload = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TimelineEntriesCompanion.insert({
    required String id,
    required String worldId,
    required int revision,
    required String payload,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       worldId = Value(worldId),
       revision = Value(revision),
       payload = Value(payload);
  static Insertable<TimelineEntry> custom({
    Expression<String>? id,
    Expression<String>? worldId,
    Expression<int>? revision,
    Expression<String>? payload,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (worldId != null) 'world_id': worldId,
      if (revision != null) 'revision': revision,
      if (payload != null) 'payload': payload,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TimelineEntriesCompanion copyWith({
    Value<String>? id,
    Value<String>? worldId,
    Value<int>? revision,
    Value<String>? payload,
    Value<int>? rowid,
  }) {
    return TimelineEntriesCompanion(
      id: id ?? this.id,
      worldId: worldId ?? this.worldId,
      revision: revision ?? this.revision,
      payload: payload ?? this.payload,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (worldId.present) {
      map['world_id'] = Variable<String>(worldId.value);
    }
    if (revision.present) {
      map['revision'] = Variable<int>(revision.value);
    }
    if (payload.present) {
      map['payload'] = Variable<String>(payload.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TimelineEntriesCompanion(')
          ..write('id: $id, ')
          ..write('worldId: $worldId, ')
          ..write('revision: $revision, ')
          ..write('payload: $payload, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ContextSummariesTable extends ContextSummaries
    with TableInfo<$ContextSummariesTable, ContextSummary> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ContextSummariesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _worldIdMeta = const VerificationMeta(
    'worldId',
  );
  @override
  late final GeneratedColumn<String> worldId = GeneratedColumn<String>(
    'world_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES worlds (id)',
    ),
  );
  static const VerificationMeta _ownerMeta = const VerificationMeta('owner');
  @override
  late final GeneratedColumn<String> owner = GeneratedColumn<String>(
    'owner',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _versionMeta = const VerificationMeta(
    'version',
  );
  @override
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
    'version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _throughRevisionMeta = const VerificationMeta(
    'throughRevision',
  );
  @override
  late final GeneratedColumn<int> throughRevision = GeneratedColumn<int>(
    'through_revision',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _payloadMeta = const VerificationMeta(
    'payload',
  );
  @override
  late final GeneratedColumn<String> payload = GeneratedColumn<String>(
    'payload',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    worldId,
    owner,
    version,
    throughRevision,
    payload,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'context_summaries';
  @override
  VerificationContext validateIntegrity(
    Insertable<ContextSummary> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('world_id')) {
      context.handle(
        _worldIdMeta,
        worldId.isAcceptableOrUnknown(data['world_id']!, _worldIdMeta),
      );
    } else if (isInserting) {
      context.missing(_worldIdMeta);
    }
    if (data.containsKey('owner')) {
      context.handle(
        _ownerMeta,
        owner.isAcceptableOrUnknown(data['owner']!, _ownerMeta),
      );
    } else if (isInserting) {
      context.missing(_ownerMeta);
    }
    if (data.containsKey('version')) {
      context.handle(
        _versionMeta,
        version.isAcceptableOrUnknown(data['version']!, _versionMeta),
      );
    } else if (isInserting) {
      context.missing(_versionMeta);
    }
    if (data.containsKey('through_revision')) {
      context.handle(
        _throughRevisionMeta,
        throughRevision.isAcceptableOrUnknown(
          data['through_revision']!,
          _throughRevisionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_throughRevisionMeta);
    }
    if (data.containsKey('payload')) {
      context.handle(
        _payloadMeta,
        payload.isAcceptableOrUnknown(data['payload']!, _payloadMeta),
      );
    } else if (isInserting) {
      context.missing(_payloadMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {worldId, owner, version};
  @override
  ContextSummary map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ContextSummary(
      worldId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}world_id'],
      )!,
      owner: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}owner'],
      )!,
      version: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}version'],
      )!,
      throughRevision: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}through_revision'],
      )!,
      payload: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload'],
      )!,
    );
  }

  @override
  $ContextSummariesTable createAlias(String alias) {
    return $ContextSummariesTable(attachedDatabase, alias);
  }
}

class ContextSummary extends DataClass implements Insertable<ContextSummary> {
  final String worldId;
  final String owner;
  final int version;
  final int throughRevision;
  final String payload;
  const ContextSummary({
    required this.worldId,
    required this.owner,
    required this.version,
    required this.throughRevision,
    required this.payload,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['world_id'] = Variable<String>(worldId);
    map['owner'] = Variable<String>(owner);
    map['version'] = Variable<int>(version);
    map['through_revision'] = Variable<int>(throughRevision);
    map['payload'] = Variable<String>(payload);
    return map;
  }

  ContextSummariesCompanion toCompanion(bool nullToAbsent) {
    return ContextSummariesCompanion(
      worldId: Value(worldId),
      owner: Value(owner),
      version: Value(version),
      throughRevision: Value(throughRevision),
      payload: Value(payload),
    );
  }

  factory ContextSummary.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ContextSummary(
      worldId: serializer.fromJson<String>(json['worldId']),
      owner: serializer.fromJson<String>(json['owner']),
      version: serializer.fromJson<int>(json['version']),
      throughRevision: serializer.fromJson<int>(json['throughRevision']),
      payload: serializer.fromJson<String>(json['payload']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'worldId': serializer.toJson<String>(worldId),
      'owner': serializer.toJson<String>(owner),
      'version': serializer.toJson<int>(version),
      'throughRevision': serializer.toJson<int>(throughRevision),
      'payload': serializer.toJson<String>(payload),
    };
  }

  ContextSummary copyWith({
    String? worldId,
    String? owner,
    int? version,
    int? throughRevision,
    String? payload,
  }) => ContextSummary(
    worldId: worldId ?? this.worldId,
    owner: owner ?? this.owner,
    version: version ?? this.version,
    throughRevision: throughRevision ?? this.throughRevision,
    payload: payload ?? this.payload,
  );
  ContextSummary copyWithCompanion(ContextSummariesCompanion data) {
    return ContextSummary(
      worldId: data.worldId.present ? data.worldId.value : this.worldId,
      owner: data.owner.present ? data.owner.value : this.owner,
      version: data.version.present ? data.version.value : this.version,
      throughRevision: data.throughRevision.present
          ? data.throughRevision.value
          : this.throughRevision,
      payload: data.payload.present ? data.payload.value : this.payload,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ContextSummary(')
          ..write('worldId: $worldId, ')
          ..write('owner: $owner, ')
          ..write('version: $version, ')
          ..write('throughRevision: $throughRevision, ')
          ..write('payload: $payload')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(worldId, owner, version, throughRevision, payload);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ContextSummary &&
          other.worldId == this.worldId &&
          other.owner == this.owner &&
          other.version == this.version &&
          other.throughRevision == this.throughRevision &&
          other.payload == this.payload);
}

class ContextSummariesCompanion extends UpdateCompanion<ContextSummary> {
  final Value<String> worldId;
  final Value<String> owner;
  final Value<int> version;
  final Value<int> throughRevision;
  final Value<String> payload;
  final Value<int> rowid;
  const ContextSummariesCompanion({
    this.worldId = const Value.absent(),
    this.owner = const Value.absent(),
    this.version = const Value.absent(),
    this.throughRevision = const Value.absent(),
    this.payload = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ContextSummariesCompanion.insert({
    required String worldId,
    required String owner,
    required int version,
    required int throughRevision,
    required String payload,
    this.rowid = const Value.absent(),
  }) : worldId = Value(worldId),
       owner = Value(owner),
       version = Value(version),
       throughRevision = Value(throughRevision),
       payload = Value(payload);
  static Insertable<ContextSummary> custom({
    Expression<String>? worldId,
    Expression<String>? owner,
    Expression<int>? version,
    Expression<int>? throughRevision,
    Expression<String>? payload,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (worldId != null) 'world_id': worldId,
      if (owner != null) 'owner': owner,
      if (version != null) 'version': version,
      if (throughRevision != null) 'through_revision': throughRevision,
      if (payload != null) 'payload': payload,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ContextSummariesCompanion copyWith({
    Value<String>? worldId,
    Value<String>? owner,
    Value<int>? version,
    Value<int>? throughRevision,
    Value<String>? payload,
    Value<int>? rowid,
  }) {
    return ContextSummariesCompanion(
      worldId: worldId ?? this.worldId,
      owner: owner ?? this.owner,
      version: version ?? this.version,
      throughRevision: throughRevision ?? this.throughRevision,
      payload: payload ?? this.payload,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (worldId.present) {
      map['world_id'] = Variable<String>(worldId.value);
    }
    if (owner.present) {
      map['owner'] = Variable<String>(owner.value);
    }
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (throughRevision.present) {
      map['through_revision'] = Variable<int>(throughRevision.value);
    }
    if (payload.present) {
      map['payload'] = Variable<String>(payload.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ContextSummariesCompanion(')
          ..write('worldId: $worldId, ')
          ..write('owner: $owner, ')
          ..write('version: $version, ')
          ..write('throughRevision: $throughRevision, ')
          ..write('payload: $payload, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $WorldDefinitionsTable extends WorldDefinitions
    with TableInfo<$WorldDefinitionsTable, WorldDefinitionRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WorldDefinitionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _worldIdMeta = const VerificationMeta(
    'worldId',
  );
  @override
  late final GeneratedColumn<String> worldId = GeneratedColumn<String>(
    'world_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES worlds (id)',
    ),
  );
  static const VerificationMeta _versionMeta = const VerificationMeta(
    'version',
  );
  @override
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
    'version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _payloadMeta = const VerificationMeta(
    'payload',
  );
  @override
  late final GeneratedColumn<String> payload = GeneratedColumn<String>(
    'payload',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _savedAtMeta = const VerificationMeta(
    'savedAt',
  );
  @override
  late final GeneratedColumn<DateTime> savedAt = GeneratedColumn<DateTime>(
    'saved_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [worldId, version, payload, savedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'world_definitions';
  @override
  VerificationContext validateIntegrity(
    Insertable<WorldDefinitionRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('world_id')) {
      context.handle(
        _worldIdMeta,
        worldId.isAcceptableOrUnknown(data['world_id']!, _worldIdMeta),
      );
    } else if (isInserting) {
      context.missing(_worldIdMeta);
    }
    if (data.containsKey('version')) {
      context.handle(
        _versionMeta,
        version.isAcceptableOrUnknown(data['version']!, _versionMeta),
      );
    } else if (isInserting) {
      context.missing(_versionMeta);
    }
    if (data.containsKey('payload')) {
      context.handle(
        _payloadMeta,
        payload.isAcceptableOrUnknown(data['payload']!, _payloadMeta),
      );
    } else if (isInserting) {
      context.missing(_payloadMeta);
    }
    if (data.containsKey('saved_at')) {
      context.handle(
        _savedAtMeta,
        savedAt.isAcceptableOrUnknown(data['saved_at']!, _savedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_savedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {worldId, version};
  @override
  WorldDefinitionRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WorldDefinitionRow(
      worldId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}world_id'],
      )!,
      version: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}version'],
      )!,
      payload: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload'],
      )!,
      savedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}saved_at'],
      )!,
    );
  }

  @override
  $WorldDefinitionsTable createAlias(String alias) {
    return $WorldDefinitionsTable(attachedDatabase, alias);
  }
}

class WorldDefinitionRow extends DataClass
    implements Insertable<WorldDefinitionRow> {
  final String worldId;
  final int version;
  final String payload;
  final DateTime savedAt;
  const WorldDefinitionRow({
    required this.worldId,
    required this.version,
    required this.payload,
    required this.savedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['world_id'] = Variable<String>(worldId);
    map['version'] = Variable<int>(version);
    map['payload'] = Variable<String>(payload);
    map['saved_at'] = Variable<DateTime>(savedAt);
    return map;
  }

  WorldDefinitionsCompanion toCompanion(bool nullToAbsent) {
    return WorldDefinitionsCompanion(
      worldId: Value(worldId),
      version: Value(version),
      payload: Value(payload),
      savedAt: Value(savedAt),
    );
  }

  factory WorldDefinitionRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WorldDefinitionRow(
      worldId: serializer.fromJson<String>(json['worldId']),
      version: serializer.fromJson<int>(json['version']),
      payload: serializer.fromJson<String>(json['payload']),
      savedAt: serializer.fromJson<DateTime>(json['savedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'worldId': serializer.toJson<String>(worldId),
      'version': serializer.toJson<int>(version),
      'payload': serializer.toJson<String>(payload),
      'savedAt': serializer.toJson<DateTime>(savedAt),
    };
  }

  WorldDefinitionRow copyWith({
    String? worldId,
    int? version,
    String? payload,
    DateTime? savedAt,
  }) => WorldDefinitionRow(
    worldId: worldId ?? this.worldId,
    version: version ?? this.version,
    payload: payload ?? this.payload,
    savedAt: savedAt ?? this.savedAt,
  );
  WorldDefinitionRow copyWithCompanion(WorldDefinitionsCompanion data) {
    return WorldDefinitionRow(
      worldId: data.worldId.present ? data.worldId.value : this.worldId,
      version: data.version.present ? data.version.value : this.version,
      payload: data.payload.present ? data.payload.value : this.payload,
      savedAt: data.savedAt.present ? data.savedAt.value : this.savedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WorldDefinitionRow(')
          ..write('worldId: $worldId, ')
          ..write('version: $version, ')
          ..write('payload: $payload, ')
          ..write('savedAt: $savedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(worldId, version, payload, savedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WorldDefinitionRow &&
          other.worldId == this.worldId &&
          other.version == this.version &&
          other.payload == this.payload &&
          other.savedAt == this.savedAt);
}

class WorldDefinitionsCompanion extends UpdateCompanion<WorldDefinitionRow> {
  final Value<String> worldId;
  final Value<int> version;
  final Value<String> payload;
  final Value<DateTime> savedAt;
  final Value<int> rowid;
  const WorldDefinitionsCompanion({
    this.worldId = const Value.absent(),
    this.version = const Value.absent(),
    this.payload = const Value.absent(),
    this.savedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WorldDefinitionsCompanion.insert({
    required String worldId,
    required int version,
    required String payload,
    required DateTime savedAt,
    this.rowid = const Value.absent(),
  }) : worldId = Value(worldId),
       version = Value(version),
       payload = Value(payload),
       savedAt = Value(savedAt);
  static Insertable<WorldDefinitionRow> custom({
    Expression<String>? worldId,
    Expression<int>? version,
    Expression<String>? payload,
    Expression<DateTime>? savedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (worldId != null) 'world_id': worldId,
      if (version != null) 'version': version,
      if (payload != null) 'payload': payload,
      if (savedAt != null) 'saved_at': savedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WorldDefinitionsCompanion copyWith({
    Value<String>? worldId,
    Value<int>? version,
    Value<String>? payload,
    Value<DateTime>? savedAt,
    Value<int>? rowid,
  }) {
    return WorldDefinitionsCompanion(
      worldId: worldId ?? this.worldId,
      version: version ?? this.version,
      payload: payload ?? this.payload,
      savedAt: savedAt ?? this.savedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (worldId.present) {
      map['world_id'] = Variable<String>(worldId.value);
    }
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (payload.present) {
      map['payload'] = Variable<String>(payload.value);
    }
    if (savedAt.present) {
      map['saved_at'] = Variable<DateTime>(savedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WorldDefinitionsCompanion(')
          ..write('worldId: $worldId, ')
          ..write('version: $version, ')
          ..write('payload: $payload, ')
          ..write('savedAt: $savedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $WorldDraftsTable extends WorldDrafts
    with TableInfo<$WorldDraftsTable, WorldDraftRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WorldDraftsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _payloadMeta = const VerificationMeta(
    'payload',
  );
  @override
  late final GeneratedColumn<String> payload = GeneratedColumn<String>(
    'payload',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, payload, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'world_drafts';
  @override
  VerificationContext validateIntegrity(
    Insertable<WorldDraftRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('payload')) {
      context.handle(
        _payloadMeta,
        payload.isAcceptableOrUnknown(data['payload']!, _payloadMeta),
      );
    } else if (isInserting) {
      context.missing(_payloadMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WorldDraftRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WorldDraftRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      payload: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $WorldDraftsTable createAlias(String alias) {
    return $WorldDraftsTable(attachedDatabase, alias);
  }
}

class WorldDraftRow extends DataClass implements Insertable<WorldDraftRow> {
  final String id;
  final String payload;
  final DateTime updatedAt;
  const WorldDraftRow({
    required this.id,
    required this.payload,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['payload'] = Variable<String>(payload);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  WorldDraftsCompanion toCompanion(bool nullToAbsent) {
    return WorldDraftsCompanion(
      id: Value(id),
      payload: Value(payload),
      updatedAt: Value(updatedAt),
    );
  }

  factory WorldDraftRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WorldDraftRow(
      id: serializer.fromJson<String>(json['id']),
      payload: serializer.fromJson<String>(json['payload']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'payload': serializer.toJson<String>(payload),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  WorldDraftRow copyWith({String? id, String? payload, DateTime? updatedAt}) =>
      WorldDraftRow(
        id: id ?? this.id,
        payload: payload ?? this.payload,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  WorldDraftRow copyWithCompanion(WorldDraftsCompanion data) {
    return WorldDraftRow(
      id: data.id.present ? data.id.value : this.id,
      payload: data.payload.present ? data.payload.value : this.payload,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WorldDraftRow(')
          ..write('id: $id, ')
          ..write('payload: $payload, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, payload, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WorldDraftRow &&
          other.id == this.id &&
          other.payload == this.payload &&
          other.updatedAt == this.updatedAt);
}

class WorldDraftsCompanion extends UpdateCompanion<WorldDraftRow> {
  final Value<String> id;
  final Value<String> payload;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const WorldDraftsCompanion({
    this.id = const Value.absent(),
    this.payload = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WorldDraftsCompanion.insert({
    required String id,
    required String payload,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       payload = Value(payload),
       updatedAt = Value(updatedAt);
  static Insertable<WorldDraftRow> custom({
    Expression<String>? id,
    Expression<String>? payload,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (payload != null) 'payload': payload,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WorldDraftsCompanion copyWith({
    Value<String>? id,
    Value<String>? payload,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return WorldDraftsCompanion(
      id: id ?? this.id,
      payload: payload ?? this.payload,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (payload.present) {
      map['payload'] = Variable<String>(payload.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WorldDraftsCompanion(')
          ..write('id: $id, ')
          ..write('payload: $payload, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $WorldsTable worlds = $WorldsTable(this);
  late final $UsageRecordsTable usageRecords = $UsageRecordsTable(this);
  late final $PendingImportsTable pendingImports = $PendingImportsTable(this);
  late final $ImportedConversationsTable importedConversations =
      $ImportedConversationsTable(this);
  late final $ImportedMessagesTable importedMessages = $ImportedMessagesTable(
    this,
  );
  late final $ImportedAttachmentsTable importedAttachments =
      $ImportedAttachmentsTable(this);
  late final $DerivedImportResultsTable derivedImportResults =
      $DerivedImportResultsTable(this);
  late final $RoleplaySavesTable roleplaySaves = $RoleplaySavesTable(this);
  late final $RoleplayTurnsTable roleplayTurns = $RoleplayTurnsTable(this);
  late final $RoleplayMemoriesTable roleplayMemories = $RoleplayMemoriesTable(
    this,
  );
  late final $StoryCheckpointsTable storyCheckpoints = $StoryCheckpointsTable(
    this,
  );
  late final $StoryBranchesTable storyBranches = $StoryBranchesTable(this);
  late final $TimelineEntriesTable timelineEntries = $TimelineEntriesTable(
    this,
  );
  late final $ContextSummariesTable contextSummaries = $ContextSummariesTable(
    this,
  );
  late final $WorldDefinitionsTable worldDefinitions = $WorldDefinitionsTable(
    this,
  );
  late final $WorldDraftsTable worldDrafts = $WorldDraftsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    worlds,
    usageRecords,
    pendingImports,
    importedConversations,
    importedMessages,
    importedAttachments,
    derivedImportResults,
    roleplaySaves,
    roleplayTurns,
    roleplayMemories,
    storyCheckpoints,
    storyBranches,
    timelineEntries,
    contextSummaries,
    worldDefinitions,
    worldDrafts,
  ];
}

typedef $$WorldsTableCreateCompanionBuilder = WorldsCompanion Function({
  required String id,
  required String title,
  required String genre,
  required String summary,
  required DateTime createdAt,
  Value<int> rowid,
});
typedef $$WorldsTableUpdateCompanionBuilder = WorldsCompanion Function({
  Value<String> id,
  Value<String> title,
  Value<String> genre,
  Value<String> summary,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

final class $$WorldsTableReferences
    extends BaseReferences<_$AppDatabase, $WorldsTable, WorldRow> {
  $$WorldsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<
    $ImportedConversationsTable,
    List<ImportedConversationRow>
  >
  _importedConversationsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.importedConversations,
        aliasName: 'worlds__id__imported_conversations__world_id',
      );

  $$ImportedConversationsTableProcessedTableManager
  get importedConversationsRefs {
    final manager = $$ImportedConversationsTableTableManager(
      $_db,
      $_db.importedConversations,
    ).filter((f) => f.worldId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _importedConversationsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$RoleplaySavesTable, List<RoleplaySave>>
  _roleplaySavesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.roleplaySaves,
    aliasName: 'worlds__id__roleplay_saves__world_id',
  );

  $$RoleplaySavesTableProcessedTableManager get roleplaySavesRefs {
    final manager = $$RoleplaySavesTableTableManager(
      $_db,
      $_db.roleplaySaves,
    ).filter((f) => f.worldId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_roleplaySavesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$RoleplayTurnsTable, List<RoleplayTurn>>
  _roleplayTurnsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.roleplayTurns,
    aliasName: 'worlds__id__roleplay_turns__world_id',
  );

  $$RoleplayTurnsTableProcessedTableManager get roleplayTurnsRefs {
    final manager = $$RoleplayTurnsTableTableManager(
      $_db,
      $_db.roleplayTurns,
    ).filter((f) => f.worldId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_roleplayTurnsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$RoleplayMemoriesTable, List<RoleplayMemory>>
  _roleplayMemoriesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.roleplayMemories,
    aliasName: 'worlds__id__roleplay_memories__world_id',
  );

  $$RoleplayMemoriesTableProcessedTableManager get roleplayMemoriesRefs {
    final manager = $$RoleplayMemoriesTableTableManager(
      $_db,
      $_db.roleplayMemories,
    ).filter((f) => f.worldId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _roleplayMemoriesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$StoryCheckpointsTable, List<StoryCheckpointRow>>
  _storyCheckpointsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.storyCheckpoints,
    aliasName: 'worlds__id__story_checkpoints__world_id',
  );

  $$StoryCheckpointsTableProcessedTableManager get storyCheckpointsRefs {
    final manager = $$StoryCheckpointsTableTableManager(
      $_db,
      $_db.storyCheckpoints,
    ).filter((f) => f.worldId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _storyCheckpointsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$StoryBranchesTable, List<StoryBranche>>
  _storyBranchesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.storyBranches,
    aliasName: 'worlds__id__story_branches__world_id',
  );

  $$StoryBranchesTableProcessedTableManager get storyBranchesRefs {
    final manager = $$StoryBranchesTableTableManager(
      $_db,
      $_db.storyBranches,
    ).filter((f) => f.worldId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_storyBranchesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$TimelineEntriesTable, List<TimelineEntry>>
  _timelineEntriesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.timelineEntries,
    aliasName: 'worlds__id__timeline_entries__world_id',
  );

  $$TimelineEntriesTableProcessedTableManager get timelineEntriesRefs {
    final manager = $$TimelineEntriesTableTableManager(
      $_db,
      $_db.timelineEntries,
    ).filter((f) => f.worldId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _timelineEntriesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ContextSummariesTable, List<ContextSummary>>
  _contextSummariesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.contextSummaries,
    aliasName: 'worlds__id__context_summaries__world_id',
  );

  $$ContextSummariesTableProcessedTableManager get contextSummariesRefs {
    final manager = $$ContextSummariesTableTableManager(
      $_db,
      $_db.contextSummaries,
    ).filter((f) => f.worldId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _contextSummariesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$WorldDefinitionsTable, List<WorldDefinitionRow>>
  _worldDefinitionsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.worldDefinitions,
    aliasName: 'worlds__id__world_definitions__world_id',
  );

  $$WorldDefinitionsTableProcessedTableManager get worldDefinitionsRefs {
    final manager = $$WorldDefinitionsTableTableManager(
      $_db,
      $_db.worldDefinitions,
    ).filter((f) => f.worldId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _worldDefinitionsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$WorldsTableFilterComposer
    extends Composer<_$AppDatabase, $WorldsTable> {
  $$WorldsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get genre => $composableBuilder(
    column: $table.genre,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get summary => $composableBuilder(
    column: $table.summary,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> importedConversationsRefs(
    Expression<bool> Function($$ImportedConversationsTableFilterComposer f) f,
  ) {
    final $$ImportedConversationsTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.importedConversations,
          getReferencedColumn: (t) => t.worldId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ImportedConversationsTableFilterComposer(
                $db: $db,
                $table: $db.importedConversations,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<bool> roleplaySavesRefs(
    Expression<bool> Function($$RoleplaySavesTableFilterComposer f) f,
  ) {
    final $$RoleplaySavesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.roleplaySaves,
      getReferencedColumn: (t) => t.worldId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RoleplaySavesTableFilterComposer(
            $db: $db,
            $table: $db.roleplaySaves,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> roleplayTurnsRefs(
    Expression<bool> Function($$RoleplayTurnsTableFilterComposer f) f,
  ) {
    final $$RoleplayTurnsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.roleplayTurns,
      getReferencedColumn: (t) => t.worldId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RoleplayTurnsTableFilterComposer(
            $db: $db,
            $table: $db.roleplayTurns,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> roleplayMemoriesRefs(
    Expression<bool> Function($$RoleplayMemoriesTableFilterComposer f) f,
  ) {
    final $$RoleplayMemoriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.roleplayMemories,
      getReferencedColumn: (t) => t.worldId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RoleplayMemoriesTableFilterComposer(
            $db: $db,
            $table: $db.roleplayMemories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> storyCheckpointsRefs(
    Expression<bool> Function($$StoryCheckpointsTableFilterComposer f) f,
  ) {
    final $$StoryCheckpointsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.storyCheckpoints,
      getReferencedColumn: (t) => t.worldId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StoryCheckpointsTableFilterComposer(
            $db: $db,
            $table: $db.storyCheckpoints,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> storyBranchesRefs(
    Expression<bool> Function($$StoryBranchesTableFilterComposer f) f,
  ) {
    final $$StoryBranchesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.storyBranches,
      getReferencedColumn: (t) => t.worldId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StoryBranchesTableFilterComposer(
            $db: $db,
            $table: $db.storyBranches,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> timelineEntriesRefs(
    Expression<bool> Function($$TimelineEntriesTableFilterComposer f) f,
  ) {
    final $$TimelineEntriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.timelineEntries,
      getReferencedColumn: (t) => t.worldId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TimelineEntriesTableFilterComposer(
            $db: $db,
            $table: $db.timelineEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> contextSummariesRefs(
    Expression<bool> Function($$ContextSummariesTableFilterComposer f) f,
  ) {
    final $$ContextSummariesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.contextSummaries,
      getReferencedColumn: (t) => t.worldId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ContextSummariesTableFilterComposer(
            $db: $db,
            $table: $db.contextSummaries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> worldDefinitionsRefs(
    Expression<bool> Function($$WorldDefinitionsTableFilterComposer f) f,
  ) {
    final $$WorldDefinitionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.worldDefinitions,
      getReferencedColumn: (t) => t.worldId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorldDefinitionsTableFilterComposer(
            $db: $db,
            $table: $db.worldDefinitions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$WorldsTableOrderingComposer
    extends Composer<_$AppDatabase, $WorldsTable> {
  $$WorldsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get genre => $composableBuilder(
    column: $table.genre,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get summary => $composableBuilder(
    column: $table.summary,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$WorldsTableAnnotationComposer
    extends Composer<_$AppDatabase, $WorldsTable> {
  $$WorldsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get genre =>
      $composableBuilder(column: $table.genre, builder: (column) => column);

  GeneratedColumn<String> get summary =>
      $composableBuilder(column: $table.summary, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> importedConversationsRefs<T extends Object>(
    Expression<T> Function($$ImportedConversationsTableAnnotationComposer a) f,
  ) {
    final $$ImportedConversationsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.importedConversations,
          getReferencedColumn: (t) => t.worldId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ImportedConversationsTableAnnotationComposer(
                $db: $db,
                $table: $db.importedConversations,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> roleplaySavesRefs<T extends Object>(
    Expression<T> Function($$RoleplaySavesTableAnnotationComposer a) f,
  ) {
    final $$RoleplaySavesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.roleplaySaves,
      getReferencedColumn: (t) => t.worldId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RoleplaySavesTableAnnotationComposer(
            $db: $db,
            $table: $db.roleplaySaves,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> roleplayTurnsRefs<T extends Object>(
    Expression<T> Function($$RoleplayTurnsTableAnnotationComposer a) f,
  ) {
    final $$RoleplayTurnsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.roleplayTurns,
      getReferencedColumn: (t) => t.worldId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RoleplayTurnsTableAnnotationComposer(
            $db: $db,
            $table: $db.roleplayTurns,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> roleplayMemoriesRefs<T extends Object>(
    Expression<T> Function($$RoleplayMemoriesTableAnnotationComposer a) f,
  ) {
    final $$RoleplayMemoriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.roleplayMemories,
      getReferencedColumn: (t) => t.worldId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RoleplayMemoriesTableAnnotationComposer(
            $db: $db,
            $table: $db.roleplayMemories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> storyCheckpointsRefs<T extends Object>(
    Expression<T> Function($$StoryCheckpointsTableAnnotationComposer a) f,
  ) {
    final $$StoryCheckpointsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.storyCheckpoints,
      getReferencedColumn: (t) => t.worldId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StoryCheckpointsTableAnnotationComposer(
            $db: $db,
            $table: $db.storyCheckpoints,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> storyBranchesRefs<T extends Object>(
    Expression<T> Function($$StoryBranchesTableAnnotationComposer a) f,
  ) {
    final $$StoryBranchesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.storyBranches,
      getReferencedColumn: (t) => t.worldId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StoryBranchesTableAnnotationComposer(
            $db: $db,
            $table: $db.storyBranches,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> timelineEntriesRefs<T extends Object>(
    Expression<T> Function($$TimelineEntriesTableAnnotationComposer a) f,
  ) {
    final $$TimelineEntriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.timelineEntries,
      getReferencedColumn: (t) => t.worldId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TimelineEntriesTableAnnotationComposer(
            $db: $db,
            $table: $db.timelineEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> contextSummariesRefs<T extends Object>(
    Expression<T> Function($$ContextSummariesTableAnnotationComposer a) f,
  ) {
    final $$ContextSummariesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.contextSummaries,
      getReferencedColumn: (t) => t.worldId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ContextSummariesTableAnnotationComposer(
            $db: $db,
            $table: $db.contextSummaries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> worldDefinitionsRefs<T extends Object>(
    Expression<T> Function($$WorldDefinitionsTableAnnotationComposer a) f,
  ) {
    final $$WorldDefinitionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.worldDefinitions,
      getReferencedColumn: (t) => t.worldId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorldDefinitionsTableAnnotationComposer(
            $db: $db,
            $table: $db.worldDefinitions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$WorldsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WorldsTable,
          WorldRow,
          $$WorldsTableFilterComposer,
          $$WorldsTableOrderingComposer,
          $$WorldsTableAnnotationComposer,
          $$WorldsTableCreateCompanionBuilder,
          $$WorldsTableUpdateCompanionBuilder,
          (WorldRow, $$WorldsTableReferences),
          WorldRow,
          PrefetchHooks Function({
            bool importedConversationsRefs,
            bool roleplaySavesRefs,
            bool roleplayTurnsRefs,
            bool roleplayMemoriesRefs,
            bool storyCheckpointsRefs,
            bool storyBranchesRefs,
            bool timelineEntriesRefs,
            bool contextSummariesRefs,
            bool worldDefinitionsRefs,
          })
        > {
  $$WorldsTableTableManager(_$AppDatabase db, $WorldsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WorldsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WorldsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WorldsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> genre = const Value.absent(),
                Value<String> summary = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WorldsCompanion(
                id: id,
                title: title,
                genre: genre,
                summary: summary,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String title,
                required String genre,
                required String summary,
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => WorldsCompanion.insert(
                id: id,
                title: title,
                genre: genre,
                summary: summary,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$WorldsTable, WorldRow>(table),
                  $$WorldsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                importedConversationsRefs = false,
                roleplaySavesRefs = false,
                roleplayTurnsRefs = false,
                roleplayMemoriesRefs = false,
                storyCheckpointsRefs = false,
                storyBranchesRefs = false,
                timelineEntriesRefs = false,
                contextSummariesRefs = false,
                worldDefinitionsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (importedConversationsRefs) db.importedConversations,
                    if (roleplaySavesRefs) db.roleplaySaves,
                    if (roleplayTurnsRefs) db.roleplayTurns,
                    if (roleplayMemoriesRefs) db.roleplayMemories,
                    if (storyCheckpointsRefs) db.storyCheckpoints,
                    if (storyBranchesRefs) db.storyBranches,
                    if (timelineEntriesRefs) db.timelineEntries,
                    if (contextSummariesRefs) db.contextSummaries,
                    if (worldDefinitionsRefs) db.worldDefinitions,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (importedConversationsRefs)
                        await $_getPrefetchedDataByColumns<
                          WorldRow,
                          $WorldsTable,
                          ImportedConversationRow,
                          $ImportedConversationsTable
                        >(
                          currentTable: table,
                          referencedTable: $$WorldsTableReferences
                              ._importedConversationsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$WorldsTableReferences(
                                db,
                                table,
                                p0,
                              ).importedConversationsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'world_id',
                          typedResults: items,
                        ),
                      if (roleplaySavesRefs)
                        await $_getPrefetchedDataByColumns<
                          WorldRow,
                          $WorldsTable,
                          RoleplaySave,
                          $RoleplaySavesTable
                        >(
                          currentTable: table,
                          referencedTable: $$WorldsTableReferences
                              ._roleplaySavesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$WorldsTableReferences(
                                db,
                                table,
                                p0,
                              ).roleplaySavesRefs,
                          currentColumn: 'id',
                          referencedColumn: 'world_id',
                          typedResults: items,
                        ),
                      if (roleplayTurnsRefs)
                        await $_getPrefetchedDataByColumns<
                          WorldRow,
                          $WorldsTable,
                          RoleplayTurn,
                          $RoleplayTurnsTable
                        >(
                          currentTable: table,
                          referencedTable: $$WorldsTableReferences
                              ._roleplayTurnsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$WorldsTableReferences(
                                db,
                                table,
                                p0,
                              ).roleplayTurnsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'world_id',
                          typedResults: items,
                        ),
                      if (roleplayMemoriesRefs)
                        await $_getPrefetchedDataByColumns<
                          WorldRow,
                          $WorldsTable,
                          RoleplayMemory,
                          $RoleplayMemoriesTable
                        >(
                          currentTable: table,
                          referencedTable: $$WorldsTableReferences
                              ._roleplayMemoriesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$WorldsTableReferences(
                                db,
                                table,
                                p0,
                              ).roleplayMemoriesRefs,
                          currentColumn: 'id',
                          referencedColumn: 'world_id',
                          typedResults: items,
                        ),
                      if (storyCheckpointsRefs)
                        await $_getPrefetchedDataByColumns<
                          WorldRow,
                          $WorldsTable,
                          StoryCheckpointRow,
                          $StoryCheckpointsTable
                        >(
                          currentTable: table,
                          referencedTable: $$WorldsTableReferences
                              ._storyCheckpointsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$WorldsTableReferences(
                                db,
                                table,
                                p0,
                              ).storyCheckpointsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'world_id',
                          typedResults: items,
                        ),
                      if (storyBranchesRefs)
                        await $_getPrefetchedDataByColumns<
                          WorldRow,
                          $WorldsTable,
                          StoryBranche,
                          $StoryBranchesTable
                        >(
                          currentTable: table,
                          referencedTable: $$WorldsTableReferences
                              ._storyBranchesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$WorldsTableReferences(
                                db,
                                table,
                                p0,
                              ).storyBranchesRefs,
                          currentColumn: 'id',
                          referencedColumn: 'world_id',
                          typedResults: items,
                        ),
                      if (timelineEntriesRefs)
                        await $_getPrefetchedDataByColumns<
                          WorldRow,
                          $WorldsTable,
                          TimelineEntry,
                          $TimelineEntriesTable
                        >(
                          currentTable: table,
                          referencedTable: $$WorldsTableReferences
                              ._timelineEntriesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$WorldsTableReferences(
                                db,
                                table,
                                p0,
                              ).timelineEntriesRefs,
                          currentColumn: 'id',
                          referencedColumn: 'world_id',
                          typedResults: items,
                        ),
                      if (contextSummariesRefs)
                        await $_getPrefetchedDataByColumns<
                          WorldRow,
                          $WorldsTable,
                          ContextSummary,
                          $ContextSummariesTable
                        >(
                          currentTable: table,
                          referencedTable: $$WorldsTableReferences
                              ._contextSummariesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$WorldsTableReferences(
                                db,
                                table,
                                p0,
                              ).contextSummariesRefs,
                          currentColumn: 'id',
                          referencedColumn: 'world_id',
                          typedResults: items,
                        ),
                      if (worldDefinitionsRefs)
                        await $_getPrefetchedDataByColumns<
                          WorldRow,
                          $WorldsTable,
                          WorldDefinitionRow,
                          $WorldDefinitionsTable
                        >(
                          currentTable: table,
                          referencedTable: $$WorldsTableReferences
                              ._worldDefinitionsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$WorldsTableReferences(
                                db,
                                table,
                                p0,
                              ).worldDefinitionsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'world_id',
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$WorldsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WorldsTable,
      WorldRow,
      $$WorldsTableFilterComposer,
      $$WorldsTableOrderingComposer,
      $$WorldsTableAnnotationComposer,
      $$WorldsTableCreateCompanionBuilder,
      $$WorldsTableUpdateCompanionBuilder,
      (WorldRow, $$WorldsTableReferences),
      WorldRow,
      PrefetchHooks Function({
        bool importedConversationsRefs,
        bool roleplaySavesRefs,
        bool roleplayTurnsRefs,
        bool roleplayMemoriesRefs,
        bool storyCheckpointsRefs,
        bool storyBranchesRefs,
        bool timelineEntriesRefs,
        bool contextSummariesRefs,
        bool worldDefinitionsRefs,
      })
    >;
typedef $$UsageRecordsTableCreateCompanionBuilder =
    UsageRecordsCompanion Function({
      Value<int> id,
      required DateTime requestedAt,
      required String model,
      required int inputTokens,
      required int outputTokens,
      Value<int?> cacheTokens,
      Value<double?> estimatedUsd,
      Value<String?> priceVersion,
    });
typedef $$UsageRecordsTableUpdateCompanionBuilder =
    UsageRecordsCompanion Function({
      Value<int> id,
      Value<DateTime> requestedAt,
      Value<String> model,
      Value<int> inputTokens,
      Value<int> outputTokens,
      Value<int?> cacheTokens,
      Value<double?> estimatedUsd,
      Value<String?> priceVersion,
    });

class $$UsageRecordsTableFilterComposer
    extends Composer<_$AppDatabase, $UsageRecordsTable> {
  $$UsageRecordsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get requestedAt => $composableBuilder(
    column: $table.requestedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get model => $composableBuilder(
    column: $table.model,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get inputTokens => $composableBuilder(
    column: $table.inputTokens,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get outputTokens => $composableBuilder(
    column: $table.outputTokens,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get cacheTokens => $composableBuilder(
    column: $table.cacheTokens,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get estimatedUsd => $composableBuilder(
    column: $table.estimatedUsd,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get priceVersion => $composableBuilder(
    column: $table.priceVersion,
    builder: (column) => ColumnFilters(column),
  );
}

class $$UsageRecordsTableOrderingComposer
    extends Composer<_$AppDatabase, $UsageRecordsTable> {
  $$UsageRecordsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get requestedAt => $composableBuilder(
    column: $table.requestedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get model => $composableBuilder(
    column: $table.model,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get inputTokens => $composableBuilder(
    column: $table.inputTokens,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get outputTokens => $composableBuilder(
    column: $table.outputTokens,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get cacheTokens => $composableBuilder(
    column: $table.cacheTokens,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get estimatedUsd => $composableBuilder(
    column: $table.estimatedUsd,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get priceVersion => $composableBuilder(
    column: $table.priceVersion,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UsageRecordsTableAnnotationComposer
    extends Composer<_$AppDatabase, $UsageRecordsTable> {
  $$UsageRecordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get requestedAt => $composableBuilder(
    column: $table.requestedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get model =>
      $composableBuilder(column: $table.model, builder: (column) => column);

  GeneratedColumn<int> get inputTokens => $composableBuilder(
    column: $table.inputTokens,
    builder: (column) => column,
  );

  GeneratedColumn<int> get outputTokens => $composableBuilder(
    column: $table.outputTokens,
    builder: (column) => column,
  );

  GeneratedColumn<int> get cacheTokens => $composableBuilder(
    column: $table.cacheTokens,
    builder: (column) => column,
  );

  GeneratedColumn<double> get estimatedUsd => $composableBuilder(
    column: $table.estimatedUsd,
    builder: (column) => column,
  );

  GeneratedColumn<String> get priceVersion => $composableBuilder(
    column: $table.priceVersion,
    builder: (column) => column,
  );
}

class $$UsageRecordsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UsageRecordsTable,
          UsageRecord,
          $$UsageRecordsTableFilterComposer,
          $$UsageRecordsTableOrderingComposer,
          $$UsageRecordsTableAnnotationComposer,
          $$UsageRecordsTableCreateCompanionBuilder,
          $$UsageRecordsTableUpdateCompanionBuilder,
          (
            UsageRecord,
            BaseReferences<_$AppDatabase, $UsageRecordsTable, UsageRecord>,
          ),
          UsageRecord,
          PrefetchHooks Function()
        > {
  $$UsageRecordsTableTableManager(_$AppDatabase db, $UsageRecordsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UsageRecordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UsageRecordsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UsageRecordsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> requestedAt = const Value.absent(),
                Value<String> model = const Value.absent(),
                Value<int> inputTokens = const Value.absent(),
                Value<int> outputTokens = const Value.absent(),
                Value<int?> cacheTokens = const Value.absent(),
                Value<double?> estimatedUsd = const Value.absent(),
                Value<String?> priceVersion = const Value.absent(),
              }) => UsageRecordsCompanion(
                id: id,
                requestedAt: requestedAt,
                model: model,
                inputTokens: inputTokens,
                outputTokens: outputTokens,
                cacheTokens: cacheTokens,
                estimatedUsd: estimatedUsd,
                priceVersion: priceVersion,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required DateTime requestedAt,
                required String model,
                required int inputTokens,
                required int outputTokens,
                Value<int?> cacheTokens = const Value.absent(),
                Value<double?> estimatedUsd = const Value.absent(),
                Value<String?> priceVersion = const Value.absent(),
              }) => UsageRecordsCompanion.insert(
                id: id,
                requestedAt: requestedAt,
                model: model,
                inputTokens: inputTokens,
                outputTokens: outputTokens,
                cacheTokens: cacheTokens,
                estimatedUsd: estimatedUsd,
                priceVersion: priceVersion,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$UsageRecordsTable, UsageRecord>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $UsageRecordsTable,
                    UsageRecord
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$UsageRecordsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UsageRecordsTable,
      UsageRecord,
      $$UsageRecordsTableFilterComposer,
      $$UsageRecordsTableOrderingComposer,
      $$UsageRecordsTableAnnotationComposer,
      $$UsageRecordsTableCreateCompanionBuilder,
      $$UsageRecordsTableUpdateCompanionBuilder,
      (
        UsageRecord,
        BaseReferences<_$AppDatabase, $UsageRecordsTable, UsageRecord>,
      ),
      UsageRecord,
      PrefetchHooks Function()
    >;
typedef $$PendingImportsTableCreateCompanionBuilder =
    PendingImportsCompanion Function({
      required String id,
      required String fingerprint,
      required String payload,
      required String state,
      Value<String?> safeError,
      required DateTime receivedAt,
      Value<int> rowid,
    });
typedef $$PendingImportsTableUpdateCompanionBuilder =
    PendingImportsCompanion Function({
      Value<String> id,
      Value<String> fingerprint,
      Value<String> payload,
      Value<String> state,
      Value<String?> safeError,
      Value<DateTime> receivedAt,
      Value<int> rowid,
    });

class $$PendingImportsTableFilterComposer
    extends Composer<_$AppDatabase, $PendingImportsTable> {
  $$PendingImportsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fingerprint => $composableBuilder(
    column: $table.fingerprint,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get state => $composableBuilder(
    column: $table.state,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get safeError => $composableBuilder(
    column: $table.safeError,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get receivedAt => $composableBuilder(
    column: $table.receivedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PendingImportsTableOrderingComposer
    extends Composer<_$AppDatabase, $PendingImportsTable> {
  $$PendingImportsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fingerprint => $composableBuilder(
    column: $table.fingerprint,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get state => $composableBuilder(
    column: $table.state,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get safeError => $composableBuilder(
    column: $table.safeError,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get receivedAt => $composableBuilder(
    column: $table.receivedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PendingImportsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PendingImportsTable> {
  $$PendingImportsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get fingerprint => $composableBuilder(
    column: $table.fingerprint,
    builder: (column) => column,
  );

  GeneratedColumn<String> get payload =>
      $composableBuilder(column: $table.payload, builder: (column) => column);

  GeneratedColumn<String> get state =>
      $composableBuilder(column: $table.state, builder: (column) => column);

  GeneratedColumn<String> get safeError =>
      $composableBuilder(column: $table.safeError, builder: (column) => column);

  GeneratedColumn<DateTime> get receivedAt => $composableBuilder(
    column: $table.receivedAt,
    builder: (column) => column,
  );
}

class $$PendingImportsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PendingImportsTable,
          PendingImport,
          $$PendingImportsTableFilterComposer,
          $$PendingImportsTableOrderingComposer,
          $$PendingImportsTableAnnotationComposer,
          $$PendingImportsTableCreateCompanionBuilder,
          $$PendingImportsTableUpdateCompanionBuilder,
          (
            PendingImport,
            BaseReferences<_$AppDatabase, $PendingImportsTable, PendingImport>,
          ),
          PendingImport,
          PrefetchHooks Function()
        > {
  $$PendingImportsTableTableManager(
    _$AppDatabase db,
    $PendingImportsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PendingImportsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PendingImportsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PendingImportsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> fingerprint = const Value.absent(),
                Value<String> payload = const Value.absent(),
                Value<String> state = const Value.absent(),
                Value<String?> safeError = const Value.absent(),
                Value<DateTime> receivedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PendingImportsCompanion(
                id: id,
                fingerprint: fingerprint,
                payload: payload,
                state: state,
                safeError: safeError,
                receivedAt: receivedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String fingerprint,
                required String payload,
                required String state,
                Value<String?> safeError = const Value.absent(),
                required DateTime receivedAt,
                Value<int> rowid = const Value.absent(),
              }) => PendingImportsCompanion.insert(
                id: id,
                fingerprint: fingerprint,
                payload: payload,
                state: state,
                safeError: safeError,
                receivedAt: receivedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$PendingImportsTable, PendingImport>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $PendingImportsTable,
                    PendingImport
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PendingImportsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PendingImportsTable,
      PendingImport,
      $$PendingImportsTableFilterComposer,
      $$PendingImportsTableOrderingComposer,
      $$PendingImportsTableAnnotationComposer,
      $$PendingImportsTableCreateCompanionBuilder,
      $$PendingImportsTableUpdateCompanionBuilder,
      (
        PendingImport,
        BaseReferences<_$AppDatabase, $PendingImportsTable, PendingImport>,
      ),
      PendingImport,
      PrefetchHooks Function()
    >;
typedef $$ImportedConversationsTableCreateCompanionBuilder =
    ImportedConversationsCompanion Function({
      required String id,
      required String jobId,
      required String title,
      required String source,
      Value<String?> worldId,
      Value<String?> currentMessageId,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$ImportedConversationsTableUpdateCompanionBuilder =
    ImportedConversationsCompanion Function({
      Value<String> id,
      Value<String> jobId,
      Value<String> title,
      Value<String> source,
      Value<String?> worldId,
      Value<String?> currentMessageId,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

final class $$ImportedConversationsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $ImportedConversationsTable,
          ImportedConversationRow
        > {
  $$ImportedConversationsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $WorldsTable _worldIdTable(_$AppDatabase db) =>
      db.worlds.createAlias('imported_conversations__world_id__worlds__id');

  $$WorldsTableProcessedTableManager? get worldId {
    final $_column = $_itemColumn<String>('world_id');
    if ($_column == null) return null;
    final manager = $$WorldsTableTableManager(
      $_db,
      $_db.worlds,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_worldIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$ImportedMessagesTable, List<ImportedMessageRow>>
  _importedMessagesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.importedMessages,
    aliasName: 'imported_conversations__id__imported_messages__conversation_id',
  );

  $$ImportedMessagesTableProcessedTableManager get importedMessagesRefs {
    final manager = $$ImportedMessagesTableTableManager(
      $_db,
      $_db.importedMessages,
    ).filter((f) => f.conversationId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _importedMessagesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $ImportedAttachmentsTable,
    List<ImportedAttachmentRow>
  >
  _importedAttachmentsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.importedAttachments,
        aliasName:
            'imported_conversations__id__imported_attachments__conversation_id',
      );

  $$ImportedAttachmentsTableProcessedTableManager get importedAttachmentsRefs {
    final manager = $$ImportedAttachmentsTableTableManager(
      $_db,
      $_db.importedAttachments,
    ).filter((f) => f.conversationId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _importedAttachmentsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $DerivedImportResultsTable,
    List<DerivedImportResult>
  >
  _derivedImportResultsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.derivedImportResults,
    aliasName:
        'imported_conversations__id__derived_import_results__conversation_id',
  );

  $$DerivedImportResultsTableProcessedTableManager
  get derivedImportResultsRefs {
    final manager = $$DerivedImportResultsTableTableManager(
      $_db,
      $_db.derivedImportResults,
    ).filter((f) => f.conversationId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _derivedImportResultsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ImportedConversationsTableFilterComposer
    extends Composer<_$AppDatabase, $ImportedConversationsTable> {
  $$ImportedConversationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get jobId => $composableBuilder(
    column: $table.jobId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get currentMessageId => $composableBuilder(
    column: $table.currentMessageId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$WorldsTableFilterComposer get worldId {
    final $$WorldsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.worldId,
      referencedTable: $db.worlds,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorldsTableFilterComposer(
            $db: $db,
            $table: $db.worlds,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> importedMessagesRefs(
    Expression<bool> Function($$ImportedMessagesTableFilterComposer f) f,
  ) {
    final $$ImportedMessagesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.importedMessages,
      getReferencedColumn: (t) => t.conversationId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ImportedMessagesTableFilterComposer(
            $db: $db,
            $table: $db.importedMessages,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> importedAttachmentsRefs(
    Expression<bool> Function($$ImportedAttachmentsTableFilterComposer f) f,
  ) {
    final $$ImportedAttachmentsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.importedAttachments,
      getReferencedColumn: (t) => t.conversationId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ImportedAttachmentsTableFilterComposer(
            $db: $db,
            $table: $db.importedAttachments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> derivedImportResultsRefs(
    Expression<bool> Function($$DerivedImportResultsTableFilterComposer f) f,
  ) {
    final $$DerivedImportResultsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.derivedImportResults,
      getReferencedColumn: (t) => t.conversationId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DerivedImportResultsTableFilterComposer(
            $db: $db,
            $table: $db.derivedImportResults,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ImportedConversationsTableOrderingComposer
    extends Composer<_$AppDatabase, $ImportedConversationsTable> {
  $$ImportedConversationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get jobId => $composableBuilder(
    column: $table.jobId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get currentMessageId => $composableBuilder(
    column: $table.currentMessageId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$WorldsTableOrderingComposer get worldId {
    final $$WorldsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.worldId,
      referencedTable: $db.worlds,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorldsTableOrderingComposer(
            $db: $db,
            $table: $db.worlds,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ImportedConversationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ImportedConversationsTable> {
  $$ImportedConversationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get jobId =>
      $composableBuilder(column: $table.jobId, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<String> get currentMessageId => $composableBuilder(
    column: $table.currentMessageId,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$WorldsTableAnnotationComposer get worldId {
    final $$WorldsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.worldId,
      referencedTable: $db.worlds,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorldsTableAnnotationComposer(
            $db: $db,
            $table: $db.worlds,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> importedMessagesRefs<T extends Object>(
    Expression<T> Function($$ImportedMessagesTableAnnotationComposer a) f,
  ) {
    final $$ImportedMessagesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.importedMessages,
      getReferencedColumn: (t) => t.conversationId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ImportedMessagesTableAnnotationComposer(
            $db: $db,
            $table: $db.importedMessages,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> importedAttachmentsRefs<T extends Object>(
    Expression<T> Function($$ImportedAttachmentsTableAnnotationComposer a) f,
  ) {
    final $$ImportedAttachmentsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.importedAttachments,
          getReferencedColumn: (t) => t.conversationId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ImportedAttachmentsTableAnnotationComposer(
                $db: $db,
                $table: $db.importedAttachments,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> derivedImportResultsRefs<T extends Object>(
    Expression<T> Function($$DerivedImportResultsTableAnnotationComposer a) f,
  ) {
    final $$DerivedImportResultsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.derivedImportResults,
          getReferencedColumn: (t) => t.conversationId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$DerivedImportResultsTableAnnotationComposer(
                $db: $db,
                $table: $db.derivedImportResults,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$ImportedConversationsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ImportedConversationsTable,
          ImportedConversationRow,
          $$ImportedConversationsTableFilterComposer,
          $$ImportedConversationsTableOrderingComposer,
          $$ImportedConversationsTableAnnotationComposer,
          $$ImportedConversationsTableCreateCompanionBuilder,
          $$ImportedConversationsTableUpdateCompanionBuilder,
          (ImportedConversationRow, $$ImportedConversationsTableReferences),
          ImportedConversationRow,
          PrefetchHooks Function({
            bool worldId,
            bool importedMessagesRefs,
            bool importedAttachmentsRefs,
            bool derivedImportResultsRefs,
          })
        > {
  $$ImportedConversationsTableTableManager(
    _$AppDatabase db,
    $ImportedConversationsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ImportedConversationsTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$ImportedConversationsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$ImportedConversationsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> jobId = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> source = const Value.absent(),
                Value<String?> worldId = const Value.absent(),
                Value<String?> currentMessageId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ImportedConversationsCompanion(
                id: id,
                jobId: jobId,
                title: title,
                source: source,
                worldId: worldId,
                currentMessageId: currentMessageId,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String jobId,
                required String title,
                required String source,
                Value<String?> worldId = const Value.absent(),
                Value<String?> currentMessageId = const Value.absent(),
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => ImportedConversationsCompanion.insert(
                id: id,
                jobId: jobId,
                title: title,
                source: source,
                worldId: worldId,
                currentMessageId: currentMessageId,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<
                    $ImportedConversationsTable,
                    ImportedConversationRow
                  >(table),
                  $$ImportedConversationsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                worldId = false,
                importedMessagesRefs = false,
                importedAttachmentsRefs = false,
                derivedImportResultsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (importedMessagesRefs) db.importedMessages,
                    if (importedAttachmentsRefs) db.importedAttachments,
                    if (derivedImportResultsRefs) db.derivedImportResults,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (worldId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.worldId,
                            referencedTable:
                                $$ImportedConversationsTableReferences
                                    ._worldIdTable(db),
                            referencedColumn:
                                $$ImportedConversationsTableReferences
                                    ._worldIdTable(db)
                                    .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (importedMessagesRefs)
                        await $_getPrefetchedDataByColumns<
                          ImportedConversationRow,
                          $ImportedConversationsTable,
                          ImportedMessageRow,
                          $ImportedMessagesTable
                        >(
                          currentTable: table,
                          referencedTable:
                              $$ImportedConversationsTableReferences
                                  ._importedMessagesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ImportedConversationsTableReferences(
                                db,
                                table,
                                p0,
                              ).importedMessagesRefs,
                          currentColumn: 'id',
                          referencedColumn: 'conversation_id',
                          typedResults: items,
                        ),
                      if (importedAttachmentsRefs)
                        await $_getPrefetchedDataByColumns<
                          ImportedConversationRow,
                          $ImportedConversationsTable,
                          ImportedAttachmentRow,
                          $ImportedAttachmentsTable
                        >(
                          currentTable: table,
                          referencedTable:
                              $$ImportedConversationsTableReferences
                                  ._importedAttachmentsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ImportedConversationsTableReferences(
                                db,
                                table,
                                p0,
                              ).importedAttachmentsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'conversation_id',
                          typedResults: items,
                        ),
                      if (derivedImportResultsRefs)
                        await $_getPrefetchedDataByColumns<
                          ImportedConversationRow,
                          $ImportedConversationsTable,
                          DerivedImportResult,
                          $DerivedImportResultsTable
                        >(
                          currentTable: table,
                          referencedTable:
                              $$ImportedConversationsTableReferences
                                  ._derivedImportResultsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ImportedConversationsTableReferences(
                                db,
                                table,
                                p0,
                              ).derivedImportResultsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'conversation_id',
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$ImportedConversationsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ImportedConversationsTable,
      ImportedConversationRow,
      $$ImportedConversationsTableFilterComposer,
      $$ImportedConversationsTableOrderingComposer,
      $$ImportedConversationsTableAnnotationComposer,
      $$ImportedConversationsTableCreateCompanionBuilder,
      $$ImportedConversationsTableUpdateCompanionBuilder,
      (ImportedConversationRow, $$ImportedConversationsTableReferences),
      ImportedConversationRow,
      PrefetchHooks Function({
        bool worldId,
        bool importedMessagesRefs,
        bool importedAttachmentsRefs,
        bool derivedImportResultsRefs,
      })
    >;
typedef $$ImportedMessagesTableCreateCompanionBuilder =
    ImportedMessagesCompanion Function({
      required String conversationId,
      required String messageId,
      Value<String?> parentId,
      required String role,
      required String body,
      required String rawJson,
      required int ordinal,
      Value<int> rowid,
    });
typedef $$ImportedMessagesTableUpdateCompanionBuilder =
    ImportedMessagesCompanion Function({
      Value<String> conversationId,
      Value<String> messageId,
      Value<String?> parentId,
      Value<String> role,
      Value<String> body,
      Value<String> rawJson,
      Value<int> ordinal,
      Value<int> rowid,
    });

final class $$ImportedMessagesTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $ImportedMessagesTable,
          ImportedMessageRow
        > {
  $$ImportedMessagesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ImportedConversationsTable _conversationIdTable(_$AppDatabase db) =>
      db.importedConversations.createAlias(
        'imported_messages__conversation_id__imported_conversations__id',
      );

  $$ImportedConversationsTableProcessedTableManager get conversationId {
    final $_column = $_itemColumn<String>('conversation_id')!;

    final manager = $$ImportedConversationsTableTableManager(
      $_db,
      $_db.importedConversations,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_conversationIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ImportedMessagesTableFilterComposer
    extends Composer<_$AppDatabase, $ImportedMessagesTable> {
  $$ImportedMessagesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get messageId => $composableBuilder(
    column: $table.messageId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get parentId => $composableBuilder(
    column: $table.parentId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get body => $composableBuilder(
    column: $table.body,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get rawJson => $composableBuilder(
    column: $table.rawJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get ordinal => $composableBuilder(
    column: $table.ordinal,
    builder: (column) => ColumnFilters(column),
  );

  $$ImportedConversationsTableFilterComposer get conversationId {
    final $$ImportedConversationsTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.conversationId,
          referencedTable: $db.importedConversations,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ImportedConversationsTableFilterComposer(
                $db: $db,
                $table: $db.importedConversations,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$ImportedMessagesTableOrderingComposer
    extends Composer<_$AppDatabase, $ImportedMessagesTable> {
  $$ImportedMessagesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get messageId => $composableBuilder(
    column: $table.messageId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get parentId => $composableBuilder(
    column: $table.parentId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get body => $composableBuilder(
    column: $table.body,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rawJson => $composableBuilder(
    column: $table.rawJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get ordinal => $composableBuilder(
    column: $table.ordinal,
    builder: (column) => ColumnOrderings(column),
  );

  $$ImportedConversationsTableOrderingComposer get conversationId {
    final $$ImportedConversationsTableOrderingComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.conversationId,
          referencedTable: $db.importedConversations,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ImportedConversationsTableOrderingComposer(
                $db: $db,
                $table: $db.importedConversations,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$ImportedMessagesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ImportedMessagesTable> {
  $$ImportedMessagesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get messageId =>
      $composableBuilder(column: $table.messageId, builder: (column) => column);

  GeneratedColumn<String> get parentId =>
      $composableBuilder(column: $table.parentId, builder: (column) => column);

  GeneratedColumn<String> get role =>
      $composableBuilder(column: $table.role, builder: (column) => column);

  GeneratedColumn<String> get body =>
      $composableBuilder(column: $table.body, builder: (column) => column);

  GeneratedColumn<String> get rawJson =>
      $composableBuilder(column: $table.rawJson, builder: (column) => column);

  GeneratedColumn<int> get ordinal =>
      $composableBuilder(column: $table.ordinal, builder: (column) => column);

  $$ImportedConversationsTableAnnotationComposer get conversationId {
    final $$ImportedConversationsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.conversationId,
          referencedTable: $db.importedConversations,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ImportedConversationsTableAnnotationComposer(
                $db: $db,
                $table: $db.importedConversations,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$ImportedMessagesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ImportedMessagesTable,
          ImportedMessageRow,
          $$ImportedMessagesTableFilterComposer,
          $$ImportedMessagesTableOrderingComposer,
          $$ImportedMessagesTableAnnotationComposer,
          $$ImportedMessagesTableCreateCompanionBuilder,
          $$ImportedMessagesTableUpdateCompanionBuilder,
          (ImportedMessageRow, $$ImportedMessagesTableReferences),
          ImportedMessageRow,
          PrefetchHooks Function({bool conversationId})
        > {
  $$ImportedMessagesTableTableManager(
    _$AppDatabase db,
    $ImportedMessagesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ImportedMessagesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ImportedMessagesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ImportedMessagesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> conversationId = const Value.absent(),
                Value<String> messageId = const Value.absent(),
                Value<String?> parentId = const Value.absent(),
                Value<String> role = const Value.absent(),
                Value<String> body = const Value.absent(),
                Value<String> rawJson = const Value.absent(),
                Value<int> ordinal = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ImportedMessagesCompanion(
                conversationId: conversationId,
                messageId: messageId,
                parentId: parentId,
                role: role,
                body: body,
                rawJson: rawJson,
                ordinal: ordinal,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String conversationId,
                required String messageId,
                Value<String?> parentId = const Value.absent(),
                required String role,
                required String body,
                required String rawJson,
                required int ordinal,
                Value<int> rowid = const Value.absent(),
              }) => ImportedMessagesCompanion.insert(
                conversationId: conversationId,
                messageId: messageId,
                parentId: parentId,
                role: role,
                body: body,
                rawJson: rawJson,
                ordinal: ordinal,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ImportedMessagesTable, ImportedMessageRow>(
                    table,
                  ),
                  $$ImportedMessagesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({conversationId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (conversationId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.conversationId,
                        referencedTable: $$ImportedMessagesTableReferences
                            ._conversationIdTable(db),
                        referencedColumn: $$ImportedMessagesTableReferences
                            ._conversationIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ImportedMessagesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ImportedMessagesTable,
      ImportedMessageRow,
      $$ImportedMessagesTableFilterComposer,
      $$ImportedMessagesTableOrderingComposer,
      $$ImportedMessagesTableAnnotationComposer,
      $$ImportedMessagesTableCreateCompanionBuilder,
      $$ImportedMessagesTableUpdateCompanionBuilder,
      (ImportedMessageRow, $$ImportedMessagesTableReferences),
      ImportedMessageRow,
      PrefetchHooks Function({bool conversationId})
    >;
typedef $$ImportedAttachmentsTableCreateCompanionBuilder =
    ImportedAttachmentsCompanion Function({
      Value<int> id,
      required String conversationId,
      required String privatePath,
      required String displayName,
      required String mime,
      required int byteSize,
      required String digest,
    });
typedef $$ImportedAttachmentsTableUpdateCompanionBuilder =
    ImportedAttachmentsCompanion Function({
      Value<int> id,
      Value<String> conversationId,
      Value<String> privatePath,
      Value<String> displayName,
      Value<String> mime,
      Value<int> byteSize,
      Value<String> digest,
    });

final class $$ImportedAttachmentsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $ImportedAttachmentsTable,
          ImportedAttachmentRow
        > {
  $$ImportedAttachmentsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ImportedConversationsTable _conversationIdTable(_$AppDatabase db) =>
      db.importedConversations.createAlias(
        'imported_attachments__conversation_id__imported_conversations__id',
      );

  $$ImportedConversationsTableProcessedTableManager get conversationId {
    final $_column = $_itemColumn<String>('conversation_id')!;

    final manager = $$ImportedConversationsTableTableManager(
      $_db,
      $_db.importedConversations,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_conversationIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ImportedAttachmentsTableFilterComposer
    extends Composer<_$AppDatabase, $ImportedAttachmentsTable> {
  $$ImportedAttachmentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get privatePath => $composableBuilder(
    column: $table.privatePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mime => $composableBuilder(
    column: $table.mime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get byteSize => $composableBuilder(
    column: $table.byteSize,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get digest => $composableBuilder(
    column: $table.digest,
    builder: (column) => ColumnFilters(column),
  );

  $$ImportedConversationsTableFilterComposer get conversationId {
    final $$ImportedConversationsTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.conversationId,
          referencedTable: $db.importedConversations,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ImportedConversationsTableFilterComposer(
                $db: $db,
                $table: $db.importedConversations,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$ImportedAttachmentsTableOrderingComposer
    extends Composer<_$AppDatabase, $ImportedAttachmentsTable> {
  $$ImportedAttachmentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get privatePath => $composableBuilder(
    column: $table.privatePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mime => $composableBuilder(
    column: $table.mime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get byteSize => $composableBuilder(
    column: $table.byteSize,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get digest => $composableBuilder(
    column: $table.digest,
    builder: (column) => ColumnOrderings(column),
  );

  $$ImportedConversationsTableOrderingComposer get conversationId {
    final $$ImportedConversationsTableOrderingComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.conversationId,
          referencedTable: $db.importedConversations,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ImportedConversationsTableOrderingComposer(
                $db: $db,
                $table: $db.importedConversations,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$ImportedAttachmentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ImportedAttachmentsTable> {
  $$ImportedAttachmentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get privatePath => $composableBuilder(
    column: $table.privatePath,
    builder: (column) => column,
  );

  GeneratedColumn<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get mime =>
      $composableBuilder(column: $table.mime, builder: (column) => column);

  GeneratedColumn<int> get byteSize =>
      $composableBuilder(column: $table.byteSize, builder: (column) => column);

  GeneratedColumn<String> get digest =>
      $composableBuilder(column: $table.digest, builder: (column) => column);

  $$ImportedConversationsTableAnnotationComposer get conversationId {
    final $$ImportedConversationsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.conversationId,
          referencedTable: $db.importedConversations,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ImportedConversationsTableAnnotationComposer(
                $db: $db,
                $table: $db.importedConversations,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$ImportedAttachmentsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ImportedAttachmentsTable,
          ImportedAttachmentRow,
          $$ImportedAttachmentsTableFilterComposer,
          $$ImportedAttachmentsTableOrderingComposer,
          $$ImportedAttachmentsTableAnnotationComposer,
          $$ImportedAttachmentsTableCreateCompanionBuilder,
          $$ImportedAttachmentsTableUpdateCompanionBuilder,
          (ImportedAttachmentRow, $$ImportedAttachmentsTableReferences),
          ImportedAttachmentRow,
          PrefetchHooks Function({bool conversationId})
        > {
  $$ImportedAttachmentsTableTableManager(
    _$AppDatabase db,
    $ImportedAttachmentsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ImportedAttachmentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ImportedAttachmentsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$ImportedAttachmentsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> conversationId = const Value.absent(),
                Value<String> privatePath = const Value.absent(),
                Value<String> displayName = const Value.absent(),
                Value<String> mime = const Value.absent(),
                Value<int> byteSize = const Value.absent(),
                Value<String> digest = const Value.absent(),
              }) => ImportedAttachmentsCompanion(
                id: id,
                conversationId: conversationId,
                privatePath: privatePath,
                displayName: displayName,
                mime: mime,
                byteSize: byteSize,
                digest: digest,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String conversationId,
                required String privatePath,
                required String displayName,
                required String mime,
                required int byteSize,
                required String digest,
              }) => ImportedAttachmentsCompanion.insert(
                id: id,
                conversationId: conversationId,
                privatePath: privatePath,
                displayName: displayName,
                mime: mime,
                byteSize: byteSize,
                digest: digest,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ImportedAttachmentsTable, ImportedAttachmentRow>(
                    table,
                  ),
                  $$ImportedAttachmentsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({conversationId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (conversationId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.conversationId,
                        referencedTable: $$ImportedAttachmentsTableReferences
                            ._conversationIdTable(db),
                        referencedColumn: $$ImportedAttachmentsTableReferences
                            ._conversationIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ImportedAttachmentsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ImportedAttachmentsTable,
      ImportedAttachmentRow,
      $$ImportedAttachmentsTableFilterComposer,
      $$ImportedAttachmentsTableOrderingComposer,
      $$ImportedAttachmentsTableAnnotationComposer,
      $$ImportedAttachmentsTableCreateCompanionBuilder,
      $$ImportedAttachmentsTableUpdateCompanionBuilder,
      (ImportedAttachmentRow, $$ImportedAttachmentsTableReferences),
      ImportedAttachmentRow,
      PrefetchHooks Function({bool conversationId})
    >;
typedef $$DerivedImportResultsTableCreateCompanionBuilder =
    DerivedImportResultsCompanion Function({
      Value<int> id,
      required String conversationId,
      required String derivedJson,
      required DateTime createdAt,
    });
typedef $$DerivedImportResultsTableUpdateCompanionBuilder =
    DerivedImportResultsCompanion Function({
      Value<int> id,
      Value<String> conversationId,
      Value<String> derivedJson,
      Value<DateTime> createdAt,
    });

final class $$DerivedImportResultsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $DerivedImportResultsTable,
          DerivedImportResult
        > {
  $$DerivedImportResultsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ImportedConversationsTable _conversationIdTable(_$AppDatabase db) =>
      db.importedConversations.createAlias(
        'derived_import_results__conversation_id__imported_conversations__id',
      );

  $$ImportedConversationsTableProcessedTableManager get conversationId {
    final $_column = $_itemColumn<String>('conversation_id')!;

    final manager = $$ImportedConversationsTableTableManager(
      $_db,
      $_db.importedConversations,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_conversationIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$DerivedImportResultsTableFilterComposer
    extends Composer<_$AppDatabase, $DerivedImportResultsTable> {
  $$DerivedImportResultsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get derivedJson => $composableBuilder(
    column: $table.derivedJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$ImportedConversationsTableFilterComposer get conversationId {
    final $$ImportedConversationsTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.conversationId,
          referencedTable: $db.importedConversations,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ImportedConversationsTableFilterComposer(
                $db: $db,
                $table: $db.importedConversations,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$DerivedImportResultsTableOrderingComposer
    extends Composer<_$AppDatabase, $DerivedImportResultsTable> {
  $$DerivedImportResultsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get derivedJson => $composableBuilder(
    column: $table.derivedJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$ImportedConversationsTableOrderingComposer get conversationId {
    final $$ImportedConversationsTableOrderingComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.conversationId,
          referencedTable: $db.importedConversations,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ImportedConversationsTableOrderingComposer(
                $db: $db,
                $table: $db.importedConversations,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$DerivedImportResultsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DerivedImportResultsTable> {
  $$DerivedImportResultsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get derivedJson => $composableBuilder(
    column: $table.derivedJson,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$ImportedConversationsTableAnnotationComposer get conversationId {
    final $$ImportedConversationsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.conversationId,
          referencedTable: $db.importedConversations,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ImportedConversationsTableAnnotationComposer(
                $db: $db,
                $table: $db.importedConversations,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$DerivedImportResultsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DerivedImportResultsTable,
          DerivedImportResult,
          $$DerivedImportResultsTableFilterComposer,
          $$DerivedImportResultsTableOrderingComposer,
          $$DerivedImportResultsTableAnnotationComposer,
          $$DerivedImportResultsTableCreateCompanionBuilder,
          $$DerivedImportResultsTableUpdateCompanionBuilder,
          (DerivedImportResult, $$DerivedImportResultsTableReferences),
          DerivedImportResult,
          PrefetchHooks Function({bool conversationId})
        > {
  $$DerivedImportResultsTableTableManager(
    _$AppDatabase db,
    $DerivedImportResultsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DerivedImportResultsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DerivedImportResultsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$DerivedImportResultsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> conversationId = const Value.absent(),
                Value<String> derivedJson = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => DerivedImportResultsCompanion(
                id: id,
                conversationId: conversationId,
                derivedJson: derivedJson,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String conversationId,
                required String derivedJson,
                required DateTime createdAt,
              }) => DerivedImportResultsCompanion.insert(
                id: id,
                conversationId: conversationId,
                derivedJson: derivedJson,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$DerivedImportResultsTable, DerivedImportResult>(
                    table,
                  ),
                  $$DerivedImportResultsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({conversationId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (conversationId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.conversationId,
                        referencedTable: $$DerivedImportResultsTableReferences
                            ._conversationIdTable(db),
                        referencedColumn: $$DerivedImportResultsTableReferences
                            ._conversationIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$DerivedImportResultsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DerivedImportResultsTable,
      DerivedImportResult,
      $$DerivedImportResultsTableFilterComposer,
      $$DerivedImportResultsTableOrderingComposer,
      $$DerivedImportResultsTableAnnotationComposer,
      $$DerivedImportResultsTableCreateCompanionBuilder,
      $$DerivedImportResultsTableUpdateCompanionBuilder,
      (DerivedImportResult, $$DerivedImportResultsTableReferences),
      DerivedImportResult,
      PrefetchHooks Function({bool conversationId})
    >;
typedef $$RoleplaySavesTableCreateCompanionBuilder =
    RoleplaySavesCompanion Function({
      required String worldId,
      required int revision,
      required String payload,
      Value<int> rowid,
    });
typedef $$RoleplaySavesTableUpdateCompanionBuilder =
    RoleplaySavesCompanion Function({
      Value<String> worldId,
      Value<int> revision,
      Value<String> payload,
      Value<int> rowid,
    });

final class $$RoleplaySavesTableReferences
    extends BaseReferences<_$AppDatabase, $RoleplaySavesTable, RoleplaySave> {
  $$RoleplaySavesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $WorldsTable _worldIdTable(_$AppDatabase db) =>
      db.worlds.createAlias('roleplay_saves__world_id__worlds__id');

  $$WorldsTableProcessedTableManager get worldId {
    final $_column = $_itemColumn<String>('world_id')!;

    final manager = $$WorldsTableTableManager(
      $_db,
      $_db.worlds,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_worldIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$RoleplaySavesTableFilterComposer
    extends Composer<_$AppDatabase, $RoleplaySavesTable> {
  $$RoleplaySavesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get revision => $composableBuilder(
    column: $table.revision,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnFilters(column),
  );

  $$WorldsTableFilterComposer get worldId {
    final $$WorldsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.worldId,
      referencedTable: $db.worlds,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorldsTableFilterComposer(
            $db: $db,
            $table: $db.worlds,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RoleplaySavesTableOrderingComposer
    extends Composer<_$AppDatabase, $RoleplaySavesTable> {
  $$RoleplaySavesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get revision => $composableBuilder(
    column: $table.revision,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnOrderings(column),
  );

  $$WorldsTableOrderingComposer get worldId {
    final $$WorldsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.worldId,
      referencedTable: $db.worlds,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorldsTableOrderingComposer(
            $db: $db,
            $table: $db.worlds,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RoleplaySavesTableAnnotationComposer
    extends Composer<_$AppDatabase, $RoleplaySavesTable> {
  $$RoleplaySavesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get revision =>
      $composableBuilder(column: $table.revision, builder: (column) => column);

  GeneratedColumn<String> get payload =>
      $composableBuilder(column: $table.payload, builder: (column) => column);

  $$WorldsTableAnnotationComposer get worldId {
    final $$WorldsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.worldId,
      referencedTable: $db.worlds,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorldsTableAnnotationComposer(
            $db: $db,
            $table: $db.worlds,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RoleplaySavesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RoleplaySavesTable,
          RoleplaySave,
          $$RoleplaySavesTableFilterComposer,
          $$RoleplaySavesTableOrderingComposer,
          $$RoleplaySavesTableAnnotationComposer,
          $$RoleplaySavesTableCreateCompanionBuilder,
          $$RoleplaySavesTableUpdateCompanionBuilder,
          (RoleplaySave, $$RoleplaySavesTableReferences),
          RoleplaySave,
          PrefetchHooks Function({bool worldId})
        > {
  $$RoleplaySavesTableTableManager(_$AppDatabase db, $RoleplaySavesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RoleplaySavesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RoleplaySavesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RoleplaySavesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> worldId = const Value.absent(),
                Value<int> revision = const Value.absent(),
                Value<String> payload = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RoleplaySavesCompanion(
                worldId: worldId,
                revision: revision,
                payload: payload,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String worldId,
                required int revision,
                required String payload,
                Value<int> rowid = const Value.absent(),
              }) => RoleplaySavesCompanion.insert(
                worldId: worldId,
                revision: revision,
                payload: payload,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$RoleplaySavesTable, RoleplaySave>(table),
                  $$RoleplaySavesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({worldId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (worldId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.worldId,
                        referencedTable: $$RoleplaySavesTableReferences
                            ._worldIdTable(db),
                        referencedColumn: $$RoleplaySavesTableReferences
                            ._worldIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$RoleplaySavesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RoleplaySavesTable,
      RoleplaySave,
      $$RoleplaySavesTableFilterComposer,
      $$RoleplaySavesTableOrderingComposer,
      $$RoleplaySavesTableAnnotationComposer,
      $$RoleplaySavesTableCreateCompanionBuilder,
      $$RoleplaySavesTableUpdateCompanionBuilder,
      (RoleplaySave, $$RoleplaySavesTableReferences),
      RoleplaySave,
      PrefetchHooks Function({bool worldId})
    >;
typedef $$RoleplayTurnsTableCreateCompanionBuilder =
    RoleplayTurnsCompanion Function({
      required String id,
      required String worldId,
      required int baseRevision,
      required String action,
      required String speaker,
      required String contextJson,
      required String state,
      Value<String?> responseJson,
      required bool mock,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$RoleplayTurnsTableUpdateCompanionBuilder =
    RoleplayTurnsCompanion Function({
      Value<String> id,
      Value<String> worldId,
      Value<int> baseRevision,
      Value<String> action,
      Value<String> speaker,
      Value<String> contextJson,
      Value<String> state,
      Value<String?> responseJson,
      Value<bool> mock,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

final class $$RoleplayTurnsTableReferences
    extends BaseReferences<_$AppDatabase, $RoleplayTurnsTable, RoleplayTurn> {
  $$RoleplayTurnsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $WorldsTable _worldIdTable(_$AppDatabase db) =>
      db.worlds.createAlias('roleplay_turns__world_id__worlds__id');

  $$WorldsTableProcessedTableManager get worldId {
    final $_column = $_itemColumn<String>('world_id')!;

    final manager = $$WorldsTableTableManager(
      $_db,
      $_db.worlds,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_worldIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$RoleplayTurnsTableFilterComposer
    extends Composer<_$AppDatabase, $RoleplayTurnsTable> {
  $$RoleplayTurnsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get baseRevision => $composableBuilder(
    column: $table.baseRevision,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get action => $composableBuilder(
    column: $table.action,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get speaker => $composableBuilder(
    column: $table.speaker,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get contextJson => $composableBuilder(
    column: $table.contextJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get state => $composableBuilder(
    column: $table.state,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get responseJson => $composableBuilder(
    column: $table.responseJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get mock => $composableBuilder(
    column: $table.mock,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$WorldsTableFilterComposer get worldId {
    final $$WorldsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.worldId,
      referencedTable: $db.worlds,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorldsTableFilterComposer(
            $db: $db,
            $table: $db.worlds,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RoleplayTurnsTableOrderingComposer
    extends Composer<_$AppDatabase, $RoleplayTurnsTable> {
  $$RoleplayTurnsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get baseRevision => $composableBuilder(
    column: $table.baseRevision,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get action => $composableBuilder(
    column: $table.action,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get speaker => $composableBuilder(
    column: $table.speaker,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get contextJson => $composableBuilder(
    column: $table.contextJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get state => $composableBuilder(
    column: $table.state,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get responseJson => $composableBuilder(
    column: $table.responseJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get mock => $composableBuilder(
    column: $table.mock,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$WorldsTableOrderingComposer get worldId {
    final $$WorldsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.worldId,
      referencedTable: $db.worlds,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorldsTableOrderingComposer(
            $db: $db,
            $table: $db.worlds,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RoleplayTurnsTableAnnotationComposer
    extends Composer<_$AppDatabase, $RoleplayTurnsTable> {
  $$RoleplayTurnsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get baseRevision => $composableBuilder(
    column: $table.baseRevision,
    builder: (column) => column,
  );

  GeneratedColumn<String> get action =>
      $composableBuilder(column: $table.action, builder: (column) => column);

  GeneratedColumn<String> get speaker =>
      $composableBuilder(column: $table.speaker, builder: (column) => column);

  GeneratedColumn<String> get contextJson => $composableBuilder(
    column: $table.contextJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get state =>
      $composableBuilder(column: $table.state, builder: (column) => column);

  GeneratedColumn<String> get responseJson => $composableBuilder(
    column: $table.responseJson,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get mock =>
      $composableBuilder(column: $table.mock, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$WorldsTableAnnotationComposer get worldId {
    final $$WorldsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.worldId,
      referencedTable: $db.worlds,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorldsTableAnnotationComposer(
            $db: $db,
            $table: $db.worlds,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RoleplayTurnsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RoleplayTurnsTable,
          RoleplayTurn,
          $$RoleplayTurnsTableFilterComposer,
          $$RoleplayTurnsTableOrderingComposer,
          $$RoleplayTurnsTableAnnotationComposer,
          $$RoleplayTurnsTableCreateCompanionBuilder,
          $$RoleplayTurnsTableUpdateCompanionBuilder,
          (RoleplayTurn, $$RoleplayTurnsTableReferences),
          RoleplayTurn,
          PrefetchHooks Function({bool worldId})
        > {
  $$RoleplayTurnsTableTableManager(_$AppDatabase db, $RoleplayTurnsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RoleplayTurnsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RoleplayTurnsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RoleplayTurnsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> worldId = const Value.absent(),
                Value<int> baseRevision = const Value.absent(),
                Value<String> action = const Value.absent(),
                Value<String> speaker = const Value.absent(),
                Value<String> contextJson = const Value.absent(),
                Value<String> state = const Value.absent(),
                Value<String?> responseJson = const Value.absent(),
                Value<bool> mock = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RoleplayTurnsCompanion(
                id: id,
                worldId: worldId,
                baseRevision: baseRevision,
                action: action,
                speaker: speaker,
                contextJson: contextJson,
                state: state,
                responseJson: responseJson,
                mock: mock,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String worldId,
                required int baseRevision,
                required String action,
                required String speaker,
                required String contextJson,
                required String state,
                Value<String?> responseJson = const Value.absent(),
                required bool mock,
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => RoleplayTurnsCompanion.insert(
                id: id,
                worldId: worldId,
                baseRevision: baseRevision,
                action: action,
                speaker: speaker,
                contextJson: contextJson,
                state: state,
                responseJson: responseJson,
                mock: mock,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$RoleplayTurnsTable, RoleplayTurn>(table),
                  $$RoleplayTurnsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({worldId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (worldId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.worldId,
                        referencedTable: $$RoleplayTurnsTableReferences
                            ._worldIdTable(db),
                        referencedColumn: $$RoleplayTurnsTableReferences
                            ._worldIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$RoleplayTurnsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RoleplayTurnsTable,
      RoleplayTurn,
      $$RoleplayTurnsTableFilterComposer,
      $$RoleplayTurnsTableOrderingComposer,
      $$RoleplayTurnsTableAnnotationComposer,
      $$RoleplayTurnsTableCreateCompanionBuilder,
      $$RoleplayTurnsTableUpdateCompanionBuilder,
      (RoleplayTurn, $$RoleplayTurnsTableReferences),
      RoleplayTurn,
      PrefetchHooks Function({bool worldId})
    >;
typedef $$RoleplayMemoriesTableCreateCompanionBuilder =
    RoleplayMemoriesCompanion Function({
      required String id,
      required String worldId,
      required String owner,
      required String payload,
      Value<int> rowid,
    });
typedef $$RoleplayMemoriesTableUpdateCompanionBuilder =
    RoleplayMemoriesCompanion Function({
      Value<String> id,
      Value<String> worldId,
      Value<String> owner,
      Value<String> payload,
      Value<int> rowid,
    });

final class $$RoleplayMemoriesTableReferences
    extends
        BaseReferences<_$AppDatabase, $RoleplayMemoriesTable, RoleplayMemory> {
  $$RoleplayMemoriesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $WorldsTable _worldIdTable(_$AppDatabase db) =>
      db.worlds.createAlias('roleplay_memories__world_id__worlds__id');

  $$WorldsTableProcessedTableManager get worldId {
    final $_column = $_itemColumn<String>('world_id')!;

    final manager = $$WorldsTableTableManager(
      $_db,
      $_db.worlds,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_worldIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$RoleplayMemoriesTableFilterComposer
    extends Composer<_$AppDatabase, $RoleplayMemoriesTable> {
  $$RoleplayMemoriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get owner => $composableBuilder(
    column: $table.owner,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnFilters(column),
  );

  $$WorldsTableFilterComposer get worldId {
    final $$WorldsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.worldId,
      referencedTable: $db.worlds,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorldsTableFilterComposer(
            $db: $db,
            $table: $db.worlds,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RoleplayMemoriesTableOrderingComposer
    extends Composer<_$AppDatabase, $RoleplayMemoriesTable> {
  $$RoleplayMemoriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get owner => $composableBuilder(
    column: $table.owner,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnOrderings(column),
  );

  $$WorldsTableOrderingComposer get worldId {
    final $$WorldsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.worldId,
      referencedTable: $db.worlds,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorldsTableOrderingComposer(
            $db: $db,
            $table: $db.worlds,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RoleplayMemoriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $RoleplayMemoriesTable> {
  $$RoleplayMemoriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get owner =>
      $composableBuilder(column: $table.owner, builder: (column) => column);

  GeneratedColumn<String> get payload =>
      $composableBuilder(column: $table.payload, builder: (column) => column);

  $$WorldsTableAnnotationComposer get worldId {
    final $$WorldsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.worldId,
      referencedTable: $db.worlds,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorldsTableAnnotationComposer(
            $db: $db,
            $table: $db.worlds,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RoleplayMemoriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RoleplayMemoriesTable,
          RoleplayMemory,
          $$RoleplayMemoriesTableFilterComposer,
          $$RoleplayMemoriesTableOrderingComposer,
          $$RoleplayMemoriesTableAnnotationComposer,
          $$RoleplayMemoriesTableCreateCompanionBuilder,
          $$RoleplayMemoriesTableUpdateCompanionBuilder,
          (RoleplayMemory, $$RoleplayMemoriesTableReferences),
          RoleplayMemory,
          PrefetchHooks Function({bool worldId})
        > {
  $$RoleplayMemoriesTableTableManager(
    _$AppDatabase db,
    $RoleplayMemoriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RoleplayMemoriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RoleplayMemoriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RoleplayMemoriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> worldId = const Value.absent(),
                Value<String> owner = const Value.absent(),
                Value<String> payload = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RoleplayMemoriesCompanion(
                id: id,
                worldId: worldId,
                owner: owner,
                payload: payload,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String worldId,
                required String owner,
                required String payload,
                Value<int> rowid = const Value.absent(),
              }) => RoleplayMemoriesCompanion.insert(
                id: id,
                worldId: worldId,
                owner: owner,
                payload: payload,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$RoleplayMemoriesTable, RoleplayMemory>(table),
                  $$RoleplayMemoriesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({worldId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (worldId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.worldId,
                        referencedTable: $$RoleplayMemoriesTableReferences
                            ._worldIdTable(db),
                        referencedColumn: $$RoleplayMemoriesTableReferences
                            ._worldIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$RoleplayMemoriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RoleplayMemoriesTable,
      RoleplayMemory,
      $$RoleplayMemoriesTableFilterComposer,
      $$RoleplayMemoriesTableOrderingComposer,
      $$RoleplayMemoriesTableAnnotationComposer,
      $$RoleplayMemoriesTableCreateCompanionBuilder,
      $$RoleplayMemoriesTableUpdateCompanionBuilder,
      (RoleplayMemory, $$RoleplayMemoriesTableReferences),
      RoleplayMemory,
      PrefetchHooks Function({bool worldId})
    >;
typedef $$StoryCheckpointsTableCreateCompanionBuilder =
    StoryCheckpointsCompanion Function({
      required String id,
      required String worldId,
      required int revision,
      required String payload,
      Value<String?> sourceConversation,
      Value<String?> sourceMessageId,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$StoryCheckpointsTableUpdateCompanionBuilder =
    StoryCheckpointsCompanion Function({
      Value<String> id,
      Value<String> worldId,
      Value<int> revision,
      Value<String> payload,
      Value<String?> sourceConversation,
      Value<String?> sourceMessageId,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

final class $$StoryCheckpointsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $StoryCheckpointsTable,
          StoryCheckpointRow
        > {
  $$StoryCheckpointsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $WorldsTable _worldIdTable(_$AppDatabase db) =>
      db.worlds.createAlias('story_checkpoints__world_id__worlds__id');

  $$WorldsTableProcessedTableManager get worldId {
    final $_column = $_itemColumn<String>('world_id')!;

    final manager = $$WorldsTableTableManager(
      $_db,
      $_db.worlds,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_worldIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$StoryCheckpointsTableFilterComposer
    extends Composer<_$AppDatabase, $StoryCheckpointsTable> {
  $$StoryCheckpointsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get revision => $composableBuilder(
    column: $table.revision,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceConversation => $composableBuilder(
    column: $table.sourceConversation,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceMessageId => $composableBuilder(
    column: $table.sourceMessageId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$WorldsTableFilterComposer get worldId {
    final $$WorldsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.worldId,
      referencedTable: $db.worlds,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorldsTableFilterComposer(
            $db: $db,
            $table: $db.worlds,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$StoryCheckpointsTableOrderingComposer
    extends Composer<_$AppDatabase, $StoryCheckpointsTable> {
  $$StoryCheckpointsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get revision => $composableBuilder(
    column: $table.revision,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceConversation => $composableBuilder(
    column: $table.sourceConversation,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceMessageId => $composableBuilder(
    column: $table.sourceMessageId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$WorldsTableOrderingComposer get worldId {
    final $$WorldsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.worldId,
      referencedTable: $db.worlds,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorldsTableOrderingComposer(
            $db: $db,
            $table: $db.worlds,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$StoryCheckpointsTableAnnotationComposer
    extends Composer<_$AppDatabase, $StoryCheckpointsTable> {
  $$StoryCheckpointsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get revision =>
      $composableBuilder(column: $table.revision, builder: (column) => column);

  GeneratedColumn<String> get payload =>
      $composableBuilder(column: $table.payload, builder: (column) => column);

  GeneratedColumn<String> get sourceConversation => $composableBuilder(
    column: $table.sourceConversation,
    builder: (column) => column,
  );

  GeneratedColumn<String> get sourceMessageId => $composableBuilder(
    column: $table.sourceMessageId,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$WorldsTableAnnotationComposer get worldId {
    final $$WorldsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.worldId,
      referencedTable: $db.worlds,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorldsTableAnnotationComposer(
            $db: $db,
            $table: $db.worlds,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$StoryCheckpointsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $StoryCheckpointsTable,
          StoryCheckpointRow,
          $$StoryCheckpointsTableFilterComposer,
          $$StoryCheckpointsTableOrderingComposer,
          $$StoryCheckpointsTableAnnotationComposer,
          $$StoryCheckpointsTableCreateCompanionBuilder,
          $$StoryCheckpointsTableUpdateCompanionBuilder,
          (StoryCheckpointRow, $$StoryCheckpointsTableReferences),
          StoryCheckpointRow,
          PrefetchHooks Function({bool worldId})
        > {
  $$StoryCheckpointsTableTableManager(
    _$AppDatabase db,
    $StoryCheckpointsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StoryCheckpointsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StoryCheckpointsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StoryCheckpointsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> worldId = const Value.absent(),
                Value<int> revision = const Value.absent(),
                Value<String> payload = const Value.absent(),
                Value<String?> sourceConversation = const Value.absent(),
                Value<String?> sourceMessageId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => StoryCheckpointsCompanion(
                id: id,
                worldId: worldId,
                revision: revision,
                payload: payload,
                sourceConversation: sourceConversation,
                sourceMessageId: sourceMessageId,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String worldId,
                required int revision,
                required String payload,
                Value<String?> sourceConversation = const Value.absent(),
                Value<String?> sourceMessageId = const Value.absent(),
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => StoryCheckpointsCompanion.insert(
                id: id,
                worldId: worldId,
                revision: revision,
                payload: payload,
                sourceConversation: sourceConversation,
                sourceMessageId: sourceMessageId,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$StoryCheckpointsTable, StoryCheckpointRow>(
                    table,
                  ),
                  $$StoryCheckpointsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({worldId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (worldId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.worldId,
                        referencedTable: $$StoryCheckpointsTableReferences
                            ._worldIdTable(db),
                        referencedColumn: $$StoryCheckpointsTableReferences
                            ._worldIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$StoryCheckpointsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $StoryCheckpointsTable,
      StoryCheckpointRow,
      $$StoryCheckpointsTableFilterComposer,
      $$StoryCheckpointsTableOrderingComposer,
      $$StoryCheckpointsTableAnnotationComposer,
      $$StoryCheckpointsTableCreateCompanionBuilder,
      $$StoryCheckpointsTableUpdateCompanionBuilder,
      (StoryCheckpointRow, $$StoryCheckpointsTableReferences),
      StoryCheckpointRow,
      PrefetchHooks Function({bool worldId})
    >;
typedef $$StoryBranchesTableCreateCompanionBuilder =
    StoryBranchesCompanion Function({
      required String worldId,
      Value<String?> parentWorldId,
      Value<String?> checkpointId,
      Value<String?> sourceConversation,
      Value<String?> sourceMessageId,
      Value<int> rowid,
    });
typedef $$StoryBranchesTableUpdateCompanionBuilder =
    StoryBranchesCompanion Function({
      Value<String> worldId,
      Value<String?> parentWorldId,
      Value<String?> checkpointId,
      Value<String?> sourceConversation,
      Value<String?> sourceMessageId,
      Value<int> rowid,
    });

final class $$StoryBranchesTableReferences
    extends BaseReferences<_$AppDatabase, $StoryBranchesTable, StoryBranche> {
  $$StoryBranchesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $WorldsTable _worldIdTable(_$AppDatabase db) =>
      db.worlds.createAlias('story_branches__world_id__worlds__id');

  $$WorldsTableProcessedTableManager get worldId {
    final $_column = $_itemColumn<String>('world_id')!;

    final manager = $$WorldsTableTableManager(
      $_db,
      $_db.worlds,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_worldIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$StoryBranchesTableFilterComposer
    extends Composer<_$AppDatabase, $StoryBranchesTable> {
  $$StoryBranchesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get parentWorldId => $composableBuilder(
    column: $table.parentWorldId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get checkpointId => $composableBuilder(
    column: $table.checkpointId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceConversation => $composableBuilder(
    column: $table.sourceConversation,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceMessageId => $composableBuilder(
    column: $table.sourceMessageId,
    builder: (column) => ColumnFilters(column),
  );

  $$WorldsTableFilterComposer get worldId {
    final $$WorldsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.worldId,
      referencedTable: $db.worlds,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorldsTableFilterComposer(
            $db: $db,
            $table: $db.worlds,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$StoryBranchesTableOrderingComposer
    extends Composer<_$AppDatabase, $StoryBranchesTable> {
  $$StoryBranchesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get parentWorldId => $composableBuilder(
    column: $table.parentWorldId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get checkpointId => $composableBuilder(
    column: $table.checkpointId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceConversation => $composableBuilder(
    column: $table.sourceConversation,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceMessageId => $composableBuilder(
    column: $table.sourceMessageId,
    builder: (column) => ColumnOrderings(column),
  );

  $$WorldsTableOrderingComposer get worldId {
    final $$WorldsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.worldId,
      referencedTable: $db.worlds,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorldsTableOrderingComposer(
            $db: $db,
            $table: $db.worlds,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$StoryBranchesTableAnnotationComposer
    extends Composer<_$AppDatabase, $StoryBranchesTable> {
  $$StoryBranchesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get parentWorldId => $composableBuilder(
    column: $table.parentWorldId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get checkpointId => $composableBuilder(
    column: $table.checkpointId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get sourceConversation => $composableBuilder(
    column: $table.sourceConversation,
    builder: (column) => column,
  );

  GeneratedColumn<String> get sourceMessageId => $composableBuilder(
    column: $table.sourceMessageId,
    builder: (column) => column,
  );

  $$WorldsTableAnnotationComposer get worldId {
    final $$WorldsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.worldId,
      referencedTable: $db.worlds,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorldsTableAnnotationComposer(
            $db: $db,
            $table: $db.worlds,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$StoryBranchesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $StoryBranchesTable,
          StoryBranche,
          $$StoryBranchesTableFilterComposer,
          $$StoryBranchesTableOrderingComposer,
          $$StoryBranchesTableAnnotationComposer,
          $$StoryBranchesTableCreateCompanionBuilder,
          $$StoryBranchesTableUpdateCompanionBuilder,
          (StoryBranche, $$StoryBranchesTableReferences),
          StoryBranche,
          PrefetchHooks Function({bool worldId})
        > {
  $$StoryBranchesTableTableManager(_$AppDatabase db, $StoryBranchesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StoryBranchesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StoryBranchesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StoryBranchesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> worldId = const Value.absent(),
                Value<String?> parentWorldId = const Value.absent(),
                Value<String?> checkpointId = const Value.absent(),
                Value<String?> sourceConversation = const Value.absent(),
                Value<String?> sourceMessageId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => StoryBranchesCompanion(
                worldId: worldId,
                parentWorldId: parentWorldId,
                checkpointId: checkpointId,
                sourceConversation: sourceConversation,
                sourceMessageId: sourceMessageId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String worldId,
                Value<String?> parentWorldId = const Value.absent(),
                Value<String?> checkpointId = const Value.absent(),
                Value<String?> sourceConversation = const Value.absent(),
                Value<String?> sourceMessageId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => StoryBranchesCompanion.insert(
                worldId: worldId,
                parentWorldId: parentWorldId,
                checkpointId: checkpointId,
                sourceConversation: sourceConversation,
                sourceMessageId: sourceMessageId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$StoryBranchesTable, StoryBranche>(table),
                  $$StoryBranchesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({worldId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (worldId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.worldId,
                        referencedTable: $$StoryBranchesTableReferences
                            ._worldIdTable(db),
                        referencedColumn: $$StoryBranchesTableReferences
                            ._worldIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$StoryBranchesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $StoryBranchesTable,
      StoryBranche,
      $$StoryBranchesTableFilterComposer,
      $$StoryBranchesTableOrderingComposer,
      $$StoryBranchesTableAnnotationComposer,
      $$StoryBranchesTableCreateCompanionBuilder,
      $$StoryBranchesTableUpdateCompanionBuilder,
      (StoryBranche, $$StoryBranchesTableReferences),
      StoryBranche,
      PrefetchHooks Function({bool worldId})
    >;
typedef $$TimelineEntriesTableCreateCompanionBuilder =
    TimelineEntriesCompanion Function({
      required String id,
      required String worldId,
      required int revision,
      required String payload,
      Value<int> rowid,
    });
typedef $$TimelineEntriesTableUpdateCompanionBuilder =
    TimelineEntriesCompanion Function({
      Value<String> id,
      Value<String> worldId,
      Value<int> revision,
      Value<String> payload,
      Value<int> rowid,
    });

final class $$TimelineEntriesTableReferences
    extends
        BaseReferences<_$AppDatabase, $TimelineEntriesTable, TimelineEntry> {
  $$TimelineEntriesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $WorldsTable _worldIdTable(_$AppDatabase db) =>
      db.worlds.createAlias('timeline_entries__world_id__worlds__id');

  $$WorldsTableProcessedTableManager get worldId {
    final $_column = $_itemColumn<String>('world_id')!;

    final manager = $$WorldsTableTableManager(
      $_db,
      $_db.worlds,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_worldIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$TimelineEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $TimelineEntriesTable> {
  $$TimelineEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get revision => $composableBuilder(
    column: $table.revision,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnFilters(column),
  );

  $$WorldsTableFilterComposer get worldId {
    final $$WorldsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.worldId,
      referencedTable: $db.worlds,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorldsTableFilterComposer(
            $db: $db,
            $table: $db.worlds,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TimelineEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $TimelineEntriesTable> {
  $$TimelineEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get revision => $composableBuilder(
    column: $table.revision,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnOrderings(column),
  );

  $$WorldsTableOrderingComposer get worldId {
    final $$WorldsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.worldId,
      referencedTable: $db.worlds,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorldsTableOrderingComposer(
            $db: $db,
            $table: $db.worlds,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TimelineEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $TimelineEntriesTable> {
  $$TimelineEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get revision =>
      $composableBuilder(column: $table.revision, builder: (column) => column);

  GeneratedColumn<String> get payload =>
      $composableBuilder(column: $table.payload, builder: (column) => column);

  $$WorldsTableAnnotationComposer get worldId {
    final $$WorldsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.worldId,
      referencedTable: $db.worlds,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorldsTableAnnotationComposer(
            $db: $db,
            $table: $db.worlds,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TimelineEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TimelineEntriesTable,
          TimelineEntry,
          $$TimelineEntriesTableFilterComposer,
          $$TimelineEntriesTableOrderingComposer,
          $$TimelineEntriesTableAnnotationComposer,
          $$TimelineEntriesTableCreateCompanionBuilder,
          $$TimelineEntriesTableUpdateCompanionBuilder,
          (TimelineEntry, $$TimelineEntriesTableReferences),
          TimelineEntry,
          PrefetchHooks Function({bool worldId})
        > {
  $$TimelineEntriesTableTableManager(
    _$AppDatabase db,
    $TimelineEntriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TimelineEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TimelineEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TimelineEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> worldId = const Value.absent(),
                Value<int> revision = const Value.absent(),
                Value<String> payload = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TimelineEntriesCompanion(
                id: id,
                worldId: worldId,
                revision: revision,
                payload: payload,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String worldId,
                required int revision,
                required String payload,
                Value<int> rowid = const Value.absent(),
              }) => TimelineEntriesCompanion.insert(
                id: id,
                worldId: worldId,
                revision: revision,
                payload: payload,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$TimelineEntriesTable, TimelineEntry>(table),
                  $$TimelineEntriesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({worldId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (worldId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.worldId,
                        referencedTable: $$TimelineEntriesTableReferences
                            ._worldIdTable(db),
                        referencedColumn: $$TimelineEntriesTableReferences
                            ._worldIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$TimelineEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TimelineEntriesTable,
      TimelineEntry,
      $$TimelineEntriesTableFilterComposer,
      $$TimelineEntriesTableOrderingComposer,
      $$TimelineEntriesTableAnnotationComposer,
      $$TimelineEntriesTableCreateCompanionBuilder,
      $$TimelineEntriesTableUpdateCompanionBuilder,
      (TimelineEntry, $$TimelineEntriesTableReferences),
      TimelineEntry,
      PrefetchHooks Function({bool worldId})
    >;
typedef $$ContextSummariesTableCreateCompanionBuilder =
    ContextSummariesCompanion Function({
      required String worldId,
      required String owner,
      required int version,
      required int throughRevision,
      required String payload,
      Value<int> rowid,
    });
typedef $$ContextSummariesTableUpdateCompanionBuilder =
    ContextSummariesCompanion Function({
      Value<String> worldId,
      Value<String> owner,
      Value<int> version,
      Value<int> throughRevision,
      Value<String> payload,
      Value<int> rowid,
    });

final class $$ContextSummariesTableReferences
    extends
        BaseReferences<_$AppDatabase, $ContextSummariesTable, ContextSummary> {
  $$ContextSummariesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $WorldsTable _worldIdTable(_$AppDatabase db) =>
      db.worlds.createAlias('context_summaries__world_id__worlds__id');

  $$WorldsTableProcessedTableManager get worldId {
    final $_column = $_itemColumn<String>('world_id')!;

    final manager = $$WorldsTableTableManager(
      $_db,
      $_db.worlds,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_worldIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ContextSummariesTableFilterComposer
    extends Composer<_$AppDatabase, $ContextSummariesTable> {
  $$ContextSummariesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get owner => $composableBuilder(
    column: $table.owner,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get throughRevision => $composableBuilder(
    column: $table.throughRevision,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnFilters(column),
  );

  $$WorldsTableFilterComposer get worldId {
    final $$WorldsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.worldId,
      referencedTable: $db.worlds,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorldsTableFilterComposer(
            $db: $db,
            $table: $db.worlds,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ContextSummariesTableOrderingComposer
    extends Composer<_$AppDatabase, $ContextSummariesTable> {
  $$ContextSummariesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get owner => $composableBuilder(
    column: $table.owner,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get throughRevision => $composableBuilder(
    column: $table.throughRevision,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnOrderings(column),
  );

  $$WorldsTableOrderingComposer get worldId {
    final $$WorldsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.worldId,
      referencedTable: $db.worlds,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorldsTableOrderingComposer(
            $db: $db,
            $table: $db.worlds,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ContextSummariesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ContextSummariesTable> {
  $$ContextSummariesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get owner =>
      $composableBuilder(column: $table.owner, builder: (column) => column);

  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  GeneratedColumn<int> get throughRevision => $composableBuilder(
    column: $table.throughRevision,
    builder: (column) => column,
  );

  GeneratedColumn<String> get payload =>
      $composableBuilder(column: $table.payload, builder: (column) => column);

  $$WorldsTableAnnotationComposer get worldId {
    final $$WorldsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.worldId,
      referencedTable: $db.worlds,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorldsTableAnnotationComposer(
            $db: $db,
            $table: $db.worlds,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ContextSummariesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ContextSummariesTable,
          ContextSummary,
          $$ContextSummariesTableFilterComposer,
          $$ContextSummariesTableOrderingComposer,
          $$ContextSummariesTableAnnotationComposer,
          $$ContextSummariesTableCreateCompanionBuilder,
          $$ContextSummariesTableUpdateCompanionBuilder,
          (ContextSummary, $$ContextSummariesTableReferences),
          ContextSummary,
          PrefetchHooks Function({bool worldId})
        > {
  $$ContextSummariesTableTableManager(
    _$AppDatabase db,
    $ContextSummariesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ContextSummariesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ContextSummariesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ContextSummariesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> worldId = const Value.absent(),
                Value<String> owner = const Value.absent(),
                Value<int> version = const Value.absent(),
                Value<int> throughRevision = const Value.absent(),
                Value<String> payload = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ContextSummariesCompanion(
                worldId: worldId,
                owner: owner,
                version: version,
                throughRevision: throughRevision,
                payload: payload,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String worldId,
                required String owner,
                required int version,
                required int throughRevision,
                required String payload,
                Value<int> rowid = const Value.absent(),
              }) => ContextSummariesCompanion.insert(
                worldId: worldId,
                owner: owner,
                version: version,
                throughRevision: throughRevision,
                payload: payload,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ContextSummariesTable, ContextSummary>(table),
                  $$ContextSummariesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({worldId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (worldId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.worldId,
                        referencedTable: $$ContextSummariesTableReferences
                            ._worldIdTable(db),
                        referencedColumn: $$ContextSummariesTableReferences
                            ._worldIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ContextSummariesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ContextSummariesTable,
      ContextSummary,
      $$ContextSummariesTableFilterComposer,
      $$ContextSummariesTableOrderingComposer,
      $$ContextSummariesTableAnnotationComposer,
      $$ContextSummariesTableCreateCompanionBuilder,
      $$ContextSummariesTableUpdateCompanionBuilder,
      (ContextSummary, $$ContextSummariesTableReferences),
      ContextSummary,
      PrefetchHooks Function({bool worldId})
    >;
typedef $$WorldDefinitionsTableCreateCompanionBuilder =
    WorldDefinitionsCompanion Function({
      required String worldId,
      required int version,
      required String payload,
      required DateTime savedAt,
      Value<int> rowid,
    });
typedef $$WorldDefinitionsTableUpdateCompanionBuilder =
    WorldDefinitionsCompanion Function({
      Value<String> worldId,
      Value<int> version,
      Value<String> payload,
      Value<DateTime> savedAt,
      Value<int> rowid,
    });

final class $$WorldDefinitionsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $WorldDefinitionsTable,
          WorldDefinitionRow
        > {
  $$WorldDefinitionsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $WorldsTable _worldIdTable(_$AppDatabase db) =>
      db.worlds.createAlias('world_definitions__world_id__worlds__id');

  $$WorldsTableProcessedTableManager get worldId {
    final $_column = $_itemColumn<String>('world_id')!;

    final manager = $$WorldsTableTableManager(
      $_db,
      $_db.worlds,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_worldIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$WorldDefinitionsTableFilterComposer
    extends Composer<_$AppDatabase, $WorldDefinitionsTable> {
  $$WorldDefinitionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get savedAt => $composableBuilder(
    column: $table.savedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$WorldsTableFilterComposer get worldId {
    final $$WorldsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.worldId,
      referencedTable: $db.worlds,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorldsTableFilterComposer(
            $db: $db,
            $table: $db.worlds,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WorldDefinitionsTableOrderingComposer
    extends Composer<_$AppDatabase, $WorldDefinitionsTable> {
  $$WorldDefinitionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get savedAt => $composableBuilder(
    column: $table.savedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$WorldsTableOrderingComposer get worldId {
    final $$WorldsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.worldId,
      referencedTable: $db.worlds,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorldsTableOrderingComposer(
            $db: $db,
            $table: $db.worlds,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WorldDefinitionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $WorldDefinitionsTable> {
  $$WorldDefinitionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  GeneratedColumn<String> get payload =>
      $composableBuilder(column: $table.payload, builder: (column) => column);

  GeneratedColumn<DateTime> get savedAt =>
      $composableBuilder(column: $table.savedAt, builder: (column) => column);

  $$WorldsTableAnnotationComposer get worldId {
    final $$WorldsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.worldId,
      referencedTable: $db.worlds,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorldsTableAnnotationComposer(
            $db: $db,
            $table: $db.worlds,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WorldDefinitionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WorldDefinitionsTable,
          WorldDefinitionRow,
          $$WorldDefinitionsTableFilterComposer,
          $$WorldDefinitionsTableOrderingComposer,
          $$WorldDefinitionsTableAnnotationComposer,
          $$WorldDefinitionsTableCreateCompanionBuilder,
          $$WorldDefinitionsTableUpdateCompanionBuilder,
          (WorldDefinitionRow, $$WorldDefinitionsTableReferences),
          WorldDefinitionRow,
          PrefetchHooks Function({bool worldId})
        > {
  $$WorldDefinitionsTableTableManager(
    _$AppDatabase db,
    $WorldDefinitionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WorldDefinitionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WorldDefinitionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WorldDefinitionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> worldId = const Value.absent(),
                Value<int> version = const Value.absent(),
                Value<String> payload = const Value.absent(),
                Value<DateTime> savedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WorldDefinitionsCompanion(
                worldId: worldId,
                version: version,
                payload: payload,
                savedAt: savedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String worldId,
                required int version,
                required String payload,
                required DateTime savedAt,
                Value<int> rowid = const Value.absent(),
              }) => WorldDefinitionsCompanion.insert(
                worldId: worldId,
                version: version,
                payload: payload,
                savedAt: savedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$WorldDefinitionsTable, WorldDefinitionRow>(
                    table,
                  ),
                  $$WorldDefinitionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({worldId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (worldId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.worldId,
                        referencedTable: $$WorldDefinitionsTableReferences
                            ._worldIdTable(db),
                        referencedColumn: $$WorldDefinitionsTableReferences
                            ._worldIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$WorldDefinitionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WorldDefinitionsTable,
      WorldDefinitionRow,
      $$WorldDefinitionsTableFilterComposer,
      $$WorldDefinitionsTableOrderingComposer,
      $$WorldDefinitionsTableAnnotationComposer,
      $$WorldDefinitionsTableCreateCompanionBuilder,
      $$WorldDefinitionsTableUpdateCompanionBuilder,
      (WorldDefinitionRow, $$WorldDefinitionsTableReferences),
      WorldDefinitionRow,
      PrefetchHooks Function({bool worldId})
    >;
typedef $$WorldDraftsTableCreateCompanionBuilder =
    WorldDraftsCompanion Function({
      required String id,
      required String payload,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$WorldDraftsTableUpdateCompanionBuilder =
    WorldDraftsCompanion Function({
      Value<String> id,
      Value<String> payload,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$WorldDraftsTableFilterComposer
    extends Composer<_$AppDatabase, $WorldDraftsTable> {
  $$WorldDraftsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$WorldDraftsTableOrderingComposer
    extends Composer<_$AppDatabase, $WorldDraftsTable> {
  $$WorldDraftsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$WorldDraftsTableAnnotationComposer
    extends Composer<_$AppDatabase, $WorldDraftsTable> {
  $$WorldDraftsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get payload =>
      $composableBuilder(column: $table.payload, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$WorldDraftsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WorldDraftsTable,
          WorldDraftRow,
          $$WorldDraftsTableFilterComposer,
          $$WorldDraftsTableOrderingComposer,
          $$WorldDraftsTableAnnotationComposer,
          $$WorldDraftsTableCreateCompanionBuilder,
          $$WorldDraftsTableUpdateCompanionBuilder,
          (
            WorldDraftRow,
            BaseReferences<_$AppDatabase, $WorldDraftsTable, WorldDraftRow>,
          ),
          WorldDraftRow,
          PrefetchHooks Function()
        > {
  $$WorldDraftsTableTableManager(_$AppDatabase db, $WorldDraftsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WorldDraftsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WorldDraftsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WorldDraftsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> payload = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WorldDraftsCompanion(
                id: id,
                payload: payload,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String payload,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => WorldDraftsCompanion.insert(
                id: id,
                payload: payload,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$WorldDraftsTable, WorldDraftRow>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $WorldDraftsTable,
                    WorldDraftRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$WorldDraftsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WorldDraftsTable,
      WorldDraftRow,
      $$WorldDraftsTableFilterComposer,
      $$WorldDraftsTableOrderingComposer,
      $$WorldDraftsTableAnnotationComposer,
      $$WorldDraftsTableCreateCompanionBuilder,
      $$WorldDraftsTableUpdateCompanionBuilder,
      (
        WorldDraftRow,
        BaseReferences<_$AppDatabase, $WorldDraftsTable, WorldDraftRow>,
      ),
      WorldDraftRow,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$WorldsTableTableManager get worlds =>
      $$WorldsTableTableManager(_db, _db.worlds);
  $$UsageRecordsTableTableManager get usageRecords =>
      $$UsageRecordsTableTableManager(_db, _db.usageRecords);
  $$PendingImportsTableTableManager get pendingImports =>
      $$PendingImportsTableTableManager(_db, _db.pendingImports);
  $$ImportedConversationsTableTableManager get importedConversations =>
      $$ImportedConversationsTableTableManager(_db, _db.importedConversations);
  $$ImportedMessagesTableTableManager get importedMessages =>
      $$ImportedMessagesTableTableManager(_db, _db.importedMessages);
  $$ImportedAttachmentsTableTableManager get importedAttachments =>
      $$ImportedAttachmentsTableTableManager(_db, _db.importedAttachments);
  $$DerivedImportResultsTableTableManager get derivedImportResults =>
      $$DerivedImportResultsTableTableManager(_db, _db.derivedImportResults);
  $$RoleplaySavesTableTableManager get roleplaySaves =>
      $$RoleplaySavesTableTableManager(_db, _db.roleplaySaves);
  $$RoleplayTurnsTableTableManager get roleplayTurns =>
      $$RoleplayTurnsTableTableManager(_db, _db.roleplayTurns);
  $$RoleplayMemoriesTableTableManager get roleplayMemories =>
      $$RoleplayMemoriesTableTableManager(_db, _db.roleplayMemories);
  $$StoryCheckpointsTableTableManager get storyCheckpoints =>
      $$StoryCheckpointsTableTableManager(_db, _db.storyCheckpoints);
  $$StoryBranchesTableTableManager get storyBranches =>
      $$StoryBranchesTableTableManager(_db, _db.storyBranches);
  $$TimelineEntriesTableTableManager get timelineEntries =>
      $$TimelineEntriesTableTableManager(_db, _db.timelineEntries);
  $$ContextSummariesTableTableManager get contextSummaries =>
      $$ContextSummariesTableTableManager(_db, _db.contextSummaries);
  $$WorldDefinitionsTableTableManager get worldDefinitions =>
      $$WorldDefinitionsTableTableManager(_db, _db.worldDefinitions);
  $$WorldDraftsTableTableManager get worldDrafts =>
      $$WorldDraftsTableTableManager(_db, _db.worldDrafts);
}
