import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';
import 'package:sewingcalculator/Entity/Material.dart';
import 'package:sewingcalculator/Helper/GermanFloatValidator.dart';
import 'package:sewingcalculator/Helper/Units.dart';
import 'package:sewingcalculator/Provider/data_provider.dart';

class AddMaterialDialog extends StatelessWidget {
  const AddMaterialDialog({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
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
                    Text("Material hinzufügen",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 25)),
                    Text(
                        "Erstelle ein neues Grundmaterial für dein Produkt und füge es deiner Kalkulation hinzu.",
                        style: TextStyle(fontSize: 15)),
                    Container(
                      height: 12,
                    ),
                    FormBuilder(
                      key: formKey,
                      child: Column(
                        children: [
                          FormBuilderTextField(
                            name: 'type',
                            initialValue: material.type,
                            decoration: const InputDecoration(
                                labelText: 'Bezeichnung'),
                            validator:
                            FormBuilderValidators.compose([
                              FormBuilderValidators.required(),
                            ]),
                            onSaved: (val) {
                              material.setType(val!);
                            },
                          ),
                          Row(
                            children: [
                              // Das Textfeld nimmt ein Drittel der Breite ein
                              Expanded(
                                flex: 1,
                                // Flexwert 1 für ein Drittel der Breite
                                child: FormBuilderTextField(
                                  name: 'amount',
                                  validator:
                                  FormBuilderValidators
                                      .compose([
                                    FormBuilderValidators
                                        .required(),
                                    GermanFloatValidator
                                  ]),
                                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                                  onSaved: (val) {
                                    material.amount =
                                        double.parse(val!
                                            .replaceAll(
                                            ',', '.'));
                                  },
                                  decoration: InputDecoration(
                                      labelText: 'Menge'),
                                ),
                              ),
                              // Das Dropdown nimmt zwei Drittel der Breite ein
                              Expanded(
                                flex: 2,
                                // Flexwert 2 für zwei Drittel der Breite
                                child: FormBuilderDropdown(
                                  initialValue: UnitHelper.getUnitByIdentifier('meter').identifier,
                                  onSaved: (val) {
                                    material.setUnit(UnitHelper
                                        .getUnitByIdentifier(
                                        val!));
                                  },
                                  name: 'unit',
                                  decoration: InputDecoration(
                                      labelText: 'Einheit'),
                                  items: UnitHelper
                                      .getDropdownItems(),
                                ),
                              ),
                            ],
                          ),
                          Container(height: 16),
                          Text(
                              "Für die Berechnung des Preises benötigen wir noch den Einkaufspreis auf eine volle Einheit.",
                              style: TextStyle(fontSize: 15)),
                          SizedBox(height: 20),

                          FormBuilderTextField(
                            name: 'purchase_price_per_unit',
                            validator:
                            FormBuilderValidators
                                .compose([
                              FormBuilderValidators
                                  .required(),
                              GermanFloatValidator
                            ]),
                            keyboardType: TextInputType.numberWithOptions(decimal: true),
                            onSaved: (val) {
                              material.purchase_price_per_unit =
                                  double.parse(val!
                                      .replaceAll(
                                      ',', '.'));
                            },
                            decoration: InputDecoration(
                                labelText: 'Grundpreis in €'),
                          ),

                          SizedBox(height: 20),

                          ElevatedButton(
                            onPressed: () {
                              formKey.currentState!.save();
                              if (formKey.currentState!
                                  .validate()) {

                                final dataProvider = Provider.of<DataProvider>(context, listen: false);
                                dataProvider.addMaterial(material);
                                Navigator.of(context).pop(true);
                              }
                            },
                            child: Text('Speichern'),
                          ),
                        ],
                      ),
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