import 'package:app_mercadofacil/ui/platform/platform_ui.dart';
import 'package:app_mercadofacil/ui/screens/cart_screen.dart';
import 'package:app_mercadofacil/ui/screens/home_screen.dart';
import 'package:app_mercadofacil/ui/screens/orders_screen.dart';
import 'package:app_mercadofacil/viewmodel/app_shell_viewmodel.dart';
import 'package:app_mercadofacil/viewmodel/cart_viewmodel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Shell principal que organiza as telas raiz do app em abas persistentes.
class AppShellScreen extends StatelessWidget {
  const AppShellScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Selector<AppShellViewModel, int>(
      selector: (_, shell) => shell.currentIndex,
      builder: (context, currentIndex, child) {
        return ColoredBox(
          color: Theme.of(context).scaffoldBackgroundColor,
          child: Column(
            children: [
              Expanded(
                child: IndexedStack(
                  index: currentIndex,
                  children: [
                    for (
                      var index = 0;
                      index < _shellTabScreens.length;
                      index++
                    )
                      HeroMode(
                        enabled: currentIndex == index,
                        child: _shellTabScreens[index],
                      ),
                  ],
                ),
              ),
              _ShellBottomNavigation(currentIndex: currentIndex),
            ],
          ),
        );
      },
    );
  }
}

class _ShellBottomNavigation extends StatelessWidget {
  const _ShellBottomNavigation({required this.currentIndex});

  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        boxShadow: [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 24,
            offset: Offset(0, -6),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 10, 8, 8),
          child: Row(
            children: [
              for (final destination in AppShellTab.values)
                Expanded(
                  child: _ShellNavigationItem(
                    destination: destination,
                    selected: currentIndex == destination.index,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ShellNavigationItem extends StatelessWidget {
  const _ShellNavigationItem({
    required this.destination,
    required this.selected,
  });

  final AppShellTab destination;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final isCupertino = isCupertinoContext(context);
    final color = selected ? const Color(0xFF2F8B37) : const Color(0xFF4B4852);
    final child = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOutCubic,
            width: selected ? 40 : 0,
            height: 3,
            decoration: BoxDecoration(
              color: const Color(0xFF2F8B37),
              borderRadius: BorderRadius.circular(999),
            ),
          ),
          const SizedBox(height: 10),
          _NavigationIcon(
            destination: destination,
            color: color,
            selected: selected,
          ),
          const SizedBox(height: 8),
          Text(
            destination.label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontSize: 13,
              fontWeight: selected ? FontWeight.w900 : FontWeight.w800,
              color: color,
            ),
          ),
        ],
      ),
    );

    if (isCupertino) {
      return CupertinoButton(
        padding: EdgeInsets.zero,
        minimumSize: const Size(0, 72),
        onPressed: () => context.read<AppShellViewModel>().goTo(destination),
        child: child,
      );
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => context.read<AppShellViewModel>().goTo(destination),
        child: child,
      ),
    );
  }
}

class _NavigationIcon extends StatelessWidget {
  const _NavigationIcon({
    required this.destination,
    required this.color,
    required this.selected,
  });

  final AppShellTab destination;
  final Color color;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final icon = Icon(
      platformIcon(
        context,
        material: destination.materialIcon(selected: selected),
        cupertino: destination.cupertinoIcon(selected: selected),
      ),
      color: color,
      size: 28,
    );

    if (destination != AppShellTab.cart) {
      return icon;
    }

