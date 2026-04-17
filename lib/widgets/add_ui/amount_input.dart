import 'package:flutter/material.dart';

class AmountInput extends StatelessWidget {
  final TextEditingController controller;

  const AmountInput({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: IntrinsicWidth(
        child: Row(
          children: [
            Text("฿", style: TextStyle(fontSize: 28)),
            SizedBox(width: 6),
            Flexible(
              child: TextField(
                controller: controller,
                keyboardType:
                    TextInputType.numberWithOptions(decimal: true),
                style: TextStyle(
                  fontSize: 42,
                  fontWeight: FontWeight.bold,
                ),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "0.00",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}