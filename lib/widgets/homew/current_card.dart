import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CurrentCard extends StatelessWidget {
  final double balance;
  final double income;
  final double expense;

  const CurrentCard({
    super.key,
    required this.balance,
    required this.income,
    required this.expense,
  });

  @override
  Widget build(BuildContext context) {
    final f = NumberFormat("#,##0.00");
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: const Color(0xFF1117D1),
        borderRadius: BorderRadius.circular(25.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('ยอดคงเหลือปัจจุบัน',
              style: TextStyle(color: Colors.white70, fontSize: 14)),
          SizedBox(height: 5),
          Text('฿ ${f.format(balance)}',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold)),
          SizedBox(height: 20),
          Row(
            children: [
              _buildMiniCard("รายรับ", "+ ฿ ${f.format(income)}",
                  Colors.greenAccent.withOpacity(0.2)),
              SizedBox(width: 10),
              _buildMiniCard("รายจ่าย", "- ฿ ${f.format(expense)}",
                  Colors.redAccent.withOpacity(0.2)),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildMiniCard(String title, String amount, Color bgColor) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
            color: Colors.white12, borderRadius: BorderRadius.circular(15)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(color: Colors.white70, fontSize: 12)),
            Text(amount,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
