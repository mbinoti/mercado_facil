import 'package:flutter/material.dart';

import '../../app_routes.dart';
import '../../model/hive/fake_hive_repository.dart';
import '../../model/hive/hive_models.dart';
import '../theme/app_theme.dart';
import '../widgets/counter_control.dart';
import '../widgets/info_card.dart';

class ProductDetailsScreen extends StatelessWidget {
  const ProductDetailsScreen({super.key});

  void _goToCart(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.cart);
  }

  Future<void> _addToCartAndGo(
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
    final product = MercadoSeedData.produtoPrincipal;
    final nutricional = product.infoNutricional;
    final nutritionCards = <({String title, String value})>[
      if (nutricional?.caloriasKcal != null)
        (
          title: 'Calorias',
          value: '${nutricional!.caloriasKcal!.toInt()} kcal',
        ),
      if (nutricional?.carboidratosG != null)
        (title: 'Carboidratos', value: '${nutricional!.carboidratosG!}g'),
      if (nutricional?.potassioMg != null)
        (title: 'Potassio', value: '${nutricional!.potassioMg!.toInt()}mg'),
      if (nutricional?.fibrasG != null)
        (title: 'Fibras', value: '${nutricional!.fibrasG!}g'),
    ];

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              product.favorito ? Icons.favorite : Icons.favorite_border,
            ),
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
                child: Icon(
                  Icons.local_grocery_store,
                  size: 60,
                  color: kTextMuted,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              product.nome,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 4),
            Text(
              formatPrecoProduto(product.precoCents, product.unidade),
              style: const TextStyle(
                color: kGreenDark,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(product.subtitulo, style: const TextStyle(color: kTextMuted)),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: cardDecoration(radius: 16),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: kGreen.withValues(alpha: 0.12),
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
                    value: product.aceitaSubstituicaoPadrao,
                    onChanged: (_) {},
                    activeThumbColor: kGreen,
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
            Text(
              product.descricao ?? 'Sem descricao.',
              style: const TextStyle(color: kTextMuted),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _addToCartAndGo(context, product),
                style: ElevatedButton.styleFrom(
                  backgroundColor: kGreen,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 20,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'ADICIONAR',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                    Text(
                      formatMoedaCents(product.precoCents),
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ),
            ),
            if (nutritionCards.isNotEmpty) ...[
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
                children: [
                  for (final card in nutritionCards)
                    InfoCard(title: card.title, value: card.value),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
