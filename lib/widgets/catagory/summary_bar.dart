import 'package:flutter/material.dart';

class SummaryBar extends StatelessWidget {
  final String title;
  final double totalExpense;
  final double totalIncome;
  final double balance;
  final double currentBudget;
  final String selectedType;

  const SummaryBar({
    super.key,
    required this.title,
    required this.totalExpense,
    required this.totalIncome,
    required this.balance,
    required this.currentBudget,
    required this.selectedType,
  });

  @override
  Widget build(BuildContext context) {
    final isExpense = selectedType == 'expense';

    // เลือกค่าที่จะแสดง
    final value = isExpense ? totalExpense : totalIncome;

    // สี (0 = ดำ)
    Color textColor;
    if (value == 0) {
      textColor = Colors.black;
    } else {
      textColor = isExpense ? Colors.red : Colors.green;
    }

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),

          SizedBox(height: 10),

          /// ตัวเลขหลัก
          Text(
            '฿${value.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),

          SizedBox(height: 10),
          Divider(),

          /// งบ (แสดงเฉพาะรายจ่าย)
          if (isExpense) ...[
            SizedBox(height: 10),
            Text(
              'งบ: ฿${currentBudget.toStringAsFixed(0)}',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ],
      ),
    );
  }
}
