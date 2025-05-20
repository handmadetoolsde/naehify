import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sewingcalculator/View/AccessoryView.dart';
import 'package:sewingcalculator/View/FeeView.dart';
import 'package:sewingcalculator/View/FloatingActionButtons.dart';
import 'package:sewingcalculator/View/MaterialView.dart';

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

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nähkulator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Color.fromRGBO(235, 226, 211, 1)),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Nähkulator'),
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

  Widget body = MaterialView();
  int selected_index = 0;
  String title = "Nähkulator";

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.

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
          IconButton(onPressed: () {}, icon: Icon(Icons.settings))
        ],
      ),

      floatingActionButton: (FloatingActionButtons(context)).getFab(selected_index),


      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Material',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Zubehör',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.money),
            label: 'Gebühren',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt),
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
    }
    else if (value == 1) {
      setState(() {
        selected_index = value;
        body = AccessoryView();
      });
    }
    else if (value == 2) {
      setState(() {
        selected_index = value;
        body = FeeView();
      });
    }
    else {
      setState(() {
        selected_index = value;
      });
    }
  }
}
