import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sewingcalculator/Entity/FeeEntity.dart';
import 'package:sewingcalculator/Entity/Material.dart';
import 'package:sewingcalculator/Helper/PdfService.dart';
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
  // Method to generate and download PDF
  Future<void> _generateAndDownloadPdf(BuildContext context, DataProvider dataProvider) async {
    try {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      );

      // Prepare sections for PDF
      List<Map<String, dynamic>> sections = [];

      // Einkaufspreis section
      sections.add({
        'title': 'Einkaufspreis',
        'items': dataProvider.getPositions().getByType('material') + 
                 dataProvider.getPositions().getByType('accessory') + 
                 _getFeeEk(dataProvider),
      });

      // Gebühren auf EK section
      sections.add({
        'title': 'Gebühren auf EK',
        'items': _getFeeVk(dataProvider),
      });

      // Steuern section (if applicable)
      if (dataProvider.ust) {
        sections.add({
          'title': 'Steuern auf Zwischensumme',
          'items': [
            ResultRow(
              description: 'Umsatzsteuer 19%', 
              amount: dataProvider.getUst(), 
              type: 'result'
            ),
          ],
        });
      }

      // Generate PDF
      final file = await PdfService.generateResultPdf(
        sections: sections,
        showUst: dataProvider.ust,
        ustAmount: dataProvider.getUst(),
        totalAmount: dataProvider.getCalculatedVk(with_fees: true, ust: true),
      );

      // Close loading dialog
      Navigator.of(context).pop();

      // Open the PDF file
      await PdfService.openFile(file);

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('PDF erfolgreich erstellt und geöffnet'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      // Close loading dialog if open
      if (Navigator.canPop(context)) {
        Navigator.of(context).pop();
      }

      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Fehler beim Erstellen der PDF: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Helper method to get fee_ek items
  List<ResultRow> _getFeeEk(DataProvider dataProvider) {
    List<ResultRow> fee_ek = [];
    for (FeeEntity e in dataProvider.getActiveFees()) {
      if (e.on_ek) {
        fee_ek.add(ResultRow(
          type: 'fee_ek', 
          amount: e.getFee(dataProvider.getCalculatedEk(), on_ek: e.on_ek), 
          description: e.type
        ));
      }
    }
    return fee_ek;
  }

  // Helper method to get fee_vk items
  List<ResultRow> _getFeeVk(DataProvider dataProvider) {
    List<ResultRow> fee_vk = [];
    for (FeeEntity e in dataProvider.getActiveFees()) {
      if (!e.on_ek) {
        fee_vk.add(ResultRow(
          type: 'fee_ek', 
          amount: e.getFee(dataProvider.getCalculatedEk(), on_ek: e.on_ek), 
          description: e.type + ' ${UnitHelper.formatCurrency(e.fix_fee, true)} + ${UnitHelper.formatCurrency(e.percentage, false)}%'
        ));
      }
    }
    return fee_vk;
  }

  @override
  Widget build(BuildContext context) {
    final dataProvider = Provider.of<DataProvider>(context);

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ResultSumCard(title: 'Einkaufspreis', items: dataProvider.getPositions().getByType('material') + dataProvider.getPositions().getByType('accessory') + _getFeeEk(dataProvider)),
            //ResultSumCard(title: 'Zubehör', items: dataProvider.getPositions().getByType('accessory')),
            //ResultSumCard(title: 'Gebühren', items: dataProvider.getPositions().getByType('fee')),
            ResultSumCard(title: 'Gebühren auf EK', items: /*[ResultRow(type: "sum_ek", description: "Einkaufspreis", amount: dataProvider.getCalculatedEk())] + */_getFeeVk(dataProvider)),
            (dataProvider.ust) ? ResultSumCard(title: 'Steuern auf Zwischensumme', items: [
              ResultRow(description: 'Umsatzsteuer 19%', amount: dataProvider.getUst(), type: 'result'),
            ]) : Container(),
            ResultSumCard(title: "Summe", items: [ResultRow(type: "sum", description: "Verkaufspreis", amount: dataProvider.getCalculatedVk(with_fees: true, ust: true))])
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _generateAndDownloadPdf(context, dataProvider),
        tooltip: 'PDF herunterladen',
        child: Icon(Icons.download),
      ),
    );
  }

  Widget listItem(MaterialEntity material, int index) {
    return Placeholder();
  }
}
