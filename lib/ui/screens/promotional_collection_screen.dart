import 'package:app_mercadofacil/model/home_product.dart';
import 'package:app_mercadofacil/model/home_promotional_banner.dart';
import 'package:app_mercadofacil/ui/platform/platform_ui.dart';
import 'package:app_mercadofacil/ui/screens/product_details_screen.dart';
import 'package:app_mercadofacil/ui/widgets/product_visual.dart';
import 'package:app_mercadofacil/viewmodel/cart_viewmodel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Tela que agrupa os produtos associados a uma promocao da home.
class PromotionalCollectionScreen extends StatelessWidget {
  const PromotionalCollectionScreen({
    super.key,
    required this.banner,
    required this.products,
  });

  final HomePromotionalBanner banner;
  final List<HomeProduct> products;

  @override
  Widget build(BuildContext context) {
    final isCupertino = isCupertinoContext(context);
    final backgroundColor = _backgroundColorForBanner(banner);
    final body = DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            backgroundColor,
            backgroundColor,
            backgroundColor.withValues(alpha: 0.96),
          ],
        ),
      ),
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 16, 12, 16),
              child: _PromotionalCollectionHero(
                banner: banner,
                productsCount: products.length,
              ),
            ),
          ),
          if (products.isEmpty)
            const SliverFillRemaining(
              hasScrollBody: false,
              child: _EmptyPromotionalCollectionState(),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 24),
              sliver: SliverLayoutBuilder(
                builder: (context, constraints) {
                  final crossAxisCount = switch (constraints.crossAxisExtent) {
                    >= 900 => 4,
                    >= 580 => 3,
                    _ => 2,
                  };
                  const spacing = 14.0;
                  final itemWidth =
                      (constraints.crossAxisExtent -
                          (crossAxisCount - 1) * spacing) /
                      crossAxisCount;
                  final itemExtent = itemWidth + 168;

                  return SliverGrid(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      return _PromotionalCollectionProductCard(
                        product: products[index],
                        accentColor: banner.backgroundColors.last,
                        tintColor: banner.backgroundColors.last.withValues(
                          alpha: 0.12,
                        ),
                      );
                    }, childCount: products.length),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: spacing,
                      mainAxisSpacing: spacing,
                      mainAxisExtent: itemExtent,
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );

    if (isCupertino) {
      return CupertinoPageScaffold(
        backgroundColor: backgroundColor,
        navigationBar: CupertinoNavigationBar(
          backgroundColor: backgroundColor.withValues(alpha: 0.94),
          middle: const Text('Promocao'),
          border: null,
        ),
        child: SafeArea(top: false, child: body),
      );
    }

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        title: const Text('Promocao'),
      ),
      body: body,
    );
  }
}

class _PromotionalCollectionHero extends StatelessWidget {
  const _PromotionalCollectionHero({
    required this.banner,
    required this.productsCount,
  });

