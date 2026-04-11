// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class CurrentCard extends StatelessWidget {
  const CurrentCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 210.0,
      padding: EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 2, 8, 190),
        // color: const Color.fromARGB(255, 4, 7, 88),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Current Balance',
            style: TextStyle(
              fontSize: 14.0,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10.0),
          Text(
            '฿ 0.00',
            style: TextStyle(
              fontSize: 36.0,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10.0),
          // mini card
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 155.0,
                height: 70.0,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 43, 43, 205),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Income',
                        style: TextStyle(
                          fontSize: 14.0,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        '฿ 0.00',
                        style: TextStyle(
                          fontSize: 20.0,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 10.0),
              Container(
                width: 155.0,
                height: 70.0,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 43, 43, 205),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Expenses',
                        style: TextStyle(
                          fontSize: 14.0,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        '฿ 0.00',
                        style: TextStyle(
                          fontSize: 20.0,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
