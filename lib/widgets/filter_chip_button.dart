import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class FilterChipButton extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback? onTap;

  const FilterChipButton({
    super.key,
    required this.label,
    required this.selected,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? kGreen.withOpacity(0.15) : Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: selected ? kGreen : kBorder),
        ),
        child: Row(
          children: [
            Text(
              label,
              style: TextStyle(
                color: selected ? kGreenDark : kTextMuted,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 6),
            const Icon(Icons.keyboard_arrow_down, size: 16, color: kTextMuted),
          ],
        ),
      ),
    );
  }
}
