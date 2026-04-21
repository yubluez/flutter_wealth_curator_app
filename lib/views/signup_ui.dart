// ignore_for_file: sort_child_properties_last, use_build_context_synchronously

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_wealth_curator_app/views/login_ui.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SignupUi extends StatefulWidget {
  const SignupUi({super.key});

  @override
  State<SignupUi> createState() => _SignupUiState();
}

class _SignupUiState extends State<SignupUi> {
  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();
  final nameCtrl = TextEditingController();

  bool isLoading = false;

  Future signup() async {
    if (nameCtrl.text.isEmpty ||
        emailCtrl.text.isEmpty ||
        passwordCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('กรุณากรอกข้อมูลให้ครบ')),
      );
      return;
    }

    try {
      setState(() => isLoading = true);

      final supabase = Supabase.instance.client;

      final res = await supabase.auth.signUp(
        email: emailCtrl.text.trim(),
        password: passwordCtrl.text.trim(),
      );

      // insert profile ได้เลย (ไม่ต้อง login ก่อนแล้ว)
      if (res.user != null) {
        await supabase.from('profile_tb').insert({
          'id': res.user!.id,
          'name': nameCtrl.text.trim(),
        });
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('สมัครสำเร็จ')),
      );

      // ไป login
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginUi()),
        (route) => false,
      );
    } catch (e) {
      print('ERROR: $e');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height,
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/logo.png',
                      width: 130,
                      height: 130,
                      fit: BoxFit.cover,
                    ),
                    SizedBox(height: 20),
                    Text(
                      'สร้างบัญชีผู้ใช้ใหม่!',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      'กรอกข้อมูลด้านล่างเพื่อใช้งานแอป',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 40),
                    // Username
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'ชื่อผู้ใช้',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: nameCtrl,
                      decoration: InputDecoration(
                        hintText: 'กรุณากรอกชื่อผู้ใช้',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    // Email
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'อีเมล',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: emailCtrl,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        hintText: 'กรุณากรอกอีเมล',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    // Password
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'รหัสผ่าน',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: passwordCtrl,
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: 'กรุณากรอกรหัสผ่าน',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    SizedBox(height: 40),
                    // ปุ่มสมัครสมาชิก
                    ElevatedButton(
                      onPressed: isLoading ? null : signup,
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(double.infinity, 55),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        backgroundColor: Color(0xFF1117D1),
                      ),
                      child: isLoading
                          ? CircularProgressIndicator(color: Colors.white)
                          : Text(
                              'สมัครสมาชิก',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                    ),
                    SizedBox(height: 20),
                    RichText(
                      text: TextSpan(
                        text: 'ท่านมีบัญชีแล้วใช่หรือไม่ ? ',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                        ),
                        children: [
                          TextSpan(
                            text: 'เข้าสู่ระบบ',
                            style: TextStyle(
                              fontSize: 14,
                              color: const Color.fromARGB(255, 11, 13, 145),
                              fontWeight: FontWeight.bold,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => LoginUi(),
                                  ),
                                );
                              },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
