// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $ScreenshotsTable extends Screenshots
    with TableInfo<$ScreenshotsTable, Screenshot> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ScreenshotsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _pathMeta = const VerificationMeta('path');
  @override
  late final GeneratedColumn<String> path = GeneratedColumn<String>(
      'path', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _extractedTextMeta =
      const VerificationMeta('extractedText');
  @override
  late final GeneratedColumn<String> extractedText = GeneratedColumn<String>(
      'extracted_text', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [id, path, extractedText, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'screenshots';
  @override
  VerificationContext validateIntegrity(Insertable<Screenshot> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('path')) {
      context.handle(
          _pathMeta, path.isAcceptableOrUnknown(data['path']!, _pathMeta));
    } else if (isInserting) {
      context.missing(_pathMeta);
    }
    if (data.containsKey('extracted_text')) {
      context.handle(
          _extractedTextMeta,
          extractedText.isAcceptableOrUnknown(
              data['extracted_text']!, _extractedTextMeta));
    } else if (isInserting) {
      context.missing(_extractedTextMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Screenshot map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Screenshot(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      path: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}path'])!,
      extractedText: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}extracted_text'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $ScreenshotsTable createAlias(String alias) {
    return $ScreenshotsTable(attachedDatabase, alias);
  }
}

class Screenshot extends DataClass implements Insertable<Screenshot> {
  final int id;
  final String path;
  final String extractedText;
  final DateTime createdAt;
  const Screenshot(
      {required this.id,
      required this.path,
      required this.extractedText,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['path'] = Variable<String>(path);
    map['extracted_text'] = Variable<String>(extractedText);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  ScreenshotsCompanion toCompanion(bool nullToAbsent) {
    return ScreenshotsCompanion(
      id: Value(id),
      path: Value(path),
      extractedText: Value(extractedText),
      createdAt: Value(createdAt),
    );
  }

  factory Screenshot.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Screenshot(
      id: serializer.fromJson<int>(json['id']),
      path: serializer.fromJson<String>(json['path']),
      extractedText: serializer.fromJson<String>(json['extractedText']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'path': serializer.toJson<String>(path),
      'extractedText': serializer.toJson<String>(extractedText),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Screenshot copyWith(
          {int? id,
          String? path,
          String? extractedText,
          DateTime? createdAt}) =>
      Screenshot(
        id: id ?? this.id,
        path: path ?? this.path,
        extractedText: extractedText ?? this.extractedText,
        createdAt: createdAt ?? this.createdAt,
      );
  Screenshot copyWithCompanion(ScreenshotsCompanion data) {
    return Screenshot(
      id: data.id.present ? data.id.value : this.id,
      path: data.path.present ? data.path.value : this.path,
      extractedText: data.extractedText.present
          ? data.extractedText.value
          : this.extractedText,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Screenshot(')
          ..write('id: $id, ')
          ..write('path: $path, ')
          ..write('extractedText: $extractedText, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, path, extractedText, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Screenshot &&
          other.id == this.id &&
          other.path == this.path &&
          other.extractedText == this.extractedText &&
          other.createdAt == this.createdAt);
}

class ScreenshotsCompanion extends UpdateCompanion<Screenshot> {
  final Value<int> id;
  final Value<String> path;
  final Value<String> extractedText;
  final Value<DateTime> createdAt;
  const ScreenshotsCompanion({
    this.id = const Value.absent(),
    this.path = const Value.absent(),
    this.extractedText = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  ScreenshotsCompanion.insert({
    this.id = const Value.absent(),
    required String path,
    required String extractedText,
    this.createdAt = const Value.absent(),
  })  : path = Value(path),
        extractedText = Value(extractedText);
  static Insertable<Screenshot> custom({
    Expression<int>? id,
    Expression<String>? path,
    Expression<String>? extractedText,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (path != null) 'path': path,
      if (extractedText != null) 'extracted_text': extractedText,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  ScreenshotsCompanion copyWith(
      {Value<int>? id,
      Value<String>? path,
      Value<String>? extractedText,
      Value<DateTime>? createdAt}) {
    return ScreenshotsCompanion(
      id: id ?? this.id,
      path: path ?? this.path,
      extractedText: extractedText ?? this.extractedText,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (path.present) {
      map['path'] = Variable<String>(path.value);
    }
    if (extractedText.present) {
      map['extracted_text'] = Variable<String>(extractedText.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ScreenshotsCompanion(')
          ..write('id: $id, ')
          ..write('path: $path, ')
          ..write('extractedText: $extractedText, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ScreenshotsTable screenshots = $ScreenshotsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [screenshots];
}

typedef $$ScreenshotsTableCreateCompanionBuilder = ScreenshotsCompanion
    Function({
  Value<int> id,
  required String path,
  required String extractedText,
  Value<DateTime> createdAt,
});
typedef $$ScreenshotsTableUpdateCompanionBuilder = ScreenshotsCompanion
    Function({
  Value<int> id,
  Value<String> path,
  Value<String> extractedText,
  Value<DateTime> createdAt,
});

class $$ScreenshotsTableFilterComposer
    extends Composer<_$AppDatabase, $ScreenshotsTable> {
  $$ScreenshotsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get path => $composableBuilder(
      column: $table.path, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get extractedText => $composableBuilder(
      column: $table.extractedText, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$ScreenshotsTableOrderingComposer
    extends Composer<_$AppDatabase, $ScreenshotsTable> {
  $$ScreenshotsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get path => $composableBuilder(
      column: $table.path, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get extractedText => $composableBuilder(
      column: $table.extractedText,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$ScreenshotsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ScreenshotsTable> {
  $$ScreenshotsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get path =>
      $composableBuilder(column: $table.path, builder: (column) => column);

  GeneratedColumn<String> get extractedText => $composableBuilder(
      column: $table.extractedText, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$ScreenshotsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ScreenshotsTable,
    Screenshot,
    $$ScreenshotsTableFilterComposer,
    $$ScreenshotsTableOrderingComposer,
    $$ScreenshotsTableAnnotationComposer,
    $$ScreenshotsTableCreateCompanionBuilder,
    $$ScreenshotsTableUpdateCompanionBuilder,
    (Screenshot, BaseReferences<_$AppDatabase, $ScreenshotsTable, Screenshot>),
    Screenshot,
    PrefetchHooks Function()> {
  $$ScreenshotsTableTableManager(_$AppDatabase db, $ScreenshotsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ScreenshotsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ScreenshotsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ScreenshotsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> path = const Value.absent(),
            Value<String> extractedText = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              ScreenshotsCompanion(
            id: id,
            path: path,
            extractedText: extractedText,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String path,
            required String extractedText,
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              ScreenshotsCompanion.insert(
            id: id,
            path: path,
            extractedText: extractedText,
            createdAt: createdAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ScreenshotsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ScreenshotsTable,
    Screenshot,
    $$ScreenshotsTableFilterComposer,
    $$ScreenshotsTableOrderingComposer,
    $$ScreenshotsTableAnnotationComposer,
    $$ScreenshotsTableCreateCompanionBuilder,
    $$ScreenshotsTableUpdateCompanionBuilder,
    (Screenshot, BaseReferences<_$AppDatabase, $ScreenshotsTable, Screenshot>),
    Screenshot,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ScreenshotsTableTableManager get screenshots =>
      $$ScreenshotsTableTableManager(_db, _db.screenshots);
}
