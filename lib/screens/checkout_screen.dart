import 'package:flutter/material.dart';

import '../app_routes.dart';
import '../theme/app_theme.dart';
import '../widgets/payment_option.dart';
import '../widgets/primary_button.dart';
import '../widgets/summary_row.dart';

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});

  void _finishOrder(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.confirmed);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pagamento e Checkout')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'ENTREGA',
              style: TextStyle(fontWeight: FontWeight.w700, color: kTextMuted),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: cardDecoration(radius: 16),
              child: Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: kBorder,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.map, color: kTextMuted),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Casa', style: TextStyle(fontWeight: FontWeight.w600)),
                        Text(
                          'Rua das Flores, 123 - Apt 402',
                          style: TextStyle(color: kTextMuted, fontSize: 12),
                        ),
                        SizedBox(height: 4),
                        Text(
                          '25-50 min',
                          style: TextStyle(color: kGreenDark, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      'Alterar',
                      style: TextStyle(color: kGreen, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'PAGAMENTO',
              style: TextStyle(fontWeight: FontWeight.w700, color: kTextMuted),
            ),
            const SizedBox(height: 10),
            const Row(
              children: [
                PaymentOption(
                  label: 'Pix',
                  icon: Icons.qr_code,
                  selected: true,
                ),
                SizedBox(width: 8),
                PaymentOption(
                  label: 'Cartao',
                  icon: Icons.credit_card,
                  selected: false,
                ),
                SizedBox(width: 8),
                PaymentOption(
                  label: 'Carteira',
                  icon: Icons.account_balance_wallet,
                  selected: false,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: cardDecoration(radius: 16),
              child: Row(
                children: const [
                  CircleAvatar(
                    backgroundColor: kGreen,
                    radius: 18,
                    child: Icon(Icons.verified_user, color: Colors.white, size: 18),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Pagar com Pix. O codigo sera gerado na proxima tela. '
                      'A confirmacao e instantanea e voce ganha 5% de desconto.',
                      style: TextStyle(color: kTextMuted, fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'RESUMO',
              style: TextStyle(fontWeight: FontWeight.w700, color: kTextMuted),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: cardDecoration(radius: 16),
              child: Column(
                children: const [
                  SummaryRow(label: 'Subtotal (12 itens)', value: 'R\$ 84,63'),
                  SizedBox(height: 6),
                  SummaryRow(label: 'Frete', value: 'R\$ 5,00'),
                  SizedBox(height: 6),
                  SummaryRow(
                    label: 'Desconto Pix (5%)',
                    value: '- R\$ 4,23',
                    valueColor: kGreenDark,
                  ),
                  Divider(height: 24),
                  SummaryRow(
                    label: 'Total',
                    value: 'R\$ 85,40',
                    bold: true,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            PrimaryButton(
              label: 'Finalizar Pedido',
              trailing: Icons.arrow_forward,
              onPressed: () => _finishOrder(context),
            ),
          ],
        ),
      ),
    );
  }
}
