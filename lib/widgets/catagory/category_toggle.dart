import 'package:flutter/material.dart';

enum PeriodType { week, month, year }

class CategoryToggle extends StatelessWidget {
  final PeriodType selected;
  final Function(PeriodType) onChanged;

  const CategoryToggle({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  String getLabel(PeriodType type) {
    switch (type) {
      case PeriodType.week:
        return "สัปดาห์";
      case PeriodType.month:
        return "เดือน";
      case PeriodType.year:
        return "ปี";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: PeriodType.values.map((type) {
          final isSelected = selected == type;

          return Expanded(
            child: GestureDetector(
              onTap: () => onChanged(type),
              child: AnimatedContainer(
                duration: Duration(milliseconds: 200),
                margin: EdgeInsets.all(6),
                padding: EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Center(
                  child: Text(
                    getLabel(type),
                    style: TextStyle(
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
