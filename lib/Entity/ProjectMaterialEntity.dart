import 'package:sewingcalculator/Database/database.dart' as db;
import 'package:drift/drift.dart';

class ProjectMaterialEntity {
  final int id;
  final int projectId;
  final String type;
  final String unitIdentifier;
  final double purchasePricePerUnit;
  final double amount;

  ProjectMaterialEntity({
    required this.id,
    required this.projectId,
    required this.type,
    required this.unitIdentifier,
    required this.purchasePricePerUnit,
    required this.amount,
  });

  // Factory constructor to create a ProjectMaterialEntity from a Material
  factory ProjectMaterialEntity.fromMaterial(db.Material material) {
    return ProjectMaterialEntity(
      id: material.id,
      projectId: material.projectId,
      type: material.type,
      unitIdentifier: material.unitIdentifier,
      purchasePricePerUnit: material.purchasePricePerUnit,
      amount: material.amount,
    );
  }

  // Convert to a Material companion for database operations
  db.MaterialsCompanion toCompanion() {
    return db.MaterialsCompanion(
      id: Value(id),
      projectId: Value(projectId),
      type: Value(type),
      unitIdentifier: Value(unitIdentifier),
      purchasePricePerUnit: Value(purchasePricePerUnit),
      amount: Value(amount),
    );
  }
}