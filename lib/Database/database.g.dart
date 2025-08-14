// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $ProjectsTable extends Projects with TableInfo<$ProjectsTable, Project> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProjectsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 100),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: Constant(DateTime.now()));
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: Constant(DateTime.now()));
  @override
  List<GeneratedColumn> get $columns => [id, name, createdAt, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'projects';
  @override
  VerificationContext validateIntegrity(Insertable<Project> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Project map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Project(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $ProjectsTable createAlias(String alias) {
    return $ProjectsTable(attachedDatabase, alias);
  }
}

class Project extends DataClass implements Insertable<Project> {
  final int id;
  final String name;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Project(
      {required this.id,
      required this.name,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  ProjectsCompanion toCompanion(bool nullToAbsent) {
    return ProjectsCompanion(
      id: Value(id),
      name: Value(name),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Project.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Project(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Project copyWith(
          {int? id, String? name, DateTime? createdAt, DateTime? updatedAt}) =>
      Project(
        id: id ?? this.id,
        name: name ?? this.name,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  Project copyWithCompanion(ProjectsCompanion data) {
    return Project(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Project(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Project &&
          other.id == this.id &&
          other.name == this.name &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class ProjectsCompanion extends UpdateCompanion<Project> {
  final Value<int> id;
  final Value<String> name;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const ProjectsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  ProjectsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : name = Value(name);
  static Insertable<Project> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  ProjectsCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt}) {
    return ProjectsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProjectsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $MaterialsTable extends Materials
    with TableInfo<$MaterialsTable, Material> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MaterialsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _projectIdMeta =
      const VerificationMeta('projectId');
  @override
  late final GeneratedColumn<int> projectId = GeneratedColumn<int>(
      'project_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES projects (id)'));
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 100),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _unitIdentifierMeta =
      const VerificationMeta('unitIdentifier');
  @override
  late final GeneratedColumn<String> unitIdentifier = GeneratedColumn<String>(
      'unit_identifier', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 50),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _purchasePricePerUnitMeta =
      const VerificationMeta('purchasePricePerUnit');
  @override
  late final GeneratedColumn<double> purchasePricePerUnit =
      GeneratedColumn<double>('purchase_price_per_unit', aliasedName, false,
          type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
      'amount', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, projectId, type, unitIdentifier, purchasePricePerUnit, amount];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'materials';
  @override
  VerificationContext validateIntegrity(Insertable<Material> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('project_id')) {
      context.handle(_projectIdMeta,
          projectId.isAcceptableOrUnknown(data['project_id']!, _projectIdMeta));
    } else if (isInserting) {
      context.missing(_projectIdMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('unit_identifier')) {
      context.handle(
          _unitIdentifierMeta,
          unitIdentifier.isAcceptableOrUnknown(
              data['unit_identifier']!, _unitIdentifierMeta));
    } else if (isInserting) {
      context.missing(_unitIdentifierMeta);
    }
    if (data.containsKey('purchase_price_per_unit')) {
      context.handle(
          _purchasePricePerUnitMeta,
          purchasePricePerUnit.isAcceptableOrUnknown(
              data['purchase_price_per_unit']!, _purchasePricePerUnitMeta));
    } else if (isInserting) {
      context.missing(_purchasePricePerUnitMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(_amountMeta,
          amount.isAcceptableOrUnknown(data['amount']!, _amountMeta));
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Material map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Material(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      projectId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}project_id'])!,
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      unitIdentifier: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}unit_identifier'])!,
      purchasePricePerUnit: attachedDatabase.typeMapping.read(
          DriftSqlType.double,
          data['${effectivePrefix}purchase_price_per_unit'])!,
      amount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}amount'])!,
    );
  }

  @override
  $MaterialsTable createAlias(String alias) {
    return $MaterialsTable(attachedDatabase, alias);
  }
}

class Material extends DataClass implements Insertable<Material> {
  final int id;
  final int projectId;
  final String type;
  final String unitIdentifier;
  final double purchasePricePerUnit;
  final double amount;
  const Material(
      {required this.id,
      required this.projectId,
      required this.type,
      required this.unitIdentifier,
      required this.purchasePricePerUnit,
      required this.amount});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['project_id'] = Variable<int>(projectId);
    map['type'] = Variable<String>(type);
    map['unit_identifier'] = Variable<String>(unitIdentifier);
    map['purchase_price_per_unit'] = Variable<double>(purchasePricePerUnit);
    map['amount'] = Variable<double>(amount);
    return map;
  }

  MaterialsCompanion toCompanion(bool nullToAbsent) {
    return MaterialsCompanion(
      id: Value(id),
      projectId: Value(projectId),
      type: Value(type),
      unitIdentifier: Value(unitIdentifier),
      purchasePricePerUnit: Value(purchasePricePerUnit),
      amount: Value(amount),
    );
  }

  factory Material.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Material(
      id: serializer.fromJson<int>(json['id']),
      projectId: serializer.fromJson<int>(json['projectId']),
      type: serializer.fromJson<String>(json['type']),
      unitIdentifier: serializer.fromJson<String>(json['unitIdentifier']),
      purchasePricePerUnit:
          serializer.fromJson<double>(json['purchasePricePerUnit']),
      amount: serializer.fromJson<double>(json['amount']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'projectId': serializer.toJson<int>(projectId),
      'type': serializer.toJson<String>(type),
      'unitIdentifier': serializer.toJson<String>(unitIdentifier),
      'purchasePricePerUnit': serializer.toJson<double>(purchasePricePerUnit),
      'amount': serializer.toJson<double>(amount),
    };
  }

  Material copyWith(
          {int? id,
          int? projectId,
          String? type,
          String? unitIdentifier,
          double? purchasePricePerUnit,
          double? amount}) =>
      Material(
        id: id ?? this.id,
        projectId: projectId ?? this.projectId,
        type: type ?? this.type,
        unitIdentifier: unitIdentifier ?? this.unitIdentifier,
        purchasePricePerUnit: purchasePricePerUnit ?? this.purchasePricePerUnit,
        amount: amount ?? this.amount,
      );
  Material copyWithCompanion(MaterialsCompanion data) {
    return Material(
      id: data.id.present ? data.id.value : this.id,
      projectId: data.projectId.present ? data.projectId.value : this.projectId,
      type: data.type.present ? data.type.value : this.type,
      unitIdentifier: data.unitIdentifier.present
          ? data.unitIdentifier.value
          : this.unitIdentifier,
      purchasePricePerUnit: data.purchasePricePerUnit.present
          ? data.purchasePricePerUnit.value
          : this.purchasePricePerUnit,
      amount: data.amount.present ? data.amount.value : this.amount,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Material(')
          ..write('id: $id, ')
          ..write('projectId: $projectId, ')
          ..write('type: $type, ')
          ..write('unitIdentifier: $unitIdentifier, ')
          ..write('purchasePricePerUnit: $purchasePricePerUnit, ')
          ..write('amount: $amount')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, projectId, type, unitIdentifier, purchasePricePerUnit, amount);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Material &&
          other.id == this.id &&
          other.projectId == this.projectId &&
          other.type == this.type &&
          other.unitIdentifier == this.unitIdentifier &&
          other.purchasePricePerUnit == this.purchasePricePerUnit &&
          other.amount == this.amount);
}

class MaterialsCompanion extends UpdateCompanion<Material> {
  final Value<int> id;
  final Value<int> projectId;
  final Value<String> type;
  final Value<String> unitIdentifier;
  final Value<double> purchasePricePerUnit;
  final Value<double> amount;
  const MaterialsCompanion({
    this.id = const Value.absent(),
    this.projectId = const Value.absent(),
    this.type = const Value.absent(),
    this.unitIdentifier = const Value.absent(),
    this.purchasePricePerUnit = const Value.absent(),
    this.amount = const Value.absent(),
  });
  MaterialsCompanion.insert({
    this.id = const Value.absent(),
    required int projectId,
    required String type,
    required String unitIdentifier,
    required double purchasePricePerUnit,
    required double amount,
  })  : projectId = Value(projectId),
        type = Value(type),
        unitIdentifier = Value(unitIdentifier),
        purchasePricePerUnit = Value(purchasePricePerUnit),
        amount = Value(amount);
  static Insertable<Material> custom({
    Expression<int>? id,
    Expression<int>? projectId,
    Expression<String>? type,
    Expression<String>? unitIdentifier,
    Expression<double>? purchasePricePerUnit,
    Expression<double>? amount,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (projectId != null) 'project_id': projectId,
      if (type != null) 'type': type,
      if (unitIdentifier != null) 'unit_identifier': unitIdentifier,
      if (purchasePricePerUnit != null)
        'purchase_price_per_unit': purchasePricePerUnit,
      if (amount != null) 'amount': amount,
    });
  }

  MaterialsCompanion copyWith(
      {Value<int>? id,
      Value<int>? projectId,
      Value<String>? type,
      Value<String>? unitIdentifier,
      Value<double>? purchasePricePerUnit,
      Value<double>? amount}) {
    return MaterialsCompanion(
      id: id ?? this.id,
      projectId: projectId ?? this.projectId,
      type: type ?? this.type,
      unitIdentifier: unitIdentifier ?? this.unitIdentifier,
      purchasePricePerUnit: purchasePricePerUnit ?? this.purchasePricePerUnit,
      amount: amount ?? this.amount,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (projectId.present) {
      map['project_id'] = Variable<int>(projectId.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (unitIdentifier.present) {
      map['unit_identifier'] = Variable<String>(unitIdentifier.value);
    }
    if (purchasePricePerUnit.present) {
      map['purchase_price_per_unit'] =
          Variable<double>(purchasePricePerUnit.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MaterialsCompanion(')
          ..write('id: $id, ')
          ..write('projectId: $projectId, ')
          ..write('type: $type, ')
          ..write('unitIdentifier: $unitIdentifier, ')
          ..write('purchasePricePerUnit: $purchasePricePerUnit, ')
          ..write('amount: $amount')
          ..write(')'))
        .toString();
  }
}

class $AccessoriesTable extends Accessories
    with TableInfo<$AccessoriesTable, Accessory> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AccessoriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _projectIdMeta =
      const VerificationMeta('projectId');
  @override
  late final GeneratedColumn<int> projectId = GeneratedColumn<int>(
      'project_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES projects (id)'));
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 100),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _unitIdentifierMeta =
      const VerificationMeta('unitIdentifier');
  @override
  late final GeneratedColumn<String> unitIdentifier = GeneratedColumn<String>(
      'unit_identifier', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 50),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _purchasePricePerUnitMeta =
      const VerificationMeta('purchasePricePerUnit');
  @override
  late final GeneratedColumn<double> purchasePricePerUnit =
      GeneratedColumn<double>('purchase_price_per_unit', aliasedName, false,
          type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
      'amount', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, projectId, type, unitIdentifier, purchasePricePerUnit, amount];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'accessories';
  @override
  VerificationContext validateIntegrity(Insertable<Accessory> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('project_id')) {
      context.handle(_projectIdMeta,
          projectId.isAcceptableOrUnknown(data['project_id']!, _projectIdMeta));
    } else if (isInserting) {
      context.missing(_projectIdMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('unit_identifier')) {
      context.handle(
          _unitIdentifierMeta,
          unitIdentifier.isAcceptableOrUnknown(
              data['unit_identifier']!, _unitIdentifierMeta));
    } else if (isInserting) {
      context.missing(_unitIdentifierMeta);
    }
    if (data.containsKey('purchase_price_per_unit')) {
      context.handle(
          _purchasePricePerUnitMeta,
          purchasePricePerUnit.isAcceptableOrUnknown(
              data['purchase_price_per_unit']!, _purchasePricePerUnitMeta));
    } else if (isInserting) {
      context.missing(_purchasePricePerUnitMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(_amountMeta,
          amount.isAcceptableOrUnknown(data['amount']!, _amountMeta));
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Accessory map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Accessory(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      projectId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}project_id'])!,
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      unitIdentifier: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}unit_identifier'])!,
      purchasePricePerUnit: attachedDatabase.typeMapping.read(
          DriftSqlType.double,
          data['${effectivePrefix}purchase_price_per_unit'])!,
      amount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}amount'])!,
    );
  }

  @override
  $AccessoriesTable createAlias(String alias) {
    return $AccessoriesTable(attachedDatabase, alias);
  }
}

class Accessory extends DataClass implements Insertable<Accessory> {
  final int id;
  final int projectId;
  final String type;
  final String unitIdentifier;
  final double purchasePricePerUnit;
  final double amount;
  const Accessory(
      {required this.id,
      required this.projectId,
      required this.type,
      required this.unitIdentifier,
      required this.purchasePricePerUnit,
      required this.amount});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['project_id'] = Variable<int>(projectId);
    map['type'] = Variable<String>(type);
    map['unit_identifier'] = Variable<String>(unitIdentifier);
    map['purchase_price_per_unit'] = Variable<double>(purchasePricePerUnit);
    map['amount'] = Variable<double>(amount);
    return map;
  }

  AccessoriesCompanion toCompanion(bool nullToAbsent) {
    return AccessoriesCompanion(
      id: Value(id),
      projectId: Value(projectId),
      type: Value(type),
      unitIdentifier: Value(unitIdentifier),
      purchasePricePerUnit: Value(purchasePricePerUnit),
      amount: Value(amount),
    );
  }

  factory Accessory.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Accessory(
      id: serializer.fromJson<int>(json['id']),
      projectId: serializer.fromJson<int>(json['projectId']),
      type: serializer.fromJson<String>(json['type']),
      unitIdentifier: serializer.fromJson<String>(json['unitIdentifier']),
      purchasePricePerUnit:
          serializer.fromJson<double>(json['purchasePricePerUnit']),
      amount: serializer.fromJson<double>(json['amount']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'projectId': serializer.toJson<int>(projectId),
      'type': serializer.toJson<String>(type),
      'unitIdentifier': serializer.toJson<String>(unitIdentifier),
      'purchasePricePerUnit': serializer.toJson<double>(purchasePricePerUnit),
      'amount': serializer.toJson<double>(amount),
    };
  }

  Accessory copyWith(
          {int? id,
          int? projectId,
          String? type,
          String? unitIdentifier,
          double? purchasePricePerUnit,
          double? amount}) =>
      Accessory(
        id: id ?? this.id,
        projectId: projectId ?? this.projectId,
        type: type ?? this.type,
        unitIdentifier: unitIdentifier ?? this.unitIdentifier,
        purchasePricePerUnit: purchasePricePerUnit ?? this.purchasePricePerUnit,
        amount: amount ?? this.amount,
      );
  Accessory copyWithCompanion(AccessoriesCompanion data) {
    return Accessory(
      id: data.id.present ? data.id.value : this.id,
      projectId: data.projectId.present ? data.projectId.value : this.projectId,
      type: data.type.present ? data.type.value : this.type,
      unitIdentifier: data.unitIdentifier.present
          ? data.unitIdentifier.value
          : this.unitIdentifier,
      purchasePricePerUnit: data.purchasePricePerUnit.present
          ? data.purchasePricePerUnit.value
          : this.purchasePricePerUnit,
      amount: data.amount.present ? data.amount.value : this.amount,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Accessory(')
          ..write('id: $id, ')
          ..write('projectId: $projectId, ')
          ..write('type: $type, ')
          ..write('unitIdentifier: $unitIdentifier, ')
          ..write('purchasePricePerUnit: $purchasePricePerUnit, ')
          ..write('amount: $amount')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, projectId, type, unitIdentifier, purchasePricePerUnit, amount);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Accessory &&
          other.id == this.id &&
          other.projectId == this.projectId &&
          other.type == this.type &&
          other.unitIdentifier == this.unitIdentifier &&
          other.purchasePricePerUnit == this.purchasePricePerUnit &&
          other.amount == this.amount);
}

class AccessoriesCompanion extends UpdateCompanion<Accessory> {
  final Value<int> id;
  final Value<int> projectId;
  final Value<String> type;
  final Value<String> unitIdentifier;
  final Value<double> purchasePricePerUnit;
  final Value<double> amount;
  const AccessoriesCompanion({
    this.id = const Value.absent(),
    this.projectId = const Value.absent(),
    this.type = const Value.absent(),
    this.unitIdentifier = const Value.absent(),
    this.purchasePricePerUnit = const Value.absent(),
    this.amount = const Value.absent(),
  });
  AccessoriesCompanion.insert({
    this.id = const Value.absent(),
    required int projectId,
    required String type,
    required String unitIdentifier,
    required double purchasePricePerUnit,
    required double amount,
  })  : projectId = Value(projectId),
        type = Value(type),
        unitIdentifier = Value(unitIdentifier),
        purchasePricePerUnit = Value(purchasePricePerUnit),
        amount = Value(amount);
  static Insertable<Accessory> custom({
    Expression<int>? id,
    Expression<int>? projectId,
    Expression<String>? type,
    Expression<String>? unitIdentifier,
    Expression<double>? purchasePricePerUnit,
    Expression<double>? amount,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (projectId != null) 'project_id': projectId,
      if (type != null) 'type': type,
      if (unitIdentifier != null) 'unit_identifier': unitIdentifier,
      if (purchasePricePerUnit != null)
        'purchase_price_per_unit': purchasePricePerUnit,
      if (amount != null) 'amount': amount,
    });
  }

  AccessoriesCompanion copyWith(
      {Value<int>? id,
      Value<int>? projectId,
      Value<String>? type,
      Value<String>? unitIdentifier,
      Value<double>? purchasePricePerUnit,
      Value<double>? amount}) {
    return AccessoriesCompanion(
      id: id ?? this.id,
      projectId: projectId ?? this.projectId,
      type: type ?? this.type,
      unitIdentifier: unitIdentifier ?? this.unitIdentifier,
      purchasePricePerUnit: purchasePricePerUnit ?? this.purchasePricePerUnit,
      amount: amount ?? this.amount,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (projectId.present) {
      map['project_id'] = Variable<int>(projectId.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (unitIdentifier.present) {
      map['unit_identifier'] = Variable<String>(unitIdentifier.value);
    }
    if (purchasePricePerUnit.present) {
      map['purchase_price_per_unit'] =
          Variable<double>(purchasePricePerUnit.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AccessoriesCompanion(')
          ..write('id: $id, ')
          ..write('projectId: $projectId, ')
          ..write('type: $type, ')
          ..write('unitIdentifier: $unitIdentifier, ')
          ..write('purchasePricePerUnit: $purchasePricePerUnit, ')
          ..write('amount: $amount')
          ..write(')'))
        .toString();
  }
}

class $ProjectFeesTable extends ProjectFees
    with TableInfo<$ProjectFeesTable, ProjectFee> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProjectFeesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _projectIdMeta =
      const VerificationMeta('projectId');
  @override
  late final GeneratedColumn<int> projectId = GeneratedColumn<int>(
      'project_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES projects (id)'));
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 100),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _percentageMeta =
      const VerificationMeta('percentage');
  @override
  late final GeneratedColumn<double> percentage = GeneratedColumn<double>(
      'percentage', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _fixFeeMeta = const VerificationMeta('fixFee');
  @override
  late final GeneratedColumn<double> fixFee = GeneratedColumn<double>(
      'fix_fee', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _isActiveMeta =
      const VerificationMeta('isActive');
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
      'is_active', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_active" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _interactiveMeta =
      const VerificationMeta('interactive');
  @override
  late final GeneratedColumn<bool> interactive = GeneratedColumn<bool>(
      'interactive', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("interactive" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _onEkMeta = const VerificationMeta('onEk');
  @override
  late final GeneratedColumn<bool> onEk = GeneratedColumn<bool>(
      'on_ek', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("on_ek" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns =>
      [id, projectId, type, percentage, fixFee, isActive, interactive, onEk];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'project_fees';
  @override
  VerificationContext validateIntegrity(Insertable<ProjectFee> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('project_id')) {
      context.handle(_projectIdMeta,
          projectId.isAcceptableOrUnknown(data['project_id']!, _projectIdMeta));
    } else if (isInserting) {
      context.missing(_projectIdMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('percentage')) {
      context.handle(
          _percentageMeta,
          percentage.isAcceptableOrUnknown(
              data['percentage']!, _percentageMeta));
    } else if (isInserting) {
      context.missing(_percentageMeta);
    }
    if (data.containsKey('fix_fee')) {
      context.handle(_fixFeeMeta,
          fixFee.isAcceptableOrUnknown(data['fix_fee']!, _fixFeeMeta));
    } else if (isInserting) {
      context.missing(_fixFeeMeta);
    }
    if (data.containsKey('is_active')) {
      context.handle(_isActiveMeta,
          isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta));
    }
    if (data.containsKey('interactive')) {
      context.handle(
          _interactiveMeta,
          interactive.isAcceptableOrUnknown(
              data['interactive']!, _interactiveMeta));
    }
    if (data.containsKey('on_ek')) {
      context.handle(
          _onEkMeta, onEk.isAcceptableOrUnknown(data['on_ek']!, _onEkMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ProjectFee map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ProjectFee(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      projectId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}project_id'])!,
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      percentage: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}percentage'])!,
      fixFee: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}fix_fee'])!,
      isActive: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_active'])!,
      interactive: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}interactive'])!,
      onEk: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}on_ek'])!,
    );
  }

  @override
  $ProjectFeesTable createAlias(String alias) {
    return $ProjectFeesTable(attachedDatabase, alias);
  }
}

class ProjectFee extends DataClass implements Insertable<ProjectFee> {
  final int id;
  final int projectId;
  final String type;
  final double percentage;
  final double fixFee;
  final bool isActive;
  final bool interactive;
  final bool onEk;
  const ProjectFee(
      {required this.id,
      required this.projectId,
      required this.type,
      required this.percentage,
      required this.fixFee,
      required this.isActive,
      required this.interactive,
      required this.onEk});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['project_id'] = Variable<int>(projectId);
    map['type'] = Variable<String>(type);
    map['percentage'] = Variable<double>(percentage);
    map['fix_fee'] = Variable<double>(fixFee);
    map['is_active'] = Variable<bool>(isActive);
    map['interactive'] = Variable<bool>(interactive);
    map['on_ek'] = Variable<bool>(onEk);
    return map;
  }

  ProjectFeesCompanion toCompanion(bool nullToAbsent) {
    return ProjectFeesCompanion(
      id: Value(id),
      projectId: Value(projectId),
      type: Value(type),
      percentage: Value(percentage),
      fixFee: Value(fixFee),
      isActive: Value(isActive),
      interactive: Value(interactive),
      onEk: Value(onEk),
    );
  }

  factory ProjectFee.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProjectFee(
      id: serializer.fromJson<int>(json['id']),
      projectId: serializer.fromJson<int>(json['projectId']),
      type: serializer.fromJson<String>(json['type']),
      percentage: serializer.fromJson<double>(json['percentage']),
      fixFee: serializer.fromJson<double>(json['fixFee']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      interactive: serializer.fromJson<bool>(json['interactive']),
      onEk: serializer.fromJson<bool>(json['onEk']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'projectId': serializer.toJson<int>(projectId),
      'type': serializer.toJson<String>(type),
      'percentage': serializer.toJson<double>(percentage),
      'fixFee': serializer.toJson<double>(fixFee),
      'isActive': serializer.toJson<bool>(isActive),
      'interactive': serializer.toJson<bool>(interactive),
      'onEk': serializer.toJson<bool>(onEk),
    };
  }

  ProjectFee copyWith(
          {int? id,
          int? projectId,
          String? type,
          double? percentage,
          double? fixFee,
          bool? isActive,
          bool? interactive,
          bool? onEk}) =>
      ProjectFee(
        id: id ?? this.id,
        projectId: projectId ?? this.projectId,
        type: type ?? this.type,
        percentage: percentage ?? this.percentage,
        fixFee: fixFee ?? this.fixFee,
        isActive: isActive ?? this.isActive,
        interactive: interactive ?? this.interactive,
        onEk: onEk ?? this.onEk,
      );
  ProjectFee copyWithCompanion(ProjectFeesCompanion data) {
    return ProjectFee(
      id: data.id.present ? data.id.value : this.id,
      projectId: data.projectId.present ? data.projectId.value : this.projectId,
      type: data.type.present ? data.type.value : this.type,
      percentage:
          data.percentage.present ? data.percentage.value : this.percentage,
      fixFee: data.fixFee.present ? data.fixFee.value : this.fixFee,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      interactive:
          data.interactive.present ? data.interactive.value : this.interactive,
      onEk: data.onEk.present ? data.onEk.value : this.onEk,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ProjectFee(')
          ..write('id: $id, ')
          ..write('projectId: $projectId, ')
          ..write('type: $type, ')
          ..write('percentage: $percentage, ')
          ..write('fixFee: $fixFee, ')
          ..write('isActive: $isActive, ')
          ..write('interactive: $interactive, ')
          ..write('onEk: $onEk')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, projectId, type, percentage, fixFee, isActive, interactive, onEk);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProjectFee &&
          other.id == this.id &&
          other.projectId == this.projectId &&
          other.type == this.type &&
          other.percentage == this.percentage &&
          other.fixFee == this.fixFee &&
          other.isActive == this.isActive &&
          other.interactive == this.interactive &&
          other.onEk == this.onEk);
}

class ProjectFeesCompanion extends UpdateCompanion<ProjectFee> {
  final Value<int> id;
  final Value<int> projectId;
  final Value<String> type;
  final Value<double> percentage;
  final Value<double> fixFee;
  final Value<bool> isActive;
  final Value<bool> interactive;
  final Value<bool> onEk;
  const ProjectFeesCompanion({
    this.id = const Value.absent(),
    this.projectId = const Value.absent(),
    this.type = const Value.absent(),
    this.percentage = const Value.absent(),
    this.fixFee = const Value.absent(),
    this.isActive = const Value.absent(),
    this.interactive = const Value.absent(),
    this.onEk = const Value.absent(),
  });
  ProjectFeesCompanion.insert({
    this.id = const Value.absent(),
    required int projectId,
    required String type,
    required double percentage,
    required double fixFee,
    this.isActive = const Value.absent(),
    this.interactive = const Value.absent(),
    this.onEk = const Value.absent(),
  })  : projectId = Value(projectId),
        type = Value(type),
        percentage = Value(percentage),
        fixFee = Value(fixFee);
  static Insertable<ProjectFee> custom({
    Expression<int>? id,
    Expression<int>? projectId,
    Expression<String>? type,
    Expression<double>? percentage,
    Expression<double>? fixFee,
    Expression<bool>? isActive,
    Expression<bool>? interactive,
    Expression<bool>? onEk,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (projectId != null) 'project_id': projectId,
      if (type != null) 'type': type,
      if (percentage != null) 'percentage': percentage,
      if (fixFee != null) 'fix_fee': fixFee,
      if (isActive != null) 'is_active': isActive,
      if (interactive != null) 'interactive': interactive,
      if (onEk != null) 'on_ek': onEk,
    });
  }

  ProjectFeesCompanion copyWith(
      {Value<int>? id,
      Value<int>? projectId,
      Value<String>? type,
      Value<double>? percentage,
      Value<double>? fixFee,
      Value<bool>? isActive,
      Value<bool>? interactive,
      Value<bool>? onEk}) {
    return ProjectFeesCompanion(
      id: id ?? this.id,
      projectId: projectId ?? this.projectId,
      type: type ?? this.type,
      percentage: percentage ?? this.percentage,
      fixFee: fixFee ?? this.fixFee,
      isActive: isActive ?? this.isActive,
      interactive: interactive ?? this.interactive,
      onEk: onEk ?? this.onEk,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (projectId.present) {
      map['project_id'] = Variable<int>(projectId.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (percentage.present) {
      map['percentage'] = Variable<double>(percentage.value);
    }
    if (fixFee.present) {
      map['fix_fee'] = Variable<double>(fixFee.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (interactive.present) {
      map['interactive'] = Variable<bool>(interactive.value);
    }
    if (onEk.present) {
      map['on_ek'] = Variable<bool>(onEk.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProjectFeesCompanion(')
          ..write('id: $id, ')
          ..write('projectId: $projectId, ')
          ..write('type: $type, ')
          ..write('percentage: $percentage, ')
          ..write('fixFee: $fixFee, ')
          ..write('isActive: $isActive, ')
          ..write('interactive: $interactive, ')
          ..write('onEk: $onEk')
          ..write(')'))
        .toString();
  }
}

class $SubscriptionsTable extends Subscriptions
    with TableInfo<$SubscriptionsTable, Subscription> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SubscriptionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _isPremiumMeta =
      const VerificationMeta('isPremium');
  @override
  late final GeneratedColumn<bool> isPremium = GeneratedColumn<bool>(
      'is_premium', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_premium" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _expiryDateMeta =
      const VerificationMeta('expiryDate');
  @override
  late final GeneratedColumn<DateTime> expiryDate = GeneratedColumn<DateTime>(
      'expiry_date', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _subscriptionTypeMeta =
      const VerificationMeta('subscriptionType');
  @override
  late final GeneratedColumn<String> subscriptionType = GeneratedColumn<String>(
      'subscription_type', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: Constant(DateTime.now()));
  @override
  List<GeneratedColumn> get $columns =>
      [id, isPremium, expiryDate, subscriptionType, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'subscriptions';
  @override
  VerificationContext validateIntegrity(Insertable<Subscription> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('is_premium')) {
      context.handle(_isPremiumMeta,
          isPremium.isAcceptableOrUnknown(data['is_premium']!, _isPremiumMeta));
    }
    if (data.containsKey('expiry_date')) {
      context.handle(
          _expiryDateMeta,
          expiryDate.isAcceptableOrUnknown(
              data['expiry_date']!, _expiryDateMeta));
    }
    if (data.containsKey('subscription_type')) {
      context.handle(
          _subscriptionTypeMeta,
          subscriptionType.isAcceptableOrUnknown(
              data['subscription_type']!, _subscriptionTypeMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Subscription map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Subscription(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      isPremium: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_premium'])!,
      expiryDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}expiry_date']),
      subscriptionType: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}subscription_type']),
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $SubscriptionsTable createAlias(String alias) {
    return $SubscriptionsTable(attachedDatabase, alias);
  }
}

class Subscription extends DataClass implements Insertable<Subscription> {
  final int id;
  final bool isPremium;
  final DateTime? expiryDate;
  final String? subscriptionType;
  final DateTime updatedAt;
  const Subscription(
      {required this.id,
      required this.isPremium,
      this.expiryDate,
      this.subscriptionType,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['is_premium'] = Variable<bool>(isPremium);
    if (!nullToAbsent || expiryDate != null) {
      map['expiry_date'] = Variable<DateTime>(expiryDate);
    }
    if (!nullToAbsent || subscriptionType != null) {
      map['subscription_type'] = Variable<String>(subscriptionType);
    }
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  SubscriptionsCompanion toCompanion(bool nullToAbsent) {
    return SubscriptionsCompanion(
      id: Value(id),
      isPremium: Value(isPremium),
      expiryDate: expiryDate == null && nullToAbsent
          ? const Value.absent()
          : Value(expiryDate),
      subscriptionType: subscriptionType == null && nullToAbsent
          ? const Value.absent()
          : Value(subscriptionType),
      updatedAt: Value(updatedAt),
    );
  }

  factory Subscription.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Subscription(
      id: serializer.fromJson<int>(json['id']),
      isPremium: serializer.fromJson<bool>(json['isPremium']),
      expiryDate: serializer.fromJson<DateTime?>(json['expiryDate']),
      subscriptionType: serializer.fromJson<String?>(json['subscriptionType']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'isPremium': serializer.toJson<bool>(isPremium),
      'expiryDate': serializer.toJson<DateTime?>(expiryDate),
      'subscriptionType': serializer.toJson<String?>(subscriptionType),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Subscription copyWith(
          {int? id,
          bool? isPremium,
          Value<DateTime?> expiryDate = const Value.absent(),
          Value<String?> subscriptionType = const Value.absent(),
          DateTime? updatedAt}) =>
      Subscription(
        id: id ?? this.id,
        isPremium: isPremium ?? this.isPremium,
        expiryDate: expiryDate.present ? expiryDate.value : this.expiryDate,
        subscriptionType: subscriptionType.present
            ? subscriptionType.value
            : this.subscriptionType,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  Subscription copyWithCompanion(SubscriptionsCompanion data) {
    return Subscription(
      id: data.id.present ? data.id.value : this.id,
      isPremium: data.isPremium.present ? data.isPremium.value : this.isPremium,
      expiryDate:
          data.expiryDate.present ? data.expiryDate.value : this.expiryDate,
      subscriptionType: data.subscriptionType.present
          ? data.subscriptionType.value
          : this.subscriptionType,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Subscription(')
          ..write('id: $id, ')
          ..write('isPremium: $isPremium, ')
          ..write('expiryDate: $expiryDate, ')
          ..write('subscriptionType: $subscriptionType, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, isPremium, expiryDate, subscriptionType, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Subscription &&
          other.id == this.id &&
          other.isPremium == this.isPremium &&
          other.expiryDate == this.expiryDate &&
          other.subscriptionType == this.subscriptionType &&
          other.updatedAt == this.updatedAt);
}

class SubscriptionsCompanion extends UpdateCompanion<Subscription> {
  final Value<int> id;
  final Value<bool> isPremium;
  final Value<DateTime?> expiryDate;
  final Value<String?> subscriptionType;
  final Value<DateTime> updatedAt;
  const SubscriptionsCompanion({
    this.id = const Value.absent(),
    this.isPremium = const Value.absent(),
    this.expiryDate = const Value.absent(),
    this.subscriptionType = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  SubscriptionsCompanion.insert({
    this.id = const Value.absent(),
    this.isPremium = const Value.absent(),
    this.expiryDate = const Value.absent(),
    this.subscriptionType = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  static Insertable<Subscription> custom({
    Expression<int>? id,
    Expression<bool>? isPremium,
    Expression<DateTime>? expiryDate,
    Expression<String>? subscriptionType,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (isPremium != null) 'is_premium': isPremium,
      if (expiryDate != null) 'expiry_date': expiryDate,
      if (subscriptionType != null) 'subscription_type': subscriptionType,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  SubscriptionsCompanion copyWith(
      {Value<int>? id,
      Value<bool>? isPremium,
      Value<DateTime?>? expiryDate,
      Value<String?>? subscriptionType,
      Value<DateTime>? updatedAt}) {
    return SubscriptionsCompanion(
      id: id ?? this.id,
      isPremium: isPremium ?? this.isPremium,
      expiryDate: expiryDate ?? this.expiryDate,
      subscriptionType: subscriptionType ?? this.subscriptionType,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (isPremium.present) {
      map['is_premium'] = Variable<bool>(isPremium.value);
    }
    if (expiryDate.present) {
      map['expiry_date'] = Variable<DateTime>(expiryDate.value);
    }
    if (subscriptionType.present) {
      map['subscription_type'] = Variable<String>(subscriptionType.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SubscriptionsCompanion(')
          ..write('id: $id, ')
          ..write('isPremium: $isPremium, ')
          ..write('expiryDate: $expiryDate, ')
          ..write('subscriptionType: $subscriptionType, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ProjectsTable projects = $ProjectsTable(this);
  late final $MaterialsTable materials = $MaterialsTable(this);
  late final $AccessoriesTable accessories = $AccessoriesTable(this);
  late final $ProjectFeesTable projectFees = $ProjectFeesTable(this);
  late final $SubscriptionsTable subscriptions = $SubscriptionsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [projects, materials, accessories, projectFees, subscriptions];
}

typedef $$ProjectsTableCreateCompanionBuilder = ProjectsCompanion Function({
  Value<int> id,
  required String name,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});
typedef $$ProjectsTableUpdateCompanionBuilder = ProjectsCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});

final class $$ProjectsTableReferences
    extends BaseReferences<_$AppDatabase, $ProjectsTable, Project> {
  $$ProjectsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$MaterialsTable, List<Material>>
      _materialsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.materials,
              aliasName:
                  $_aliasNameGenerator(db.projects.id, db.materials.projectId));

  $$MaterialsTableProcessedTableManager get materialsRefs {
    final manager = $$MaterialsTableTableManager($_db, $_db.materials)
        .filter((f) => f.projectId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_materialsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$AccessoriesTable, List<Accessory>>
      _accessoriesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
          db.accessories,
          aliasName:
              $_aliasNameGenerator(db.projects.id, db.accessories.projectId));

  $$AccessoriesTableProcessedTableManager get accessoriesRefs {
    final manager = $$AccessoriesTableTableManager($_db, $_db.accessories)
        .filter((f) => f.projectId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_accessoriesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$ProjectFeesTable, List<ProjectFee>>
      _projectFeesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
          db.projectFees,
          aliasName:
              $_aliasNameGenerator(db.projects.id, db.projectFees.projectId));

  $$ProjectFeesTableProcessedTableManager get projectFeesRefs {
    final manager = $$ProjectFeesTableTableManager($_db, $_db.projectFees)
        .filter((f) => f.projectId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_projectFeesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$ProjectsTableFilterComposer
    extends Composer<_$AppDatabase, $ProjectsTable> {
  $$ProjectsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  Expression<bool> materialsRefs(
      Expression<bool> Function($$MaterialsTableFilterComposer f) f) {
    final $$MaterialsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.materials,
        getReferencedColumn: (t) => t.projectId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MaterialsTableFilterComposer(
              $db: $db,
              $table: $db.materials,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> accessoriesRefs(
      Expression<bool> Function($$AccessoriesTableFilterComposer f) f) {
    final $$AccessoriesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.accessories,
        getReferencedColumn: (t) => t.projectId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AccessoriesTableFilterComposer(
              $db: $db,
              $table: $db.accessories,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> projectFeesRefs(
      Expression<bool> Function($$ProjectFeesTableFilterComposer f) f) {
    final $$ProjectFeesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.projectFees,
        getReferencedColumn: (t) => t.projectId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProjectFeesTableFilterComposer(
              $db: $db,
              $table: $db.projectFees,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$ProjectsTableOrderingComposer
    extends Composer<_$AppDatabase, $ProjectsTable> {
  $$ProjectsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$ProjectsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProjectsTable> {
  $$ProjectsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> materialsRefs<T extends Object>(
      Expression<T> Function($$MaterialsTableAnnotationComposer a) f) {
    final $$MaterialsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.materials,
        getReferencedColumn: (t) => t.projectId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MaterialsTableAnnotationComposer(
              $db: $db,
              $table: $db.materials,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> accessoriesRefs<T extends Object>(
      Expression<T> Function($$AccessoriesTableAnnotationComposer a) f) {
    final $$AccessoriesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.accessories,
        getReferencedColumn: (t) => t.projectId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AccessoriesTableAnnotationComposer(
              $db: $db,
              $table: $db.accessories,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> projectFeesRefs<T extends Object>(
      Expression<T> Function($$ProjectFeesTableAnnotationComposer a) f) {
    final $$ProjectFeesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.projectFees,
        getReferencedColumn: (t) => t.projectId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProjectFeesTableAnnotationComposer(
              $db: $db,
              $table: $db.projectFees,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$ProjectsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ProjectsTable,
    Project,
    $$ProjectsTableFilterComposer,
    $$ProjectsTableOrderingComposer,
    $$ProjectsTableAnnotationComposer,
    $$ProjectsTableCreateCompanionBuilder,
    $$ProjectsTableUpdateCompanionBuilder,
    (Project, $$ProjectsTableReferences),
    Project,
    PrefetchHooks Function(
        {bool materialsRefs, bool accessoriesRefs, bool projectFeesRefs})> {
  $$ProjectsTableTableManager(_$AppDatabase db, $ProjectsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProjectsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProjectsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProjectsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              ProjectsCompanion(
            id: id,
            name: name,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              ProjectsCompanion.insert(
            id: id,
            name: name,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$ProjectsTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: (
              {materialsRefs = false,
              accessoriesRefs = false,
              projectFeesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (materialsRefs) db.materials,
                if (accessoriesRefs) db.accessories,
                if (projectFeesRefs) db.projectFees
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (materialsRefs)
                    await $_getPrefetchedData<Project, $ProjectsTable,
                            Material>(
                        currentTable: table,
                        referencedTable:
                            $$ProjectsTableReferences._materialsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$ProjectsTableReferences(db, table, p0)
                                .materialsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.projectId == item.id),
                        typedResults: items),
                  if (accessoriesRefs)
                    await $_getPrefetchedData<Project, $ProjectsTable,
                            Accessory>(
                        currentTable: table,
                        referencedTable:
                            $$ProjectsTableReferences._accessoriesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$ProjectsTableReferences(db, table, p0)
                                .accessoriesRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.projectId == item.id),
                        typedResults: items),
                  if (projectFeesRefs)
                    await $_getPrefetchedData<Project, $ProjectsTable,
                            ProjectFee>(
                        currentTable: table,
                        referencedTable:
                            $$ProjectsTableReferences._projectFeesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$ProjectsTableReferences(db, table, p0)
                                .projectFeesRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.projectId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$ProjectsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ProjectsTable,
    Project,
    $$ProjectsTableFilterComposer,
    $$ProjectsTableOrderingComposer,
    $$ProjectsTableAnnotationComposer,
    $$ProjectsTableCreateCompanionBuilder,
    $$ProjectsTableUpdateCompanionBuilder,
    (Project, $$ProjectsTableReferences),
    Project,
    PrefetchHooks Function(
        {bool materialsRefs, bool accessoriesRefs, bool projectFeesRefs})>;
typedef $$MaterialsTableCreateCompanionBuilder = MaterialsCompanion Function({
  Value<int> id,
  required int projectId,
  required String type,
  required String unitIdentifier,
  required double purchasePricePerUnit,
  required double amount,
});
typedef $$MaterialsTableUpdateCompanionBuilder = MaterialsCompanion Function({
  Value<int> id,
  Value<int> projectId,
  Value<String> type,
  Value<String> unitIdentifier,
  Value<double> purchasePricePerUnit,
  Value<double> amount,
});

final class $$MaterialsTableReferences
    extends BaseReferences<_$AppDatabase, $MaterialsTable, Material> {
  $$MaterialsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ProjectsTable _projectIdTable(_$AppDatabase db) =>
      db.projects.createAlias(
          $_aliasNameGenerator(db.materials.projectId, db.projects.id));

  $$ProjectsTableProcessedTableManager get projectId {
    final $_column = $_itemColumn<int>('project_id')!;

    final manager = $$ProjectsTableTableManager($_db, $_db.projects)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_projectIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$MaterialsTableFilterComposer
    extends Composer<_$AppDatabase, $MaterialsTable> {
  $$MaterialsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get unitIdentifier => $composableBuilder(
      column: $table.unitIdentifier,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get purchasePricePerUnit => $composableBuilder(
      column: $table.purchasePricePerUnit,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnFilters(column));

  $$ProjectsTableFilterComposer get projectId {
    final $$ProjectsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.projectId,
        referencedTable: $db.projects,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProjectsTableFilterComposer(
              $db: $db,
              $table: $db.projects,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$MaterialsTableOrderingComposer
    extends Composer<_$AppDatabase, $MaterialsTable> {
  $$MaterialsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get unitIdentifier => $composableBuilder(
      column: $table.unitIdentifier,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get purchasePricePerUnit => $composableBuilder(
      column: $table.purchasePricePerUnit,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnOrderings(column));

  $$ProjectsTableOrderingComposer get projectId {
    final $$ProjectsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.projectId,
        referencedTable: $db.projects,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProjectsTableOrderingComposer(
              $db: $db,
              $table: $db.projects,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$MaterialsTableAnnotationComposer
    extends Composer<_$AppDatabase, $MaterialsTable> {
  $$MaterialsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get unitIdentifier => $composableBuilder(
      column: $table.unitIdentifier, builder: (column) => column);

  GeneratedColumn<double> get purchasePricePerUnit => $composableBuilder(
      column: $table.purchasePricePerUnit, builder: (column) => column);

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  $$ProjectsTableAnnotationComposer get projectId {
    final $$ProjectsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.projectId,
        referencedTable: $db.projects,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProjectsTableAnnotationComposer(
              $db: $db,
              $table: $db.projects,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$MaterialsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $MaterialsTable,
    Material,
    $$MaterialsTableFilterComposer,
    $$MaterialsTableOrderingComposer,
    $$MaterialsTableAnnotationComposer,
    $$MaterialsTableCreateCompanionBuilder,
    $$MaterialsTableUpdateCompanionBuilder,
    (Material, $$MaterialsTableReferences),
    Material,
    PrefetchHooks Function({bool projectId})> {
  $$MaterialsTableTableManager(_$AppDatabase db, $MaterialsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MaterialsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MaterialsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MaterialsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> projectId = const Value.absent(),
            Value<String> type = const Value.absent(),
            Value<String> unitIdentifier = const Value.absent(),
            Value<double> purchasePricePerUnit = const Value.absent(),
            Value<double> amount = const Value.absent(),
          }) =>
              MaterialsCompanion(
            id: id,
            projectId: projectId,
            type: type,
            unitIdentifier: unitIdentifier,
            purchasePricePerUnit: purchasePricePerUnit,
            amount: amount,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int projectId,
            required String type,
            required String unitIdentifier,
            required double purchasePricePerUnit,
            required double amount,
          }) =>
              MaterialsCompanion.insert(
            id: id,
            projectId: projectId,
            type: type,
            unitIdentifier: unitIdentifier,
            purchasePricePerUnit: purchasePricePerUnit,
            amount: amount,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$MaterialsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({projectId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
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
                      dynamic>>(state) {
                if (projectId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.projectId,
                    referencedTable:
                        $$MaterialsTableReferences._projectIdTable(db),
                    referencedColumn:
                        $$MaterialsTableReferences._projectIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$MaterialsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $MaterialsTable,
    Material,
    $$MaterialsTableFilterComposer,
    $$MaterialsTableOrderingComposer,
    $$MaterialsTableAnnotationComposer,
    $$MaterialsTableCreateCompanionBuilder,
    $$MaterialsTableUpdateCompanionBuilder,
    (Material, $$MaterialsTableReferences),
    Material,
    PrefetchHooks Function({bool projectId})>;
typedef $$AccessoriesTableCreateCompanionBuilder = AccessoriesCompanion
    Function({
  Value<int> id,
  required int projectId,
  required String type,
  required String unitIdentifier,
  required double purchasePricePerUnit,
  required double amount,
});
typedef $$AccessoriesTableUpdateCompanionBuilder = AccessoriesCompanion
    Function({
  Value<int> id,
  Value<int> projectId,
  Value<String> type,
  Value<String> unitIdentifier,
  Value<double> purchasePricePerUnit,
  Value<double> amount,
});

final class $$AccessoriesTableReferences
    extends BaseReferences<_$AppDatabase, $AccessoriesTable, Accessory> {
  $$AccessoriesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ProjectsTable _projectIdTable(_$AppDatabase db) =>
      db.projects.createAlias(
          $_aliasNameGenerator(db.accessories.projectId, db.projects.id));

  $$ProjectsTableProcessedTableManager get projectId {
    final $_column = $_itemColumn<int>('project_id')!;

    final manager = $$ProjectsTableTableManager($_db, $_db.projects)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_projectIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$AccessoriesTableFilterComposer
    extends Composer<_$AppDatabase, $AccessoriesTable> {
  $$AccessoriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get unitIdentifier => $composableBuilder(
      column: $table.unitIdentifier,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get purchasePricePerUnit => $composableBuilder(
      column: $table.purchasePricePerUnit,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnFilters(column));

  $$ProjectsTableFilterComposer get projectId {
    final $$ProjectsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.projectId,
        referencedTable: $db.projects,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProjectsTableFilterComposer(
              $db: $db,
              $table: $db.projects,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$AccessoriesTableOrderingComposer
    extends Composer<_$AppDatabase, $AccessoriesTable> {
  $$AccessoriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get unitIdentifier => $composableBuilder(
      column: $table.unitIdentifier,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get purchasePricePerUnit => $composableBuilder(
      column: $table.purchasePricePerUnit,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnOrderings(column));

  $$ProjectsTableOrderingComposer get projectId {
    final $$ProjectsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.projectId,
        referencedTable: $db.projects,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProjectsTableOrderingComposer(
              $db: $db,
              $table: $db.projects,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$AccessoriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $AccessoriesTable> {
  $$AccessoriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get unitIdentifier => $composableBuilder(
      column: $table.unitIdentifier, builder: (column) => column);

  GeneratedColumn<double> get purchasePricePerUnit => $composableBuilder(
      column: $table.purchasePricePerUnit, builder: (column) => column);

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  $$ProjectsTableAnnotationComposer get projectId {
    final $$ProjectsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.projectId,
        referencedTable: $db.projects,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProjectsTableAnnotationComposer(
              $db: $db,
              $table: $db.projects,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$AccessoriesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $AccessoriesTable,
    Accessory,
    $$AccessoriesTableFilterComposer,
    $$AccessoriesTableOrderingComposer,
    $$AccessoriesTableAnnotationComposer,
    $$AccessoriesTableCreateCompanionBuilder,
    $$AccessoriesTableUpdateCompanionBuilder,
    (Accessory, $$AccessoriesTableReferences),
    Accessory,
    PrefetchHooks Function({bool projectId})> {
  $$AccessoriesTableTableManager(_$AppDatabase db, $AccessoriesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AccessoriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AccessoriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AccessoriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> projectId = const Value.absent(),
            Value<String> type = const Value.absent(),
            Value<String> unitIdentifier = const Value.absent(),
            Value<double> purchasePricePerUnit = const Value.absent(),
            Value<double> amount = const Value.absent(),
          }) =>
              AccessoriesCompanion(
            id: id,
            projectId: projectId,
            type: type,
            unitIdentifier: unitIdentifier,
            purchasePricePerUnit: purchasePricePerUnit,
            amount: amount,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int projectId,
            required String type,
            required String unitIdentifier,
            required double purchasePricePerUnit,
            required double amount,
          }) =>
              AccessoriesCompanion.insert(
            id: id,
            projectId: projectId,
            type: type,
            unitIdentifier: unitIdentifier,
            purchasePricePerUnit: purchasePricePerUnit,
            amount: amount,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$AccessoriesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({projectId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
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
                      dynamic>>(state) {
                if (projectId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.projectId,
                    referencedTable:
                        $$AccessoriesTableReferences._projectIdTable(db),
                    referencedColumn:
                        $$AccessoriesTableReferences._projectIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$AccessoriesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $AccessoriesTable,
    Accessory,
    $$AccessoriesTableFilterComposer,
    $$AccessoriesTableOrderingComposer,
    $$AccessoriesTableAnnotationComposer,
    $$AccessoriesTableCreateCompanionBuilder,
    $$AccessoriesTableUpdateCompanionBuilder,
    (Accessory, $$AccessoriesTableReferences),
    Accessory,
    PrefetchHooks Function({bool projectId})>;
typedef $$ProjectFeesTableCreateCompanionBuilder = ProjectFeesCompanion
    Function({
  Value<int> id,
  required int projectId,
  required String type,
  required double percentage,
  required double fixFee,
  Value<bool> isActive,
  Value<bool> interactive,
  Value<bool> onEk,
});
typedef $$ProjectFeesTableUpdateCompanionBuilder = ProjectFeesCompanion
    Function({
  Value<int> id,
  Value<int> projectId,
  Value<String> type,
  Value<double> percentage,
  Value<double> fixFee,
  Value<bool> isActive,
  Value<bool> interactive,
  Value<bool> onEk,
});

final class $$ProjectFeesTableReferences
    extends BaseReferences<_$AppDatabase, $ProjectFeesTable, ProjectFee> {
  $$ProjectFeesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ProjectsTable _projectIdTable(_$AppDatabase db) =>
      db.projects.createAlias(
          $_aliasNameGenerator(db.projectFees.projectId, db.projects.id));

  $$ProjectsTableProcessedTableManager get projectId {
    final $_column = $_itemColumn<int>('project_id')!;

    final manager = $$ProjectsTableTableManager($_db, $_db.projects)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_projectIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$ProjectFeesTableFilterComposer
    extends Composer<_$AppDatabase, $ProjectFeesTable> {
  $$ProjectFeesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get percentage => $composableBuilder(
      column: $table.percentage, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get fixFee => $composableBuilder(
      column: $table.fixFee, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get interactive => $composableBuilder(
      column: $table.interactive, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get onEk => $composableBuilder(
      column: $table.onEk, builder: (column) => ColumnFilters(column));

  $$ProjectsTableFilterComposer get projectId {
    final $$ProjectsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.projectId,
        referencedTable: $db.projects,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProjectsTableFilterComposer(
              $db: $db,
              $table: $db.projects,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ProjectFeesTableOrderingComposer
    extends Composer<_$AppDatabase, $ProjectFeesTable> {
  $$ProjectFeesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get percentage => $composableBuilder(
      column: $table.percentage, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get fixFee => $composableBuilder(
      column: $table.fixFee, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get interactive => $composableBuilder(
      column: $table.interactive, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get onEk => $composableBuilder(
      column: $table.onEk, builder: (column) => ColumnOrderings(column));

  $$ProjectsTableOrderingComposer get projectId {
    final $$ProjectsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.projectId,
        referencedTable: $db.projects,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProjectsTableOrderingComposer(
              $db: $db,
              $table: $db.projects,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ProjectFeesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProjectFeesTable> {
  $$ProjectFeesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<double> get percentage => $composableBuilder(
      column: $table.percentage, builder: (column) => column);

  GeneratedColumn<double> get fixFee =>
      $composableBuilder(column: $table.fixFee, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<bool> get interactive => $composableBuilder(
      column: $table.interactive, builder: (column) => column);

  GeneratedColumn<bool> get onEk =>
      $composableBuilder(column: $table.onEk, builder: (column) => column);

  $$ProjectsTableAnnotationComposer get projectId {
    final $$ProjectsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.projectId,
        referencedTable: $db.projects,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProjectsTableAnnotationComposer(
              $db: $db,
              $table: $db.projects,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ProjectFeesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ProjectFeesTable,
    ProjectFee,
    $$ProjectFeesTableFilterComposer,
    $$ProjectFeesTableOrderingComposer,
    $$ProjectFeesTableAnnotationComposer,
    $$ProjectFeesTableCreateCompanionBuilder,
    $$ProjectFeesTableUpdateCompanionBuilder,
    (ProjectFee, $$ProjectFeesTableReferences),
    ProjectFee,
    PrefetchHooks Function({bool projectId})> {
  $$ProjectFeesTableTableManager(_$AppDatabase db, $ProjectFeesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProjectFeesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProjectFeesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProjectFeesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> projectId = const Value.absent(),
            Value<String> type = const Value.absent(),
            Value<double> percentage = const Value.absent(),
            Value<double> fixFee = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<bool> interactive = const Value.absent(),
            Value<bool> onEk = const Value.absent(),
          }) =>
              ProjectFeesCompanion(
            id: id,
            projectId: projectId,
            type: type,
            percentage: percentage,
            fixFee: fixFee,
            isActive: isActive,
            interactive: interactive,
            onEk: onEk,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int projectId,
            required String type,
            required double percentage,
            required double fixFee,
            Value<bool> isActive = const Value.absent(),
            Value<bool> interactive = const Value.absent(),
            Value<bool> onEk = const Value.absent(),
          }) =>
              ProjectFeesCompanion.insert(
            id: id,
            projectId: projectId,
            type: type,
            percentage: percentage,
            fixFee: fixFee,
            isActive: isActive,
            interactive: interactive,
            onEk: onEk,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$ProjectFeesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({projectId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
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
                      dynamic>>(state) {
                if (projectId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.projectId,
                    referencedTable:
                        $$ProjectFeesTableReferences._projectIdTable(db),
                    referencedColumn:
                        $$ProjectFeesTableReferences._projectIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$ProjectFeesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ProjectFeesTable,
    ProjectFee,
    $$ProjectFeesTableFilterComposer,
    $$ProjectFeesTableOrderingComposer,
    $$ProjectFeesTableAnnotationComposer,
    $$ProjectFeesTableCreateCompanionBuilder,
    $$ProjectFeesTableUpdateCompanionBuilder,
    (ProjectFee, $$ProjectFeesTableReferences),
    ProjectFee,
    PrefetchHooks Function({bool projectId})>;
typedef $$SubscriptionsTableCreateCompanionBuilder = SubscriptionsCompanion
    Function({
  Value<int> id,
  Value<bool> isPremium,
  Value<DateTime?> expiryDate,
  Value<String?> subscriptionType,
  Value<DateTime> updatedAt,
});
typedef $$SubscriptionsTableUpdateCompanionBuilder = SubscriptionsCompanion
    Function({
  Value<int> id,
  Value<bool> isPremium,
  Value<DateTime?> expiryDate,
  Value<String?> subscriptionType,
  Value<DateTime> updatedAt,
});

class $$SubscriptionsTableFilterComposer
    extends Composer<_$AppDatabase, $SubscriptionsTable> {
  $$SubscriptionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isPremium => $composableBuilder(
      column: $table.isPremium, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get expiryDate => $composableBuilder(
      column: $table.expiryDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get subscriptionType => $composableBuilder(
      column: $table.subscriptionType,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$SubscriptionsTableOrderingComposer
    extends Composer<_$AppDatabase, $SubscriptionsTable> {
  $$SubscriptionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isPremium => $composableBuilder(
      column: $table.isPremium, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get expiryDate => $composableBuilder(
      column: $table.expiryDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get subscriptionType => $composableBuilder(
      column: $table.subscriptionType,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$SubscriptionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SubscriptionsTable> {
  $$SubscriptionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<bool> get isPremium =>
      $composableBuilder(column: $table.isPremium, builder: (column) => column);

  GeneratedColumn<DateTime> get expiryDate => $composableBuilder(
      column: $table.expiryDate, builder: (column) => column);

  GeneratedColumn<String> get subscriptionType => $composableBuilder(
      column: $table.subscriptionType, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$SubscriptionsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SubscriptionsTable,
    Subscription,
    $$SubscriptionsTableFilterComposer,
    $$SubscriptionsTableOrderingComposer,
    $$SubscriptionsTableAnnotationComposer,
    $$SubscriptionsTableCreateCompanionBuilder,
    $$SubscriptionsTableUpdateCompanionBuilder,
    (
      Subscription,
      BaseReferences<_$AppDatabase, $SubscriptionsTable, Subscription>
    ),
    Subscription,
    PrefetchHooks Function()> {
  $$SubscriptionsTableTableManager(_$AppDatabase db, $SubscriptionsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SubscriptionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SubscriptionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SubscriptionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<bool> isPremium = const Value.absent(),
            Value<DateTime?> expiryDate = const Value.absent(),
            Value<String?> subscriptionType = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              SubscriptionsCompanion(
            id: id,
            isPremium: isPremium,
            expiryDate: expiryDate,
            subscriptionType: subscriptionType,
            updatedAt: updatedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<bool> isPremium = const Value.absent(),
            Value<DateTime?> expiryDate = const Value.absent(),
            Value<String?> subscriptionType = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              SubscriptionsCompanion.insert(
            id: id,
            isPremium: isPremium,
            expiryDate: expiryDate,
            subscriptionType: subscriptionType,
            updatedAt: updatedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$SubscriptionsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SubscriptionsTable,
    Subscription,
    $$SubscriptionsTableFilterComposer,
    $$SubscriptionsTableOrderingComposer,
    $$SubscriptionsTableAnnotationComposer,
    $$SubscriptionsTableCreateCompanionBuilder,
    $$SubscriptionsTableUpdateCompanionBuilder,
    (
      Subscription,
      BaseReferences<_$AppDatabase, $SubscriptionsTable, Subscription>
    ),
    Subscription,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ProjectsTableTableManager get projects =>
      $$ProjectsTableTableManager(_db, _db.projects);
  $$MaterialsTableTableManager get materials =>
      $$MaterialsTableTableManager(_db, _db.materials);
  $$AccessoriesTableTableManager get accessories =>
      $$AccessoriesTableTableManager(_db, _db.accessories);
  $$ProjectFeesTableTableManager get projectFees =>
      $$ProjectFeesTableTableManager(_db, _db.projectFees);
  $$SubscriptionsTableTableManager get subscriptions =>
      $$SubscriptionsTableTableManager(_db, _db.subscriptions);
}
