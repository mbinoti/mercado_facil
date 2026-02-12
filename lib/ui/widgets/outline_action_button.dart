import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class OutlineActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color iconColor;
  final VoidCallback? onPressed;

  const OutlineActionButton({
    super.key,
    required this.label,
    required this.icon,
    required this.iconColor,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: onPressed ?? () {},
        style: OutlinedButton.styleFrom(
          foregroundColor: kTextDark,
          side: const BorderSide(color: kBorder),
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
        ),
        icon: Icon(icon, color: iconColor),
        label: Text(label),
      ),
    );
  }
}
