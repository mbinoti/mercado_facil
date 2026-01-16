import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class ProductGridCard extends StatelessWidget {
  final String name;
  final String subtitle;
  final String price;
  final String? oldPrice;
  final String? badge;
  final Color imageColor;
  final bool showFavorite;
  final bool selected;
  final VoidCallback? onTap;

  const ProductGridCard({
    super.key,
    required this.name,
    required this.subtitle,
    required this.price,
    this.oldPrice,
    this.badge,
    required this.imageColor,
    this.showFavorite = false,
    this.selected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: cardDecoration(),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 90,
                    decoration: BoxDecoration(
                      color: imageColor,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Center(
                      child: Icon(Icons.local_grocery_store, color: kTextMuted),
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (badge != null)
                    Container(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: kGreen.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        badge!,
                        style: const TextStyle(
                          fontSize: 11,
                          color: kGreenDark,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  const SizedBox(height: 6),
                  Text(
                    name,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(fontSize: 12, color: kTextMuted),
                  ),
                  const Spacer(),
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
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          color: kGreenDark,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Positioned(
              right: 12,
              bottom: 12,
              child: CircleAvatar(
                radius: 16,
                backgroundColor: selected ? kGreen : kGreen.withOpacity(0.12),
                child: Icon(
                  selected ? Icons.check : Icons.add,
                  color: selected ? Colors.white : kGreenDark,
                  size: 18,
                ),
              ),
            ),
            if (showFavorite)
              Positioned(
                right: 12,
                top: 12,
                child: CircleAvatar(
                  radius: 14,
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.favorite,
                    color: selected ? kGreen : kTextMuted,
                    size: 14,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
