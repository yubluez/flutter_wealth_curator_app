import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class ImagePickerBox extends StatelessWidget {
  final File? file;
  final VoidCallback onTap;
  final VoidCallback? onDelete;

  const ImagePickerBox({
    super.key,
    required this.file,
    required this.onTap,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (file != null) {
          // 👉 ดูรูปเต็ม
          showDialog(
            context: context,
            builder: (_) => Dialog(
              child: Image.file(file!),
            ),
          );
        } else {
          onTap();
        }
      },
      child: Stack(
        children: [
          Container(
            height: 140,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(12),
            ),
            child: file == null
                ? Icon(Icons.camera_alt, size: 40)
                : ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.file(file!, fit: BoxFit.cover),
                  ),
          ),

          /// 🔴 ปุ่มลบ
          if (file != null)
            Positioned(
              top: 8,
              right: 8,
              child: GestureDetector(
                onTap: onDelete,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    shape: BoxShape.circle,
                  ),
                  padding: EdgeInsets.all(6),
                  child: Icon(Icons.close, color: Colors.white, size: 18),
                ),
              ),
            ),
        ],
      ),
    );
  }
}