import 'package:flutter/material.dart';

import '../app_routes.dart';
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: cardDecoration(radius: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Falta pouco para o Frete Gratis!',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Adicione mais R\$ 39,06 para ganhar entrega gratis.',
                    style: TextStyle(color: kTextMuted, fontSize: 12),
                  ),
                  SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: 0.7,
                    color: kGreen,
                    backgroundColor: kBorder,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const CartItemCard(
              name: 'Arroz Branco Tipo 1 (5kg)',
              brand: 'Marca: Tio Joao',
              price: 'R\$ 24,90',
              quantity: '1',
            ),
            const SizedBox(height: 12),
            const CartItemCard(
              name: 'Leite Integral (1L)',
              brand: 'Marca: Parmalat',
              price: 'R\$ 4,59',
              quantity: '4',
            ),
            const SizedBox(height: 12),
            const CartItemCard(
              name: 'Banana Prata (Kg)',
              brand: 'Aprox. 800g',
              price: 'R\$ 6,90',
              quantity: '1',
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
                      style: TextStyle(color: kGreen, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text('Subtotal', style: TextStyle(color: kTextMuted)),
                Text('R\$ 73,04'),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text('Frete', style: TextStyle(color: kTextMuted)),
                Text('R\$ 7,90'),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  'Total',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                Text(
                  'R\$ 80,94',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
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
      ),
    );
  }
}
