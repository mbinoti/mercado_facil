import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final bool bold;
  final Color? valueColor;

  const SummaryRow({
    super.key,
    required this.label,
    required this.value,
    this.bold = false,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    final style = TextStyle(
      fontWeight: bold ? FontWeight.w700 : FontWeight.w500,
      color: valueColor ?? kTextDark,
    );
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: kTextMuted)),
        Text(value, style: style),
      ],
    );
  }
}
