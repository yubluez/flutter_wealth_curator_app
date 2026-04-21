import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AmountInput extends StatelessWidget {
  final TextEditingController controller;

  const AmountInput({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize:
            MainAxisSize.min,
        children: [
          Text(
            "฿",
            style: TextStyle(
              fontSize: 28,
              color: Colors.grey[500],
            ),
          ),
          SizedBox(width: 10),
          Flexible(
            child: IntrinsicWidth(
              child: TextField(
                controller: controller,
                keyboardType:
                    TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  LengthLimitingTextInputFormatter(10),
                ],
                textAlign: TextAlign.left,
                cursorColor: Color(0xFF1117D1),
                autofocus: true,
                style: TextStyle(
                  fontSize: 42,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1117D1),
                ),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "0.00",
                  hintStyle: TextStyle(
                    fontSize: 42,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[400],
                  ),
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
