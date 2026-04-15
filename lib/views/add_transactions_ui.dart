import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class AddTransactionsUi extends StatefulWidget {
  const AddTransactionsUi({super.key});

  @override
  State<AddTransactionsUi> createState() => _AddTransactionsUiState();
}

class _AddTransactionsUiState extends State<AddTransactionsUi> {
  bool isExpense = true;
  String amount = "0.00";
  String selectedCategory = "";
  File? image;
  DateTime? selectedDateTime;

  final List<Map<String, dynamic>> categories = [
    {"name": "อาหาร", "color": Color(0xffF97316), "icon": Icons.fastfood},
    {
      "name": "เดินทาง",
      "color": Color(0xff3B82F6),
      "icon": Icons.directions_car
    },
    {"name": "ที่พัก", "color": Color(0xff10B981), "icon": Icons.home},
    {
      "name": "ช้อปปิ้ง",
      "color": Color(0xff8B5CF6),
      "icon": Icons.shopping_bag
    },
    {"name": "บันเทิง", "color": Color(0xffEF4444), "icon": Icons.movie},
    {"name": "สุขภาพ", "color": Color(0xffF59E0B), "icon": Icons.favorite},
    {"name": "การศึกษา", "color": Color(0xff06B6D4), "icon": Icons.school},
    {"name": "อื่นๆ", "color": Color(0xff6B7280), "icon": Icons.category},
  ];

  // 📸 เลือกรูป
  Future<void> pickImage() async {
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
                  final picked =
                      await ImagePicker().pickImage(source: ImageSource.camera);
                  if (picked != null) {
                    setState(() => image = File(picked.path));
                  }
                },
              ),
              ListTile(
                leading: Icon(Icons.photo),
                title: Text("เลือกจากแกลเลอรี่"),
                onTap: () async {
                  Navigator.pop(context);
                  final picked = await ImagePicker()
                      .pickImage(source: ImageSource.gallery);
                  if (picked != null) {
                    setState(() => image = File(picked.path));
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // 📅 เลือกวันเวลา
  Future<void> pickDateTime() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (pickedDate == null) return;

    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime == null) return;

    setState(() {
      selectedDateTime = DateTime(
        pickedDate.year,
        pickedDate.month,
        pickedDate.day,
        pickedTime.hour,
        pickedTime.minute,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("เพิ่มรายการ")),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(40), // 🔥 พอดี
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🔹 Toggle
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => isExpense = true),
                        child: AnimatedContainer(
                          duration: Duration(milliseconds: 200),
                          margin: EdgeInsets.all(6),
                          padding: EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color:
                                isExpense ? Colors.white : Colors.transparent,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Center(child: Text("Expenses")),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => isExpense = false),
                        child: AnimatedContainer(
                          duration: Duration(milliseconds: 200),
                          margin: EdgeInsets.all(6),
                          padding: EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color:
                                !isExpense ? Colors.white : Colors.transparent,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Center(child: Text("Income")),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 20),

              // 🔹 Amount
              Center(
                child: RichText(
                  text: TextSpan(
                    text: "฿ ",
                    style: TextStyle(fontSize: 28, color: Colors.grey[600]),
                    children: [
                      TextSpan(
                        text: amount,
                        style: TextStyle(
                          fontSize: 46,
                          fontWeight: FontWeight.bold,
                          color: amount == "0.00" ? Colors.grey : Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 20),

              // 🔹 Categories
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 20,
                runSpacing: 10,
                children: categories.map((cat) {
                  final isSelected = selectedCategory == cat["name"];

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedCategory = cat["name"];
                      });
                    },
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 200),
                      width: 72.5,
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: isSelected ? cat["color"] : Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            cat["icon"],
                            color: isSelected ? Colors.white : Colors.black,
                          ),
                          SizedBox(height: 5),
                          Text(
                            cat["name"],
                            style: TextStyle(
                              fontSize: 10,
                              color: isSelected ? Colors.white : Colors.black,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),

              SizedBox(height: 25),

              // 🔹 DateTime
              GestureDetector(
                onTap: pickDateTime,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 18),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.calendar_today),
                      SizedBox(width: 10),
                      Text(
                        selectedDateTime == null
                            ? "date / time"
                            : DateFormat('dd MMM yyyy • HH:mm')
                                .format(selectedDateTime!),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 20),

              // 🔹 Note
              TextField(
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

              // 🔹 Image
              GestureDetector(
                onTap: pickImage,
                child: Container(
                  height: 140,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: image == null
                      ? Center(child: Icon(Icons.camera_alt, size: 40))
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.file(
                            image!,
                            width: double.infinity,
                            height: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                ),
              ),

              SizedBox(height: 25),

              // 🔹 Save
              ElevatedButton(
                onPressed: () {
                  // TODO: ส่งข้อมูลไป Supabase
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 55),
                  backgroundColor: Color(0xFF1117D1),
                ),
                child: Text(
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
