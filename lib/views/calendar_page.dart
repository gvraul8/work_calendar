import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import '../widgets/calendar_widget.dart';
import '../services/pdf_service.dart';
import 'day_details_page.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime _selectedDay = DateTime.now();
  Map<DateTime, List<Map<String, dynamic>>> _workLog = {};

  Future<void> _generatePdf() async {
    final pdfService = PdfService();
    final selectedMonth = DateTime(_selectedDay.year, _selectedDay.month); // Mes seleccionado
    final pdfData = await pdfService.generateCalendarPdf(
      selectedMonth: selectedMonth,
      workLog: _workLog, // Datos de trabajo
    );
    await Printing.layoutPdf(onLayout: (format) async => pdfData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Work Calendar'),
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: _generatePdf,
          ),
        ],
      ),
      body: CalendarWidget(
        selectedDay: _selectedDay,
        onDaySelected: (selectedDay) {
          setState(() {
            _selectedDay = selectedDay;
          });
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DayDetailsPage(
                selectedDay: _selectedDay,
                workLog: _workLog,
                onWorkUpdated: (updatedWork) {
                  setState(() {
                    _workLog[_selectedDay] = updatedWork;
                  });
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
