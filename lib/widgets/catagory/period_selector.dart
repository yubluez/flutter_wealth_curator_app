import 'package:flutter/material.dart';

class PeriodSelector extends StatelessWidget {
  final String selectedPeriod;
  final Function(String) onPeriodSelected;

  const PeriodSelector({
    super.key,
    required this.selectedPeriod,
    required this.onPeriodSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
          color: Colors.grey[300], borderRadius: BorderRadius.circular(30)),
      child: Row(
        children: ['สัปดาห์', 'เดือน', 'ปี'].map((p) {
          bool isSel = selectedPeriod == p;
          return Expanded(
            child: GestureDetector(
              onTap: () => onPeriodSelected(p),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                    color: isSel ? Colors.white : Colors.transparent,
                    borderRadius: BorderRadius.circular(30)),
                child: Center(
                    child: Text(p,
                        style: TextStyle(
                            fontWeight: isSel ? FontWeight.bold : FontWeight.normal))),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}