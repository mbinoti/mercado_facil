import 'package:flutter/material.dart';

import '../../app_routes.dart';
import '../theme/app_theme.dart';
import '../widgets/counter_control.dart';
import '../widgets/info_card.dart';

class ProductDetailsScreen extends StatelessWidget {
  const ProductDetailsScreen({super.key});

  void _goToCart(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.cart);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.favorite_border),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 220,
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFFFDE68A),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Center(
                child:
                    Icon(Icons.local_grocery_store, size: 60, color: kTextMuted),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Banana Prata',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 4),
            const Text('R\$ 7,99 / kg',
                style: TextStyle(color: kGreenDark, fontWeight: FontWeight.w600)),
            const SizedBox(height: 4),
            const Text(
              'Aprox. 6 unidades por kg',
              style: TextStyle(color: kTextMuted),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: cardDecoration(radius: 16),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: kGreen.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.fitness_center, color: kGreen),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Peso (kg)',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        Text(
                          'Total estimado',
                          style: TextStyle(fontSize: 12, color: kTextMuted),
                        ),
                      ],
                    ),
                  ),
                  const CounterControl(value: '1'),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: cardDecoration(radius: 16),
              child: Row(
                children: [
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Permitir substituicao',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        Text(
                          'Aceitar item similar se estiver em falta.',
                          style: TextStyle(fontSize: 12, color: kTextMuted),
                        ),
                      ],
                    ),
                  ),
                  Switch(
                    value: true,
                    onChanged: (_) {},
                    activeColor: kGreen,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Descricao',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 6),
            const Text(
              'Bananas prata frescas, selecionadas e de origem controlada.',
              style: TextStyle(color: kTextMuted),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _goToCart(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: kGreen,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('ADICIONAR', style: TextStyle(fontWeight: FontWeight.w700)),
                    Text('R\$ 7,99', style: TextStyle(fontWeight: FontWeight.w700)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Informacao Nutricional',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 2.6,
              children: const [
                InfoCard(title: 'Calorias', value: '89 kcal'),
                InfoCard(title: 'Carboidratos', value: '23g'),
                InfoCard(title: 'Potassio', value: '358mg'),
                InfoCard(title: 'Fibras', value: '2.6g'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
