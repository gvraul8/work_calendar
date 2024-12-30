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

  void _deleteWork(int index) {
    setState(() {
      dayWork.removeAt(index);
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
                child: ListView.builder(
                  itemCount: dayWork.length,
                  itemBuilder: (context, index) {
                    final entry = dayWork[index];
                    return ListTile(
                      title: Text(entry['work']),
                      subtitle: Text('${entry['hours']} horas'),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => _deleteWork(index),
                      ),
                    );
                  },
                ),
              )
            else
              const Expanded(
                child: Center(
                  child: Text('No hay trabajos registrados para este día.'),
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
