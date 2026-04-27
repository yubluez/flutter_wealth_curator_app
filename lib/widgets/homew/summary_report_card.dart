import 'package:flutter/material.dart';

class SummaryReportCard extends StatefulWidget {
  final List<dynamic> transactions;
  final List<dynamic> categories;
  final String topCategory;

  const SummaryReportCard({
    super.key,
    required this.transactions,
    required this.categories,
    required this.topCategory,
  });

  @override
  State<SummaryReportCard> createState() => _SummaryReportCardState();
}

class _SummaryReportCardState extends State<SummaryReportCard> {
  bool isExpanded = false;

  Color hexToColor(String hex) {
    return Color(int.parse(hex));
  }

  @override
  Widget build(BuildContext context) {
    /// 🔥 รวมรายจ่าย
    double totalExp = widget.transactions
        .where((t) => t.type == 'expense')
        .fold(0, (sum, t) => sum + t.amount);

    /// 🔥 รวมรายรับ
    double totalIncome = widget.transactions
        .where((t) => t.type == 'income')
        .fold(0, (sum, t) => sum + t.amount);

    /// 🔥 % จริง
    double percent = 0;
    if (totalIncome > 0) {
      percent = totalExp / totalIncome;
      if (percent > 1) percent = 1;
    }

    double remain = (1 - percent) * 100;

    /// 🔥 group ตามหมวด
    var expGroup = <String, double>{};

    for (var t in widget.transactions.where((t) => t.type == 'expense')) {
      expGroup[t.catId] = (expGroup[t.catId] ?? 0) + t.amount;
    }

    /// 🔥 sort
    var sortedCats = expGroup.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    final top3 = sortedCats.take(3).toList();
    final displayList = isExpanded ? sortedCats : top3;

    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 🔝 TITLE
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "ภาพรวมการใช้จ่าย",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              Text(
                "ใช้มากสุด: ${widget.topCategory}",
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
              ),
            ],
          ),
          SizedBox(height: 5),

          SizedBox(height: 20),

          /// 🔥 วงกลม %
          Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 150,
                  height: 150,
                  child: CircularProgressIndicator(
                    value: percent,
                    strokeWidth: 10,
                    backgroundColor: Colors.grey[200],
                    color: Colors.blue,
                  ),
                ),
                Column(
                  children: [
                    Text(
                      "${(percent * 100).toStringAsFixed(0)}%",
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "ใช้ไปจากรายรับ",
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    Text(
                      "เหลือ ${remain.toStringAsFixed(0)}%",
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                )
              ],
            ),
          ),

          SizedBox(height: 20),

          /// 🔥 LIST (Top3 / All)
          AnimatedSize(
            duration: Duration(milliseconds: 300),
            child: Column(
              children: displayList.map((entry) {
                final category =
                    widget.categories.where((c) => c.id == entry.key).toList();

                final cat = category.isNotEmpty ? category.first : null;

                final percentCat = totalExp > 0
                    ? (entry.value / totalExp).clamp(0.0, 1.0)
                    : 0.0;

                final color = cat != null && cat.color != null
                    ? hexToColor(cat.color!)
                    : Colors.grey;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(cat?.name ?? "อื่นๆ"),
                          Text(
                            "${(percentCat * 100).toStringAsFixed(1)}%",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                      SizedBox(height: 6),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: LinearProgressIndicator(
                          value: percentCat,
                          minHeight: 8,
                          backgroundColor: Colors.grey[200],
                          valueColor: AlwaysStoppedAnimation<Color>(color),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),

          /// 🔥 ปุ่ม expand
          if (sortedCats.length > 3)
            Center(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    isExpanded = !isExpanded;
                  });
                },
                child: Text(
                  isExpanded ? "ย่อกลับ" : "ดูทั้งหมด",
                  style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
