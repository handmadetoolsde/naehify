import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sewingcalculator/Helper/ResultHelper.dart';

class ResultSumCard extends StatelessWidget {
  final String title;
  final List<ResultRow> items;

  const ResultSumCard({
    super.key,
    required this.title,
    required this.items,
  });

  // Hilfsmethode zur Währungsformatierung
  String _formatCurrency(double amount) {
    return NumberFormat.currency(locale: 'de_DE', symbol: '€').format(amount);
  }

  @override
  Widget build(BuildContext context) {
    // Berechnung der Gesamtsumme
    double totalAmount = items.fold(0.0, (sum, item) => sum + item.amount);

    return Card(
      elevation: 4.0,
      margin: const EdgeInsets.all(16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Titel der Karte
            Text(
              title,
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary, // Passende Farbe zum Theme
              ),
            ),
            const SizedBox(height: 2.0),

            // Auflistung der Positionen
            if (items.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Center(
                  child: Text(
                    'Keine Positionen vorhanden.',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ),
              )
            else
              ListView.separated(
                shrinkWrap: true, // Wichtig, damit ListView in Column funktioniert
                physics: NeverScrollableScrollPhysics(), // Deaktiviert Scrollen der inneren Liste
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 0.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded( // Nimmt verfügbaren Platz für die Beschreibung
                          child: Text(
                            item.description,
                            style: TextStyle(fontSize: 14.0),
                          ),
                        ),
                        Text(
                          _formatCurrency(item.amount),
                          style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  );
                },
                separatorBuilder: (context, index) => const SizedBox(height: 1.0), // Kleiner Abstand zwischen den Zeilen
              ),

            // Summenstrich (Divider)
            if (items.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 0.0),
                child: Divider(
                  thickness: 1.5,
                  color: Colors.grey[400],
                ),
              ),

            // Gesamtsumme
            if (items.isNotEmpty)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    '',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    _formatCurrency(totalAmount),
                    style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}