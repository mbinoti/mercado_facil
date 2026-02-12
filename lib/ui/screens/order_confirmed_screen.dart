import 'package:flutter/material.dart';

import '../app_routes.dart';
import '../theme/app_theme.dart';
import '../widgets/primary_button.dart';

class OrderConfirmedScreen extends StatelessWidget {
  const OrderConfirmedScreen({super.key});

  void _goHome(BuildContext context) {
    Navigator.pushReplacementNamed(context, AppRoutes.home);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const CircleAvatar(
                radius: 36,
                backgroundColor: kGreen,
                child: Icon(Icons.check, size: 36, color: Colors.white),
              ),
              const SizedBox(height: 16),
              const Text(
                'Pedido #1234 Realizado!',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 6),
              const Text(
                'Tudo certo! Estamos separando seus itens com todo cuidado.',
                textAlign: TextAlign.center,
                style: TextStyle(color: kTextMuted),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: cardDecoration(radius: 16),
                child: Row(
                  children: [
                    const Icon(Icons.timer, color: kGreen),
                    const SizedBox(width: 10),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'PREVISAO DE ENTREGA',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: kGreenDark,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            '14:45 - 15:10',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          Text('Hoje', style: TextStyle(color: kTextMuted)),
                        ],
                      ),
                    ),
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: kBorder,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.map, color: kTextMuted),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: cardDecoration(radius: 16),
                child: Row(
                  children: [
                    const Icon(Icons.shopping_bag, color: kGreen),
                    const SizedBox(width: 10),
                    const Expanded(
                      child: Text(
                        'Resumo do pedido',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                    const Text('5 itens'),
                    const SizedBox(width: 6),
                    const Text(
                      'R\$ 124,90',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const Icon(Icons.expand_more),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: cardDecoration(radius: 16),
                child: Row(
                  children: const [
                    Icon(Icons.location_on, color: kGreen),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Av. Paulista, 1000 - Bela Vista\nApt 42 - Sao Paulo, SP',
                        style: TextStyle(color: kTextMuted, height: 1.3),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const PrimaryButton(label: 'Acompanhar entrega'),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => _goHome(context),
                child: const Text('Voltar para o Inicio'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
