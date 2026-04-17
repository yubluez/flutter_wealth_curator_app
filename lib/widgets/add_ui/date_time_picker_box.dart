import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateTimePickerBox extends StatelessWidget {
  final DateTime? dateTime;
  final VoidCallback onTap;

  const DateTimePickerBox({
    super.key,
    required this.dateTime,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          dateTime == null
              ? "date / time"
              : DateFormat('dd MMM yyyy • HH:mm').format(dateTime!),
        ),
      ),
    );
  }
}