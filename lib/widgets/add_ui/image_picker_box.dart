import 'dart:io';
import 'package:flutter/material.dart';

class ImagePickerBox extends StatelessWidget {
  final File? file;
  final VoidCallback onTap;

  const ImagePickerBox({
    super.key,
    required this.file,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 140,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(12),
        ),
        child: file == null
            ? Icon(Icons.camera_alt, size: 40)
            : Image.file(file!, fit: BoxFit.cover),
      ),
    );
  }
}