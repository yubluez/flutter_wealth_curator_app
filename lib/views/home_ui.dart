// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter_wealth_curator_app/views/add_transactions_ui.dart';
import 'package:flutter_wealth_curator_app/views/category_ui.dart';
import 'package:flutter_wealth_curator_app/views/history_ui.dart';
import 'package:flutter_wealth_curator_app/views/profile_ui.dart';
import 'package:flutter_wealth_curator_app/widgets/home_ui/circular_widget.dart';
import 'package:flutter_wealth_curator_app/widgets/home_ui/current_card.dart';
import 'package:flutter_wealth_curator_app/widgets/home_ui/linear_widget.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomeUi extends StatefulWidget {
  const HomeUi({super.key});

  @override
  State<HomeUi> createState() => _HomeUiState();
}

class _HomeUiState extends State<HomeUi> {
  int _currentIndex = 0;
  double balance = 0;

  late final List<Widget> _pages = [
    homePage(),
    AddTransactionsUi(),
    HistoryUi(),
    CategoryUi(),
    // Add other pages here
  ];

  final List<String> _titles = [
    'Wealth Curator',
    'เพิ่มรายการ',
    'ประวัติรายการ',
    'รายงาน',
  ];

  //-------------------------------------------------
  Future load() async {
    final user = Supabase.instance.client.auth.currentUser;

    final data = await Supabase.instance.client
        .from('transactions_tb')
        .select()
        .eq('user_id', user!.id);

    double total = 0;

    for (var t in data) {
      if (t['type'] == 'income') {
        total += t['amount'];
      } else {
        total -= t['amount'];
      }
    }

    setState(() => balance = total);
  }

  @override
  void initState() {
    super.initState();
    load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            SizedBox(width: 15.0),
            GestureDetector(
              onTap: () {
                // Handle profile tap
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfileUi()),
                );
              },
              child: Icon(Icons.account_circle, size: 30.0),
            ),
            SizedBox(width: 10.0),
            Text(
              _titles[_currentIndex],
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: const Color.fromARGB(255, 17, 23, 209),
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.house),
            label: 'หน้าแรก',
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.circlePlus),
            label: 'เพิ่ม',
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.clockRotateLeft),
            label: 'ประวัติ',
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.chartPie),
            label: 'รายงาน',
          ),
        ],
      ),
    );
  }

  Widget homePage() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(35.0),
      child: Column(
        children: [
          // Card Current
          CurrentCard(),
          SizedBox(height: 30.0),
          // Category Circular
          Container(
            width: double.infinity,
            height: 435.0,
            padding: EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 255, 255, 255),
              borderRadius: BorderRadius.circular(20.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      'Category',
                      style: TextStyle(
                        fontSize: 14.0,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Spacer(),
                    GestureDetector(
                      onTap: () {
                        // Handle "See All" tap
                        setState(() {
                          _currentIndex = 3; // Navigate to CategoryUi
                        });
                      },
                      child: Text(
                        'See All',
                        style: TextStyle(
                          fontSize: 14.0,
                          color: const Color.fromARGB(255, 17, 23, 209),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.0),
                CircularWidget(),
                SizedBox(height: 30.0),
                LinearWidget(),
                SizedBox(height: 30.0),
                LinearWidget(),
                SizedBox(height: 30.0),
                LinearWidget(),
              ],
            ),
          ),
          SizedBox(height: 30.0),
          // Recent Activity
          Row(
            children: [
              Text(
                'Recent Activity',
                style: TextStyle(
                  fontSize: 14.0,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Spacer(),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _currentIndex = 2; // Navigate to HistoryUi
                  });
                },
                child: Text(
                  'Full History',
                  style: TextStyle(
                    fontSize: 14.0,
                    color: const Color.fromARGB(255, 17, 23, 209),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20.0),
        ],
      ),
    );
  }
}
