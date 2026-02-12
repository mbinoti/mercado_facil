import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class PaymentOption extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback? onTap;

  const PaymentOption({
    super.key,
    required this.label,
    required this.icon,
    required this.selected,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: selected ? kGreen.withOpacity(0.12) : Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: selected ? kGreen : kBorder),
          ),
          child: Column(
            children: [
              Icon(icon, color: selected ? kGreenDark : kTextMuted),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: selected ? kGreenDark : kTextMuted,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
