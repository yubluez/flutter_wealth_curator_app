import 'package:flutter/material.dart';
import 'package:flutter_wealth_curator_app/models/category_model.dart';
import 'package:flutter_wealth_curator_app/models/transaction_model.dart';
import 'package:flutter_wealth_curator_app/services/supabase_service.dart';
import 'package:flutter_wealth_curator_app/widgets/catagory/category_chart.dart';
import 'package:flutter_wealth_curator_app/widgets/catagory/history_list.dart';
import 'package:flutter_wealth_curator_app/widgets/catagory/period_selector.dart';
import 'package:flutter_wealth_curator_app/widgets/catagory/summary_bar.dart';
import 'package:intl/intl.dart';

class CategoryUi extends StatefulWidget {
  const CategoryUi({super.key, required this.onTypeChanged});
  final Function(String) onTypeChanged;

  @override
  State<CategoryUi> createState() => CategoryUiState();
}

class CategoryUiState extends State<CategoryUi> {
  final SupabaseService service = SupabaseService();

  String selectedPeriod = 'เดือน';
  DateTime focusedDate = DateTime.now();
  Category? selectedCategory;
  bool isExpanded = false;

  List<Category> categories = [];
  List<Transaction> allTransactions = [];
  bool isLoading = true;

  String selectedType = 'expense';

  void toggleType() {
    setState(() {
      selectedType = (selectedType == 'expense') ? 'income' : 'expense';
    });
    widget.onTypeChanged(selectedType);
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    setState(() => isLoading = true);
    categories = await service.getCategories();
    allTransactions = await service.getTransactions();
    setState(() => isLoading = false);
  }

  List<Transaction> get filteredTransactions {
    return allTransactions.where((t) {
      if (t.createdAt == null) return false;

      // หมวดหมู่
      bool matchCategory =
          selectedCategory == null || t.catId == selectedCategory!.id;

      // เวลา
      bool matchDate = false;

      if (selectedPeriod == 'สัปดาห์') {
        DateTime startOfWeek =
            focusedDate.subtract(Duration(days: focusedDate.weekday - 1));
        DateTime endOfWeek = startOfWeek.add(Duration(days: 6));

        matchDate =
            t.createdAt!.isAfter(startOfWeek.subtract(Duration(seconds: 1))) &&
                t.createdAt!.isBefore(endOfWeek.add(Duration(days: 1)));
      } else if (selectedPeriod == 'เดือน') {
        matchDate = t.createdAt!.month == focusedDate.month &&
            t.createdAt!.year == focusedDate.year;
      } else if (selectedPeriod == 'ปี') {
        matchDate = t.createdAt!.year == focusedDate.year;
      }

      return matchCategory && matchDate;
    }).toList();
  }

  List<Transaction> get filteredByType =>
      filteredTransactions.where((t) => t.type == selectedType).toList();

  double get totalExpense => filteredTransactions
      .where((t) => t.type == 'expense')
      .fold(0, (sum, item) => sum + item.amount);

  double get totalIncome => filteredTransactions
      .where((t) => t.type == 'income')
      .fold(0, (sum, item) => sum + item.amount);

  double get balance => totalIncome - totalExpense;

  double get currentBudget => selectedCategory == null ? 10000 : 2000;

  String get formattedDateTitle {
    if (selectedPeriod == 'สัปดาห์') {
      return 'สัปดาห์ที่ ${focusedDate.day ~/ 7 + 1} ${DateFormat('MMM yyyy').format(focusedDate)}';
    } else if (selectedPeriod == 'เดือน') {
      return DateFormat('MMMM yyyy').format(focusedDate);
    } else {
      return 'ปี ${focusedDate.year}';
    }
  }

  // ฟังก์ชันสำหรับการ Refresh ข้อมูลและรีเซ็ตค่า
  Future<void> _handleRefresh() async {
    setState(() {
      // 1. รีเซ็ตฟิลเตอร์เป็นค่าเริ่มต้น
      selectedPeriod = 'เดือน';
      focusedDate = DateTime.now();
      selectedCategory = null;
      isExpanded = false;
    });

    // 2. โหลดข้อมูลใหม่จาก Service
    await loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        color: Color(0xFF1117D1),
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              PeriodSelector(
                selectedPeriod: selectedPeriod,
                onPeriodSelected: (p) => setState(() => selectedPeriod = p),
              ),
              SizedBox(height: 20),
              CategoryChartCard(
                selectedType: selectedType,
                categoryName: selectedCategory?.name ?? 'ทั้งหมด',
                dateTitle: formattedDateTitle,
                totalSpent:
                    selectedType == 'expense' ? totalExpense : totalIncome,
                currentBudget: currentBudget,
                categories: categories,
                selectedCategory: selectedCategory,
                onDateTap: () {},
                onCategorySelected: (cat) =>
                    setState(() => selectedCategory = cat),
                onPrevious: () {
                  setState(() {
                    if (selectedPeriod == 'สัปดาห์') {
                      focusedDate = focusedDate.subtract(Duration(days: 7));
                    } else if (selectedPeriod == 'เดือน') {
                      focusedDate =
                          DateTime(focusedDate.year, focusedDate.month - 1);
                    } else {
                      focusedDate = DateTime(focusedDate.year - 1);
                    }
                  });
                },
                onNext: () {
                  setState(() {
                    if (selectedPeriod == 'สัปดาห์') {
                      focusedDate = focusedDate.add(Duration(days: 7));
                    } else if (selectedPeriod == 'เดือน') {
                      focusedDate =
                          DateTime(focusedDate.year, focusedDate.month + 1);
                    } else {
                      focusedDate = DateTime(focusedDate.year + 1);
                    }
                  });
                },
              ),
              SizedBox(height: 20),
              SummaryBar(
                title: selectedType == 'expense' ? 'สรุปรายจ่าย' : 'สรุปรายรับ',
                totalExpense: totalExpense,
                totalIncome: totalIncome,
                balance: balance,
                currentBudget: currentBudget,
                selectedType: selectedType,
              ),
              SizedBox(height: 20),
              HistoryListCard(
                transactions: filteredByType,
                isExpanded: isExpanded,
                onToggleExpand: () => setState(() => isExpanded = !isExpanded),
                categories: categories,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
