import 'package:flutter/material.dart';
import 'package:flutter_wealth_curator_app/models/category_model.dart';
import 'package:flutter_wealth_curator_app/models/transaction_model.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class SummaryReportCard extends StatelessWidget {
  final List<Transaction> transactions;
  final List<Category> categories;
  final VoidCallback onViewAll;

  const SummaryReportCard(
      {super.key,
      required this.transactions,
      required this.categories,
      required this.onViewAll});

  // 🔹 เพิ่มฟังก์ชันแปลง Hex String เป็น Color (เหมือนที่คุณใช้ในหน้าอื่น)
  Color hexToColor(String? hex) {
    if (hex == null || hex.isEmpty)
      return Colors.grey; // สีเริ่มต้นถ้าไม่มีข้อมูล
    try {
      return Color(int.parse(hex));
    } catch (e) {
      return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    double totalExp = transactions
        .where((t) => t.type == 'expense')
        .fold(0, (sum, t) => sum + t.amount);
    double budget = 10000; // สมมติงบประมาณ
    double percent = totalExp / budget;
    if (percent > 1) percent = 1;

    // คำนวณหา Top 3 หมวดหมู่
    var expGroup = <String, double>{};
    for (var t in transactions.where((t) => t.type == 'expense')) {
      expGroup[t.catId] = (expGroup[t.catId] ?? 0) + t.amount;
    }
    var sortedCats = expGroup.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    var top3 = sortedCats.take(3).toList();

    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(25)),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("รายงาน",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              GestureDetector(
                  onTap: onViewAll,
                  child:
                      Text("ดูทั้งหมด", style: TextStyle(color: Colors.grey))),
            ],
          ),
          SizedBox(height: 15),
          CircularPercentIndicator(
            radius: 80.0,
            lineWidth: 12.0,
            percent: percent,
            center: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("${(percent * 100).toInt()}%",
                    style:
                        TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                Text("ของงบประมาณ",
                    style: TextStyle(fontSize: 10, color: Colors.grey)),
              ],
            ),
            progressColor: Color(0xFF1117D1),
            backgroundColor: Colors.grey.shade200,
            circularStrokeCap: CircularStrokeCap.round,
          ),
          SizedBox(height: 25),
          ...top3.map((entry) {
            final cat = categories.firstWhere((c) => c.id == entry.key,
                orElse: () => Category(name: "อื่นๆ"));

            double catPercent = totalExp > 0 ? entry.value / totalExp : 0;

            // ดึงสีประจำหมวดหมู่มาใช้
            final Color categoryColor = hexToColor(cat.color);

            return Padding(
              padding: EdgeInsets.only(bottom: 15),
              child: Column(
                children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(cat.name ?? "",
                            style: TextStyle(
                                fontSize: 13, fontWeight: FontWeight.w500)),
                        Text("${(catPercent * 100).toInt()}%",
                            style: TextStyle(fontSize: 12, color: Colors.grey)),
                      ]),
                  SizedBox(height: 6),
                  LinearPercentIndicator(
                    lineHeight: 10.0,
                    percent: catPercent,
                    backgroundColor: Colors.grey.shade100,
                    progressColor: categoryColor,
                    barRadius: Radius.circular(10),
                    padding: EdgeInsets.zero,
                    animation: true,
                    animationDuration: 1000,
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}
