import 'package:flutter/material.dart';

import '../app_routes.dart';
import '../theme/app_theme.dart';

class AppBottomNav extends StatelessWidget {
  final int currentIndex;

  const AppBottomNav({super.key, required this.currentIndex});

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
    return BottomNavigationBar(
      currentIndex: currentIndex,
      selectedItemColor: kGreen,
      unselectedItemColor: kTextMuted,
      showUnselectedLabels: true,
      type: BottomNavigationBarType.fixed,
      onTap: (index) => _handleTap(context, index),
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
        BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Buscar'),
        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_basket),
          label: 'Cesta',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.receipt_long),
          label: 'Pedidos',
        ),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
      ],
    );
  }
}
