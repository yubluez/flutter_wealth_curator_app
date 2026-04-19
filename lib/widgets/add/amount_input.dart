import 'package:flutter/material.dart';

class AmountInput extends StatelessWidget {
  final TextEditingController controller;

  const AmountInput({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Center(
      // 🔹 ใช้ IntrinsicWidth เพื่อให้ Row กว้างเท่ากับเนื้อหาที่พิมพ์จริง
      child: IntrinsicWidth(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "฿",
              style: TextStyle(
                fontSize: 28,
                color: Colors.grey[500],
              ),
            ),
            SizedBox(width: 10),
            // 🔹 ใช้ IntrinsicWidth ซ้อนใน TextField เพื่อให้ขยายตามตัวหนังสือ
            IntrinsicWidth(
              child: TextField(
                controller: controller,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
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
                  // ลบ Constraints ที่จำกัดพื้นที่ออก
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
