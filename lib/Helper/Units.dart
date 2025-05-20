import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class UnitHelper {
  // Liste der verfügbaren Units
  static const List<Unit> units = [
    Unit(identifier: 'meter', label: 'Meter', unit: 'm'),
    Unit(identifier: 'centimeter', label: 'Centimeter', unit: 'cm'),
    Unit(identifier: 'stueck', label: 'Stück', unit: 'Stück'),
  ];

  // Methode, um DropdownMenuItems zu generieren
  static List<DropdownMenuItem<String>> getDropdownItems() {
    return units.map((unit) {
      return DropdownMenuItem(
        value: unit.identifier, // Nutze den Identifier als Wert
        child: Text(unit.label), // Nutze das Label als Anzeige
      );
    }).toList();
  }

  // Optionale Methode, um eine Unit anhand ihres Identifiers zu finden
  static Unit getUnitByIdentifier(String identifier) {
    return units.firstWhere(
          (unit) => unit.identifier == identifier,
      orElse: () => Unit(identifier: 'unknown', label: 'Unknown', unit: 'Unknown'),
    );
  }


  static String formatCurrency(double amount, bool withSymbol , {String locale = 'de_DE', String symbol = '€'}) {
    final formatter = NumberFormat.currency(locale: locale, symbol: (withSymbol) ? symbol: '');
    return formatter.format(amount);
  }

}

class Unit {
  final String identifier; // Eindeutiger Identifier (z. B. 'meter')
  final String label;      // Lesbares Label (z. B. 'Meter')
  final String unit;      // Lesbares Label (z. B. 'Meter')

  const Unit({required this.identifier, required this.label, required this.unit});
}