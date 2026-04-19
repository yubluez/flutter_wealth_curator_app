import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_wealth_curator_app/models/category_model.dart';

class CategoryChartCard extends StatelessWidget {
  final String categoryName;
  final String dateTitle;
  final double totalSpent;
  final double currentBudget;
  final List<Category> categories;
  final Category? selectedCategory;
  final VoidCallback onDateTap;
  final Function(Category?) onCategorySelected;

  const CategoryChartCard({
    super.key,
    required this.categoryName,
    required this.dateTitle,
    required this.totalSpent,
    required this.currentBudget,
    required this.categories,
    required this.selectedCategory,
    required this.onDateTap,
    required this.onCategorySelected,
  });

  IconData getIcon(String? name) {
    switch (name) {
      case 'ทั้งหมด':
        return Icons.pie_chart;
      case 'ช้อปปิ้ง':
        return Icons.shopping_bag;
      case 'เดินทาง':
        return Icons.directions_car;
      case 'ที่พัก':
        return Icons.hotel;
      case 'บันเทิง':
        return Icons.movie;
      case 'บิล':
        return Icons.receipt;
      case 'สุขภาพ':
        return Icons.health_and_safety;
      case 'อาหาร':
        return Icons.restaurant;
      default:
        return Icons.category;
    }
  }

  // 🔹 ฟังก์ชันกำหนดสีตามหมวดหมู่
  Color getCategoryColor(String? name) {
    if (name == null || name == 'ทั้งหมด')
      return const Color(0xFF1117D1); // สีน้ำเงินหลัก

    // คุณสามารถดึงค่าสีจาก cat.color ในฐานข้อมูล (ถ้ามีเก็บไว้)
    // หรือกำหนดเงื่อนไขแบบ Manual ตามชื่อหมวดหมู่ที่นี่
    switch (name) {
      case 'ทั้งหมด':
        return const Color(0xFF1117D1);
      case 'ช้อปปิ้ง':
        return const Color(0xff8B5CF6);
      case 'เดินทาง':
        return const Color(0xff3B82F6);
      case 'ที่พัก':
        return const Color(0xff10B981);
      case 'บันเทิง':
        return const Color(0xffEF4444);
      case 'บิล':
        return const Color(0xff06B6D4);
      case 'สุขภาพ':
        return const Color(0xffF59E0B);
      case 'อาหาร':
        return const Color(0xffF97316);
      default:
        return Colors.pinkAccent;
    }
  }

  @override
  Widget build(BuildContext context) {
    double percent = (totalSpent / currentBudget) * 100;
    if (percent > 100) percent = 100;

    final Color activeColor = getCategoryColor(selectedCategory?.name);

    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(25)),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(categoryName,
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.grey)),
              GestureDetector(
                onTap: onDateTap,
                child: Row(
                  children: [
                    Text(dateTitle,
                        style: TextStyle(
                            color: Color(0xFF1117D1),
                            fontWeight: FontWeight.bold)),
                    Icon(Icons.arrow_drop_down, color: Color(0xFF1117D1)),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          SizedBox(
            height: 150,
            child: Stack(
              children: [
                PieChart(PieChartData(
                    sectionsSpace: 0,
                    centerSpaceRadius: 70,
                    sections: [
                      PieChartSectionData(
                          color: activeColor,
                          value: percent,
                          showTitle: false,
                          radius: 15),
                      PieChartSectionData(
                          color: Colors.grey[200],
                          value: 100 - percent,
                          showTitle: false,
                          radius: 15),
                    ])),
                Center(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                      Text('${percent.toStringAsFixed(0)}%',
                          style: TextStyle(
                              fontSize: 32, fontWeight: FontWeight.bold)),
                      Text('งบประมาณที่ใช้',
                          style: TextStyle(color: Colors.grey, fontSize: 12)),
                    ])),
              ],
            ),
          ),
          SizedBox(height: 20),
          GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4, childAspectRatio: 1),
            itemCount: categories.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) return _buildIcon(null, 'ทั้งหมด');
              final cat = categories[index - 1];
              return _buildIcon(cat, cat.name!);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildIcon(Category? cat, String label) {
    bool isSel = selectedCategory?.id == cat?.id;

    final Color itemColor = getCategoryColor(cat?.name);

    return GestureDetector(
      onTap: () => onCategorySelected(cat),
      child: Column(
        children: [
          CircleAvatar(
            radius: 25,
            backgroundColor: isSel ? itemColor : Colors.grey[200],
            child: Icon(getIcon(cat?.name),
                color: isSel ? Colors.white : Colors.black),
          ),
          Text(label,
              style: TextStyle(fontSize: 10), textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
