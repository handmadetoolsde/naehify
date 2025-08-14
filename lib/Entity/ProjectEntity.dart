import 'package:sewingcalculator/Database/database.dart' as db;
import 'package:drift/drift.dart';

class ProjectEntity {
  final int id;
  final String name;
  final DateTime createdAt;
  final DateTime updatedAt;

  ProjectEntity({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
  });

  // Factory constructor to create a ProjectEntity from a Project
  factory ProjectEntity.fromProject(db.Project project) {
    return ProjectEntity(
      id: project.id,
      name: project.name,
      createdAt: project.createdAt,
      updatedAt: project.updatedAt,
    );
  }

  // Convert to a Project companion for database operations
  db.ProjectsCompanion toCompanion() {
    return db.ProjectsCompanion(
      id: Value(id),
      name: Value(name),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }
}
