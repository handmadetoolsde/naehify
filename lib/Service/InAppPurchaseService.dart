import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';
import 'package:in_app_purchase_storekit/store_kit_wrappers.dart';
import 'package:sewingcalculator/Provider/database_provider.dart';

class InAppPurchaseService {
  static final InAppPurchaseService _instance = InAppPurchaseService._internal();

  // Callback for purchase completion
  // This callback is triggered when a purchase is successfully completed
  // It's used to show a congratulatory modal and redirect the user
  Function? onPurchaseComplete;

  // Singleton pattern
  factory InAppPurchaseService() {
    return _instance;
  }

  InAppPurchaseService._internal();

  // Product IDs
  static const String _monthlySubscriptionId = 'monthly_subscription2';
  static const String _yearlySubscriptionId = 'yearly_subscription';
  static const String _lifetimeSubscriptionId = 'lifetime_subscription';

  // Set of product IDs
  static final Set<String> _productIds = {
    _monthlySubscriptionId,
    _yearlySubscriptionId,
    _lifetimeSubscriptionId,
  };

  // In-app purchase instance
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;

  // Stream subscription for purchase updates
  StreamSubscription<List<PurchaseDetails>>? _subscription;

  // Available products
  List<ProductDetails> _products = [];

  // Initialization status
  bool _isAvailable = false;
  bool _isLoading = true;

  // Getters
  bool get isAvailable => _isAvailable;
  bool get isLoading => _isLoading;
  List<ProductDetails> get products => _products;

  // Initialize the in-app purchase service
  Future<void> initialize() async {
    // Check if the store is available
    final isAvailable = await _inAppPurchase.isAvailable();
    if (!isAvailable) {
      _isAvailable = false;
      _isLoading = false;
      return;
    }

    // For App Store, request a delegate
    if (Platform.isIOS) {
      final InAppPurchaseStoreKitPlatformAddition iosPlatformAddition =
          _inAppPurchase.getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
      await iosPlatformAddition.setDelegate(ExamplePaymentQueueDelegate());
    }

    // Listen to purchase updates
    _subscription = _inAppPurchase.purchaseStream.listen(
      _listenToPurchaseUpdated,
      onDone: () {
        _subscription?.cancel();
      },
      onError: (error) {
        debugPrint('Error in purchase stream: $error');
      },
    );

    // Load products
    await loadProducts();
  }

  // Load available products
  Future<void> loadProducts() async {
    _isLoading = true;

    final ProductDetailsResponse response =
        await _inAppPurchase.queryProductDetails(_productIds);

    if (response.notFoundIDs.isNotEmpty) {
      debugPrint('Products not found: ${response.notFoundIDs}');
    }

    debugPrint(response.productDetails.length.toString());

    _products = response.productDetails;
    _isAvailable = _products.isNotEmpty;
    _isLoading = false;
  }

