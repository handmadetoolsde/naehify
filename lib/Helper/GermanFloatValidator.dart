
String? GermanFloatValidator(String? value) {
  if (value == null || value.isEmpty) {
    return 'Bitte gib einen Wert ein.'; // Oder null, wenn leere Eingabe erlaubt ist
  }

  // Ersetze Komma durch Punkt und entferne Tausendertrennzeichen
  String valueWithDot = value.replaceAll('.', '').replaceAll(',', '.');

  if (double.tryParse(valueWithDot) == null) {
    return 'Bitte gib eine gültige Zahl ein.';
  }

  return null; // Eingabe ist gültig
}