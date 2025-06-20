import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sewingcalculator/Entity/FeeEntity.dart';
import 'package:sewingcalculator/Helper/FeeHelper.dart';
import 'package:sewingcalculator/Helper/Units.dart';

import '../Provider/data_provider.dart';
import 'SumCard.dart';

class FeeView extends StatefulWidget {
  const FeeView({super.key});

  String getTitle() {
    return "Nähkulator: Gebühren";
  }

  @override
  State<FeeView> createState() => _FeeViewState();
}

class _FeeViewState extends State<FeeView> {

  @override
  Widget build(BuildContext context) {
    final dataProvider = Provider.of<DataProvider>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SumCard(),
        Expanded(
          child: ListView.builder(
            itemCount: FeeHelper.fees.length,
            itemBuilder: (context, index) {
              return listItem(FeeHelper.fees[index], index, dataProvider);
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

  Widget listItem(FeeEntity fee, index, DataProvider dataProvider) {
    Widget data = Card(
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
                        fee.type,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Expanded(child: Container()),
                      Switch(
                          value: fee.is_active,
                          onChanged: (value) {
                            dataProvider.setFee(fee);
                            setState(() {
                              fee.is_active = !fee.is_active;
                            });
                          })
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 8),
              (fee.is_active)
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        (fee.interactive)
                            ? IconButton(
                                onPressed: () async {
                                  final enteredAmount =
                                      await _showCurrencyInputDialog(context);
                                  if (enteredAmount != null) {
                                    // Hier kannst du den eingegebenen Betrag weiterverarbeiten
                                    print(
                                        'Eingegebener Betrag: ${NumberFormat.currency(locale: 'de_DE', symbol: '€').format(enteredAmount)}');
                                    fee.fix_fee = enteredAmount;
                                    dataProvider.setFee(fee);
                                  } else {
                                    print('Eingabe abgebrochen.');
                                  }
                                },
                                icon: Icon(Icons.edit))
                            : Container(),
                        Text(
                            UnitHelper.formatCurrency(
                                fee.getFee(dataProvider.getCalculatedEk(), on_ek: fee.on_ek),
                                true),
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                      ],
                    )
                  : Container()
            ],
          ),
        ));

    return data;
  }

  Future<double?> _showCurrencyInputDialog(BuildContext context) async {
    final _formKey = GlobalKey<FormState>();
    String? _inputValue;

    return showDialog<double>(
      context: context,
      barrierDismissible: false, // Benutzer muss einen Button klicken
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Geldbetrag eingeben'),
          content: Form(
            key: _formKey,
            child: TextFormField(
              decoration: InputDecoration(
                labelText: 'Betrag',
                hintText: 'z.B. 123,45',
                prefixIcon: Icon(Icons.euro_symbol), // Optional: Währungssymbol
              ),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                // Erlaubt nur Zahlen und ein Komma oder Punkt als Dezimaltrennzeichen
                FilteringTextInputFormatter.allow(
                    RegExp(r'^\d+([.,]\d{0,2})?$')),
              ],
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Bitte geben Sie einen Betrag ein.';
                }
                // Ersetze Komma durch Punkt für die double-Konvertierung
                final normalizedValue = value.replaceAll(',', '.');
                if (double.tryParse(normalizedValue) == null) {
                  return 'Ungültiger Betrag.';
                }
                return null;
              },
              onSaved: (value) {
                _inputValue = value;
              },
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Abbrechen'),
              onPressed: () {
                Navigator.of(context).pop(); // Schließt den Dialog ohne Wert
              },
            ),
            ElevatedButton(
              child: Text('Speichern'),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  // Ersetze Komma durch Punkt für die double-Konvertierung
                  final normalizedValue = _inputValue!.replaceAll(',', '.');
                  Navigator.of(context).pop(double.parse(normalizedValue));
                }
              },
            ),
          ],
        );
      },
    );
  }
}
