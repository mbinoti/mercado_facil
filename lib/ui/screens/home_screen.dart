import 'package:app_mercadofacil/model/home_product.dart';
import 'package:app_mercadofacil/model/home_promotional_banner.dart';
import 'package:app_mercadofacil/ui/platform/platform_ui.dart';
import 'package:app_mercadofacil/ui/screens/product_details_screen.dart';
import 'package:app_mercadofacil/ui/widgets/product_visual.dart';
import 'package:app_mercadofacil/viewmodel/cart_viewmodel.dart';
import 'package:app_mercadofacil/viewmodel/home_products_viewmodel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Tela publica da home de produtos.
///
/// Ela recebe configuracoes externas, cria o [HomeProductsViewModel] e injeta
/// o estado na arvore com `ChangeNotifierProvider`. A composicao visual fica
/// delegada para widgets privados definidos no mesmo arquivo.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HomeProductsViewModel(),
      child: const _HomeScreenView(),
    );
  }
}

/// Corpo interno da home, responsavel por observar o estado e compor o layout
/// principal da pagina.
class _HomeScreenView extends StatelessWidget {
  const _HomeScreenView();

  @override
  Widget build(BuildContext context) {
    final isCupertino = isCupertinoContext(context);
    final body = DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            _homeVisuals.backgroundColor,
            _homeVisuals.backgroundColor,
            _homeVisuals.backgroundColor.withValues(alpha: 0.92),
          ],
        ),
      ),
      child: SafeArea(
        child: Consumer<HomeProductsViewModel>(
          builder: (context, viewModel, child) {
            final products = viewModel.products;
            final promotionalBanners = viewModel.promotionalBanners;
            final productsById = {
              for (final product in products) product.id: product,
            };

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 12, 12, 6),
                  child: const _HomeHeader(),
                ),
                if (promotionalBanners.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 6, 12, 8),
                    child: _PromotionalBannersSection(
                      banners: promotionalBanners,
                      productsById: productsById,
                    ),
                  ),
                Expanded(child: _ProductsGrid(products: products)),
              ],
            );
          },
        ),
      ),
    );

    if (isCupertino) {
      return CupertinoPageScaffold(
        backgroundColor: _homeVisuals.backgroundColor,
        child: body,
      );
    }

    return Scaffold(backgroundColor: _homeVisuals.backgroundColor, body: body);
  }
}

/// Cabecalho principal da home.
class _HomeHeader extends StatelessWidget {
  const _HomeHeader();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Produtos',
          style: textTheme.headlineMedium?.copyWith(
            fontSize: 30,
            fontWeight: FontWeight.w900,
            color: const Color(0xFF111A30),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Catalogo sincronizado com o Hive, com promocoes ativas e atalhos rapidos para os destaques do dia.',
          style: textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: const Color(0xFF6F7784),
          ),
        ),
      ],
    );
  }
}

const double _promotionalBannerCardWidth = 304;
const double _promotionalBannerSpacing = 12;

class _PromotionalBannersSection extends StatefulWidget {
  const _PromotionalBannersSection({
    required this.banners,
    required this.productsById,
  });

  final List<HomePromotionalBanner> banners;
  final Map<String, HomeProduct> productsById;

  @override
  State<_PromotionalBannersSection> createState() =>
      _PromotionalBannersSectionState();
}

