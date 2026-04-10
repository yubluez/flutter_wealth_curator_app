import 'package:flutter/material.dart';

class RecentActivity extends StatelessWidget {
  const RecentActivity({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: 5, // Number of recent activities
            itemBuilder: (context, index) {
              return ListTile(
                onTap: () {},
              );
            },
          ),
        )
      ],
    );
  }
}