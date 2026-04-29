import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_wealth_curator_app/models/category_model.dart';
import 'package:flutter_wealth_curator_app/models/transaction_model.dart';
import 'package:flutter_wealth_curator_app/services/supabase_service.dart';
import 'package:flutter_wealth_curator_app/widgets/add/amount_input.dart';
import 'package:flutter_wealth_curator_app/widgets/add/category_widget.dart';
import 'package:flutter_wealth_curator_app/widgets/add/date_time_picker_box.dart';
import 'package:flutter_wealth_curator_app/widgets/add/transaction_toggle.dart';
import 'package:image_picker/image_picker.dart';

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
  bool isDeletedImage = false;

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

  Future<void> pickImageOption() async {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: Icon(Icons.camera_alt),
                title: Text("ถ่ายรูป"),
                onTap: () async {
                  Navigator.pop(context);
                  final picked = await ImagePicker().pickImage(
                    source: ImageSource.camera,
                  );
                  if (picked != null) {
                    setState(() => file = File(picked.path));
                  }
                },
              ),
              ListTile(
                leading: Icon(Icons.photo),
                title: Text("เลือกจากอัลบั้ม"),
                onTap: () async {
                  Navigator.pop(context);
                  final picked = await ImagePicker().pickImage(
                    source: ImageSource.gallery,
                  );
                  if (picked != null) {
                    setState(() => file = File(picked.path));
                  }
                },
              ),
            ],
          ),
        );
      },
    );
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

  List<Category> get filteredCategories {
    final type = isExpense ? 'expense' : 'income';

    return categories.where((c) => c.type == type).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            // Toggle Expenses/Income
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
            GestureDetector(
              onTap: () {
                if (file != null ||
                    (widget.transaction.imageUrl != null && !isDeletedImage)) {
                  // 👉 ดูรูปเต็ม
                  showDialog(
                    context: context,
                    builder: (_) => Dialog(
                      child: file != null
                          ? Image.file(file!)
                          : Image.network(widget.transaction.imageUrl!),
                    ),
                  );
                } else {
                  pickImageOption();
                }
              },
              child: Stack(
                children: [
                  Container(
                    height: 140,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: file != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.file(file!, fit: BoxFit.cover),
                          )
                        : (!isDeletedImage &&
                                widget.transaction.imageUrl != null &&
                                widget.transaction.imageUrl!.isNotEmpty)
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.network(
                                  widget.transaction.imageUrl!,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : Center(child: Icon(Icons.camera_alt, size: 40)),
                  ),

                  /// 🔴 ปุ่มลบ
                  if (file != null ||
                      (!isDeletedImage &&
                          widget.transaction.imageUrl != null &&
                          widget.transaction.imageUrl!.isNotEmpty))
                    Positioned(
                      top: 8,
                      right: 8,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            file = null;
                            isDeletedImage = true;
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.black54,
                            shape: BoxShape.circle,
                          ),
                          padding: EdgeInsets.all(6),
                          child:
                              Icon(Icons.close, color: Colors.white, size: 18),
                        ),
                      ),
                    ),
                ],
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
