import 'package:flutter/material.dart';
import 'package:sewingcalculator/Database/database.dart' hide Material;
import 'package:drift/drift.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Database/database.dart' as db;

class DatabaseProvider extends ChangeNotifier {
  static final DatabaseProvider _instance = DatabaseProvider._internal();
  late final db.AppDatabase _database;

  // Singleton pattern
  factory DatabaseProvider() {
    return _instance;
  }

  DatabaseProvider._internal() {
    _database = db.AppDatabase();
  }

  db.AppDatabase get database => _database;

  // Project methods
  Future<List<db.Project>> getAllProjects() async {
    return await _database.getAllProjects();
  }

  Stream<List<db.Project>> watchAllProjects() {
    return _database.watchAllProjects();
  }

  Future<db.Project> getProject(int id) async {
    return await _database.getProject(id);
  }

  Future<int> createProject(String name) async {
    return await _database.insertProject(
      db.ProjectsCompanion.insert(
        name: name,
      ),
    );
  }

  Future<bool> updateProject(db.Project project) async {
    return await _database.updateProject(
      project.toCompanion(true),
    );
  }

  Future<int> deleteProject(int id) async {
    // Delete all related data first
    await _database.deleteMaterialsForProject(id);
    await _database.deleteAccessoriesForProject(id);
    await _database.deleteFeesForProject(id);

    // Then delete the project
    return await _database.deleteProject(id);
  }

  // Material methods
  Future<List<db.Material>> getMaterialsForProject(int projectId) async {
    return await _database.getMaterialsForProject(projectId);
  }

  Future<int> deleteMaterialsForProject(int projectId) async {
    return await _database.deleteMaterialsForProject(projectId);
  }

  Future<int> addMaterialToProject(
    int projectId, 
    String type, 
    String unitIdentifier, 
    double purchasePricePerUnit, 
    double amount
  ) async {
    return await _database.insertMaterial(
      MaterialsCompanion.insert(
        projectId: projectId,
        type: type,
        unitIdentifier: unitIdentifier,
        purchasePricePerUnit: purchasePricePerUnit,
        amount: amount,
      ),
    );
  }

  // Accessory methods
  Future<List<Accessory>> getAccessoriesForProject(int projectId) async {
    return await _database.getAccessoriesForProject(projectId);
  }

  Future<int> deleteAccessoriesForProject(int projectId) async {
    return await _database.deleteAccessoriesForProject(projectId);
  }

  Future<int> addAccessoryToProject(
    int projectId, 
    String type, 
    String unitIdentifier, 
    double purchasePricePerUnit, 
    double amount
  ) async {
    return await _database.insertAccessory(
      AccessoriesCompanion.insert(
        projectId: projectId,
        type: type,
        unitIdentifier: unitIdentifier,
        purchasePricePerUnit: purchasePricePerUnit,
        amount: amount,
      ),
    );
  }

  // Fee methods
  Future<List<ProjectFee>> getFeesForProject(int projectId) async {
    return await _database.getFeesForProject(projectId);
  }

  Future<int> deleteFeesForProject(int projectId) async {
    return await _database.deleteFeesForProject(projectId);
  }

  Future<int> addFeeToProject(
    int projectId, 
    String type, 
    double percentage, 
    double fixFee, 
    bool isActive, 
    bool interactive, 
    bool onEk
  ) async {
    return await _database.insertFee(
      ProjectFeesCompanion.insert(
        projectId: projectId,
        type: type,
        percentage: percentage,
        fixFee: fixFee,
        isActive: Value(isActive),
        interactive: Value(interactive),
        onEk: Value(onEk),
      ),
    );
  }

  // Subscription methods
  Future<bool> isPremium() async {
    // Check if developer mode is enabled
    final prefs = await SharedPreferences.getInstance();
    final devModeEnabled = prefs.getBool('dev_mode_enabled') ?? false;

    // If developer mode is enabled, return true to enable all premium features
    if (devModeEnabled) {
      debugPrint('[Subscription] Developer mode enabled, granting premium access');
      return true;
    }

    // Otherwise, check actual subscription status
    final subscription = await _database.getSubscription();
    if (subscription == null) {
      debugPrint('[Subscription] No subscription found');
      return false;
    }

    if (subscription.subscriptionType == 'lifetime') {
      debugPrint('[Subscription] Lifetime subscription active');
      return true;
    }

    if (subscription.expiryDate == null) {
      debugPrint('[Subscription] Subscription has no expiry date');
      return false;
    }

    final isActive = subscription.isPremium && subscription.expiryDate!.isAfter(DateTime.now());
    debugPrint(subscription.expiryDate!.difference(DateTime.now()).toString());
    
    if (isActive) {
      debugPrint('[Subscription] Active ${subscription.subscriptionType} subscription, expires: ${subscription.expiryDate}');
    } else if (subscription.isPremium) {
      debugPrint('[Subscription] Expired ${subscription.subscriptionType} subscription, expired on: ${subscription.expiryDate}');
      // If subscription has expired, update the database to reflect this
      await setSubscription(false, subscription.subscriptionType, subscription.expiryDate);
    } else {
      debugPrint('[Subscription] Inactive subscription');
    }
    
    return isActive;
  }

  Future<int> setSubscription(bool isPremium, String? subscriptionType, DateTime? expiryDate) async {
    return await _database.insertOrUpdateSubscription(
      SubscriptionsCompanion(
        isPremium: Value(isPremium),
        subscriptionType: Value(subscriptionType),
        expiryDate: Value(expiryDate),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  // Check if user can create a new project (free version limit)
  Future<bool> canCreateNewProject() async {
    final isPremiumUser = await isPremium();
    if (isPremiumUser) {
      return true;
    }

    final projectCount = await _database.countProjects();
    return projectCount < 1; // Free users can only have 1 project
  }
  
  // For testing purposes: simulate an expired subscription
  Future<void> simulateExpiredSubscription() async {
    // Set a subscription that expired yesterday
    final expiredDate = DateTime.now().subtract(const Duration(days: 1));
    await setSubscription(true, 'monthly', expiredDate);
    debugPrint('[TEST] Simulated expired subscription with date: $expiredDate');
  }
  
  // For testing purposes: simulate an active subscription
  Future<void> simulateActiveSubscription() async {
    // Set a subscription that expires in 30 days
    final expiryDate = DateTime.now().add(const Duration(days: 30));
    await setSubscription(true, 'monthly', expiryDate);
    debugPrint('[TEST] Simulated active subscription with expiry date: $expiryDate');
  }
}
