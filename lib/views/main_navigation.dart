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
  String currentReportType = 'expense'; // เก็บสถานะเพื่อเปลี่ยนสีไอคอนใน AppBar
  final GlobalKey<HomeUiState> _homeKey = GlobalKey<HomeUiState>();
  final GlobalKey<AddTransactionsUiState> _addKey =
      GlobalKey<AddTransactionsUiState>();
  final GlobalKey<HistoryUiState> _historyKey = GlobalKey<HistoryUiState>();
  final GlobalKey<CategoryUiState> _categoryKey = GlobalKey<CategoryUiState>();

  final supabase = Supabase.instance.client;
  int _currentIndex = 0;
  String? avatarUrl;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
    _pages = [
      HomeUi(key: _homeKey, onNavigate: _onNavigate),
      AddTransactionsUi(key: _addKey),
      HistoryUi(key: _historyKey),
      CategoryUi(
        key: _categoryKey,
        onTypeChanged: (type) => setState(() => currentReportType = type),
      ),
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
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(width: 5.0),
            GestureDetector(
              onTap: () async {
                // เมื่อกลับมาจากหน้า Profile ให้โหลดรูปใหม่เผื่อมีการอัปเดต
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfileUi()),
                );
                _loadUserProfile();
              },
              child: CircleAvatar(
                radius: 18,
                backgroundColor: Colors.grey[300],
                // เงื่อนไขการแสดงรูป: ถ้ามี URL ให้โชว์รูปจากเน็ต ถ้าไม่มีให้โชว์ไอคอนคน
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
        actions: [
          if (_currentIndex == 3)
            Padding(
              padding: EdgeInsets.only(right: 15),
              child: _buildTypeToggle(),
            ),
        ],
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
        onTap: (index) {
          setState(() => _currentIndex = index);
          if (index == 0) _homeKey.currentState?.loadData();
          if (index == 1) _addKey.currentState?.resetForm();
          if (index == 2) _historyKey.currentState?.loadData();
          if (index == 3) _categoryKey.currentState?.loadData();
        },
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

  Widget _buildTypeToggle() {
    final isExpense = currentReportType == 'expense';

    return GestureDetector(
      onTap: () {
        _categoryKey.currentState?.toggleType();
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 250),
        padding: EdgeInsets.symmetric(horizontal: 6, vertical: 6),
        decoration: BoxDecoration(
          color: isExpense ? Color(0xFFFFEBEB) : Color(0xFFE8F7EF),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: Colors.white, width: 1.5),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            /// 🔴 / 🟢 วงกลม
            AnimatedContainer(
              duration: Duration(milliseconds: 250),
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: isExpense ? Colors.red : Colors.green,
                shape: BoxShape.circle,
              ),
              child: Icon(
                isExpense ? Icons.trending_down : Icons.trending_up,
                color: Colors.white,
                size: 16,
              ),
            ),
            SizedBox(width: 8),
            Padding(
              padding: EdgeInsets.only(right: 10),
              child: Text(
                isExpense ? 'รายจ่าย' : 'รายรับ',
                style: TextStyle(
                  color: isExpense ? Colors.red : Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
