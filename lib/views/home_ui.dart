import 'package:flutter/material.dart';
import 'package:flutter_wealth_curator_app/models/category_model.dart';
import 'package:flutter_wealth_curator_app/models/transaction_model.dart';
import 'package:flutter_wealth_curator_app/services/supabase_service.dart';
import 'package:flutter_wealth_curator_app/widgets/homew/current_card.dart';
import 'package:flutter_wealth_curator_app/widgets/homew/summary_report_card.dart';
import 'package:intl/intl.dart';

class HomeUi extends StatefulWidget {
  final Function(int)? onNavigate;
  const HomeUi({super.key, this.onNavigate});

  @override
  State<HomeUi> createState() => _HomeUiState();
}

class _HomeUiState extends State<HomeUi> {
  final SupabaseService service = SupabaseService();
  List<Transaction> allTransactions = [];
  List<Category> categories = [];
  bool isLoading = true;
  String? errorMessage; // เพิ่มตัวแปรเก็บ Error

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    try {
      if (!mounted) return;
      setState(() {
        isLoading = true;
        errorMessage = null;
      });

      // ดึงข้อมูลจาก Supabase
      final trans = await service.getTransactions();
      final cats = await service.getCategories();

      if (!mounted) return;

      setState(() {
        allTransactions = trans;
        categories = cats;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        isLoading = false;
        errorMessage = "ไม่สามารถโหลดข้อมูลได้ กรุณาลองใหม่อีกครั้ง";
      });
      print("Error loading home data: $e");
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
        return Icons.receipt_long; // ไอคอนเริ่มต้นถ้าไม่ตรงกับหมวดใดเลย
    }
  }

  @override
  Widget build(BuildContext context) {
    // กรณีโหลดไม่เสร็จ
    if (isLoading) {
      return Scaffold(
        body:
            Center(child: CircularProgressIndicator(color: Color(0xFF1117D1))),
      );
    }

    // กรณีเกิด Error
    if (errorMessage != null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(errorMessage!, style: TextStyle(color: Colors.red)),
              ElevatedButton(onPressed: loadData, child: Text("ลองใหม่")),
            ],
          ),
        ),
      );
    }

    // คำนวณยอดรวม
    double income = allTransactions
        .where((t) => t.type == 'income')
        .fold(0, (sum, t) => sum + t.amount);
    double expense = allTransactions
        .where((t) => t.type == 'expense')
        .fold(0, (sum, t) => sum + t.amount);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: RefreshIndicator(
        onRefresh: loadData,
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10),
              // ส่วนบัตรแสดงยอดเงิน
              CurrentCard(
                balance: income - expense,
                income: income,
                expense: expense,
              ),
              SizedBox(height: 25),

              // ส่วนรายงานกราฟ
              SummaryReportCard(
                transactions: allTransactions,
                categories: categories,
                onViewAll: () => widget.onNavigate?.call(3), // ไปที่หน้ารายงาน
              ),
              SizedBox(height: 25),

              // ส่วนประวัติล่าสุด
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "ประวัติรายการล่าสุด",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                    onPressed: () =>
                        widget.onNavigate?.call(2), // ไปหน้าประวัติ
                    child: Text("ดูทั้งหมด"),
                  ),
                ],
              ),

              if (allTransactions.isEmpty)
                Center(
                    child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Text("ยังไม่มีข้อมูลรายการ"),
                ))
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount:
                      allTransactions.length > 3 ? 3 : allTransactions.length,
                  itemBuilder: (context, index) {
                    final t = allTransactions[index];
                    final cat = categories.firstWhere(
                      (c) => c.id == t.catId,
                      orElse: () => Category(name: "อื่นๆ"),
                    );
                    return Card(
                      margin: EdgeInsets.only(bottom: 12),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.blue.withOpacity(0.1),
                          child: Icon(
                            getCategoryIcon(cat.name),
                            color: Colors.black,
                          ),
                        ),
                        title: Text(
                          t.note != null && t.note!.isNotEmpty
                              ? t.note!
                              : (cat.name ?? "ไม่มีชื่อหมวด"),
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        subtitle: Text(
                          t.createdAt != null
                              ? DateFormat('HH:mm • dd MMM yyyy')
                                  .format(t.createdAt!)
                              : "-",
                          style: TextStyle(fontSize: 12),
                        ),
                        trailing: Text(
                          "${t.type == 'expense' ? '-' : '+'} ฿${t.amount.toStringAsFixed(2)}",
                          style: TextStyle(
                            color:
                                t.type == 'expense' ? Colors.red : Colors.green,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
