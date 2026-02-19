import 'package:flutter/material.dart';

import '../../app_routes.dart';
import '../theme/app_theme.dart';

class ScreenEntry {
  final String title;
  final String route;

  const ScreenEntry(this.title, this.route);
}

class ScreensIndexPage extends StatelessWidget {
  const ScreensIndexPage({super.key});

  static final List<ScreenEntry> _screens = [
    ScreenEntry('01 - Onboarding', AppRoutes.onboarding),
    ScreenEntry('02 - Login e Cadastro', AppRoutes.login),
    ScreenEntry('03 - Selecao de Endereco', AppRoutes.address),
    ScreenEntry('04 - Pagina Inicial', AppRoutes.home),
    ScreenEntry('05 - Resultado da Busca', AppRoutes.search),
    ScreenEntry('06 - Listagem de Categorias', AppRoutes.categories),
    ScreenEntry('07 - Detalhes do Produto', AppRoutes.product),
    ScreenEntry('08 - Meu Carrinho', AppRoutes.cart),
    ScreenEntry('09 - Pagamento e Checkout', AppRoutes.checkout),
    ScreenEntry('10 - Pedido Confirmado', AppRoutes.confirmed),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Telas Mercado Facil')),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: _screens.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final entry = _screens[index];
          return Container(
            decoration: cardDecoration(),
            child: ListTile(
              title: Text(
                entry.title,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Navigator.pushNamed(context, entry.route),
            ),
          );
        },
      ),
    );
  }
}
