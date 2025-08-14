import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:sewingcalculator/View/PaywallPage.dart';
import 'package:sewingcalculator/View/ProjectsOverviewPage.dart';
import 'package:sewingcalculator/View/VectorImages.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final introKey = GlobalKey<IntroductionScreenState>();

  void _onIntroEnd(BuildContext context, {bool showPaywall = true}) async {
    // Save that onboarding is completed
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_completed', true);

    if (!mounted) return;

    if (showPaywall) {
      // Navigate to paywall
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const PaywallPage()),
      );
    } else {
      // Skip paywall and go directly to app
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const ProjectsOverviewPage()),
      );
    }
  }

  Widget _buildImage(String vectorType, [double width = 350]) {
    switch (vectorType) {
      case 'calculation':
        return Image.asset(
          'images/onboarding/calculator.jpg',
          width: width,
          height: width,
          fit: BoxFit.contain,
        );
      case 'offers':
        return OnboardingVectors.offersVector(context, size: width);
      case 'fees':
        return OnboardingVectors.feesVector(context, size: width);
      case 'premium':
        return OnboardingVectors.premiumVector(context, size: width);
      default:
        return SizedBox(width: width, height: width);
    }
  }

  @override
  Widget build(BuildContext context) {
    const bodyStyle = TextStyle(fontSize: 16.0);
    const pageDecoration = PageDecoration(
      titleTextStyle: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
      bodyTextStyle: bodyStyle,
      bodyPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      pageColor: Colors.white,
      imagePadding: EdgeInsets.zero,
    );

    return IntroductionScreen(
      key: introKey,
      globalBackgroundColor: Colors.white,
      allowImplicitScrolling: true,
      autoScrollDuration: 3000,
      infiniteAutoScroll: false,
      pages: [
        PageViewModel(
          title: "Einfache Kalkulation von Nähprojekten",
          body: "Berechne schnell und einfach die Kosten für deine Nähprojekte. Erfasse Materialien, Zubehör und weitere Kosten in einer übersichtlichen Oberfläche.",
          image: _buildImage('calculation'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Schnelles Erstellen von Angeboten",
          body: "Erstelle professionelle Angebote für deine Kund:innen mit nur wenigen Klicks. Alle Kosten werden automatisch berechnet und übersichtlich dargestellt.",
          image: _buildImage('offers'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Korrekte Berechnung von Verkaufsgebühren",
          body: "Behalte den Überblick über alle Gebühren, die bei Verkaufsplattformen anfallen. So weißt du immer genau, wie viel du am Ende verdienst.",
          image: _buildImage('fees'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Premium-Funktionen",
          body: "Mit Nähify Premium erhältst du Zugang zu allen Funktionen, u.a.:\n\n• Berechnung für Kleinunternehmer ohne Umsatzsteuer\n• Speichern von beliebig vielen Projekten\n• Backup und Wiederherstellung deiner Daten",
          image: _buildImage('premium'),
          decoration: pageDecoration,
          footer: Padding(
            padding: const EdgeInsets.only(top: 24.0),
            child: ElevatedButton(
              onPressed: () => _onIntroEnd(context, showPaywall: true),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
                minimumSize: const Size.fromHeight(50),
              ),
              child: const Text(
                'Premium entdecken',
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ],
      onDone: () => _onIntroEnd(context, showPaywall: true),
      onSkip: () => _onIntroEnd(context, showPaywall: false),
      showSkipButton: true,
      skipOrBackFlex: 0,
      nextFlex: 0,
      showBackButton: false,
      back: const Icon(Icons.arrow_back),
      skip: const Text('Überspringen', style: TextStyle(fontWeight: FontWeight.w600)),
      next: const Icon(Icons.arrow_forward),
      done: const Text('Fertig', style: TextStyle(fontWeight: FontWeight.w600)),
      curve: Curves.fastLinearToSlowEaseIn,
      controlsMargin: const EdgeInsets.all(16),
      controlsPadding: const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0),
      dotsDecorator: const DotsDecorator(
        size: Size(10.0, 10.0),
        color: Color(0xFFBDBDBD),
        activeSize: Size(22.0, 10.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
      ),
      dotsContainerDecorator: const ShapeDecoration(
        color: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
      ),
    );
  }
}
