import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Helper/Units.dart';
import '../Provider/data_provider.dart';

class SumCard extends StatefulWidget {
  const SumCard({super.key});

  @override
  State<SumCard> createState() => _SumCardState();
}

class _SumCardState extends State<SumCard> {


  @override
  Widget build(BuildContext context) {

    final dataProvider = Provider.of<DataProvider>(context);

    return Container(
      width: double.infinity, // Volle Breite
      margin: const EdgeInsets.symmetric(horizontal: 11), // Horizontaler Abstand
      child: Card(
        elevation: 8, // Schattenhöhe
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12), // Eckradius
        ),
        child: Padding(
          padding: const EdgeInsets.all(16), // Innenabstand
          child: Column(
            children: [
              Text('Einkaufspreis: ${UnitHelper.formatCurrency(dataProvider.getCalculatedEk(), true)}'),
              Text('Verkaufspreis: ${UnitHelper.formatCurrency(dataProvider.getCalculatedVk(with_fees: true), true)}'),
            ],
          ),
        ),
      ),
    );
  }
}