  final HomePromotionalBanner banner;
  final int productsCount;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final summaryLabel = productsCount == 1
        ? '1 item selecionado'
        : '$productsCount itens selecionados';

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: banner.backgroundColors,
        ),
        borderRadius: BorderRadius.circular(32),
        boxShadow: const [
          BoxShadow(
            color: Color(0x18000000),
            blurRadius: 24,
            offset: Offset(0, 14),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.16),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    child: Text(
                      banner.badge,
                      style: textTheme.bodySmall?.copyWith(
                        color: banner.textColor,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),
                const Spacer(),
                Text(
                  summaryLabel,
                  style: textTheme.bodySmall?.copyWith(
                    color: banner.textColor.withValues(alpha: 0.88),
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Text(
              banner.title,
              style: textTheme.headlineMedium?.copyWith(
                color: banner.textColor,
                fontWeight: FontWeight.w900,
                height: 1.05,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              banner.subtitle,
              style: textTheme.bodyLarge?.copyWith(
                color: banner.textColor.withValues(alpha: 0.86),
                height: 1.4,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Toque em um item para abrir os detalhes ou adicionar ao carrinho '
              'sem sair da promocao.',
              style: textTheme.bodyMedium?.copyWith(
                color: banner.textColor.withValues(alpha: 0.78),
                height: 1.35,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PromotionalCollectionProductCard extends StatelessWidget {
  const _PromotionalCollectionProductCard({
    required this.product,
    required this.accentColor,
    required this.tintColor,
  });

  final HomeProduct product;
  final Color accentColor;
  final Color tintColor;

  @override
  Widget build(BuildContext context) {
    final isCupertino = isCupertinoContext(context);
    final textTheme = Theme.of(context).textTheme;

    return LayoutBuilder(
      builder: (context, constraints) {
        final imageSide = constraints.maxWidth - 32;
        final priceFontSize = constraints.maxWidth < 170 ? 24.0 : 28.0;
        final content = DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(28),
            boxShadow: const [
              BoxShadow(
                color: Color(0x12000000),
                blurRadius: 18,
                offset: Offset(0, 10),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    Hero(
                      tag: 'product-${product.id}',
                      child: SizedBox.square(
                        dimension: imageSide,
                        child: ProductVisual(
                          product: product,
                          preferAssetImage: true,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 10,
                      right: 10,
                      child: Selector<CartViewModel, int>(
                        selector: (_, cart) => cart.quantityFor(product),
                        builder: (context, quantity, child) {
                          if (quantity == 0) {
                            return const SizedBox.shrink();
                          }

                          return DecoratedBox(
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.92),
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 6,
                              ),
                              child: Text(
                                'x$quantity',
                                style: textTheme.bodySmall?.copyWith(
                                  color: const Color(0xFF111A30),
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: tintColor,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    child: Text(
                      product.category.label,
                      style: textTheme.bodySmall?.copyWith(
                        color: accentColor,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  product.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.titleLarge?.copyWith(
                    fontSize: 18,
                    height: 1.05,
                    fontWeight: FontWeight.w900,
                    color: const Color(0xFF111A30),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  product.details,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.bodyMedium?.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF848B96),
                  ),
                ),
                const Spacer(),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        product.price,
                        style: textTheme.headlineMedium?.copyWith(
                          fontSize: priceFontSize,
                          fontWeight: FontWeight.w900,
                          color: accentColor,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    if (isCupertino)
                      CupertinoButton(
                        padding: EdgeInsets.zero,
                        minimumSize: const Size.square(42),
                        onPressed: () => _addProductToCart(context, product),
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: tintColor,
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: SizedBox(
                            width: 42,
                            height: 42,
                            child: Icon(
                              CupertinoIcons.plus,
                              color: accentColor,
                            ),
                          ),
                        ),
                      )
                    else
                      IconButton.filledTonal(
                        tooltip: 'Adicionar ao carrinho',
                        onPressed: () => _addProductToCart(context, product),
                        style: IconButton.styleFrom(
                          backgroundColor: tintColor,
                          foregroundColor: accentColor,
                        ),
                        icon: const Icon(Icons.add_shopping_cart_rounded),
                      ),
                  ],
                ),
              ],
            ),
          ),
        );

        if (isCupertino) {
          return CupertinoButton(
            padding: EdgeInsets.zero,
            minimumSize: Size.zero,
            onPressed: () => _openProductDetails(context, product),
            child: content,
          );
        }

        return Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(28),
            onTap: () => _openProductDetails(context, product),
            child: content,
          ),
        );
      },
    );
  }
}

class _EmptyPromotionalCollectionState extends StatelessWidget {
  const _EmptyPromotionalCollectionState();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              platformIcon(
                context,
                material: Icons.local_offer_outlined,
                cupertino: CupertinoIcons.tag,
              ),
              size: 44,
              color: const Color(0xFF7C838D),
            ),
            const SizedBox(height: 12),
            Text(
              'Nenhum item encontrado para esta promocao.',
              textAlign: TextAlign.center,
              style: textTheme.titleMedium?.copyWith(
                color: const Color(0xFF111A30),
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Atualize o seed do catalogo ou revise os ids configurados para esta campanha.',
              textAlign: TextAlign.center,
              style: textTheme.bodyMedium?.copyWith(
                color: const Color(0xFF6F7784),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Color _backgroundColorForBanner(HomePromotionalBanner banner) {
  return Color.lerp(Colors.white, banner.backgroundColors.last, 0.10) ??
      const Color(0xFFF7F8F5);
}

void _addProductToCart(BuildContext context, HomeProduct product) {
  context.read<CartViewModel>().addProduct(product);
  showPlatformFeedback(context, '${product.name} adicionado ao carrinho.');
}

void _openProductDetails(BuildContext context, HomeProduct product) {
  Navigator.of(context).push(
    platformPageRoute(builder: (_) => ProductDetailsScreen(product: product)),
  );
}
