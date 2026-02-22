import 'package:flutter/material.dart';
import 'package:hive_ce/hive.dart';

import '../../app_routes.dart';
import '../../model/hive/fake_hive_repository.dart';
import '../../model/hive/hive_models.dart';
import '../theme/app_theme.dart';
import '../widgets/app_bottom_nav.dart';
import '../widgets/app_text_field.dart';
import '../widgets/badge_icon.dart';
import '../widgets/filter_chip_button.dart';
import '../widgets/search_product_card.dart';

class SearchResultsScreen extends StatelessWidget {
  const SearchResultsScreen({super.key});

  void _goToCart(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.cart);
  }

  Future<void> _addAndOpenCart(
    BuildContext context,
    ProdutoHive product,
  ) async {
    final added = await FakeHiveRepository.addProductToCart(product);
    if (!context.mounted) {
      return;
    }
    if (!added) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Produto indisponivel para adicionar')),
      );
      return;
    }
    _goToCart(context);
  }

  @override
  Widget build(BuildContext context) {
    const query = 'Arroz';
    final results = MercadoSeedData.buscarProdutos(query);

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: kBlack,
        foregroundColor: Colors.white,
        child: const Icon(Icons.tune),
      ),
      bottomNavigationBar: const AppBottomNav(currentIndex: 1),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Expanded(
                    child: AppTextField(
                      hint: 'Arroz',
                      icon: Icons.search,
                      suffix: Icon(Icons.close, color: kTextMuted),
                    ),
                  ),
                  const SizedBox(width: 12),
                  ValueListenableBuilder<Box<dynamic>>(
                    valueListenable: FakeHiveRepository.cartListenable(),
                    builder: (context, box, child) {
                      return BadgeIcon(
                        icon: Icons.shopping_cart,
                        badge: FakeHiveRepository.cartItemsCount().toString(),
                      );
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: const [
                  FilterChipButton(label: 'Ordenar', selected: false),
                  SizedBox(width: 8),
                  FilterChipButton(label: 'Preco', selected: true),
                  SizedBox(width: 8),
                  FilterChipButton(label: 'Marca', selected: false),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Encontrados ${results.length} produtos para "$query"',
                  style: const TextStyle(color: kTextMuted),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: results.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final product = results[index];
                  return SearchProductCard(
                    name: product.nome,
                    subtitle: product.subtitulo,
                    price: formatMoedaCents(product.precoCents),
                    oldPrice: product.precoAntigoCents == null
                        ? null
                        : formatMoedaCents(product.precoAntigoCents!),
                    tag: product.badge,
                    soldOut: product.esgotado,
                    onAdd: () => _addAndOpenCart(context, product),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
