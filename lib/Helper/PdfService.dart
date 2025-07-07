import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:sewingcalculator/Helper/ResultHelper.dart';

class PdfService {
  // Generate PDF from ResultHelper data
  static Future<File> generateResultPdf({
    required List<Map<String, dynamic>> sections,
    required bool showUst,
    required double ustAmount,
    required double totalAmount,
  }) async {
    // Create a PDF document with font that supports Euro symbol
    final pdf = pw.Document(
      theme: pw.ThemeData.withFont(
        base: pw.Font.helvetica(),
      ),
    );

    // Load the app logo
    final ByteData logoData = await rootBundle.load('images/naehify_app_logo.jpg');
    final Uint8List logoBytes = logoData.buffer.asUint8List();
    final pw.MemoryImage logoImage = pw.MemoryImage(logoBytes);

    // Define custom color for headings and sums
    final customColor = PdfColor.fromHex('#000000');

    // Define styles
    final titleStyle = pw.TextStyle(
      fontSize: 16,
      fontWeight: pw.FontWeight.bold,
      color: customColor,
    );

    final headerTextStyle = pw.TextStyle(
      fontSize: 24,
      fontWeight: pw.FontWeight.bold,
      color: customColor,
    );

    final itemTextStyle = pw.TextStyle(
      fontSize: 14,
    );

    final amountTextStyle = pw.TextStyle(
      fontSize: 14,
      fontWeight: pw.FontWeight.bold,
    );

    final totalTextStyle = pw.TextStyle(
      fontSize: 14,
      fontWeight: pw.FontWeight.bold,
      color: customColor,
    );

    // Add content to the PDF
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Header with logo and title
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Image(logoImage, width: 60, height: 60),
                  pw.Text('Nähify', style: headerTextStyle),
                ],
              ),
              pw.SizedBox(height: 20),

              // Date
              pw.Text(
                'Datum: ${DateFormat('dd.MM.yyyy').format(DateTime.now())}',
                style: itemTextStyle,
              ),
              pw.SizedBox(height: 20),

              // Sections
              ...sections.map((section) {
                final String title = section['title'];
                final List<ResultRow> items = section['items'];
                final double sectionTotal = items.fold(0.0, (sum, item) => sum + item.amount);

                return pw.Container(
                  margin: const pw.EdgeInsets.only(bottom: 20),
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(color: PdfColors.grey300),
                    borderRadius: pw.BorderRadius.circular(8),
                  ),
                  padding: const pw.EdgeInsets.all(16),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      // Section title
                      pw.Text(title, style: titleStyle),
                      pw.SizedBox(height: 10),

                      // Items
                      ...items.map((item) => pw.Padding(
                        padding: const pw.EdgeInsets.symmetric(vertical: 2),
                        child: pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.Expanded(
                              child: pw.Text(item.description, style: itemTextStyle),
                            ),
                            pw.Text(
                              _formatCurrency(item.amount),
                              style: amountTextStyle,
                            ),
                          ],
                        ),
                      )),

                      // Divider
                      pw.Divider(thickness: 1, color: PdfColors.grey400),

                      // Section total
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Text('', style: totalTextStyle),
                          pw.Text(
                            _formatCurrency(sectionTotal),
                            style: totalTextStyle,
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }),

              // Final total
              pw.Container(
                margin: const pw.EdgeInsets.only(top: 10),
                decoration: pw.BoxDecoration(
                  color: PdfColors.blue50,
                  borderRadius: pw.BorderRadius.circular(8),
                ),
                padding: const pw.EdgeInsets.all(16),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text(
                      'Gesamtbetrag:',
                      style: pw.TextStyle(
                        fontSize: 16,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.Text(
                      _formatCurrency(totalAmount),
                      style: pw.TextStyle(
                        fontSize: 16,
                        fontWeight: pw.FontWeight.bold,
                        color: customColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );

    // Save the PDF
    return saveDocument(name: 'naehify_kalkulation.pdf', pdf: pdf);
  }

  // Helper method to format currency
  static String _formatCurrency(double amount) {
    return NumberFormat.currency(locale: 'de_DE', symbol: 'Euro').format(amount);
  }

  // Save the PDF document to a file
  static Future<File> saveDocument({
    required String name,
    required pw.Document pdf,
  }) async {
    final bytes = await pdf.save();

    // Get the documents directory
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$name');

    // Write the PDF to the file
    await file.writeAsBytes(bytes);

    return file;
  }

  // Open the PDF file
  static Future<void> openFile(File file) async {
    final result = await OpenFile.open(file.path);

    if (result.type != ResultType.done) {
      throw Exception('Could not open the file: ${result.message}');
    }
  }
}
