import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_wealth_curator_app/models/transaction_model.dart';

class HistoryListCard extends StatelessWidget {
  final List<Transaction> transactions;
  final bool isExpanded;
  final VoidCallback onToggleExpand;

  const HistoryListCard({
    super.key,
    required this.transactions,
    required this.isExpanded,
    required this.onToggleExpand,
  });

  @override
  Widget build(BuildContext context) {
    final displayList = isExpanded ? transactions : transactions.take(3).toList();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(20)),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('ประวัติรายการ', style: TextStyle(fontWeight: FontWeight.bold)),
              if (transactions.length > 3)
                GestureDetector(
                  onTap: onToggleExpand,
                  child: Row(
                    children: [
                      Text(isExpanded ? 'พับเก็บ' : 'ดูทั้งหมด', style: const TextStyle(fontSize: 12)),
                      Icon(isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down),
                    ],
                  ),
                ),
            ],
          ),
          const Divider(),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: displayList.length,
            itemBuilder: (context, index) {
              final t = displayList[index];
              return ListTile(
                leading: const CircleAvatar(child: Icon(Icons.payment)),
                title: Text(t.note ?? 'ไม่มีหมายเหตุ'),
                subtitle: Text(DateFormat('HH:mm • dd MMM').format(t.createdAt!)),
                trailing: Text(
                  '- ฿${t.amount.toStringAsFixed(2)}',
                  style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}