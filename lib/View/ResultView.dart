import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sewingcalculator/Entity/FeeEntity.dart';
import 'package:sewingcalculator/Entity/Material.dart';
import 'package:sewingcalculator/Helper/ResultHelper.dart';
import 'package:sewingcalculator/Helper/Units.dart';
import 'package:sewingcalculator/Provider/data_provider.dart';
import 'package:sewingcalculator/View/SumCard.dart';

import 'ResultSumCard.dart';

class ResultView extends StatefulWidget {
  const ResultView({super.key});

  @override
  State<ResultView> createState() => _ResultViewState();
}

class _ResultViewState extends State<ResultView> {
  @override
  Widget build(BuildContext context) {
    final dataProvider = Provider.of<DataProvider>(context);

    List<ResultRow> fee_ek = [];
    List<ResultRow> fee_vk = [];

    for (FeeEntity e in dataProvider.getActiveFees()) {
      if (e.on_ek) {
        fee_ek.add(ResultRow(type: 'fee_ek', amount: e.getFee(dataProvider.getCalculatedEk(), on_ek: e.on_ek), description: e.type));
      } else {
        fee_vk.add(ResultRow(type: 'fee_ek', amount: e.getFee(dataProvider.getCalculatedEk(), on_ek: e.on_ek), description: e.type + ' ${UnitHelper.formatCurrency(e.fix_fee, true)} + ${UnitHelper.formatCurrency(e.percentage, false)}%'));
      }
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ResultSumCard(title: 'Einkaufspreis', items: dataProvider.getPositions().getByType('material') + dataProvider.getPositions().getByType('accessory') + fee_ek),
          //ResultSumCard(title: 'Zubehör', items: dataProvider.getPositions().getByType('accessory')),
          //ResultSumCard(title: 'Gebühren', items: dataProvider.getPositions().getByType('fee')),
          ResultSumCard(title: 'Gebühren auf EK', items: /*[ResultRow(type: "sum_ek", description: "Einkaufspreis", amount: dataProvider.getCalculatedEk())] + */fee_vk ),
          (dataProvider.ust) ? ResultSumCard(title: 'Steuern auf Zwischensumme', items: [
            ResultRow(description: 'Umsatzsteuer 19%', amount: dataProvider.getUst(), type: 'result'),
          ]) : Container(),
          ResultSumCard(title: "Summe", items: [ResultRow(type: "sum", description: "Verkaufspreis", amount: dataProvider.getCalculatedVk(with_fees: true, ust: true))])
        ],
      ),
    );
  }

  Widget listItem(MaterialEntity material, int index) {
    return Placeholder();
  }
}
