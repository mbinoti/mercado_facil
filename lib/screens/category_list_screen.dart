import 'package:flutter/material.dart';

import '../app_routes.dart';
import '../theme/app_theme.dart';
import '../widgets/app_bottom_nav.dart';
import '../widgets/badge_icon.dart';
import '../widgets/filter_chip_button.dart';
import '../widgets/product_grid_card.dart';

class CategoryListScreen extends StatelessWidget {
  const CategoryListScreen({super.key});

  void _goToProduct(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.product);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hortifruti'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: BadgeIcon(icon: Icons.shopping_cart, badge: '3'),
          ),
        ],
      ),
      bottomNavigationBar: const AppBottomNav(currentIndex: 1),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          children: [
            Row(
              children: const [
                FilterChipButton(label: 'Todos', selected: true),
                SizedBox(width: 8),
                FilterChipButton(label: 'Frutas', selected: false),
                SizedBox(width: 8),
                FilterChipButton(label: 'Legumes', selected: false),
                SizedBox(width: 8),
                FilterChipButton(label: 'Verd', selected: false),
              ],
            ),
            const SizedBox(height: 16),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.75,
              children: [
                ProductGridCard(
                  name: 'Maca Fuji',
                  subtitle: 'aprox. 180g / un',
                  price: 'R\$ 12,90',
                  imageColor: const Color(0xFFFECACA),
                  showFavorite: true,
                  onTap: () => _goToProduct(context),
                ),
                ProductGridCard(
                  name: 'Banana Prata',
                  subtitle: 'aprox. 1kg / penca',
                  price: 'R\$ 8,99',
                  imageColor: const Color(0xFFFDE68A),
                  showFavorite: true,
                  onTap: () => _goToProduct(context),
                ),
                ProductGridCard(
                  name: 'Alface Americana',
                  subtitle: '1 unidade',
                  price: 'R\$ 4,50',
                  imageColor: const Color(0xFFD9F99D),
                  showFavorite: true,
                  onTap: () => _goToProduct(context),
                ),
                ProductGridCard(
                  name: 'Tomate Italiano',
                  subtitle: 'aprox. 150g / un',
                  price: 'R\$ 9,90',
                  imageColor: const Color(0xFFFCA5A5),
                  showFavorite: true,
                  onTap: () => _goToProduct(context),
                ),
                ProductGridCard(
                  name: 'Cenoura',
                  subtitle: 'aprox. 500g',
                  price: 'R\$ 5,49',
                  imageColor: const Color(0xFFFED7AA),
                  showFavorite: true,
                  onTap: () => _goToProduct(context),
                ),
                ProductGridCard(
                  name: 'Morango',
                  subtitle: 'Bandeja 250g',
                  price: 'R\$ 14,90',
                  imageColor: const Color(0xFFFBCFE8),
                  showFavorite: true,
                  selected: true,
                  onTap: () => _goToProduct(context),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