    return Selector<CartViewModel, int>(
      selector: (_, cart) => cart.totalItems,
      builder: (context, totalItems, child) {
        return Stack(
          clipBehavior: Clip.none,
          children: [
            child!,
            if (totalItems > 0)
              Positioned(
                top: -6,
                right: -10,
                child: DecoratedBox(
                  decoration: const BoxDecoration(
                    color: Color(0xFF2F8B37),
                    shape: BoxShape.circle,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 3,
                    ),
                    child: Text(
                      totalItems > 99 ? '99+' : '$totalItems',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        );
      },
      child: icon,
    );
  }
}

class _ShellPlaceholderScreen extends StatelessWidget {
  const _ShellPlaceholderScreen({required this.config});

  final _ShellPlaceholderConfig config;

  @override
  Widget build(BuildContext context) {
    final isCupertino = isCupertinoContext(context);
    final body = _ShellPlaceholderBody(config: config);

    if (isCupertino) {
      return CupertinoPageScaffold(
        backgroundColor: config.backgroundColor,
        navigationBar: CupertinoNavigationBar(
          backgroundColor: config.backgroundColor.withValues(alpha: 0.94),
          border: null,
          middle: Text(config.title),
        ),
        child: SafeArea(top: false, child: body),
      );
    }

    return Scaffold(
      backgroundColor: config.backgroundColor,
      appBar: AppBar(
        backgroundColor: config.backgroundColor,
        title: Text(config.title),
      ),
      body: body,
    );
  }
}

class _ShellPlaceholderBody extends StatelessWidget {
  const _ShellPlaceholderBody({required this.config});

  final _ShellPlaceholderConfig config;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final isCupertino = isCupertinoContext(context);
    final icon = platformIcon(
      context,
      material: config.materialIcon,
      cupertino: config.cupertinoIcon,
    );
    final actionLabel = config.actionLabel;
    final action = isCupertino
        ? CupertinoButton.filled(
            borderRadius: BorderRadius.circular(18),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            onPressed: () => context.read<AppShellViewModel>().goTo(
              config.actionDestination,
            ),
            child: Text(
              actionLabel,
              style: textTheme.bodyMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w900,
              ),
            ),
          )
        : FilledButton(
            onPressed: () => context.read<AppShellViewModel>().goTo(
              config.actionDestination,
            ),
            style: FilledButton.styleFrom(
              backgroundColor: config.accentColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              textStyle: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w900,
              ),
            ),
            child: Text(actionLabel),
          );

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 440),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.86),
              borderRadius: BorderRadius.circular(30),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x12000000),
                  blurRadius: 22,
                  offset: Offset(0, 10),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(28),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DecoratedBox(
                    decoration: BoxDecoration(
                      color: config.accentColor.withValues(alpha: 0.14),
                      shape: BoxShape.circle,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Icon(icon, size: 40, color: config.accentColor),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    config.headline,
                    textAlign: TextAlign.center,
                    style: textTheme.headlineMedium?.copyWith(
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      color: const Color(0xFF111A30),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    config.description,
                    textAlign: TextAlign.center,
                    style: textTheme.bodyMedium?.copyWith(
                      height: 1.5,
                      color: const Color(0xFF66707F),
                    ),
                  ),
                  const SizedBox(height: 20),
                  action,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ShellPlaceholderConfig {
  const _ShellPlaceholderConfig({
    required this.title,
    required this.headline,
    required this.description,
    required this.actionLabel,
    required this.actionDestination,
    required this.backgroundColor,
    required this.accentColor,
    required this.materialIcon,
    required this.cupertinoIcon,
  });

  final String title;
  final String headline;
  final String description;
  final String actionLabel;
  final AppShellTab actionDestination;
  final Color backgroundColor;
  final Color accentColor;
  final IconData materialIcon;
  final IconData cupertinoIcon;
}

const _categoriesTabConfig = _ShellPlaceholderConfig(
  title: 'Categorias',
  headline: 'Categorias entram aqui.',
  description:
      'Use esta aba para navegar por secoes como frutas, limpeza e mercearia sem misturar esse fluxo com a vitrine principal.',
  actionLabel: 'Ir para inicio',
  actionDestination: AppShellTab.home,
  backgroundColor: Color(0xFFF6F1EB),
  accentColor: Color(0xFF8F5D3B),
  materialIcon: Icons.grid_view_rounded,
  cupertinoIcon: CupertinoIcons.square_grid_2x2,
);

const _profileTabConfig = _ShellPlaceholderConfig(
  title: 'Perfil',
  headline: 'Perfil pronto para evoluir.',
  description:
      'A aba pode concentrar endereco, pagamentos e preferencias do cliente sem poluir a home de produtos.',
  actionLabel: 'Voltar para inicio',
  actionDestination: AppShellTab.home,
  backgroundColor: Color(0xFFEEF4F7),
  accentColor: Color(0xFF3A6D84),
  materialIcon: Icons.person_outline_rounded,
  cupertinoIcon: CupertinoIcons.person,
);

const List<Widget> _shellTabScreens = [
  HomeScreen(),
  _ShellPlaceholderScreen(config: _categoriesTabConfig),
  CartScreen(),
  OrdersScreen(),
  _ShellPlaceholderScreen(config: _profileTabConfig),
];

extension on AppShellTab {
  String get label {
    return switch (this) {
      AppShellTab.home => 'Inicio',
      AppShellTab.categories => 'Categorias',
      AppShellTab.cart => 'Carrinho',
      AppShellTab.orders => 'Pedidos',
      AppShellTab.profile => 'Perfil',
    };
  }

  IconData materialIcon({required bool selected}) {
    return switch (this) {
      AppShellTab.home => selected ? Icons.home_rounded : Icons.home_outlined,
      AppShellTab.categories =>
        selected ? Icons.grid_view_rounded : Icons.grid_view_outlined,
      AppShellTab.cart =>
        selected ? Icons.shopping_cart_rounded : Icons.shopping_cart_outlined,
      AppShellTab.orders =>
        selected ? Icons.inbox_rounded : Icons.inventory_2_outlined,
      AppShellTab.profile =>
        selected ? Icons.person_rounded : Icons.person_outline_rounded,
    };
  }

  IconData cupertinoIcon({required bool selected}) {
    return switch (this) {
      AppShellTab.home =>
        selected ? CupertinoIcons.house_fill : CupertinoIcons.house,
      AppShellTab.categories =>
        selected
            ? CupertinoIcons.square_grid_2x2_fill
            : CupertinoIcons.square_grid_2x2,
      AppShellTab.cart =>
        selected ? CupertinoIcons.cart_fill : CupertinoIcons.cart,
      AppShellTab.orders =>
        selected ? CupertinoIcons.cube_box_fill : CupertinoIcons.cube_box,
      AppShellTab.profile =>
        selected ? CupertinoIcons.person_fill : CupertinoIcons.person,
    };
  }
}
