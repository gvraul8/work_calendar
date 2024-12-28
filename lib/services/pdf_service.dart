import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class PdfService {
  Future<Uint8List> generateCalendarPdf(
    Map<DateTime, List<Map<String, dynamic>>> workLog,
  ) async {
    final pdf = pw.Document();
    final boldFont = await rootBundle.load("assets/fonts/Roboto-Bold.ttf");
    final regularFont = await rootBundle.load("assets/fonts/Roboto-Regular.ttf");

    final ttfBold = pw.Font.ttf(boldFont);
    final ttfRegular = pw.Font.ttf(regularFont);

    // Agregar página de calendario
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (context) {
          return pw.Column(
            children: [
              pw.Container(
                alignment: pw.Alignment.center,
                color: PdfColors.green,
                padding: const pw.EdgeInsets.all(16),
                child: pw.Text(
                  'Enero 2024',
                  style: pw.TextStyle(
                    font: ttfBold,
                    fontSize: 24,
                    color: PdfColors.white,
                  ),
                ),
              ),
              pw.SizedBox(height: 16),
              pw.Table(
                border: pw.TableBorder.all(),
                children: _buildCalendarRows(workLog, ttfRegular, ttfBold),
              ),
            ],
          );
        },
      ),
    );

    return pdf.save();
  }

  List<pw.TableRow> _buildCalendarRows(
    Map<DateTime, List<Map<String, dynamic>>> workLog,
    pw.Font regularFont,
    pw.Font boldFont,
  ) {
    final daysInMonth = List.generate(31, (index) => index + 1);
    final rows = <pw.TableRow>[];

    rows.add(
      pw.TableRow(
        children: [
          for (final day in ['Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes', 'Sábado', 'Domingo'])
            pw.Padding(
              padding: const pw.EdgeInsets.all(8),
              child: pw.Text(
                day,
                style: pw.TextStyle(font: boldFont),
                textAlign: pw.TextAlign.center,
              ),
            ),
        ],
      ),
    );

    for (final day in daysInMonth) {
      final date = DateTime(2024, 1, day);
      final logs = workLog[date] ?? [];

      rows.add(
        pw.TableRow(
          children: [
            pw.Padding(
              padding: const pw.EdgeInsets.all(4),
              child: pw.Column(
                children: [
                  pw.Text(
                    '$day',
                    style: pw.TextStyle(font: regularFont, fontSize: 10),
                  ),
                  for (final log in logs)
                    pw.Container(
                      padding: const pw.EdgeInsets.all(4),
                      margin: const pw.EdgeInsets.symmetric(vertical: 2),
                      color: PdfColors.grey300,
                      child: pw.Text(
                        '${log['hours']}H | ${log['work']}',
                        style: pw.TextStyle(font: regularFont, fontSize: 8),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return rows;
  }
}
