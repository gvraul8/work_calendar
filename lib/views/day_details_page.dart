import 'package:flutter/material.dart';
import '../widgets/add_work_dialog.dart';

class DayDetailsPage extends StatefulWidget {
  final DateTime selectedDay;
  final Map<DateTime, List<Map<String, dynamic>>> workLog;
  final Function(List<Map<String, dynamic>>) onWorkUpdated;

  const DayDetailsPage({
    required this.selectedDay,
    required this.workLog,
    required this.onWorkUpdated,
    super.key,
  });

  @override
  _DayDetailsPageState createState() => _DayDetailsPageState();
}

class _DayDetailsPageState extends State<DayDetailsPage> {
  late List<Map<String, dynamic>> dayWork;

  @override
  void initState() {
    super.initState();
    dayWork = widget.workLog[widget.selectedDay] ?? [];
  }

  void _addWork(Map<String, dynamic> newWork) {
    setState(() {
      dayWork.add(newWork);
    });
    widget.onWorkUpdated(dayWork);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            'Detalles del ${widget.selectedDay.toLocal().toString().split(' ')[0]}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (dayWork.isNotEmpty)
              Expanded(
                child: ListView(
                  children: dayWork.map((entry) {
                    return ListTile(
                      title: Text(entry['work']),
                      subtitle: Text('${entry['hours']} horas'),
                    );
                  }).toList(),
                ),
              ),
            ElevatedButton.icon(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AddWorkDialog(onAdd: _addWork),
                );
              },
              icon: const Icon(Icons.add),
              label: const Text('Añadir trabajo'),
            ),
          ],
        ),
      ),
    );
  }
}
