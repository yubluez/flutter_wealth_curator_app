// ignore_for_file: deprecated_member_use

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_wealth_curator_app/widgets/circular_widget.dart';
import 'package:flutter_wealth_curator_app/widgets/current_card.dart';
import 'package:flutter_wealth_curator_app/widgets/linear_widget.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class HomeUi extends StatefulWidget {
  const HomeUi({super.key});

  @override
  State<HomeUi> createState() => _HomeUiState();
}

class _HomeUiState extends State<HomeUi> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            SizedBox(width: 15.0),
            Icon(Icons.account_circle, size: 30.0),
            SizedBox(width: 10.0),
            Text(
              'Wealth Curator',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
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
                    // Handle "See All" tap
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
      ),
    );
  }
}
