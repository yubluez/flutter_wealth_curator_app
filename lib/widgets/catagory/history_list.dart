import 'package:flutter/material.dart';
import 'package:flutter_wealth_curator_app/models/category_model.dart';
import 'package:intl/intl.dart';
import 'package:flutter_wealth_curator_app/models/transaction_model.dart';

class HistoryListCard extends StatelessWidget {
  final List<Transaction> transactions;
  final bool isExpanded;
  final VoidCallback onToggleExpand;
  final List<Category> categories;

  const HistoryListCard({
    super.key,
    required this.transactions,
    required this.isExpanded,
    required this.onToggleExpand,
    required this.categories,
  });

  IconData getCategoryIcon(String? categoryName) {
    switch (categoryName) {
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
      case 'การศึกษา':
        return Icons.school;
      default:
        return Icons.receipt_long;
    }
  }

  @override
  Widget build(BuildContext context) {
    final displayList =
        isExpanded ? transactions : transactions.take(3).toList();

    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(20)),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('ประวัติรายการ',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              if (transactions.length > 3)
                GestureDetector(
                  onTap: onToggleExpand,
                  child: Row(
                    children: [
                      Text(isExpanded ? 'พับเก็บ' : 'ดูทั้งหมด',
                          style: TextStyle(fontSize: 12)),
                      Icon(isExpanded
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down),
                    ],
                  ),
                ),
            ],
          ),
          Divider(),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: displayList.length,
            itemBuilder: (context, index) {
              final t = displayList[index];
              // 🔹 1. ค้นหาข้อมูลหมวดหมู่จากลิสต์ categories โดยใช้ catId ของ transaction
              final category = categories.firstWhere(
                (c) => c.id == t.catId,
                orElse: () =>
                    Category(name: 'ทั่วไป'), // ค่าเริ่มต้นถ้าหาไม่เจอ
              );
              // 🔹 2. กำหนดชื่อที่จะแสดง (ถ้าไม่มีโน้ต ให้ใช้ชื่อหมวดหมู่ที่หามาได้)
              final String displayName =
                  (t.note != null && t.note!.trim().isNotEmpty)
                      ? t.note!
                      : (category.name ?? 'ทั่วไป');
              return ListTile(
                leading: CircleAvatar(
                  child: Icon(
                    getCategoryIcon(category.name),
                    color: Colors.black,
                  ),
                ),
                title: Text(displayName),
                subtitle:
                    Text(DateFormat('HH:mm • dd MMM').format(t.createdAt!)),
                trailing: Text(
                  '${t.type == 'expense' ? '-' : '+'} ฿${t.amount.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: t.type == 'expense'
                        ? Colors.red
                        : Colors.green,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
