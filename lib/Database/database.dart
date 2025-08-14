import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'database.g.dart';

class Projects extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 100)();
  DateTimeColumn get createdAt => dateTime().withDefault(Constant(DateTime.now()))();
  DateTimeColumn get updatedAt => dateTime().withDefault(Constant(DateTime.now()))();
}

class Materials extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get projectId => integer().references(Projects, #id)();
  TextColumn get type => text().withLength(min: 1, max: 100)();
  TextColumn get unitIdentifier => text().withLength(min: 1, max: 50)();
  RealColumn get purchasePricePerUnit => real()();
  RealColumn get amount => real()();
}

class Accessories extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get projectId => integer().references(Projects, #id)();
  TextColumn get type => text().withLength(min: 1, max: 100)();
  TextColumn get unitIdentifier => text().withLength(min: 1, max: 50)();
  RealColumn get purchasePricePerUnit => real()();
  RealColumn get amount => real()();
}

class ProjectFees extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get projectId => integer().references(Projects, #id)();
  TextColumn get type => text().withLength(min: 1, max: 100)();
  RealColumn get percentage => real()();
  RealColumn get fixFee => real()();
  BoolColumn get isActive => boolean().withDefault(const Constant(false))();
  BoolColumn get interactive => boolean().withDefault(const Constant(false))();
  BoolColumn get onEk => boolean().withDefault(const Constant(false))();
}

class Subscriptions extends Table {
  IntColumn get id => integer().autoIncrement()();
  BoolColumn get isPremium => boolean().withDefault(const Constant(false))();
  DateTimeColumn get expiryDate => dateTime().nullable()();
  TextColumn get subscriptionType => text().nullable()(); // 'monthly', 'yearly', 'lifetime'
  DateTimeColumn get updatedAt => dateTime().withDefault(Constant(DateTime.now()))();
}

@DriftDatabase(tables: [Projects, Materials, Accessories, ProjectFees, Subscriptions])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  // Projects
  Future<List<Project>> getAllProjects() => select(projects).get();

  Stream<List<Project>> watchAllProjects() => select(projects).watch();

  Future<Project> getProject(int id) => 
      (select(projects)..where((p) => p.id.equals(id))).getSingle();

  Future<int> insertProject(ProjectsCompanion project) => 
      into(projects).insert(project);

  Future<bool> updateProject(ProjectsCompanion project) => 
      update(projects).replace(project);

  Future<int> deleteProject(int id) => 
      (delete(projects)..where((p) => p.id.equals(id))).go();

  // Materials
  Future<List<Material>> getMaterialsForProject(int projectId) => 
      (select(materials)..where((m) => m.projectId.equals(projectId))).get();

  Future<int> insertMaterial(MaterialsCompanion material) => 
      into(materials).insert(material);

  Future<int> deleteMaterialsForProject(int projectId) => 
      (delete(materials)..where((m) => m.projectId.equals(projectId))).go();

  // Accessories
  Future<List<Accessory>> getAccessoriesForProject(int projectId) => 
      (select(accessories)..where((a) => a.projectId.equals(projectId))).get();

  Future<int> insertAccessory(AccessoriesCompanion accessory) => 
      into(accessories).insert(accessory);

  Future<int> deleteAccessoriesForProject(int projectId) => 
      (delete(accessories)..where((a) => a.projectId.equals(projectId))).go();

  // Fees
  Future<List<ProjectFee>> getFeesForProject(int projectId) => 
      (select(projectFees)..where((f) => f.projectId.equals(projectId))).get();

  Future<int> insertFee(ProjectFeesCompanion fee) => 
      into(projectFees).insert(fee);

  Future<int> deleteFeesForProject(int projectId) => 
      (delete(projectFees)..where((f) => f.projectId.equals(projectId))).go();

  // Subscription
  Future<Subscription?> getSubscription() async {
    final results = await select(subscriptions).get();
    if (results.isEmpty) {
      return null;
    }
    return results.first;
  }

  Future<int> insertOrUpdateSubscription(SubscriptionsCompanion subscription) async {
    final currentSubscription = await getSubscription();
    if (currentSubscription == null) {
      return into(subscriptions).insert(subscription);
    } else {
      return (update(subscriptions)..where((s) => s.id.equals(currentSubscription.id)))
          .write(subscription);
    }
  }

  // Count projects
  Future<int> countProjects() async {
    final count = await customSelect(
      'SELECT COUNT(*) as count FROM projects',
      readsFrom: {projects},
    ).getSingle();
    return count.read<int>('count');
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'sewingcalculator.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
