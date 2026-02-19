import 'package:flutter/material.dart';

import '../../app_routes.dart';
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

  @override
  Widget build(BuildContext context) {
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
                  const BadgeIcon(icon: Icons.shopping_cart, badge: '2'),
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
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Encontrados 42 produtos para "Arroz"',
                  style: TextStyle(color: kTextMuted),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  SearchProductCard(
                    name: 'Arroz Tio Joao Branco',
                    subtitle: 'Pacote 5kg',
                    price: 'R\$ 24,90',
                    oldPrice: 'R\$ 29,90',
                    tag: 'MAIS VENDIDO',
                    onAdd: () => _goToCart(context),
                  ),
                  const SizedBox(height: 12),
                  SearchProductCard(
                    name: 'Arroz Camil Parboilizado',
                    subtitle: 'Pacote 1kg',
                    price: 'R\$ 6,50',
                    onAdd: () => _goToCart(context),
                  ),
                  const SizedBox(height: 12),
                  SearchProductCard(
                    name: 'Arroz Integral Prato Fino',
                    subtitle: 'Pacote 1kg',
                    price: 'R\$ 5,90',
                    oldPrice: 'R\$ 7,20',
                    tag: '15% OFF',
                    onAdd: () => _goToCart(context),
                  ),
                  const SizedBox(height: 12),
                  const SearchProductCard(
                    name: 'Arroz Arboreo Paganini',
                    subtitle: 'Caixa 1kg',
                    price: 'R\$ 22,90',
                    soldOut: true,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
