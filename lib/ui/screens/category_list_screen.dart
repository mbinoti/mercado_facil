import 'package:flutter/material.dart';
import 'package:hive_ce/hive.dart';

import '../../app_routes.dart';
import '../../model/hive/fake_hive_repository.dart';
import '../../model/hive/hive_models.dart';
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
    final products = MercadoSeedData.produtosHortifruti;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Hortifruti'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: ValueListenableBuilder<Box<dynamic>>(
              valueListenable: FakeHiveRepository.cartListenable(),
              builder: (context, box, child) {
                return BadgeIcon(
                  icon: Icons.shopping_cart,
                  badge: FakeHiveRepository.cartItemsCount().toString(),
                );
              },
            ),
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
              children: products
                  .map(
                    (product) => ProductGridCard(
                      name: product.nome,
                      subtitle: product.subtitulo,
                      price: formatMoedaCents(product.precoCents),
                      oldPrice: product.precoAntigoCents == null
                          ? null
                          : formatMoedaCents(product.precoAntigoCents!),
                      badge: product.badge,
                      imageColor: _imageColorFromProductId(product.id),
                      showFavorite: product.favorito,
                      selected: product.id == 'prd_morango_250g',
                      onTap: () => _goToProduct(context),
                    ),
                  )
                  .toList(growable: false),
            ),
          ],
        ),
      ),
    );
  }
}

Color _imageColorFromProductId(String productId) {
  switch (productId) {
    case 'prd_maca_fuji':
      return const Color(0xFFFECACA);
    case 'prd_banana_prata':
      return const Color(0xFFFDE68A);
    case 'prd_alface_americana':
      return const Color(0xFFD9F99D);
    case 'prd_tomate_italiano':
      return const Color(0xFFFCA5A5);
    case 'prd_cenoura_500g':
      return const Color(0xFFFED7AA);
    case 'prd_morango_250g':
      return const Color(0xFFFBCFE8);
    default:
      return const Color(0xFFE5E7EB);
  }
}
