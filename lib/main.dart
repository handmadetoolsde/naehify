import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sewingcalculator/View/AccessoryView.dart';
import 'package:sewingcalculator/View/FeeView.dart';
import 'package:sewingcalculator/View/FloatingActionButtons.dart';
import 'package:sewingcalculator/View/MaterialView.dart';
import 'package:sewingcalculator/View/ResultView.dart';
import 'package:sewingcalculator/View/SettingsView.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

import 'Provider/data_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => DataProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nähify',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme:
            ColorScheme.fromSeed(seedColor: Color.fromRGBO(235, 226, 211, 1)),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Nähify'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late TutorialCoachMark tutorialCoachMark;

  Widget body = MaterialView();
  int selected_index = 0;
  String title = "Nähify";

  GlobalKey nav_material = GlobalKey();
  GlobalKey nav_accessory = GlobalKey();
  GlobalKey nav_fee = GlobalKey();
  GlobalKey nav_result = GlobalKey();


  @override
  void initState() {
    createTutorial();
    Future.delayed(Duration.zero, showTutorial);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(title),
        actions: [
          IconButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (_) => StatefulBuilder(
                          builder: (context, setState) {
                            return SettingsView();
                          },
                        ));
              },
              icon: Icon(Icons.settings))
        ],
      ),
      floatingActionButton:
          (FloatingActionButtons(context)).getFab(selected_index),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.checkroom),
            key: nav_material,
            label: 'Material',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.widgets),
            key: nav_accessory,
            label: 'Zubehör',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.money),
            key: nav_fee,
            label: 'Gebühren',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt),
            key: nav_result,
            label: 'Ergebnis',
          ),
        ],
        currentIndex: selected_index,
        onTap: _onItemTapped,
      ),
      body: body,
    );
  }

  void _onItemTapped(int value) {
    if (value == 0) {
      setState(() {
        selected_index = value;
        body = MaterialView();
      });
    } else if (value == 1) {
      setState(() {
        selected_index = value;
        body = AccessoryView();
      });
    } else if (value == 2) {
      setState(() {
        selected_index = value;
        body = FeeView();
      });
    } else if (value == 3) {
      setState(() {
        selected_index = value;
        body = ResultView();
      });
    } else {
      setState(() {
        selected_index = value;
      });
    }
  }

  /////////////////////// Tutorial

  void showTutorial() async {
    debugPrint('function: showTutorial');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if ((prefs.containsKey('tutorial_finished') && prefs.getBool('tutorial_finished') == false) || prefs.containsKey('tutorial_finished') == false) {
      tutorialCoachMark.show(context: context);
    }
  }

  void setTutorialFinished() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('tutorial_finished', true);
  }

  void createTutorial() {
    tutorialCoachMark = TutorialCoachMark(
      targets: _createTargets(),
      colorShadow: Color.fromRGBO(235, 226, 211, 1),
      textSkip: "Tutorial überspringen",
      paddingFocus: 10,
      opacityShadow: 0.5,
      imageFilter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
      onFinish: () {
        print("finish");
        setTutorialFinished();
      },
      onClickTarget: (target) {
        print('onClickTarget: $target');
      },
      onClickTargetWithTapPosition: (target, tapDetails) {
        print("target: $target");
        print(
            "clicked at position local: ${tapDetails.localPosition} - global: ${tapDetails.globalPosition}");
      },
      onClickOverlay: (target) {
        print('onClickOverlay: $target');
      },
      onSkip: () {
        print("skip");
        setTutorialFinished();
        return true;
      },
    );
  }

  List<TargetFocus> _createTargets() {
    List<TargetFocus> targets = [];
    targets.add(
      TargetFocus(
        identify: "keyBottomNavigation1",
        keyTarget: nav_material,
        alignSkip: Alignment.topRight,
        enableOverlayTab: true,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            builder: (context, controller) {
              return Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Willkommen bei Nähify!',
                    style: TextStyle(color: Colors.black, fontSize: 20),
                  ),
                  Container(
                    height: 80,
                  ),
                  Text(
                    'Lass uns kurz die wichtigsten Funktionen anschauen.',
                    style: TextStyle(color: Colors.black, fontSize: 16),
                  ),
                  Container(
                    height: 20,
                  ),
                  Text(
                    "Hier fügst du alle benötigten Materialen deiner Kalkulation hinzu, bspw. Stoffe oder Garn.",
                    style: TextStyle(color: Colors.black, fontSize: 16),
                  ),
                  Container(
                    height: 50,
                  )
                ],
              );
            },
          ),
        ],
      ),
    );

    targets.add(
      TargetFocus(
        identify: "keyBottomNavigation2",
        keyTarget: nav_accessory,
        alignSkip: Alignment.topRight,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            builder: (context, controller) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Unter diesen Punkt fügst du alles an Zubehör hinzu, bspw. Knöpfe oder Bügelbilder.",
                    style: TextStyle(color: Colors.black, fontSize: 16),
                  ),
                  Container(
                    height: 50,
                  )
                ],
              );
            },
          ),
        ],
      ),
    );

    targets.add(
      TargetFocus(
        identify: "keyBottomNavigation3",
        keyTarget: nav_fee,
        alignSkip: Alignment.topRight,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            builder: (context, controller) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Unter den Gebühren kannst du den Versand, deine Marge und die Bezahlungsgebühren mit einberechnen.",
                    style: TextStyle(color: Colors.black, fontSize: 16),
                  ),
                  Container(
                    height: 50,
                  )
                ],
              );
            },
          ),
        ],
      ),
    );
    targets.add(
      TargetFocus(
        identify: "keyBottomNavigation4",
        keyTarget: nav_result,
        alignSkip: Alignment.topRight,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            builder: (context, controller) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Hier fügst du alle benötigten Materialen deiner Kalkulation hinzu, bspw. Stoffe oder Garn.",
                    style: TextStyle(color: Colors.black, fontSize: 16),
                  ),
                  Text(
                    "Und nun: Viel Spaß!",
                    style: TextStyle(color: Colors.black, fontSize: 16),
                  ),
                  Container(
                    height: 50,
                  )
                ],
              );
            },
          ),
        ],
      ),
    );

    return targets;
  }
}
