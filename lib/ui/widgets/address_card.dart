import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class AddressCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final bool selected;
  final VoidCallback? onTap;

  const AddressCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.selected,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: cardDecoration(radius: 16),
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: kGreen.withOpacity(0.12),
          child: Icon(icon, color: kGreen),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle, style: const TextStyle(color: kTextMuted)),
        trailing: Container(
          width: 22,
          height: 22,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: selected ? kGreen : kBorder,
              width: 2,
            ),
          ),
          child: selected
              ? Center(
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: const BoxDecoration(
                      color: kGreen,
                      shape: BoxShape.circle,
                    ),
                  ),
                )
              : null,
        ),
      ),
    );
  }
}
