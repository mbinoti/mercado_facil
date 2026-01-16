import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class PrimaryButton extends StatelessWidget {
  final String label;
  final IconData? trailing;
  final VoidCallback? onPressed;
  final EdgeInsets padding;
  final Color color;
  final bool expanded;

  const PrimaryButton({
    super.key,
    required this.label,
    this.trailing,
    this.onPressed,
    this.padding = const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
    this.color = kGreen,
    this.expanded = true,
  });

  @override
  Widget build(BuildContext context) {
    final child = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        ),
        if (trailing != null) ...[
          const SizedBox(width: 8),
          Icon(trailing, size: 18),
        ],
      ],
    );

    return SizedBox(
      width: expanded ? double.infinity : null,
      child: ElevatedButton(
        onPressed: onPressed ?? () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: padding,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
        ),
        child: child,
      ),
    );
  }
}
