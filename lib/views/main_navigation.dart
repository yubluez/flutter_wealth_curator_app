import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'home_ui.dart';
import 'add_transactions_ui.dart';
import 'history_ui.dart';
import 'category_ui.dart';
import 'profile_ui.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  final supabase = Supabase.instance.client;
  int _currentIndex = 0;
  String? avatarUrl; // 🔹 ตัวแปรเก็บ URL รูปโปรไฟล์

  @override
  void initState() {
    super.initState();
    _loadUserProfile(); // 🔹 โหลดรูปโปรไฟล์ตั้งแต่เปิดแอป
    _pages = [
      HomeUi(onNavigate: _onNavigate),
      AddTransactionsUi(),
      HistoryUi(),
      CategoryUi(),
    ];
  }

  // 🔹 ฟังก์ชันดึงรูปโปรไฟล์จากฐานข้อมูล
  Future<void> _loadUserProfile() async {
    final user = supabase.auth.currentUser;
    if (user != null) {
      final data = await supabase
          .from('profile_tb')
          .select('avatar_url')
          .eq('id', user.id)
          .maybeSingle();

      if (data != null && mounted) {
        setState(() {
          avatarUrl = data['avatar_url'];
        });
      }
    }
  }

  void _onNavigate(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  late final List<Widget> _pages;

  final List<String> _titles = [
    'Wealth Curator',
    'เพิ่มรายการ',
    'ประวัติรายการ',
    'รายงาน',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.grey[100],
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            SizedBox(width: 5.0),
            GestureDetector(
              onTap: () async {
                // 🔹 เมื่อกลับมาจากหน้า Profile ให้โหลดรูปใหม่เผื่อมีการอัปเดต
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfileUi()),
                );
                _loadUserProfile();
              },
              child: CircleAvatar(
                radius: 18,
                backgroundColor: Colors.grey[300],
                // 🔹 เงื่อนไขการแสดงรูป: ถ้ามี URL ให้โชว์รูปจากเน็ต ถ้าไม่มีให้โชว์ไอคอนคน
                backgroundImage: (avatarUrl != null && avatarUrl!.isNotEmpty)
                    ? NetworkImage(avatarUrl!)
                    : null,
                child: (avatarUrl == null || avatarUrl!.isEmpty)
                    ? Icon(Icons.person, color: Colors.white, size: 25)
                    : null,
              ),
            ),
            SizedBox(width: 15.0),
            Text(
              _titles[_currentIndex],
              style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
          ],
        ),
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Color(0xFF1117D1),
        unselectedItemColor: Colors.grey,
        onTap: (index) => setState(() => _currentIndex = index),
        items: [
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.house, size: 20),
            label: 'หน้าแรก',
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.circlePlus, size: 20),
            label: 'เพิ่ม',
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.clockRotateLeft, size: 20),
            label: 'ประวัติ',
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.chartPie, size: 20),
            label: 'รายงาน',
          ),
        ],
      ),
    );
  }
}
