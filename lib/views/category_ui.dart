import 'package:flutter/material.dart';
// ... import model & service ...
import 'package:flutter_wealth_curator_app/models/category_model.dart';
import 'package:flutter_wealth_curator_app/models/transaction_model.dart';
import 'package:flutter_wealth_curator_app/services/supabase_service.dart';
import 'package:flutter_wealth_curator_app/widgets/catagory/category_chart.dart';
import 'package:flutter_wealth_curator_app/widgets/catagory/history_list.dart';
import 'package:flutter_wealth_curator_app/widgets/catagory/period_selector.dart';
import 'package:flutter_wealth_curator_app/widgets/catagory/summary_bar.dart';
import 'package:intl/intl.dart';

class CategoryUi extends StatefulWidget {
  const CategoryUi({super.key});
  @override
  State<CategoryUi> createState() => _CategoryUiState();
}

class _CategoryUiState extends State<CategoryUi> {
  final SupabaseService service = SupabaseService();

  String selectedPeriod = 'เดือน'; // สัปดาห์, เดือน, ปี
  DateTime focusedDate = DateTime.now(); // วันที่ฐานสำหรับแสดงผล

  Category? selectedCategory; // null หมายถึง "ทั้งหมด"
  bool isExpanded = false; // สำหรับกางรายการประวัติ

  List<Category> categories = [];
  List<Transaction> allTransactions = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    setState(() => isLoading = true);
    final cats = await service.getCategories();
    final trans = await service.getTransactions();
    setState(() {
      categories = cats;
      allTransactions = trans;
      isLoading = false;
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: focusedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      helpText: 'เลือกช่วงเวลาที่ต้องการดู',
    );
    if (picked != null && picked != focusedDate) {
      setState(() {
        focusedDate = picked;
        // เมื่อเปลี่ยนวันที่ ข้อมูลยอดเงินและกราฟจะถูกกรองใหม่โดยอัตโนมัติ
      });
    }
  }

  String get formattedDateTitle {
    if (selectedPeriod == 'สัปดาห์') {
      // หาว่าวันที่เลือกอยู่ในสัปดาห์ที่เท่าไหร่ของเดือน
      int dayOfMonth = focusedDate.day;
      int weekOfMonth = ((dayOfMonth - 1) / 7).floor() + 1;
      return 'สัปดาห์ที่ $weekOfMonth ${DateFormat('MMM yyyy').format(focusedDate)}';
    } else if (selectedPeriod == 'เดือน') {
      return DateFormat('MMMM yyyy').format(focusedDate);
    } else {
      return 'ปี ${focusedDate.year + 543}'; // แสดงเป็น พ.ศ.
    }
  }

  // --- Logic การกรองข้อมูล ---

  // กรองรายการตามช่วงเวลาและหมวดหมู่ที่เลือก
  // กรองรายการตามช่วงเวลาและหมวดหมู่ที่เลือก
  List<Transaction> get filteredTransactions {
    return allTransactions.where((t) {
      // 1. กรองตามหมวดหมู่
      bool matchCategory =
          selectedCategory == null || t.catId == selectedCategory!.id;

      // 2. กรองตามช่วงเวลา (เพิ่ม logic ตรงนี้)
      if (t.createdAt == null) return false;
      bool matchDate = false;

      if (selectedPeriod == 'สัปดาห์') {
        // หาช่วงวันที่เริ่มต้นและสิ้นสุดของสัปดาห์นั้นๆ (อาทิตย์ - เสาร์)
        DateTime startOfWeek =
            focusedDate.subtract(Duration(days: focusedDate.weekday % 7));
        startOfWeek =
            DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day);
        DateTime endOfWeek =
            startOfWeek.add(Duration(days: 6, hours: 23, minutes: 59));

        matchDate = t.createdAt!
                .isAfter(startOfWeek.subtract(Duration(seconds: 1))) &&
            t.createdAt!.isBefore(endOfWeek.add(Duration(seconds: 1)));
      } else if (selectedPeriod == 'เดือน') {
        // ตรวจสอบว่า เดือน และ ปี ตรงกันหรือไม่
        matchDate = t.createdAt!.month == focusedDate.month &&
            t.createdAt!.year == focusedDate.year;
      } else if (selectedPeriod == 'ปี') {
        // ตรวจสอบว่า ปี ตรงกันหรือไม่
        matchDate = t.createdAt!.year == focusedDate.year;
      }

      return matchCategory && matchDate;
    }).toList();
  }

  double get totalSpent =>
      filteredTransactions.fold(0, (sum, item) => sum + item.amount);

  // สมมติงบประมาณ (Budget) สำหรับแต่ละหมวดหมู่
  double get currentBudget => selectedCategory == null ? 10000 : 2000;

  @override
  Widget build(BuildContext context) {
    if (isLoading)
      return const Scaffold(body: Center(child: CircularProgressIndicator()));

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            PeriodSelector(
              selectedPeriod: selectedPeriod,
              onPeriodSelected: (p) => setState(() => selectedPeriod = p),
            ),
            SizedBox(height: 20),
            CategoryChartCard(
              categoryName: selectedCategory?.name ?? 'ทั้งหมด',
              dateTitle: formattedDateTitle,
              totalSpent: totalSpent,
              currentBudget: currentBudget,
              categories: categories,
              selectedCategory: selectedCategory,
              onDateTap: () => _selectDate(context),
              onCategorySelected: (cat) =>
                  setState(() => selectedCategory = cat),
            ),
            SizedBox(height: 20),
            SummaryBar(
              title:
                  'สรุปผล $selectedPeriod - ${selectedCategory?.name ?? 'ทั้งหมด'}',
              totalSpent: totalSpent,
              currentBudget: currentBudget,
            ),
            SizedBox(height: 20),
            HistoryListCard(
              transactions: filteredTransactions,
              isExpanded: isExpanded,
              onToggleExpand: () => setState(() => isExpanded = !isExpanded),
            ),
          ],
        ),
      ),
    );
  }
}
