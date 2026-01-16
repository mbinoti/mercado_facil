import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import 'counter_control.dart';

class CartItemCard extends StatelessWidget {
  final String name;
  final String brand;
  final String price;
  final String quantity;

  const CartItemCard({
    super.key,
    required this.name,
    required this.brand,
    required this.price,
    required this.quantity,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: cardDecoration(radius: 16),
      child: Row(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: kBorder,
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(Icons.shopping_bag, color: kTextMuted),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.w600)),
                Text(brand, style: const TextStyle(color: kTextMuted, fontSize: 12)),
                const SizedBox(height: 6),
                Text(price,
                    style: const TextStyle(
                      color: kGreenDark,
                      fontWeight: FontWeight.w700,
                    )),
              ],
            ),
          ),
          CounterControl(value: quantity),
          const SizedBox(width: 8),
          const Icon(Icons.delete_outline, color: kTextMuted),
        ],
      ),
    );
  }
}
