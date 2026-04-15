// ignore_for_file: deprecated_member_use

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_wealth_curator_app/views/login_ui.dart';

class ProfileUi extends StatefulWidget {
  ProfileUi({super.key});

  @override
  State<ProfileUi> createState() => _ProfileUiState();
}

class _ProfileUiState extends State<ProfileUi> {
  final supabase = Supabase.instance.client;

  File? file;
  String? avatarUrl;
  String email = '';
  String name = '';

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadProfile();
  }

  // 🔹 โหลดข้อมูล user
  Future<void> loadProfile() async {
    final user = supabase.auth.currentUser;

    email = user?.email ?? '';

    final data = await supabase
        .from('profile_tb')
        .select()
        .eq('id', user!.id)
        .maybeSingle();

    if (data != null) {
      avatarUrl = data['avatar_url'];
      name = data['name'] ?? '';
    }

    setState(() => isLoading = false);
  }

  // 🔹 เลือกรูป + upload
  Future<void> pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (picked == null) return;

    final newFile = File(picked.path);

    final path =
        'avatar/${DateTime.now().millisecondsSinceEpoch}_${picked.name}';

    await supabase.storage.from('images_bk').upload(path, newFile);

    final url = supabase.storage.from('images_bk').getPublicUrl(path);

    final user = supabase.auth.currentUser;

    await supabase
        .from('profile_tb')
        .update({'avatar_url': url}).eq('id', user!.id);

    setState(() {
      file = newFile;
      avatarUrl = url;
    });
  }

  // 🔹 logout
  Future<void> logout() async {
    await supabase.auth.signOut();

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => LoginUi()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

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
                        ? Icon(Icons.image, size: 50, color: Colors.black54)
                        : null,
                  ),
                ),
              ),
              SizedBox(height: 15),
              Text(
                name.isNotEmpty ? name : 'Username',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 50),
              // 🔹 Email
              ListTile(
                leading: Icon(Icons.email),
                title: Text('อีเมล'),
                subtitle: Text(email),
              ),  

              Spacer(),

              // 🔹 Logout
              ElevatedButton(
                onPressed: logout,
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 55),
                  backgroundColor: Colors.red,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.logout_outlined, color: Colors.white),
                    SizedBox(width: 10),
                    Text(
                      'Logout',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
