import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_wealth_curator_app/models/category_model.dart';
import 'package:flutter_wealth_curator_app/models/transaction_model.dart';
import 'package:flutter_wealth_curator_app/services/supabase_service.dart';
import 'package:flutter_wealth_curator_app/widgets/add/amount_input.dart';
import 'package:flutter_wealth_curator_app/widgets/add/category_widget.dart';
import 'package:flutter_wealth_curator_app/widgets/add/date_time_picker_box.dart';
import 'package:flutter_wealth_curator_app/widgets/add/image_picker_box.dart';
import 'package:flutter_wealth_curator_app/widgets/add/transaction_toggle.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class UpdateDeleteUi extends StatefulWidget {
  final Transaction transaction; // รับข้อมูลตัวที่ต้องการแก้มา
  const UpdateDeleteUi({super.key, required this.transaction});

  @override
  State<UpdateDeleteUi> createState() => _UpdateDeleteUiState();
}

class _UpdateDeleteUiState extends State<UpdateDeleteUi> {
  final SupabaseService service = SupabaseService();
  late TextEditingController amountCtrl;
  late TextEditingController noteCtrl;
  late bool isExpense;
  late String selectedCategoryId;
  late DateTime selectedDateTime;

  List<Category> categories = [];
  bool isLoading = false;

  File? file;

  @override
  void initState() {
    super.initState();
    // ดึงค่าเดิมจาก Transaction มาใส่ Controller
    amountCtrl =
        TextEditingController(text: widget.transaction.amount.toString());
    noteCtrl = TextEditingController(text: widget.transaction.note);
    isExpense = widget.transaction.type == 'expense';
    selectedCategoryId = widget.transaction.catId;
    selectedDateTime = widget.transaction.createdAt!;
    loadCategories();
  }

  Future<void> loadCategories() async {
    final data = await service.getCategories();
    setState(() => categories = data);
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

  Future<void> handleUpdate() async {
    setState(() => isLoading = true);
    try {
      final updatedData = Transaction(
        id: widget.transaction.id,
        amount: double.parse(amountCtrl.text),
        type: isExpense ? 'expense' : 'income',
        catId: selectedCategoryId,
        note: noteCtrl.text,
        createdAt: selectedDateTime,
        userId: widget.transaction.userId,
        imageUrl: widget.transaction.imageUrl,
      );

      await service.updateTransaction(widget.transaction.id!, updatedData);
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> handleDelete() async {
    // โชว์ Confirm Dialog ก่อนลบ
    bool confirm = await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("ยืนยันการลบ"),
        content: Text("คุณต้องการลบรายการนี้ใช่หรือไม่?"),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text("ยกเลิก")),
          TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text("ลบ", style: TextStyle(color: Colors.red))),
        ],
      ),
    );

    if (confirm) {
      setState(() => isLoading = true);
      await service.deleteTransaction(widget.transaction.id!);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            // 🔹 Toggle Expenses/Income
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
              categories: categories,
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
            GestureDetector(
              onTap: pickImage,
              child: Container(
                height: 140,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: file != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(file!,
                            fit: BoxFit.cover), // 1. โชว์รูปใหม่ที่เพิ่งเลือก
                      )
                    : (widget.transaction.imageUrl != null &&
                            widget.transaction.imageUrl!.isNotEmpty)
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              widget.transaction
                                  .imageUrl!, // 2. โชว์รูปเดิมจาก Database
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  Center(
                                      child:
                                          Icon(Icons.broken_image, size: 40)),
                            ),
                          )
                        : Center(
                            child: Icon(Icons.camera_alt,
                                size: 40)), // 3. ถ้าไม่มีทั้งคู่ โชว์ไอคอนกล้อง
              ),
            ),
            SizedBox(height: 35),
            // 🔹 SAVE & DELETE Buttons
            ElevatedButton(
              onPressed: isLoading ? null : handleUpdate,
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 55),
                backgroundColor: Color(0xFF1117D1),
              ),
              child: Text("บันทึกแก้ไข",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  )),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: isLoading ? null : handleDelete,
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 55),
                backgroundColor: Colors.red,
              ),
              child: Text("ลบรายการ",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
