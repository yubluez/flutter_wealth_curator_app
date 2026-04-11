import 'package:flutter/material.dart';

class AddTransactionsUi extends StatefulWidget {
  const AddTransactionsUi({super.key});

  @override
  State<AddTransactionsUi> createState() => _AddTransactionsUiState();
}

class _AddTransactionsUiState extends State<AddTransactionsUi> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'เพิ่มรายการ',
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20.0),
              // Add form fields for transaction details here
              TextField(
                decoration: InputDecoration(
                  labelText: 'ชื่อรายการ',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10.0),
              TextField(
                decoration: InputDecoration(
                  labelText: 'จำนวนเงิน',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 10.0),
              ElevatedButton(
                onPressed: () {
                  // Handle save transaction logic here
                },
                child: Text('บันทึก'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}