class _PromotionalBannersSectionState
    extends State<_PromotionalBannersSection> {
  late final ScrollController _scrollController;
  int _currentBannerIndex = 0;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_handleScroll);
  }

  @override
  void didUpdateWidget(covariant _PromotionalBannersSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    final maxIndex = widget.banners.isEmpty ? 0 : widget.banners.length - 1;
    if (_currentBannerIndex > maxIndex) {
      _currentBannerIndex = maxIndex;
    }
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_handleScroll)
      ..dispose();
    super.dispose();
  }

  void _handleScroll() {
    if (!_scrollController.hasClients || widget.banners.isEmpty) {
      return;
    }

    final nextIndex =
        (_scrollController.offset /
                (_promotionalBannerCardWidth + _promotionalBannerSpacing))
            .round()
            .clamp(0, widget.banners.length - 1);

    if (nextIndex == _currentBannerIndex) {
      return;
    }

    setState(() {
      _currentBannerIndex = nextIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Promocoes em destaque',
              style: textTheme.titleLarge?.copyWith(
                color: const Color(0xFF111A30),
                fontWeight: FontWeight.w900,
              ),
            ),
            const Spacer(),
            Text(
              '${widget.banners.length} ativas',
              style: textTheme.bodySmall?.copyWith(
                color: const Color(0xFF66707F),
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 174,
          child: ListView.separated(
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: widget.banners.length,
            separatorBuilder: (_, _) =>
                const SizedBox(width: _promotionalBannerSpacing),
            itemBuilder: (context, index) {
              final banner = widget.banners[index];
              return _PromotionalBannerCard(
                banner: banner,
                targetProduct: banner.targetProductId == null
                    ? null
                    : widget.productsById[banner.targetProductId],
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        _PromotionalBannerIndicators(
          totalBanners: widget.banners.length,
          currentBannerIndex: _currentBannerIndex,
        ),
      ],
    );
  }
}

class _PromotionalBannerIndicators extends StatelessWidget {
  const _PromotionalBannerIndicators({
    required this.totalBanners,
    required this.currentBannerIndex,
  });

  final int totalBanners;
  final int currentBannerIndex;

  @override
  Widget build(BuildContext context) {
    if (totalBanners == 0) {
      return const SizedBox.shrink();
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (var index = 0; index < totalBanners; index++) ...[
          AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOutCubic,
            width: index == currentBannerIndex ? 18 : 8,
            height: 8,
            decoration: BoxDecoration(
              color: index == currentBannerIndex
                  ? const Color(0xFF2F8B37)
                  : const Color(0xFFD2D9CE),
              borderRadius: BorderRadius.circular(999),
            ),
          ),
          if (index != totalBanners - 1) const SizedBox(width: 6),
        ],
        const SizedBox(width: 12),
        Text(
          '${currentBannerIndex + 1}/$totalBanners',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: const Color(0xFF66707F),
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }
}

class _PromotionalBannerCard extends StatelessWidget {
  const _PromotionalBannerCard({
    required this.banner,
    required this.targetProduct,
  });

  final HomePromotionalBanner banner;
  final HomeProduct? targetProduct;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final content = SizedBox(
      width: _promotionalBannerCardWidth,
      child: Stack(
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: banner.backgroundColors,
              ),
              borderRadius: BorderRadius.circular(28),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x18000000),
                  blurRadius: 22,
                  offset: Offset(0, 12),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                  const SizedBox(height: 12),
                  Text(
                    banner.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.titleLarge?.copyWith(
                      color: banner.textColor,
                      fontWeight: FontWeight.w900,
                      height: 1.05,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Expanded(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 228),
                      child: Text(
                        banner.subtitle,
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                        style: textTheme.bodyMedium?.copyWith(
                          color: banner.textColor.withValues(alpha: 0.84),
                          height: 1.35,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      DecoratedBox(
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.16),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                banner.ctaLabel,
                                style: textTheme.bodySmall?.copyWith(
                                  color: banner.textColor,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Icon(
                                platformIcon(
                                  context,
                                  material: Icons.arrow_forward_rounded,
                                  cupertino: CupertinoIcons.arrow_right,
                                ),
                                size: 14,
                                color: banner.textColor,
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (targetProduct != null) ...[
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            targetProduct!.price,
                            textAlign: TextAlign.right,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: textTheme.bodySmall?.copyWith(
                              color: banner.textColor,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 16,
            right: 18,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const SizedBox(width: 72, height: 72),
            ),
          ),
          Positioned(
            right: 26,
            bottom: 18,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(999),
              ),
              child: const SizedBox(width: 86, height: 86),
            ),
          ),
        ],
      ),
    );

    if (isCupertinoContext(context)) {
      return CupertinoButton(
        padding: EdgeInsets.zero,
        minimumSize: Size.zero,
        onPressed: () => _openPromotionalBanner(context),
        child: content,
      );
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(28),
        onTap: () => _openPromotionalBanner(context),
        child: content,
      ),
    );
  }

  void _openPromotionalBanner(BuildContext context) {
    if (targetProduct != null) {
      _openProductDetails(context, targetProduct!);
      return;
    }

    showPlatformFeedback(context, 'Promocao atualizada no catalogo do dia.');
  }
}

/// Grid responsivo usado para exibir a lista de produtos da home.
///
/// A quantidade de colunas varia conforme a largura disponivel. Quando a
/// lista esta vazia, o widget delega para [_EmptyProductsState].
class _ProductsGrid extends StatelessWidget {
  const _ProductsGrid({required this.products});

  final List<HomeProduct> products;

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) {
      return const _EmptyProductsState();
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = switch (constraints.maxWidth) {
          >= 900 => 4,
          >= 580 => 3,
          _ => 2,
        };
        const horizontalPadding = 24.0;
        const crossAxisSpacing = 14.0;
        final itemWidth =
            (constraints.maxWidth -
                horizontalPadding -
                (crossAxisCount - 1) * crossAxisSpacing) /
            crossAxisCount;
        final itemExtent = itemWidth + 136;

        return GridView.builder(
          padding: const EdgeInsets.fromLTRB(12, 6, 12, 24),
          physics: const BouncingScrollPhysics(),
          itemCount: products.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: crossAxisSpacing,
            mainAxisSpacing: 14,
            mainAxisExtent: itemExtent,
          ),
          itemBuilder: (context, index) {
            return _ProductCard(product: products[index]);
          },
        );
      },
    );
  }
}

