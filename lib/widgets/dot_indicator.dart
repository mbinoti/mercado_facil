import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class DotIndicator extends StatelessWidget {
  final bool active;

  const DotIndicator({super.key, required this.active});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: active ? 22 : 10,
      height: 8,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: active ? kGreen : kBorder,
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}
