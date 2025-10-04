import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:provider/provider.dart';
import 'package:sewingcalculator/Provider/database_provider.dart';
import 'package:sewingcalculator/Service/InAppPurchaseService.dart';
import 'package:sewingcalculator/View/ProjectsOverviewPage.dart';

class PaywallPage extends StatefulWidget {
  const PaywallPage({super.key});

  @override
  _PaywallPageState createState() => _PaywallPageState();
}

class _PaywallPageState extends State<PaywallPage> {
  int _selectedPlanIndex = 1; // Default to yearly plan
  bool _isLoading = false;
  late InAppPurchaseService _purchaseService;
  List<ProductDetails> _availableProducts = [];

  // Mapping from product IDs to subscription plans
  final Map<String, SubscriptionPlan> _planTemplates = {
    'monthly_subscription2': SubscriptionPlan(
      title: 'Monatlich',
      price: '2,99 €', // Will be replaced with actual price
      description: 'Monatliche Zahlung',
      duration: 'pro Monat',
      productId: 'monthly_subscription2',
      savePercentage: 0,
    ),
    'yearly_subscription': SubscriptionPlan(
      title: 'Jährlich',
      price: '29,00 €', // Will be replaced with actual price
      description: 'Jährliche Zahlung',
      duration: 'pro Jahr',
      productId: 'yearly_subscription',
      savePercentage: 20,
      isBestValue: true,
    )/*,
    'lifetime_subscription': SubscriptionPlan(
      title: 'Lifetime',
      price: '49,00 €', // Will be replaced with actual price
      description: 'Einmalige Zahlung',
      duration: 'für immer',
      productId: 'lifetime_subscription',
      savePercentage: 0,
    ),*/
  };

  List<SubscriptionPlan> _plans = [];

  @override
  void initState() {
    super.initState();
    _initializePurchases();
  }

