import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class CounterControl extends StatelessWidget {
  final String value;

  const CounterControl({super.key, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 14,
          backgroundColor: kBorder,
          child: const Icon(Icons.remove, size: 16, color: kTextMuted),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
        const CircleAvatar(
          radius: 14,
          backgroundColor: kGreen,
          child: Icon(Icons.add, size: 16, color: Colors.white),
        ),
      ],
    );
  }
}