  // Make a purchase
  Future<bool> buyProduct(ProductDetails product, DatabaseProvider databaseProvider) async {
    // Store the database provider for later use when the purchase is confirmed
    // We'll set the premium flag only after the purchase is confirmed
    debugPrint('[InAppPurchaseService] Initiating purchase: ${product.id}');

    final PurchaseParam purchaseParam = PurchaseParam(
      productDetails: product,
      applicationUserName: null,
    );

    // For subscriptions on Android, use buyNonConsumable for one-time purchases
    //if (product.id == _lifetimeSubscriptionId) {
      return _inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);
    //} else {
      return _inAppPurchase.buyConsumable(purchaseParam: purchaseParam);
    //}
  }

  // Restore purchases
  Future<void> restorePurchases() async {
    // Use the common method for both platforms
    await _inAppPurchase.restorePurchases();
  }
  
  // Verify subscription status with Play Store and update database
  Future<bool> verifySubscriptionWithPlayStore() async {
    debugPrint('[InAppPurchaseService] Verifying subscription with Play Store');
    
    // Initialize if not already initialized
    if (!_isAvailable) {
      await initialize();
    }
    
    // Check if store is available
    if (!_isAvailable) {
      debugPrint('[InAppPurchaseService] Store is not available for verification');
      return false;
    }
    
    final databaseProvider = DatabaseProvider();
    
    // We'll use a completer to wait for the purchase stream to provide results
    final completer = Completer<bool>();
    bool hasActiveSubscription = false;
    
    // Store the original subscription
    final originalSubscription = _subscription;
    
    // Create a temporary handler for purchase updates
    StreamSubscription<List<PurchaseDetails>>? tempSubscription;
    tempSubscription = _inAppPurchase.purchaseStream.listen(
      (purchaseDetailsList) async {
        debugPrint('[InAppPurchaseService] Received ${purchaseDetailsList.length} purchases from stream');
        
        // Check for active subscriptions
        for (final purchase in purchaseDetailsList) {
          if ((purchase.status == PurchaseStatus.purchased || 
               purchase.status == PurchaseStatus.restored) &&
              _productIds.contains(purchase.productID)) {
            
            debugPrint('[InAppPurchaseService] Found active purchase: ${purchase.productID}');
            
            // Update subscription in database based on product ID
            DateTime? expiryDate;
            String? subscriptionType;
            
            if (purchase.productID == _lifetimeSubscriptionId) {
              subscriptionType = 'lifetime';
              expiryDate = null;
              hasActiveSubscription = true;
            } else if (purchase.productID == _yearlySubscriptionId) {
              subscriptionType = 'yearly';
              expiryDate = DateTime.now().add(const Duration(days: 365));
              hasActiveSubscription = true;
            } else if (purchase.productID == _monthlySubscriptionId) {
              subscriptionType = 'monthly';
              expiryDate = DateTime.now().add(const Duration(days: 30));
              hasActiveSubscription = true;
            }
            
            if (hasActiveSubscription) {
              await databaseProvider.setSubscription(true, subscriptionType, expiryDate);
              debugPrint('[InAppPurchaseService] Updated subscription in database: $subscriptionType, expires: $expiryDate');
              
              // Complete the future with true (active subscription found)
              if (!completer.isCompleted) {
                completer.complete(true);
              }
              
              // We found an active subscription, no need to check further
              break;
            }
          }
        }
        
        // If we've processed all purchases and found no active subscription,
        // complete the future with false
        if (!hasActiveSubscription && !completer.isCompleted) {
          // Get current subscription from database
          final subscription = await databaseProvider.database.getSubscription();
          
          // If there's an active subscription in the database but not in Play Store,
          // update the database to reflect this (except for lifetime subscriptions)
          if (subscription != null && subscription.isPremium && subscription.subscriptionType != 'lifetime') {
            await databaseProvider.setSubscription(false, subscription.subscriptionType, subscription.expiryDate);
            debugPrint('[InAppPurchaseService] Marked subscription as inactive in database');
          }
          
          completer.complete(false);
        }
      },
      onDone: () {
        if (!completer.isCompleted) {
          completer.complete(hasActiveSubscription);
        }
      },
      onError: (error) {
        debugPrint('[InAppPurchaseService] Error in purchase stream: $error');
        if (!completer.isCompleted) {
          completer.complete(false);
        }
      },
    );
    
    // Trigger restore purchases to get current purchases
    try {
      await _inAppPurchase.restorePurchases();
    } catch (e) {
      debugPrint('[InAppPurchaseService] Error restoring purchases: $e');
      if (!completer.isCompleted) {
        completer.complete(false);
      }
    }
    
    // Wait for the purchase stream to provide results (with timeout)
    bool result = false;
    try {
      result = await completer.future.timeout(
        const Duration(seconds: 5),
        onTimeout: () {
          debugPrint('[InAppPurchaseService] Timeout waiting for purchase stream');
          return hasActiveSubscription;
        },
      );
    } catch (e) {
      debugPrint('[InAppPurchaseService] Error waiting for purchase stream: $e');
    }
    
    // Clean up the temporary subscription
    await tempSubscription.cancel();
    _subscription = originalSubscription;
    
    return result;
  }

  // Handle purchase updates
  void _listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) async {
    for (final PurchaseDetails purchaseDetails in purchaseDetailsList) {
      if (purchaseDetails.status == PurchaseStatus.pending) {
        // Show a dialog or indicator that purchase is pending
        debugPrint('Purchase pending: ${purchaseDetails.productID}');
      } else if (purchaseDetails.status == PurchaseStatus.error) {
        // Handle error
        debugPrint('Purchase error: ${purchaseDetails.error}');
      } else if (purchaseDetails.status == PurchaseStatus.purchased ||
                 purchaseDetails.status == PurchaseStatus.restored) {
        // Verify the purchase
        if (await _verifyPurchase(purchaseDetails)) {
          // Grant entitlement to the user
          await _deliverProduct(purchaseDetails);
          
          // Notify listeners that purchase is complete
          if (onPurchaseComplete != null && purchaseDetails.status == PurchaseStatus.purchased) {
            onPurchaseComplete!();
          }
        } else {
          // Invalid purchase
          debugPrint('Invalid purchase: ${purchaseDetails.productID}');
        }
      }

      // Complete the purchase
      if (purchaseDetails.pendingCompletePurchase) {
        await _inAppPurchase.completePurchase(purchaseDetails);
      }
    }
  }

  // Verify the purchase (in a real app, this would involve server verification)
  Future<bool> _verifyPurchase(PurchaseDetails purchaseDetails) async {
    // In a production app, you would verify the purchase with your server
    // For this example, we'll just return true
    return true;
  }

  // Deliver the product to the user
  Future<void> _deliverProduct(PurchaseDetails purchaseDetails) async {
    // Update the user's subscription status in the database
    final databaseProvider = DatabaseProvider();

    DateTime? expiryDate;
    String? subscriptionType;

    if (purchaseDetails.productID == _monthlySubscriptionId) {
      expiryDate = DateTime.now().add(const Duration(days: 30));
      subscriptionType = 'monthly';
    } else if (purchaseDetails.productID == _yearlySubscriptionId) {
      expiryDate = DateTime.now().add(const Duration(days: 365));
      subscriptionType = 'yearly';
    } else if (purchaseDetails.productID == _lifetimeSubscriptionId) {
      expiryDate = null; // No expiry for lifetime
      subscriptionType = 'lifetime';
    }

    debugPrint('[InAppPurchaseService] Activating premium features after successful purchase: ${purchaseDetails.productID}');
    await databaseProvider.setSubscription(true, subscriptionType, expiryDate);
  }

  // Dispose of resources
  void dispose() {
    _subscription?.cancel();
  }
}

// Example payment queue delegate for iOS
class ExamplePaymentQueueDelegate implements SKPaymentQueueDelegateWrapper {
  @override
  bool shouldContinueTransaction(
      SKPaymentTransactionWrapper transaction, SKStorefrontWrapper storefront) {
    return true;
  }

  @override
  bool shouldShowPriceConsent() {
    return false;
  }
}
