import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class CategoryIcon extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback? onTap;

  const CategoryIcon({
    super.key,
    required this.label,
    required this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: kGreen.withOpacity(0.12),
            child: Icon(icon, color: kGreen),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: const TextStyle(fontSize: 11),
          ),
        ],
      ),
    );
  }
}
