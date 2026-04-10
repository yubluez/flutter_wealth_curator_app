import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class CircularWidget extends StatelessWidget {
  const CircularWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularPercentIndicator(
        radius: 80.0,
        lineWidth: 15.0,
        percent: 0.7,
        center: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "64%",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text("Budget Used", style: TextStyle(fontSize: 14)),
          ],
        ),
        progressColor: Colors.blueAccent,
        backgroundColor: Colors.grey.shade300,
        circularStrokeCap: CircularStrokeCap.round,
      ),
    );
  }
}
