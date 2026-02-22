import 'package:flutter/material.dart';
import 'package:hive_ce/hive.dart';

import '../../app_routes.dart';
import '../../model/hive/fake_hive_repository.dart';

class AppBottomNav extends StatelessWidget {
  final int currentIndex;

  const AppBottomNav({super.key, required this.currentIndex});

  static const List<_BottomNavEntry> _entries = [
    _BottomNavEntry(label: 'Inicio', icon: Icons.home_rounded),
    _BottomNavEntry(label: 'Buscar', icon: Icons.search_rounded),
    _BottomNavEntry(label: 'Cesta', icon: Icons.shopping_basket_rounded),
    _BottomNavEntry(label: 'Pedidos', icon: Icons.receipt_long_rounded),
    _BottomNavEntry(label: 'Perfil', icon: Icons.person_rounded),
  ];

  void _handleTap(BuildContext context, int index) {
    if (index == currentIndex) {
      return;
    }
    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, AppRoutes.home);
        return;
      case 1:
        Navigator.pushReplacementNamed(context, AppRoutes.search);
        return;
      case 2:
        Navigator.pushReplacementNamed(context, AppRoutes.cart);
        return;
      case 3:
        Navigator.pushReplacementNamed(context, AppRoutes.confirmed);
        return;
      case 4:
        Navigator.pushReplacementNamed(context, AppRoutes.login);
        return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box<dynamic>>(
      valueListenable: FakeHiveRepository.cartListenable(),
      builder: (context, box, child) {
        final cartCount = FakeHiveRepository.cartItemsCount();
        final cartBadge = cartCount > 0 ? cartCount.toString() : null;

        return SafeArea(
          top: false,
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Color(0xFFE7ECE8))),
            ),
            padding: const EdgeInsets.fromLTRB(6, 7, 6, 8),
            child: Row(
              children: [
                for (int index = 0; index < _entries.length; index++)
                  Expanded(
                    child: _BottomNavItem(
                      entry: _entries[index],
                      active: index == currentIndex,
                      cartBadge: index == 2 ? cartBadge : null,
                      onTap: () => _handleTap(context, index),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _BottomNavItem extends StatelessWidget {
  final _BottomNavEntry entry;
  final bool active;
  final String? cartBadge;
  final VoidCallback onTap;

  const _BottomNavItem({
    required this.entry,
    required this.active,
    required this.cartBadge,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final iconColor = active
        ? const Color(0xFF18B958)
        : const Color(0xFFA1A8A4);
    final labelColor = active
        ? const Color(0xFF18B958)
        : const Color(0xFFA1A8A4);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 3),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: active
                        ? const Color(0xFFD9F8E6)
                        : Colors.transparent,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(entry.icon, color: iconColor, size: 20),
                ),
                if (cartBadge != null)
                  Positioned(
                    right: -2,
                    top: -1,
                    child: CircleAvatar(
                      radius: 7,
                      backgroundColor: Color(0xFFE83B40),
                      child: Text(
                        cartBadge!,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 3),
            Text(
              entry.label,
              style: TextStyle(
                color: labelColor,
                fontSize: 10,
                fontWeight: active ? FontWeight.w700 : FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BottomNavEntry {
  final String label;
  final IconData icon;

  const _BottomNavEntry({required this.label, required this.icon});
}
