import 'package:flutter/material.dart';
import 'package:hive_ce/hive.dart';

import '../../app_routes.dart';
import '../../model/hive/fake_hive_repository.dart';
import '../../model/hive/hive_models.dart';
import '../theme/app_theme.dart';
import '../widgets/cart_item_card.dart';
import '../widgets/primary_button.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  void _goToCheckout(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.checkout);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Meu Carrinho')),
      body: ValueListenableBuilder<Box<dynamic>>(
        valueListenable: FakeHiveRepository.cartListenable(),
        builder: (context, box, child) {
          final cart = FakeHiveRepository.getCart();
          final faltaFreteGratis =
              cart.limiteFreteGratisCents - cart.subtotalCents;
          final progress = (cart.subtotalCents / cart.limiteFreteGratisCents)
              .clamp(0.0, 1.0)
              .toDouble();

          if (cart.itens.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(
                      Icons.shopping_cart_outlined,
                      size: 46,
                      color: kTextMuted,
                    ),
                    SizedBox(height: 12),
                    Text(
                      'Seu carrinho esta vazio.',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Adicione produtos para continuar.',
                      style: TextStyle(color: kTextMuted),
                    ),
                  ],
                ),
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: cardDecoration(radius: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Falta pouco para o Frete Gratis!',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        faltaFreteGratis > 0
                            ? 'Adicione mais ${formatMoedaCents(faltaFreteGratis)} para ganhar entrega gratis.'
                            : 'Parabens! Voce desbloqueou frete gratis.',
                        style: const TextStyle(color: kTextMuted, fontSize: 12),
                      ),
                      const SizedBox(height: 8),
                      LinearProgressIndicator(
                        value: progress,
                        color: kGreen,
                        backgroundColor: kBorder,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                ...cart.itens.asMap().entries.map((entry) {
                  final index = entry.key;
                  final item = entry.value;
                  return Padding(
                    padding: EdgeInsets.only(
                      bottom: index == cart.itens.length - 1 ? 0 : 12,
                    ),
                    child: CartItemCard(
                      name: item.nomeSnapshot,
                      brand: item.subtituloSnapshot,
                      price: formatMoedaCents(item.precoUnitarioCents),
                      quantity: formatQuantidade(item.quantidade),
                    ),
                  );
                }),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: kBorder),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.local_offer, color: kTextMuted),
                      const SizedBox(width: 8),
                      const Expanded(
                        child: Text(
                          'Cupom de desconto',
                          style: TextStyle(color: kTextMuted),
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: const Text(
                          'Aplicar',
                          style: TextStyle(
                            color: kGreen,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Subtotal', style: TextStyle(color: kTextMuted)),
                    Text(formatMoedaCents(cart.subtotalCents)),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Frete', style: TextStyle(color: kTextMuted)),
                    Text(formatMoedaCents(cart.taxaEntregaCents)),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                    Text(
                      formatMoedaCents(cart.totalCents),
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                PrimaryButton(
                  label: 'Continuar para pagamento',
                  trailing: Icons.arrow_forward,
                  onPressed: () => _goToCheckout(context),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
