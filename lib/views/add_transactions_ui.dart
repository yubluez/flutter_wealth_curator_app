import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_wealth_curator_app/controllers/add_transaction_controller.dart';
import 'package:flutter_wealth_curator_app/models/category_model.dart';
import 'package:flutter_wealth_curator_app/models/transaction_model.dart';
import 'package:flutter_wealth_curator_app/services/supabase_service.dart';
import 'package:flutter_wealth_curator_app/widgets/add_transaction/transaction_toggle.dart';
import 'package:flutter_wealth_curator_app/widgets/add_ui/amount_input.dart';
import 'package:flutter_wealth_curator_app/widgets/add_ui/category_widget.dart';
import 'package:flutter_wealth_curator_app/widgets/add_ui/date_time_picker_box.dart';
import 'package:flutter_wealth_curator_app/widgets/add_ui/image_picker_box.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AddTransactionsUi extends StatefulWidget {
  const AddTransactionsUi({super.key});

  @override
  State<AddTransactionsUi> createState() => _AddTransactionsUiState();
}

class _AddTransactionsUiState extends State<AddTransactionsUi> {
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

  Future<void> pickImage() async {
    final picked =
        await ImagePicker().pickImage(source: ImageSource.gallery);
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
        selectedDateTime == null) return;

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
        SnackBar(content: Text("บันทึกสำเร็จ")),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(20),
        child: ListView(
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

            TextField(controller: noteCtrl),

            SizedBox(height: 20),

            ImagePickerBox(
              file: file,
              onTap: pickImage,
            ),

            SizedBox(height: 20),

            ElevatedButton(
              onPressed: isLoading ? null : save,
              child: isLoading
                  ? CircularProgressIndicator()
                  : Text("บันทึก"),
            ),
          ],
        ),
      ),
    );
  }
}