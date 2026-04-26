import '../models/transaction_model.dart';
import '../models/category_model.dart';

class BehaviorController {
  final List<Transaction> transactions;

  BehaviorController(this.transactions);

  double get totalExpense => transactions
      .where((t) => t.type == 'expense')
      .fold(0, (sum, t) => sum + t.amount);

  double get totalIncome => transactions
      .where((t) => t.type == 'income')
      .fold(0, (sum, t) => sum + t.amount);

  Map<String, double> categoryTotals(String type) {
    Map<String, double> data = {};

    for (var t in transactions) {
      if (t.type != type) continue;
      data[t.catId] = (data[t.catId] ?? 0) + t.amount;
    }

    return data;
  }

  String getTopCategory(List<Category> categories, String type) {
    final data = categoryTotals(type);
    if (data.isEmpty) return "-";

    var top = data.entries.reduce(
      (a, b) => a.value > b.value ? a : b,
    );

    final cat = categories.firstWhere(
      (c) => c.id == top.key,
      orElse: () => Category(name: "อื่นๆ"),
    );

    return cat.name ?? "-";
  }
}