import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfileUi extends StatefulWidget {
  const ProfileUi({super.key});

  @override
  State<ProfileUi> createState() => _ProfileUiState();
}

class _ProfileUiState extends State<ProfileUi> {
  //ตัวแปรเก็บไฟล์ที่ใช้อัปโหลด
  File? file;

  //---- เปิดกลองถ่ายภาพ และกำหนดค่ารูปเพื่อ upload ----
  Future<void> pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (picked != null) {
      setState(() {
        file = File(picked.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(
              'Profile',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(
          30.0,
          40.0,
          30.0,
          20.0,
        ),
        child: Center(
          child: Column(
            children: [
              // ส่วนแสดงรูปและรูปกล้องเพื่อเปิดกล้อง
              GestureDetector(
                onTap: pickImage,
                child: Container(
                  padding: EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 5),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    radius: 70,
                    backgroundColor: Colors.grey[300],
                    backgroundImage: file != null ? FileImage(file!) : null,
                    child: file == null
                        ? Icon(Icons.image,
                            size: 50, color: Colors.black54)
                        : null,
                  ),
                ),
              ),
              SizedBox(height: 20),

            ],
          ),
        ),
      ),
    );
  }
}
