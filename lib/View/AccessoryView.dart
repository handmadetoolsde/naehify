import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sewingcalculator/Entity/AccessoryEntity.dart';
import 'package:sewingcalculator/Helper/EmptyWidget.dart';
import 'package:sewingcalculator/Helper/Units.dart';

import '../Provider/data_provider.dart';
import 'SumCard.dart';

class AccessoryView extends StatefulWidget {
  const AccessoryView({super.key});

  String getTitle() {
    return "Nähkulator: Zubehör";
  }

  @override
  State<AccessoryView> createState() => _AccessoryViewState();
}

class _AccessoryViewState extends State<AccessoryView> {
  void _removeItem(int index) {
    setState(() {
      final dataProvider = Provider.of<DataProvider>(context, listen: false);
      dataProvider.removeAccessory(index);
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
          child: (dataProvider.accessoryList.accessories.isEmpty)
              ? EmptyWidget()
              : ListView.builder(
                  itemCount: dataProvider.accessoryList.accessories.length,
                  itemBuilder: (context, index) {
                    return listItem(
                        dataProvider.accessoryList.accessories[index], index);
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

  Widget listItem(AccessoryEntity accessory, index) {
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
                        accessory.type,
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
                  'Grundpreis: ${UnitHelper.formatCurrency(accessory.purchase_price_per_unit, true)}/${accessory.unit.unit} - benötigt werden: ${UnitHelper.formatCurrency(accessory.amount, false)}${accessory.unit.unit}'),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(UnitHelper.formatCurrency(accessory.getSum(), true),
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold))
                ],
              )
            ],
          ),
        ));
  }
}