  Future<void> _initializePurchases() async {
    setState(() {
      _isLoading = true;
    });

    try {
      _purchaseService = InAppPurchaseService();
      await _purchaseService.initialize();

      debugPrint(_purchaseService.products.length.toString());

      // Load available products
      _availableProducts = _purchaseService.products;

      // Update plans with actual prices from store
      _updatePlansWithStoreData();
    } catch (e) {
      debugPrint('Error initializing purchases: $e');
      // Fallback to default plans if there's an error
      _plans = _planTemplates.values.toList();
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _updatePlansWithStoreData() {
    final List<SubscriptionPlan> updatedPlans = [];

    for (final template in _planTemplates.values) {
      // Find the corresponding product
      ProductDetails? product;
      try {
        product = _availableProducts.firstWhere(
          (p) => p.id == template.productId,
        );
      } catch (e) {
        // Product not found
        continue;
      }

      // Create a new plan with the actual price from the store
      updatedPlans.add(
        SubscriptionPlan(
          title: template.title,
          price: product.price,
          description: template.description,
          duration: template.duration,
          productId: product.id,
          savePercentage: template.savePercentage,
          isBestValue: template.isBestValue,
        ),
      );
        }

    // Sort plans: monthly, yearly, lifetime
    updatedPlans.sort((a, b) {
      if (a.productId == 'monthly_subscription') return -1;
      if (a.productId == 'yearly_subscription' && b.productId != 'monthly_subscription') return -1;
      return 1;
    });

    setState(() {
      _plans = updatedPlans;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Premium-Funktionen'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 16),
              // Header
              Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.workspace_premium,
                      size: 80,
                      color: Theme.of(context).primaryColor,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Nähify Premium',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Schalte alle Premium-Funktionen frei',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Features
              const Text(
                'Mit Premium erhältst du:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              _buildFeatureItem(
                icon: Icons.calculate,
                title: 'Unbegrenzte Kalkulationen',
                description: 'Erstelle so viele Kalkulationen wie du möchtest',
              ),
              _buildFeatureItem(
                icon: Icons.money_outlined,
                title: 'Kleinunternehmer',
                description: 'Berechnung für Kleinunternehmer ohne Umsatzsteuer',
              ),
              _buildFeatureItem(
                icon: Icons.backup,
                title: 'Backup und Wiederherstellung deiner Daten',
                description: 'Sichere deine Daten gegen einen Verlust',
              ),

              const SizedBox(height: 32),

              // Subscription Plans
              const Text(
                'Wähle deinen Plan:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              // Plan selection
              for (int i = 0; i < _plans.length; i++)
                _buildPlanCard(
                  plan: _plans[i],
                  isSelected: _selectedPlanIndex == i,
                  onTap: () {
                    setState(() {
                      _selectedPlanIndex = i;
                    });
                  },
                ),

              const SizedBox(height: 24),

              // Subscribe button
              ElevatedButton(
                onPressed: _isLoading ? null : () => _handleSubscription(context),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        'Jetzt abonnieren',
                        style: TextStyle(fontSize: 16),
                      ),
              ),

              const SizedBox(height: 16),

              // Terms and conditions
              const Text(
                'Abonnements verlängern sich automatisch, können aber jederzeit in den Einstellungen deines App Stores gekündigt werden.',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 16),

              // Restore purchases
              TextButton(
                onPressed: _isLoading ? null : _restorePurchases,
                child: const Text('Käufe wiederherstellen'),
              ),

              const SizedBox(height: 16),

              // Free version button
              OutlinedButton(
                onPressed: () {
                  // Navigate to the main app (ProjectsOverviewPage)
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (_) => const ProjectsOverviewPage()),
                  );
                },
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: BorderSide(color: Colors.grey.shade400),
                ),
                child: const Text(
                  'Kostenlose Version nutzen',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureItem({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: Theme.of(context).primaryColor,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlanCard({
    required SubscriptionPlan plan,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected
                ? Theme.of(context).primaryColor
                : Colors.grey.shade300,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(12),
          color: isSelected
              ? Theme.of(context).primaryColor.withOpacity(0.05)
              : Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Radio<int>(
                value: _plans.indexOf(plan),
                groupValue: _selectedPlanIndex,
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _selectedPlanIndex = value;
                    });
                  }
                },
                activeColor: Theme.of(context).primaryColor,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          plan.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(width: 8),
                        if (plan.isBestValue)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text(
                              'Bestseller',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      plan.description,
                      style: const TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    plan.price,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    plan.duration,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                  if (plan.savePercentage > 0)
                    Container(
                      margin: const EdgeInsets.only(top: 4),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'Spare ${plan.savePercentage}%',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleSubscription(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final selectedPlan = _plans[_selectedPlanIndex];
      final databaseProvider = Provider.of<DatabaseProvider>(context, listen: false);

      // Find the corresponding product
      ProductDetails product;
      try {
        product = _availableProducts.firstWhere(
          (p) => p.id == selectedPlan.productId,
        );
      } catch (e) {
        throw Exception('Produkt nicht verfügbar');
      }

      // Make the purchase
      final success = await _purchaseService.buyProduct(product, databaseProvider);

      if (!success) {
        throw Exception('Kauf konnte nicht abgeschlossen werden');
      }

      // Note: The actual subscription update is handled in the InAppPurchaseService
      // when the purchase is completed successfully

      if (!mounted) return;

      // Show processing message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Kauf wird verarbeitet...'),
          backgroundColor: Colors.blue,
          duration: Duration(seconds: 2),
        ),
      );
      
      // Set the callback for when purchase is fully completed
      // The premium features will only be activated after successful purchase confirmation
      _purchaseService.onPurchaseComplete = () {
        if (mounted) {
          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Kauf erfolgreich!'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
            ),
          );
          
          // Show congratulatory modal after successful purchase
          _showCongratulationsModal(context, selectedPlan);
        }
      };
    } catch (e) {
      if (!mounted) return;

      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Fehler beim Kauf: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _restorePurchases() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Restore purchases using the InAppPurchaseService
      await _purchaseService.restorePurchases();

      if (!mounted) return;

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Käufe werden wiederhergestellt...'),
          backgroundColor: Colors.blue,
        ),
      );
    } catch (e) {
      if (!mounted) return;

      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Fehler beim Wiederherstellen: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
  
  void _showCongratulationsModal(BuildContext context, SubscriptionPlan plan) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Container(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 80,
                ),
                const SizedBox(height: 24),
                Text(
                  'Herzlichen Glückwunsch!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Dein ${plan.title} Abonnement wurde erfolgreich aktiviert.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    // Close the dialog and navigate to the main app
                    Navigator.of(context).pop();
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (_) => const ProjectsOverviewPage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    backgroundColor: Theme.of(context).primaryColor,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Jetzt loslegen'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class SubscriptionPlan {
  final String title;
  final String price;
  final String description;
  final String duration;
  final String productId;
  final int savePercentage;
  final bool isBestValue;

  SubscriptionPlan({
    required this.title,
    required this.price,
    required this.description,
    required this.duration,
    required this.productId,
    this.savePercentage = 0,
    this.isBestValue = false,
  });
}
