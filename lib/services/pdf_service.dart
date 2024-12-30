import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class PdfService {
  Future<Uint8List> generateCalendarPdf({
    required DateTime selectedMonth,
    required Map<DateTime, List<Map<String, dynamic>>> workLog,
  }) async {
    final pdf = pw.Document();

    // Calcular el nombre del mes y el año
    final monthName = _getMonthName(selectedMonth.month);
    final year = selectedMonth.year;

    // Agregar página de calendario
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4.landscape, // Formato horizontal
        build: (context) {
          return pw.Column(
            children: [
              // Encabezado del calendario
              pw.Container(
                alignment: pw.Alignment.center,
                color: PdfColors.green,
                padding: const pw.EdgeInsets.all(16),
                child: pw.Text(
                  '$monthName $year',
                  style: pw.TextStyle(
                    fontSize: 32,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.white,
                  ),
                ),
              ),
              pw.SizedBox(height: 16),
              // Tabla del calendario
              _buildCalendarTable(selectedMonth, workLog),
            ],
          );
        },
      ),
    );

    return pdf.save();
  }

  pw.Widget _buildCalendarTable(
    DateTime selectedMonth,
    Map<DateTime, List<Map<String, dynamic>>> workLog,
  ) {
    // Días de la semana
    final daysOfWeek = ['Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes', 'Sábado', 'Domingo'];

    // Generar días del mes seleccionado
    final daysInMonth = List.generate(
      DateTime(selectedMonth.year, selectedMonth.month + 1, 0).day,
      (index) => DateTime(selectedMonth.year, selectedMonth.month, index + 1),
    );
    final weeks = <List<DateTime?>>[];

    // Agrupar los días en semanas
    List<DateTime?> currentWeek = List.filled(7, null);
    for (final day in daysInMonth) {
      final weekDayIndex = (day.weekday - 1) % 7; // Ajustar índice (1 = Lunes)
      currentWeek[weekDayIndex] = day;
      if (weekDayIndex == 6) {
        weeks.add(currentWeek);
        currentWeek = List.filled(7, null);
      }
    }
    if (currentWeek.any((day) => day != null)) {
      weeks.add(currentWeek);
    }

    // Construir tabla
    return pw.Table(
      border: pw.TableBorder.all(),
      children: [
        // Encabezados de días de la semana
        pw.TableRow(
          children: [
            for (final day in daysOfWeek)
              pw.Padding(
                padding: const pw.EdgeInsets.all(8),
                child: pw.Text(
                  day,
                  style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                    fontSize: 12,
                  ),
                  textAlign: pw.TextAlign.center,
                ),
              ),
          ],
        ),
        // Filas de semanas
        for (final week in weeks)
          pw.TableRow(
            children: [
              for (final day in week)
                pw.Padding(
                  padding: const pw.EdgeInsets.all(4),
                  child: day == null
                      ? pw.Container() // Celda vacía para días fuera del mes
                      : pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text(
                              '${day.day}', // Día del mes
                              style: pw.TextStyle(
                                fontSize: 10,
                                fontWeight: pw.FontWeight.bold,
                              ),
                            ),
                            for (final log in workLog[day] ?? [])
                              pw.Container(
                                padding: const pw.EdgeInsets.all(4),
                                margin: const pw.EdgeInsets.symmetric(vertical: 2),
                                color: PdfColors.grey300,
                                child: pw.Text(
                                  '${log['hours']}H | ${log['work']}',
                                  style: pw.TextStyle(fontSize: 8),
                                ),
                              ),
                          ],
                        ),
                ),
            ],
          ),
      ],
    );
  }

  // Obtener nombre del mes en español
  String _getMonthName(int month) {
    const months = [
      'Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio',
      'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'
    ];
    return months[month - 1];
  }
}
