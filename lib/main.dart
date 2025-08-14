import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sewingcalculator/Provider/data_provider.dart';
import 'package:sewingcalculator/Provider/database_provider.dart';
import 'package:sewingcalculator/Service/InAppPurchaseService.dart';
import 'package:sewingcalculator/View/CalculationPage.dart';
import 'package:sewingcalculator/View/OnboardingScreen.dart';
import 'package:sewingcalculator/View/PaywallPage.dart';
import 'package:sewingcalculator/View/ProjectsOverviewPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => DataProvider()),
        ChangeNotifierProvider(create: (_) => DatabaseProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _initialized = false;
  bool _showOnboarding = true;

  @override
  void initState() {
    super.initState();
    _checkOnboardingStatus();
  }

  Future<void> _checkOnboardingStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final onboardingCompleted = prefs.getBool('onboarding_completed') ?? false;
    
    // Validate subscription status at app startup
    await _validateSubscription();

    setState(() {
      _showOnboarding = !onboardingCompleted;
      _initialized = true;
    });
  }
  
  Future<void> _validateSubscription() async {
    try {
      final databaseProvider = Provider.of<DatabaseProvider>(context, listen: false);
      
      // Get the current subscription from the database
      final subscription = await databaseProvider.database.getSubscription();
      final wasSubscriptionActive = subscription != null && subscription.isPremium;
      
      // First, verify subscription with Play Store
      debugPrint('[App] Verifying subscription with Play Store');
      
      // Use the InAppPurchaseService
      final purchaseService = InAppPurchaseService();
      
      try {
        // Verify subscription with Play Store and update database
        await purchaseService.verifySubscriptionWithPlayStore();
        debugPrint('[App] Play Store verification completed');
      } catch (e) {
        debugPrint('[App] Error verifying with Play Store: $e');
      }
      
      // Now check if the subscription is still valid after verification
      final isPremiumUser = await databaseProvider.isPremium();
      
      debugPrint('[App] Premium status at startup: $isPremiumUser');
      
      // If the subscription was active but is now expired, show a notification
      if (wasSubscriptionActive && !isPremiumUser && subscription?.subscriptionType != 'lifetime') {
        // We'll show this notification after the app is fully initialized
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            _showExpiredSubscriptionNotification();
          }
        });
      }
    } catch (e) {
      debugPrint('[App] Error validating subscription: $e');
    }
  }
  
  void _showExpiredSubscriptionNotification() {
    // Wait until we have a valid context
    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted) return;
      
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Abonnement abgelaufen'),
            content: const Text(
              'Dein Premium-Abonnement ist abgelaufen. Um weiterhin alle Premium-Funktionen nutzen zu können, erneuere bitte dein Abonnement.'
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Später'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  // Navigate to the PaywallPage
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const PaywallPage()),
                  );
                },
                child: const Text('Jetzt erneuern'),
              ),
            ],
          );
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nähify',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme:
            ColorScheme.fromSeed(seedColor: const Color.fromRGBO(235, 226, 211, 1)),
        useMaterial3: true,
      ),
      home: _initialized
          ? (_showOnboarding ? const OnboardingScreen() : const ProjectsOverviewPage())
          : const Scaffold(body: Center(child: CircularProgressIndicator())),
      routes: {
        '/calculation': (context) {
          // Get the project ID from the arguments
          final projectId = ModalRoute.of(context)!.settings.arguments as int;
          return CalculationPage(projectId: projectId);
        },
      },
    );
  }
}