/// Estado vazio mostrado quando nao ha produtos para a fonte selecionada.
class _EmptyProductsState extends StatelessWidget {
  const _EmptyProductsState();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final icon = platformIcon(
      context,
      material: Icons.inventory_2_outlined,
      cupertino: CupertinoIcons.cube_box,
    );

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 44, color: const Color(0xFF7C838D)),
            const SizedBox(height: 12),
            Text(
              'Nenhum produto encontrado.',
              style: textTheme.titleMedium?.copyWith(
                color: const Color(0xFF111A30),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Confira se o seed do Hive foi executado e se ha produtos persistidos na base local.',
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

/// Card visual de um produto dentro da grade.
///
/// Organiza a arte do item, textos descritivos, acesso ao detalhe e adicao
/// rapida ao carrinho em um unico componente.
class _ProductCard extends StatelessWidget {
  const _ProductCard({required this.product});

  final HomeProduct product;

  @override
  Widget build(BuildContext context) {
    final isCupertino = isCupertinoContext(context);
    final textTheme = Theme.of(context).textTheme;

    return LayoutBuilder(
      builder: (context, constraints) {
        final imageSide = constraints.maxWidth - 24;
        final priceFontSize = constraints.maxWidth < 170 ? 24.0 : 28.0;
        final cardBody = DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [
              BoxShadow(
                color: Color(0x12000000),
                blurRadius: 18,
                offset: Offset(0, 10),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    Hero(
                      tag: 'product-${product.id}',
                      child: SizedBox.square(
                        dimension: imageSide,
                        child: ProductVisual(product: product),
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

                          return _InlineQuantityBadge(quantity: quantity);
                        },
                      ),
                    ),
                  ],
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
                          color: const Color(0xFF2F8B37),
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
                            color: const Color(0xFFEEF6EA),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: const SizedBox(
                            width: 42,
                            height: 42,
                            child: Icon(
                              CupertinoIcons.plus,
                              color: Color(0xFF2F8B37),
                            ),
                          ),
                        ),
                      )
                    else
                      IconButton.filledTonal(
                        tooltip: 'Adicionar ao carrinho',
                        onPressed: () => _addProductToCart(context, product),
                        style: IconButton.styleFrom(
                          backgroundColor: const Color(0xFFEEF6EA),
                          foregroundColor: const Color(0xFF2F8B37),
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
            child: cardBody,
          );
        }

        return Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () => _openProductDetails(context, product),
            child: cardBody,
          ),
        );
      },
    );
  }
}

class _InlineQuantityBadge extends StatelessWidget {
  const _InlineQuantityBadge({required this.quantity});

  final int quantity;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: Text(
          'x$quantity',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: const Color(0xFF111A30),
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }
}

/// Objeto imutavel que agrupa o conjunto de cores e icones associado a uma
/// fonte de dados da home.
class _SourceVisuals {
  const _SourceVisuals({
    required this.label,
    required this.materialIcon,
    required this.cupertinoIcon,
    required this.backgroundColor,
    required this.accentColor,
  });

  final String label;
  final IconData materialIcon;
  final IconData cupertinoIcon;
  final Color backgroundColor;
  final Color accentColor;
}

const _homeVisuals = _SourceVisuals(
  label: 'Hive',
  materialIcon: Icons.storage_rounded,
  cupertinoIcon: CupertinoIcons.cube_box,
  backgroundColor: Color(0xFFEEF6EA),
  accentColor: Color(0xFF2F8B37),
);

void _addProductToCart(BuildContext context, HomeProduct product) {
  context.read<CartViewModel>().addProduct(product);
  showPlatformFeedback(context, '${product.name} adicionado ao carrinho.');
}

void _openProductDetails(BuildContext context, HomeProduct product) {
  Navigator.of(context).push(
    platformPageRoute(builder: (_) => ProductDetailsScreen(product: product)),
  );
}
