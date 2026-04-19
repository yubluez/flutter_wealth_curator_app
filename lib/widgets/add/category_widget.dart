import 'package:flutter/material.dart';
import '../../models/category_model.dart';

class CategoryWidget extends StatelessWidget {
  final List<Category> categories;
  final String selectedId;
  final Function(String) onSelect;

  const CategoryWidget({
    super.key,
    required this.categories,
    required this.selectedId,
    required this.onSelect,
  });

  Color hexToColor(String hex) {
    return Color(int.parse(hex));
  }

  IconData getIcon(String? name) {
    switch (name) {
      case 'ช้อปปิ้ง':
        return Icons.shopping_bag;
      case 'เดินทาง':
        return Icons.directions_car;
      case 'ที่พัก':
        return Icons.hotel;
      case 'บันเทิง':
        return Icons.movie;
      case 'บิล':
        return Icons.receipt;
      case 'สุขภาพ':
        return Icons.health_and_safety;
      case 'อาหาร':
        return Icons.restaurant;
      default:
        return Icons.category;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: categories.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 1,
      ),
      itemBuilder: (context, index) {
        final cat = categories[index];
        final isSelected = selectedId == cat.id;
        final color = cat.color != null ? hexToColor(cat.color!) : Colors.blue;

        return GestureDetector(
          onTap: () => onSelect(cat.id!),
          child: Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isSelected ? color : Colors.grey[300],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(getIcon(cat.name),
                    color: isSelected ? Colors.white : Colors.black),
                SizedBox(height: 5),
                Text(
                  cat.name ?? "",
                  style: TextStyle(
                    fontSize: 12,
                    color: isSelected ? Colors.white : Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
