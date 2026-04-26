// ignore_for_file: use_build_context_synchronously, curly_braces_in_flow_control_structures

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_wealth_curator_app/controllers/add_transaction_controller.dart';
import 'package:flutter_wealth_curator_app/models/category_model.dart';
import 'package:flutter_wealth_curator_app/models/transaction_model.dart';
import 'package:flutter_wealth_curator_app/services/supabase_service.dart';
import 'package:flutter_wealth_curator_app/widgets/add/transaction_toggle.dart';
import 'package:flutter_wealth_curator_app/widgets/add/amount_input.dart';
import 'package:flutter_wealth_curator_app/widgets/add/category_widget.dart';
import 'package:flutter_wealth_curator_app/widgets/add/date_time_picker_box.dart';
import 'package:flutter_wealth_curator_app/widgets/add/image_picker_box.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AddTransactionsUi extends StatefulWidget {
  const AddTransactionsUi({super.key});

  @override
  State<AddTransactionsUi> createState() => AddTransactionsUiState();
}

class AddTransactionsUiState extends State<AddTransactionsUi> {
  bool isExpense = true;
  TextEditingController amountCtrl = TextEditingController();
  TextEditingController noteCtrl = TextEditingController();

  DateTime? selectedDateTime;
  File? file;
  bool isLoading = false;

  List<Category> categories = [];
  String selectedCategoryId = "";

  final userId = Supabase.instance.client.auth.currentUser!.id;

  late AddTransactionController controller;

  @override
  void initState() {
    super.initState();
    controller = AddTransactionController(SupabaseService());
    loadCategories();
  }

  Future<void> loadCategories() async {
    final data = await SupabaseService().getCategories();
    setState(() => categories = data);
  }

  Future<void> resetForm() async {
    setState(() {
      isExpense = true;
      amountCtrl.clear();
      noteCtrl.clear();
      selectedDateTime = null;
      file = null;
      selectedCategoryId = "";
    });
    await loadCategories(); // โหลดหมวดหมู่ใหม่เพื่อให้ข้อมูลเป็นปัจจุบัน
  }

  Future<void> pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => file = File(picked.path));
    }
  }

  Future<void> pickDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (date == null) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (time == null) return;

    setState(() {
      selectedDateTime = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
    });
  }

  Future<void> save() async {
    if (amountCtrl.text.isEmpty ||
        selectedCategoryId.isEmpty ||
        selectedDateTime == null)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('กรุณาป้อนข้อมูลให้ครบถ้วน'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );

    setState(() => isLoading = true);

    try {
      final imageUrl = await controller.uploadImage(file);

      final transaction = Transaction(
        amount: double.parse(amountCtrl.text),
        type: isExpense ? "expense" : "income",
        catId: selectedCategoryId,
        imageUrl: imageUrl,
        createdAt: selectedDateTime,
        note: noteCtrl.text,
        userId: userId,
      );

      await controller.saveTransaction(transaction);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("บันทึกสำเร็จ"),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );

      amountCtrl.clear();
      noteCtrl.clear();
      setState(() {
        file = null;
        selectedDateTime = null;
        selectedCategoryId = "";
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }

    setState(() => isLoading = false);
  }

  Future<void> _handleRefresh() async {
    await Future.delayed(Duration(milliseconds: 500));

    setState(() {
      // รีเซ็ตค่า Input ต่างๆ เป็นค่าเริ่มต้น
      isExpense = true;
      amountCtrl.clear();
      noteCtrl.clear();
      selectedDateTime = null;
      file = null;
      selectedCategoryId = "";
    });

    await loadCategories();
  }

  List<Category> get filteredCategories {
    final type = isExpense ? 'expense' : 'income';

    return categories.where((c) => c.type == type).toList();
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
              TransactionToggle(
                isExpense: isExpense,
                onChanged: (val) {
                  setState(() {
                    isExpense = val;
                    selectedCategoryId = "";
                  });
                },
              ),
              SizedBox(height: 25),
              AmountInput(controller: amountCtrl),
              SizedBox(height: 25),
              CategoryWidget(
                categories: filteredCategories,
                selectedId: selectedCategoryId,
                onSelect: (id) => setState(() => selectedCategoryId = id),
              ),
              SizedBox(height: 20),
              DateTimePickerBox(
                dateTime: selectedDateTime,
                onTap: pickDateTime,
              ),
              SizedBox(height: 20),
              TextField(
                controller: noteCtrl,
                decoration: InputDecoration(
                  hintText: "เพิ่มโน้ต...",
                  prefixIcon: Icon(Icons.edit),
                  filled: true,
                  fillColor: Colors.grey[300],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              SizedBox(height: 20),
              ImagePickerBox(
                file: file,
                onTap: pickImage,
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: isLoading ? null : () => save(),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 55),
                  backgroundColor: Color(0xFF1117D1),
                ),
                child: isLoading
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text(
                        "บันทึกรายการ",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
