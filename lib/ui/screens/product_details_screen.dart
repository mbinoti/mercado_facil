import 'package:app_mercadofacil/model/home_product.dart';
import 'package:app_mercadofacil/ui/platform/platform_ui.dart';
import 'package:app_mercadofacil/ui/widgets/product_visual.dart';
import 'package:app_mercadofacil/ui/widgets/quantity_stepper.dart';
import 'package:app_mercadofacil/viewmodel/cart_viewmodel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Tela de detalhes do produto com descricao, destaques e acoes de carrinho.
class ProductDetailsScreen extends StatelessWidget {
  const ProductDetailsScreen({super.key, required this.product});

  final HomeProduct product;

  @override
  Widget build(BuildContext context) {
    final backgroundColor = _backgroundColorFor(product);
    final accentColor = product.imageColors.last;
    final isCupertino = isCupertinoContext(context);
    final content = LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 900;

        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 120),
          child: isWide
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _DetailsHero(
                        product: product,
                        accentColor: accentColor,
                      ),
                    ),
                    const SizedBox(width: 24),
                    Expanded(
                      child: _DetailsContent(
                        product: product,
                        accentColor: accentColor,
                      ),
                    ),
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _DetailsHero(product: product, accentColor: accentColor),
                    const SizedBox(height: 20),
                    _DetailsContent(product: product, accentColor: accentColor),
                  ],
                ),
        );
      },
    );
    final bottomBar = SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(28),
            boxShadow: const [
              BoxShadow(
                color: Color(0x16000000),
                blurRadius: 28,
                offset: Offset(0, 14),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Selector<CartViewModel, int>(
                  selector: (_, cart) => cart.quantityFor(product),
                  builder: (context, quantity, child) {
                    final button = isCupertino
                        ? CupertinoButton.filled(
                            borderRadius: BorderRadius.circular(18),
                            padding: const EdgeInsets.symmetric(vertical: 18),
                            onPressed: () => _addToCart(context),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  CupertinoIcons.bag_fill,
                                  size: 18,
                                  color: Colors.white,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  quantity == 0
                                      ? 'Adicionar ao carrinho'
                                      : 'Adicionar mais',
                                  style: Theme.of(context).textTheme.titleMedium
                                      ?.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w900,
                                      ),
                                ),
                              ],
                            ),
                          )
                        : FilledButton.icon(
                            style: FilledButton.styleFrom(
                              backgroundColor: accentColor,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 18),
                              textStyle: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(fontWeight: FontWeight.w900),
                            ),
                            onPressed: () => _addToCart(context),
                            icon: const Icon(Icons.shopping_bag_outlined),
                            label: Text(
                              quantity == 0
                                  ? 'Adicionar ao carrinho'
                                  : 'Adicionar mais',
                            ),
                          );

                    if (constraints.maxWidth < 360) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          QuantityStepper(
                            quantity: quantity,
                            onIncrement: () => _addToCart(context),
                            onDecrement: () {
                              context.read<CartViewModel>().removeSingleProduct(
                                product,
                              );
                            },
                          ),
                          const SizedBox(height: 12),
                          SizedBox(width: double.infinity, child: button),
                        ],
                      );
                    }

                    return Row(
                      children: [
                        QuantityStepper(
                          quantity: quantity,
                          onIncrement: () => _addToCart(context),
                          onDecrement: () {
                            context.read<CartViewModel>().removeSingleProduct(
                              product,
                            );
                          },
                        ),
                        const SizedBox(width: 12),
                        Expanded(child: button),
                      ],
                    );
                  },
                );
              },
            ),
          ),
        ),
      ),
    );

    if (isCupertino) {
      return CupertinoPageScaffold(
        backgroundColor: backgroundColor,
        navigationBar: CupertinoNavigationBar(
          backgroundColor: backgroundColor.withValues(alpha: 0.92),
          middle: const Text('Detalhes'),
          border: null,
        ),
        child: SafeArea(
          top: false,
          child: Column(
            children: [
              Expanded(child: content),
              bottomBar,
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        title: const Text('Detalhes'),
      ),
      body: content,
      bottomNavigationBar: bottomBar,
    );
  }

  void _addToCart(BuildContext context) {
    context.read<CartViewModel>().addProduct(product);
    showPlatformFeedback(context, '${product.name} adicionado ao carrinho.');
  }
}

/// Bloco visual principal da tela de detalhes.
class _DetailsHero extends StatelessWidget {
  const _DetailsHero({required this.product, required this.accentColor});

  final HomeProduct product;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    final deliveryIcon = platformIcon(
      context,
      material: Icons.local_shipping_outlined,
      cupertino: CupertinoIcons.clock,
    );
    final detailsIcon = platformIcon(
      context,
      material: Icons.inventory_2_outlined,
      cupertino: CupertinoIcons.cube_box,
    );
    final verifiedIcon = platformIcon(
      context,
      material: Icons.verified_outlined,
      cupertino: CupertinoIcons.check_mark_circled_solid,
    );

    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        boxShadow: const [
          BoxShadow(
            color: Color(0x12000000),
            blurRadius: 28,
            offset: Offset(0, 18),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: 'product-${product.id}',
              child: AspectRatio(
                aspectRatio: 1,
                child: ProductVisual(
                  product: product,
                  borderRadius: 28,
                  emojiSize: 120,
                  padding: const EdgeInsets.all(20),
                ),
              ),
            ),
            const SizedBox(height: 18),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                _InfoChip(
                  icon: deliveryIcon,
                  text: 'Entrega hoje',
                  accentColor: accentColor,
                ),
                _InfoChip(
                  icon: detailsIcon,
                  text: product.details,
                  accentColor: accentColor,
                ),
                _InfoChip(
                  icon: verifiedIcon,
                  text: product.imageLabel,
                  accentColor: accentColor,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Conteudo textual e comercial da tela de detalhes.
class _DetailsContent extends StatelessWidget {
  const _DetailsContent({required this.product, required this.accentColor});

  final HomeProduct product;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final highlightIcon = platformIcon(
      context,
      material: Icons.check_circle_rounded,
      cupertino: CupertinoIcons.check_mark_circled_solid,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          product.name,
          style: textTheme.headlineMedium?.copyWith(
            fontSize: 34,
            height: 1,
            fontWeight: FontWeight.w900,
            color: const Color(0xFF111A30),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          product.price,
          style: textTheme.headlineMedium?.copyWith(
            fontSize: 32,
            fontWeight: FontWeight.w900,
            color: accentColor,
          ),
        ),
        const SizedBox(height: 12),
        Selector<CartViewModel, int>(
          selector: (_, cart) => cart.quantityFor(product),
          builder: (context, quantity, child) {
            if (quantity == 0) {
              return Text(
                'Ainda nao ha unidades deste item no carrinho.',
                style: textTheme.bodyMedium?.copyWith(
                  color: const Color(0xFF6F7784),
                ),
              );
            }

            return DecoratedBox(
              decoration: BoxDecoration(
                color: accentColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                child: Text(
                  '$quantity unidade(s) no carrinho',
                  style: textTheme.bodyMedium?.copyWith(
                    color: accentColor,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 20),
        Text(
          'Sobre o produto',
          style: textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w900,
            color: const Color(0xFF111A30),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          product.description,
          style: textTheme.bodyLarge?.copyWith(
            height: 1.5,
            color: const Color(0xFF465063),
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'Destaques',
          style: textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w900,
            color: const Color(0xFF111A30),
          ),
        ),
        const SizedBox(height: 12),
        ..._highlightsFor(product).map(
          (highlight) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(highlightIcon, size: 20, color: accentColor),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    highlight,
                    style: textTheme.bodyMedium?.copyWith(
                      height: 1.4,
                      color: const Color(0xFF465063),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({
    required this.icon,
    required this.text,
    required this.accentColor,
  });

  final IconData icon;
  final String text;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: accentColor.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: accentColor),
            const SizedBox(width: 6),
            Text(
              text,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: accentColor,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

List<String> _highlightsFor(HomeProduct product) {
  return [
    'Apresentacao em ${product.details}, ideal para reposicao rapida no carrinho.',
    'Identidade visual ${product.imageLabel.toLowerCase()} usada para destacar o produto na vitrine.',
    'Preco unitario de ${product.price}, com atualizacao imediata no subtotal do carrinho.',
  ];
}

Color _backgroundColorFor(HomeProduct product) {
  return Color.lerp(product.imageColors.first, Colors.white, 0.82) ??
      const Color(0xFFF7F4EF);
}
