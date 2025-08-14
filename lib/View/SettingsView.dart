import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';
import 'package:sewingcalculator/Entity/Material.dart';
import 'package:sewingcalculator/Provider/data_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsView extends StatelessWidget {
  SettingsView({
    super.key,
  });

  late SharedPreferencesAsync prefs;
  bool tutorial_finished = false;


  bool getTutorialFinishedState() {
    debugPrint('function: getTutorialFinishedState');
    if (prefs.containsKey('tutorial_finished').toString() == "true") {
      debugPrint('return: ${prefs.getBool('tutorial_finished')}');
      if (prefs.getBool('tutorial_finished').toString() == "true") {
        return true;
      }
      return false;
    }
    debugPrint('return: false (not found)');
    return false;
  }

  void setTutorialFinished(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('tutorial_finished', value);
    tutorial_finished = value;
  }

  @override
  Widget build(BuildContext context) {

    prefs = SharedPreferencesAsync();
    tutorial_finished = getTutorialFinishedState();

    final dataProvider = Provider.of<DataProvider>(context);
    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius:
          BorderRadius.all(Radius.circular(10.0))),
      content: Builder(
        builder: (context) {
          // Get available height and width of the build area of this widget. Make a choice depending on the size.
          var width = MediaQuery.of(context).size.width;
          final formKey = GlobalKey<FormBuilderState>();

          MaterialEntity material = MaterialEntity();
          return SizedBox(
            //height: height - 200,
            width: width - 100,
            child: Stack(
              children: [SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Einstellungen",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 25)),
                    Text(
                        "Setze hier grundlegende Einstellungen zu deinem Gewerbe.",
                        style: TextStyle(fontSize: 15)),
                    Container(
                      height: 25,
                    ),


                    Row(
                      children: [
                        Text("Umsatzsteuer berechnen", style: TextStyle(fontSize: 16),),
                        Expanded(child: Switch(onChanged: (e)  {dataProvider.setUst(e); }, value: dataProvider.ust,),)

                      ],
                    ),

                    Row(
                      children: [
                        Text("Tutorial ausblenden", style: TextStyle(fontSize: 16),),
                        Expanded(child: Switch(onChanged: (e)  {setTutorialFinished(e); }, value: tutorial_finished,),)

                      ],
                    ),

                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop(true);
                      },
                      child: Text('Schließen'),
                    )
                  ],
                ),
              ),
                Positioned(
                  top: -5,
                  right: -10,
                  child: IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                  ),
                ),],
            ),
          );
        },
      ),
    );
  }
}