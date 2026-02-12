import 'package:flutter/material.dart';

import '../app_routes.dart';
import '../theme/app_theme.dart';
import '../widgets/app_text_field.dart';
import '../widgets/outline_action_button.dart';
import '../widgets/primary_button.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  void _continue(BuildContext context) {
    Navigator.pushReplacementNamed(context, AppRoutes.address);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 160,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  gradient: const LinearGradient(
                    colors: [Color(0xFF1F4037), Color(0xFF4CAF50)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      const CircleAvatar(
                        backgroundColor: kGreen,
                        child: Icon(Icons.shopping_basket, color: Colors.white),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Mercado Facil',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              RichText(
                text: TextSpan(
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: kTextDark,
                    height: 1.2,
                  ),
                  children: const [
                    TextSpan(text: 'Sua feira em minutos.\n'),
                    TextSpan(
                      text: 'Faca seu login.',
                      style: TextStyle(color: kGreen),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Entre com seus dados para continuar.',
                style: TextStyle(color: kTextMuted),
              ),
              const SizedBox(height: 16),
              const Text(
                'E-mail ou Telefone',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              const AppTextField(
                hint: 'ex: nome@email.com',
                icon: Icons.mail_outline,
              ),
              const SizedBox(height: 16),
              PrimaryButton(
                label: 'Continuar',
                onPressed: () => _continue(context),
              ),
              const SizedBox(height: 20),
              Row(
                children: const [
                  Expanded(child: Divider(color: kBorder)),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      'ou continuar com',
                      style: TextStyle(color: kTextMuted),
                    ),
                  ),
                  Expanded(child: Divider(color: kBorder)),
                ],
              ),
              const SizedBox(height: 16),
              OutlineActionButton(
                label: 'Continuar com Google',
                icon: Icons.g_mobiledata,
                iconColor: const Color(0xFFEA4335),
                onPressed: () => _continue(context),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => _continue(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kBlack,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  icon: const Icon(Icons.apple),
                  label: const Text('Continuar com Apple'),
                ),
              ),
              const SizedBox(height: 24),
              Center(
                child: GestureDetector(
                  onTap: () => _continue(context),
                  child: RichText(
                    text: const TextSpan(
                      style: TextStyle(color: kTextMuted),
                      children: [
                        TextSpan(text: 'Ainda nao tem cadastro? '),
                        TextSpan(
                          text: 'Criar conta',
                          style: TextStyle(
                            color: kGreen,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
