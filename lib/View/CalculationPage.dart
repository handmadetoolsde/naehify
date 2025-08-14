import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sewingcalculator/Database/database.dart';
import 'package:sewingcalculator/Provider/data_provider.dart';
import 'package:sewingcalculator/Provider/database_provider.dart';
import 'package:sewingcalculator/View/AccessoryView.dart';
import 'package:sewingcalculator/View/FeeView.dart';
import 'package:sewingcalculator/View/FloatingActionButtons.dart';
import 'package:sewingcalculator/View/MaterialView.dart';
import 'package:sewingcalculator/View/ResultView.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import 'dart:ui';

import '../Entity/AccessoryEntity.dart';
import '../Entity/FeeEntity.dart';
import '../Entity/Material.dart';
import '../Helper/Units.dart';

class CalculationPage extends StatefulWidget {
  final int projectId;
  
  const CalculationPage({
    super.key,
    required this.projectId,
  });

  @override
  _CalculationPageState createState() => _CalculationPageState();
}

class _CalculationPageState extends State<CalculationPage> {
  late TutorialCoachMark tutorialCoachMark;
  late DatabaseProvider _databaseProvider;
  late Project _project;
  bool _isLoading = true;

  Widget body = MaterialView();
  int selected_index = 0;
  String title = "Nähify";

  GlobalKey nav_material = GlobalKey();
  GlobalKey nav_accessory = GlobalKey();
  GlobalKey nav_fee = GlobalKey();
  GlobalKey nav_result = GlobalKey();
  GlobalKey save_button = GlobalKey();

  @override
  void initState() {
    super.initState();
    _databaseProvider = Provider.of<DatabaseProvider>(context, listen: false);
    _loadProject();
    createTutorial();
    Future.delayed(Duration.zero, showTutorial);
  }

  Future<void> _loadProject() async {
    try {
      final project = await _databaseProvider.getProject(widget.projectId);
      
      // Load materials, accessories, and fees for this project
      final materials = await _databaseProvider.getMaterialsForProject(widget.projectId);
      final accessories = await _databaseProvider.getAccessoriesForProject(widget.projectId);
      final fees = await _databaseProvider.getFeesForProject(widget.projectId);
      
      // Update the DataProvider with the loaded data
      final dataProvider = Provider.of<DataProvider>(context, listen: false);
      
      // Clear existing data
      for (int i = dataProvider.materials.materials.length - 1; i >= 0; i--) {
        dataProvider.removeMaterial(i);
      }
      
      for (int i = dataProvider.accessories.accessories.length - 1; i >= 0; i--) {
        dataProvider.removeAccessory(i);
      }
      
      // Add loaded materials
      for (final material in materials) {
        final materialEntity = MaterialEntity();
        materialEntity.type = material.type;
        materialEntity.setUnit(UnitHelper.getUnitByIdentifier(material.unitIdentifier));
        materialEntity.purchase_price_per_unit = material.purchasePricePerUnit;
        materialEntity.amount = material.amount;
        dataProvider.addMaterial(materialEntity);
      }
      
      // Add loaded accessories
      for (final accessory in accessories) {
        final accessoryEntity = AccessoryEntity();
        accessoryEntity.type = accessory.type;
        accessoryEntity.setUnit(UnitHelper.getUnitByIdentifier(accessory.unitIdentifier));
        accessoryEntity.purchase_price_per_unit = accessory.purchasePricePerUnit;
        accessoryEntity.amount = accessory.amount;
        dataProvider.addAccessory(accessoryEntity);
      }
      
      // Set fees
      for (final fee in fees) {
        final feeEntity = FeeEntity(
          type: fee.type,
          percentage: fee.percentage,
          fix_fee: fee.fixFee,
          is_active: fee.isActive,
          interactive: fee.interactive,
          on_ek: fee.onEk,
        );
        dataProvider.setFee(feeEntity);
      }
      
      setState(() {
        _project = project;
        title = project.name;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading project: $e');
      setState(() {
        _isLoading = false;
        title = "Neue Kalkulation";
      });
    }
  }

  Future<void> _saveProject() async {
    setState(() {
      _isLoading = true;
    });
    
    try {
      final dataProvider = Provider.of<DataProvider>(context, listen: false);
      
      // Update project
      final updatedProject = _project.copyWith(
        updatedAt: DateTime.now(),
      );
      await _databaseProvider.updateProject(updatedProject);
      
      // Delete existing materials, accessories, and fees
      await _databaseProvider.deleteMaterialsForProject(widget.projectId);
      await _databaseProvider.deleteAccessoriesForProject(widget.projectId);
      await _databaseProvider.deleteFeesForProject(widget.projectId);
      
      // Save materials
      for (final material in dataProvider.materials.materials) {
        await _databaseProvider.addMaterialToProject(
          widget.projectId,
          material.type,
          material.unit.identifier,
          material.purchase_price_per_unit,
          material.amount,
        );
      }
      
      // Save accessories
      for (final accessory in dataProvider.accessories.accessories) {
        await _databaseProvider.addAccessoryToProject(
          widget.projectId,
          accessory.type,
          accessory.unit.identifier,
          accessory.purchase_price_per_unit,
          accessory.amount,
        );
      }
      
      // Save fees
      for (final fee in dataProvider.getActiveFees()) {
        await _databaseProvider.addFeeToProject(
          widget.projectId,
          fee.type,
          fee.percentage,
          fee.fix_fee,
          fee.is_active,
          fee.interactive,
          fee.on_ek,
        );
      }
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Kalkulation gespeichert'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      print('Error saving project: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Fehler beim Speichern: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: Text(title),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(title),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            key: save_button,
            icon: const Icon(Icons.save),
            onPressed: _saveProject,
          ),
        ],
      ),
      floatingActionButton:
          (FloatingActionButtons(context)).getFab(selected_index),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: const Icon(Icons.checkroom),
            key: nav_material,
            label: 'Material',
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.widgets),
            key: nav_accessory,
            label: 'Zubehör',
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.money),
            key: nav_fee,
            label: 'Gebühren',
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.list_alt),
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
      colorShadow: const Color.fromRGBO(235, 226, 211, 1),
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
                  const Text(
                    'Willkommen bei Nähify!',
                    style: TextStyle(color: Colors.black, fontSize: 20),
                  ),
                  Container(
                    height: 80,
                  ),
                  const Text(
                    'Lass uns kurz die wichtigsten Funktionen anschauen.',
                    style: TextStyle(color: Colors.black, fontSize: 16),
                  ),
                  Container(
                    height: 20,
                  ),
                  const Text(
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
                  const Text(
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
                  const Text(
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
                  const Text(
                    "Hier siehst du das Ergebnis deiner Kalkulation mit allen Details.",
                    style: TextStyle(color: Colors.black, fontSize: 16),
                  ),
                  Container(
                    height: 20,
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
    
    targets.add(
      TargetFocus(
        identify: "keySaveButton",
        keyTarget: save_button,
        alignSkip: Alignment.bottomLeft,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Text(
                    "Vergiss nicht, deine Kalkulation regelmäßig zu speichern!",
                    style: TextStyle(color: Colors.black, fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  const Text(
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