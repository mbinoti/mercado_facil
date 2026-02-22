import 'package:flutter/material.dart';

import '../../app_routes.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  static const _background = Color(0xFFE5EAE6);

  void _goToLogin(BuildContext context) {
    Navigator.pushReplacementNamed(context, AppRoutes.login);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _background,
      body: SafeArea(
        child: _OnboardingBody(
          onPrimaryTap: () => _goToLogin(context),
          onSkipTap: () => _goToLogin(context),
        ),
      ),
    );
  }
}

class _OnboardingBody extends StatelessWidget {
  final VoidCallback onPrimaryTap;
  final VoidCallback onSkipTap;

  const _OnboardingBody({required this.onPrimaryTap, required this.onSkipTap});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final imageHeight = (constraints.maxHeight * 0.48).clamp(300.0, 430.0);

        return Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 430),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 10),
              child: Column(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: imageHeight,
                          child: Center(
                            child: AspectRatio(
                              aspectRatio: 620 / 760,
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF2F4F2),
                                  borderRadius: BorderRadius.circular(38),
                                  border: Border.all(
                                    color: const Color(0xFFD9DED9),
                                    width: 1.2,
                                  ),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(38),
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                      12,
                                      12,
                                      12,
                                      10,
                                    ),
                                    child: Image.asset(
                                      'assets/images/onboarding_hero.jpg',
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 26),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _OnboardingDot(active: true),
                            _OnboardingDot(active: false),
                            _OnboardingDot(active: false),
                          ],
                        ),
                        const SizedBox(height: 30),
                        const Text(
                          'Bem-vindo ao',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 44,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.9,
                            height: 1.1,
                            color: Color(0xFF111614),
                          ),
                        ),
                        const Text(
                          'Mercado Fácil',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 44,
                            color: Color(0xFF18E55E),
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.9,
                            height: 1.1,
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Sua feira e mercado na palma da mão\ncom entrega em minutos.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFF747B79),
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            height: 1.45,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _PrimaryButton(onPressed: onPrimaryTap),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: onSkipTap,
                    style: TextButton.styleFrom(
                      foregroundColor: const Color(0xFF888E8B),
                      textStyle: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.4,
                      ),
                    ),
                    child: const Text('Pular'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _PrimaryButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: const Color(0xFF18E55E),
          foregroundColor: const Color(0xFF111614),
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(32),
          ),
        ),
        child: const Stack(
          alignment: Alignment.center,
          children: [
            Text(
              'Próximo',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.4,
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Icon(Icons.arrow_forward, size: 29),
            ),
          ],
        ),
      ),
    );
  }
}

class _OnboardingDot extends StatelessWidget {
  final bool active;

  const _OnboardingDot({required this.active});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: active ? 42 : 12,
      height: 12,
      margin: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        color: active ? const Color(0xFF18E55E) : const Color(0xFFCFECD6),
        borderRadius: BorderRadius.circular(14),
      ),
    );
  }
}
