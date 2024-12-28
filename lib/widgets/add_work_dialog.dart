import 'package:flutter/material.dart';

class AddWorkDialog extends StatefulWidget {
  final Function(Map<String, dynamic>) onAdd;

  const AddWorkDialog({
    required this.onAdd,
    super.key,
  });

  @override
  _AddWorkDialogState createState() => _AddWorkDialogState();
}

class _AddWorkDialogState extends State<AddWorkDialog> {
  String? selectedWork;
  TextEditingController hoursController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Añadir trabajo'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButtonFormField<String>(
            value: selectedWork,
            items: [
              'Trabajo 1',
              'Trabajo 2',
              'Trabajo 3',
            ].map((work) {
              return DropdownMenuItem<String>(
                value: work,
                child: Text(work),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                selectedWork = value;
              });
            },
            decoration: const InputDecoration(labelText: 'Seleccionar trabajo'),
          ),
          TextField(
            controller: hoursController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Horas trabajadas'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: () {
            if (selectedWork != null && hoursController.text.isNotEmpty) {
              widget.onAdd({
                'work': selectedWork!,
                'hours': int.parse(hoursController.text),
              });
              Navigator.of(context).pop();
            }
          },
          child: const Text('Añadir'),
        ),
      ],
    );
  }
}
