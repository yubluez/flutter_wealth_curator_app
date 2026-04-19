import 'package:flutter/material.dart';

class SummaryBar extends StatelessWidget {
  final String title;
  final double totalSpent;
  final double currentBudget;

  const SummaryBar({
    super.key,
    required this.title,
    required this.totalSpent,
    required this.currentBudget,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('฿${totalSpent.toStringAsFixed(2)}',
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              Text('งบ: ฿${currentBudget.toStringAsFixed(0)}',
                  style: const TextStyle(color: Colors.grey)),
            ],
          ),
        ],
      ),
    );
  }
}