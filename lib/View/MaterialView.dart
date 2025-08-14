import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sewingcalculator/Entity/Material.dart';
import 'package:sewingcalculator/Helper/EmptyWidget.dart';
import 'package:sewingcalculator/Helper/Units.dart';

import '../Provider/data_provider.dart';
import 'SumCard.dart';

class MaterialView extends StatefulWidget {
  const MaterialView({super.key});

  String getTitle() {
    return "Nähkulator: Material";
  }

  @override
  State<MaterialView> createState() => _MaterialViewState();
}

class _MaterialViewState extends State<MaterialView> {
  void _removeItem(int index) {
    setState(() {
      final dataProvider = Provider.of<DataProvider>(context, listen: false);
      dataProvider.removeMaterial(index);
      //_dynamicData.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    final dataProvider = Provider.of<DataProvider>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SumCard(),
        Expanded(
          child: (dataProvider.materialList.materials.isEmpty)
              ? EmptyWidget()
              : ListView.builder(
                  itemCount: dataProvider.materialList.materials.length,
                  itemBuilder: (context, index) {
                    return listItem(
                        dataProvider.materialList.materials[index], index);
                  },
                ),
        ),
        /* ElevatedButton(
          onPressed: _addItem,
          child: const Text('Widget hinzufügen'),
        ),*/
      ],
    );
  }

  Widget listItem(MaterialEntity material, index) {
    return Card(
        elevation: 8, // Schattenhöhe
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12), // Eckradius
        ),
        margin: const EdgeInsets.all(11), // Abstand zur Umgebung
        child: Padding(
          padding: const EdgeInsets.all(16), // Innenabstand
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  Row(
                    children: [
                      Text(
                        material.type,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Expanded(child: Container()),
                      IconButton(
                          onPressed: () {
                            _removeItem(index);
                          },
                          icon: Icon(Icons.delete, color: Colors.redAccent)),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                  'Grundpreis: ${UnitHelper.formatCurrency(material.purchase_price_per_unit, true)}/${material.unit.unit} - benötigt werden: ${UnitHelper.formatCurrency(material.amount, false)}${material.unit.unit}'),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(UnitHelper.formatCurrency(material.getSum(), true),
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold))
                ],
              )
            ],
          ),
        ));
  }
}
