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
      ),
      itemBuilder: (context, index) {
        final cat = categories[index];
        final isSelected = selectedId == cat.id;
        final color =
            cat.color != null ? hexToColor(cat.color!) : Colors.blue;

        return GestureDetector(
          onTap: () => onSelect(cat.id!),
          child: Container(
            decoration: BoxDecoration(
              color: isSelected ? color : Colors.grey[300],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(child: Text(cat.name ?? "")),
          ),
        );
      },
    );
  }
}