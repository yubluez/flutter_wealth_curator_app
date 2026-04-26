import 'package:flutter/material.dart';
import 'package:flutter_wealth_curator_app/models/category_model.dart'; // 🔹 เพิ่ม import
import 'package:flutter_wealth_curator_app/models/transaction_model.dart';
import 'package:flutter_wealth_curator_app/services/supabase_service.dart';
import 'package:flutter_wealth_curator_app/views/update_delete_ui.dart';
import 'package:intl/intl.dart';

class HistoryUi extends StatefulWidget {
  const HistoryUi({super.key});

  @override
  State<HistoryUi> createState() => HistoryUiState();
}

class HistoryUiState extends State<HistoryUi> {
  final SupabaseService service = SupabaseService();
  String selectedFilter = 'All';
  List<Transaction> allTransactions = [];
  List<Category> categories = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    setState(() => isLoading = true);
    // ดึงทั้งรายการและหมวดหมู่มาพร้อมกัน
    final transData = await service.getTransactions();
    final catsData = await service.getCategories();

    setState(() {
      allTransactions = transData;
      categories = catsData;
      isLoading = false;
    });
  }

  // 🔹 ฟังก์ชันช่วยหาชื่อหมวดหมู่จาก catId
  String getCategoryName(String catId) {
    try {
      final category = categories.firstWhere((c) => c.id == catId);
      return category.name ?? 'ทั่วไป';
    } catch (e) {
      return 'ทั่วไป';
    }
  }

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

  List<Transaction> get filteredTransactions {
    if (selectedFilter == 'Income') {
      return allTransactions.where((t) => t.type == 'income').toList();
    } else if (selectedFilter == 'Expenses') {
      return allTransactions.where((t) => t.type == 'expense').toList();
    }
    return allTransactions;
  }

  // ฟังก์ชันรีเซ็ตค่าและโหลดข้อมูลใหม่
  Future<void> _handleRefresh() async {
    setState(() {
      selectedFilter = 'All'; // รีเซ็ตฟิลเตอร์กลับเป็นค่าเริ่มต้น
    });
    await loadData(); // ดึงข้อมูลใหม่จาก Supabase
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        body: Column(
          children: [
            _buildFilterBar(),
            Expanded(
              child: RefreshIndicator(
                onRefresh: _handleRefresh,
                color: Color(0xFF1117D1),
                child: isLoading
                    ? Center(child: CircularProgressIndicator())
                    : _buildTransactionList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: ['All', 'Income', 'Expenses'].map((filter) {
        bool isSel = selectedFilter == filter;
        return GestureDetector(
          onTap: () => setState(() => selectedFilter = filter),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 35, vertical: 10),
            decoration: BoxDecoration(
              color: isSel ? Colors.grey[400] : Colors.grey[300],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(filter,
                style: TextStyle(
                    fontWeight: isSel ? FontWeight.bold : FontWeight.normal)),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildTransactionList() {
    if (filteredTransactions.isEmpty) {
      return ListView(
        physics: AlwaysScrollableScrollPhysics(),
        children: [
          SizedBox(height: 100),
          Center(child: Text("ไม่มีข้อมูล")),
        ],
      );
    }

    /// 🔥 1. จัดกลุ่มตามวัน
    Map<String, List<Transaction>> grouped = {};

    for (var t in filteredTransactions) {
      String dateKey = DateFormat('dd MMM yyyy').format(t.createdAt!);

      if (!grouped.containsKey(dateKey)) {
        grouped[dateKey] = [];
      }
      grouped[dateKey]!.add(t);
    }

    /// 🔥 2. เรียงวันล่าสุดก่อน
    final sortedKeys = grouped.keys.toList()
      ..sort((a, b) => DateFormat('dd MMM yyyy')
          .parse(b)
          .compareTo(DateFormat('dd MMM yyyy').parse(a)));

    return ListView(
      padding: EdgeInsets.only(top: 20),
      children: sortedKeys.map((date) {
        final transactions = grouped[date]!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 🔥 หัวข้อวัน
            Padding(
              padding: EdgeInsets.only(bottom: 10, top: 10),
              child: Text(
                date,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[700],
                ),
              ),
            ),

            /// 🔥 รายการในวันนั้น
            ...transactions.map((t) {
              final category = categories.firstWhere(
                (c) => c.id == t.catId,
                orElse: () => Category(name: 'ทั่วไป'),
              );

              final displayName = (t.note != null && t.note!.trim().isNotEmpty)
                  ? t.note!
                  : (category.name ?? 'ทั่วไป');

              return GestureDetector(
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => UpdateDeleteUi(transaction: t)),
                  );
                  loadData();
                },
                child: Container(
                  margin: EdgeInsets.only(bottom: 15),
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.grey[100],
                        child: Icon(
                          getCategoryIcon(category.name),
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(displayName,
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            Text(
                              DateFormat('HH:mm').format(t.createdAt!),
                              style:
                                  TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        '${t.type == 'expense' ? '-' : '+'} ฿${t.amount.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color:
                              t.type == 'expense' ? Colors.red : Colors.green,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ],
        );
      }).toList(),
    );
  }
}
