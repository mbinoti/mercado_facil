import 'package:flutter/material.dart';

import '../app_routes.dart';
import '../theme/app_theme.dart';
import '../widgets/dot_indicator.dart';
import '../widgets/primary_button.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 320,
                      width: double.infinity,
                      decoration: cardDecoration(radius: 28),
                      child: const Center(
                        child: Icon(
                          Icons.local_grocery_store,
                          size: 140,
                          color: kGreen,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        DotIndicator(active: true),
                        DotIndicator(active: false),
                        DotIndicator(active: false),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Bem-vindo ao',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    Text(
                      'Mercado Facil',
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(color: kGreen),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Sua feira e mercado na palma da mao\ncom entrega em minutos.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: kTextMuted),
                    ),
                  ],
                ),
              ),
              PrimaryButton(
                label: 'Proximo',
                trailing: Icons.arrow_forward,
                onPressed: () => Navigator.pushReplacementNamed(
                  context,
                  AppRoutes.login,
                ),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => Navigator.pushReplacementNamed(
                  context,
                  AppRoutes.login,
                ),
                child: const Text('Pular'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
