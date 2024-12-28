import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarWidget extends StatelessWidget {
  final DateTime selectedDay;
  final Function(DateTime) onDaySelected;

  const CalendarWidget({
    required this.selectedDay,
    required this.onDaySelected,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      focusedDay: selectedDay,
      firstDay: DateTime.utc(2000, 1, 1),
      lastDay: DateTime.utc(2100, 12, 31),
      selectedDayPredicate: (day) => isSameDay(day, selectedDay),
      onDaySelected: (selectedDay, focusedDay) {
        onDaySelected(selectedDay);
      },
    );
  }
}
