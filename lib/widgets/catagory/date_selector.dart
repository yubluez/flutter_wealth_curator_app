import 'package:flutter/material.dart';

class DateSelector extends StatelessWidget {
  final String selectedType;
  final DateTime selectedDate;
  final Function(DateTime) onDateChange;

  const DateSelector({
    super.key,
    required this.selectedType,
    required this.selectedDate,
    required this.onDateChange,
  });

  String formatDate() {
    if (selectedType == "month") {
      return "${selectedDate.month}/${selectedDate.year}";
    }

    if (selectedType == "year") {
      return "${selectedDate.year}";
    }

    if (selectedType == "week") {
      final start = selectedDate.subtract(
        Duration(days: selectedDate.weekday - 1),
      );
      final end = start.add(const Duration(days: 6));

      return "${start.day}-${end.day}/${start.month}";
    }

    return "";
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: selectedDate,
          firstDate: DateTime(2020),
          lastDate: DateTime(2100),
          initialDatePickerMode:
              selectedType == "year" ? DatePickerMode.year : DatePickerMode.day,
        );

        if (picked != null) {
          onDateChange(picked); // 🔥 ส่งกลับไป parent
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          formatDate(),
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
