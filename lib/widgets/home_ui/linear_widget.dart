import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class LinearWidget extends StatelessWidget {
  const LinearWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('name'),
            Text("50%"),
          ],
        ),
        SizedBox(height: 5),
        LinearPercentIndicator(
          lineHeight: 8.0,
          percent: 50.0/100.0,
          backgroundColor: Colors.grey.shade300,
          progressColor: Colors.grey,
          barRadius: Radius.circular(10.0),
        ),

      ],
    );
  }
}

// Widget buildCategory(String name, double percent) {
//   return Padding(
//     padding: const EdgeInsets.only(bottom: 12),
//     child: Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Text(name),
//             Text("${(percent * 100).toInt()}%"),
//           ],
//         ),
//         SizedBox(height: 5),
//         LinearPercentIndicator(
//           lineHeight: 8,
//           percent: percent,
//           backgroundColor: Colors.grey.shade300,
//           progressColor: Colors.grey,
//           barRadius: Radius.circular(10),
//         ),
//       ],
//     ),
//   );
// }