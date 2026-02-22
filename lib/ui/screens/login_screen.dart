import 'package:flutter/material.dart';

import '../../app_routes.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  static const Color _background = Color(0xFFECEEEB);
  static const Color _primaryGreen = Color(0xFF1BE65C);
  static const Color _textDark = Color(0xFF141816);
  static const Color _mutedGreen = Color(0xFF678C7A);
  static const Color _hintColor = Color(0xFFA7AFAB);
  static const Color _border = Color(0xFFD6DBD8);

  void _continue(BuildContext context) {
    Navigator.pushReplacementNamed(context, AppRoutes.address);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _background,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 18),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight - 32,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: SizedBox(
                          height: 168,
                          width: double.infinity,
                          child: Image.asset(
                            'assets/images/login_banner.jpg',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(height: 28),
                      const Text(
                        'Sua feira em minutos.',
                        style: TextStyle(
                          fontSize: 46,
                          height: 1.05,
                          letterSpacing: -0.6,
                          fontWeight: FontWeight.w800,
                          color: _textDark,
                        ),
                      ),
                      const Text(
                        'Faca seu login.',
                        style: TextStyle(
                          fontSize: 46,
                          height: 1.05,
                          letterSpacing: -0.6,
                          fontWeight: FontWeight.w800,
                          color: _primaryGreen,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Entre com seus dados para continuar.',
                        style: TextStyle(
                          color: _mutedGreen,
                          fontWeight: FontWeight.w600,
                          fontSize: 17,
                        ),
                      ),
                      const SizedBox(height: 28),
                      const Text(
                        'E-mail ou Telefone',
                        style: TextStyle(
                          color: _textDark,
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          hintText: 'ex: nome@email.com',
                          hintStyle: const TextStyle(
                            color: _hintColor,
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                          ),
                          prefixIcon: const Icon(
                            Icons.mail,
                            color: _mutedGreen,
                            size: 20,
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 15,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: const BorderSide(color: _border),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: const BorderSide(color: _border),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: const BorderSide(color: _primaryGreen),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => _continue(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _primaryGreen,
                            foregroundColor: _textDark,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: const Text(
                            'Continuar',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 26),
                      const _SocialDivider(),
                      const SizedBox(height: 18),
                      _SocialButton(
                        label: 'Continuar com Google',
                        background: Colors.white,
                        borderColor: _border,
                        foreground: _textDark,
                        icon: const _GoogleMark(),
                        onPressed: () => _continue(context),
                      ),
                      const SizedBox(height: 12),
                      _SocialButton(
                        label: 'Continuar com Apple',
                        background: Colors.black,
                        borderColor: Colors.black,
                        foreground: Colors.white,
                        icon: const Icon(
                          Icons.apple,
                          color: Colors.white,
                          size: 18,
                        ),
                        onPressed: () => _continue(context),
                      ),
                      const Spacer(),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: GestureDetector(
                            onTap: () => _continue(context),
                            child: RichText(
                              text: TextSpan(
                                style: TextStyle(
                                  color: _mutedGreen,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 17,
                                ),
                                children: [
                                  TextSpan(text: 'Ainda nao tem cadastro? '),
                                  TextSpan(
                                    text: 'Criar conta',
                                    style: TextStyle(
                                      color: _primaryGreen,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _SocialDivider extends StatelessWidget {
  const _SocialDivider();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        Expanded(child: Divider(color: LoginScreen._border, thickness: 1.2)),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            'ou continuar com',
            style: TextStyle(
              color: LoginScreen._mutedGreen,
              fontWeight: FontWeight.w700,
              fontSize: 14,
            ),
          ),
        ),
        Expanded(child: Divider(color: LoginScreen._border, thickness: 1.2)),
      ],
    );
  }
}

class _SocialButton extends StatelessWidget {
  final String label;
  final Color background;
  final Color borderColor;
  final Color foreground;
  final Widget icon;
  final VoidCallback onPressed;

  const _SocialButton({
    required this.label,
    required this.background,
    required this.borderColor,
    required this.foreground,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      width: double.infinity,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: background,
          side: BorderSide(color: borderColor),
          foregroundColor: foreground,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            icon,
            const SizedBox(width: 10),
            Text(
              label,
              style: TextStyle(
                color: foreground,
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GoogleMark extends StatelessWidget {
  const _GoogleMark();

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (Rect bounds) {
        return const LinearGradient(
          colors: [
            Color(0xFF4285F4),
            Color(0xFF34A853),
            Color(0xFFFBBC05),
            Color(0xFFEA4335),
          ],
          stops: [0.0, 0.35, 0.65, 1.0],
        ).createShader(bounds);
      },
      child: const Text(
        'G',
        style: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}
