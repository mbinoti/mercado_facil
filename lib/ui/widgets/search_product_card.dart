import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class SearchProductCard extends StatelessWidget {
  final String name;
  final String subtitle;
  final String price;
  final String? oldPrice;
  final String? tag;
  final bool soldOut;
  final VoidCallback? onAdd;

  const SearchProductCard({
    super.key,
    required this.name,
    required this.subtitle,
    required this.price,
    this.oldPrice,
    this.tag,
    this.soldOut = false,
    this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    final muted = soldOut ? kTextMuted : kGreenDark;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: cardDecoration(radius: 16),
      child: Row(
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: kBorder,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(Icons.shopping_basket, color: kTextMuted),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (tag != null)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: kGreen.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      tag!,
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: kGreenDark,
                      ),
                    ),
                  ),
                const SizedBox(height: 6),
                Text(
                  name,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: soldOut ? kTextMuted : kTextDark,
                  ),
                ),
                Text(subtitle, style: const TextStyle(color: kTextMuted)),
                const SizedBox(height: 6),
                Row(
                  children: [
                    if (oldPrice != null)
                      Padding(
                        padding: const EdgeInsets.only(right: 6),
                        child: Text(
                          oldPrice!,
                          style: const TextStyle(
                            fontSize: 11,
                            color: kTextMuted,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      ),
                    Text(
                      price,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: muted,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          if (soldOut)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: kBorder,
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Text(
                'Avise-me',
                style: TextStyle(fontSize: 12, color: kTextMuted),
              ),
            )
          else
            ElevatedButton(
              onPressed: onAdd ?? () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: kGreen,
                foregroundColor: Colors.white,
                elevation: 0,
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text(
                'Adicionar +',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
              ),
            ),
        ],
      ),
    );
  }
}
