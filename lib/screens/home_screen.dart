import 'package:flutter/material.dart';

import '../app_routes.dart';
import '../theme/app_theme.dart';
import '../widgets/app_bottom_nav.dart';
import '../widgets/app_text_field.dart';
import '../widgets/category_icon.dart';
import '../widgets/offer_card.dart';
import '../widgets/product_grid_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _goToSearch(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.search);
  }

  void _goToCategories(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.categories);
  }

  void _goToProduct(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.product);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const AppBottomNav(currentIndex: 0),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.location_on, color: kGreen),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('Entregar em:', style: TextStyle(color: kTextMuted)),
                        Text(
                          'Rua Amazonas, 123',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.notifications_none),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              AppTextField(
                hint: 'Busque produtos ou marcas',
                icon: Icons.search,
                onTap: () => _goToSearch(context),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    'Ofertas da Semana',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  Text(
                    'Ver tudo',
                    style: TextStyle(color: kGreen, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 140,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    OfferCard(
                      title: 'Feira Fresca\nToda Quarta',
                      subtitle: 'Descontos de ate 40%',
                      tag: 'PROMOCAO',
                      colors: const [Color(0xFF14532D), Color(0xFF16A34A)],
                      onTap: () => _goToCategories(context),
                    ),
                    const SizedBox(width: 12),
                    OfferCard(
                      title: 'Churrasco\nde Domingo',
                      subtitle: 'Carnes selecionadas',
                      tag: 'CLUBE',
                      colors: const [Color(0xFF7C2D12), Color(0xFFEA580C)],
                      onTap: () => _goToCategories(context),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CategoryIcon(
                    label: 'Hortifruti',
                    icon: Icons.eco,
                    onTap: () => _goToCategories(context),
                  ),
                  CategoryIcon(
                    label: 'Carnes',
                    icon: Icons.set_meal,
                    onTap: () => _goToCategories(context),
                  ),
                  CategoryIcon(
                    label: 'Padaria',
                    icon: Icons.cake,
                    onTap: () => _goToCategories(context),
                  ),
                  CategoryIcon(
                    label: 'Bebidas',
                    icon: Icons.local_drink,
                    onTap: () => _goToCategories(context),
                  ),
                  CategoryIcon(
                    label: 'Laticinios',
                    icon: Icons.icecream,
                    onTap: () => _goToCategories(context),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Text(
                    'Ofertas do dia',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const Spacer(),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: kDanger.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'EXPIRA EM 12H',
                      style: TextStyle(
                        fontSize: 10,
                        color: kDanger,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.78,
                children: [
                  ProductGridCard(
                    name: 'Banana Prata',
                    subtitle: 'aprox. 1kg',
                    price: 'R\$ 4,99',
                    oldPrice: 'R\$ 6,20',
                    badge: '-20%',
                    imageColor: const Color(0xFFFDE68A),
                    onTap: () => _goToProduct(context),
                  ),
                  ProductGridCard(
                    name: 'Arroz Branco Tipo 1',
                    subtitle: 'Pacote 5kg',
                    price: 'R\$ 22,90',
                    oldPrice: 'R\$ 26,90',
                    badge: '-15%',
                    imageColor: const Color(0xFFE5E7EB),
                    onTap: () => _goToProduct(context),
                  ),
                  ProductGridCard(
                    name: 'Leite Integral',
                    subtitle: '1 Litro',
                    price: 'R\$ 4,50',
                    imageColor: const Color(0xFFE2E8F0),
                    onTap: () => _goToProduct(context),
                  ),
                  ProductGridCard(
                    name: 'Refrigerante Cola',
                    subtitle: '2 Litros',
                    price: 'R\$ 9,90',
                    imageColor: const Color(0xFFFECACA),
                    onTap: () => _goToProduct(context),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
