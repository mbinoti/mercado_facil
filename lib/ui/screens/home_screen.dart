import 'package:app_mercadofacil/model/home_product.dart';
import 'package:app_mercadofacil/model/home_promotional_banner.dart';
import 'package:app_mercadofacil/ui/platform/platform_ui.dart';
import 'package:app_mercadofacil/ui/screens/product_details_screen.dart';
import 'package:app_mercadofacil/ui/widgets/cart_button.dart';
import 'package:app_mercadofacil/ui/widgets/product_visual.dart';
import 'package:app_mercadofacil/viewmodel/app_shell_viewmodel.dart';
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
            final promotionalBanners = viewModel.hasActiveFilters
                ? const <HomePromotionalBanner>[]
                : viewModel.promotionalBanners;
            final productsById = {
              for (final product in viewModel.catalogProducts)
                product.id: product,
            };

            return CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(12, 12, 12, 6),
                    child: _HomeHeader(),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(12, 6, 12, 8),
                    child: _CatalogDiscoverySection(viewModel: viewModel),
                  ),
                ),
                if (promotionalBanners.isNotEmpty)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
                      child: _PromotionalBannersSection(
                        banners: promotionalBanners,
                        productsById: productsById,
                      ),
                    ),
                  ),
                _ProductsSliver(
                  products: products,
                  hasActiveFilters: viewModel.hasActiveFilters,
                ),
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

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
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
          ),
        ),
        const SizedBox(width: 16),
        CartButton(
          onPressed: () =>
              context.read<AppShellViewModel>().goTo(AppShellTab.cart),
          backgroundColor: Colors.white,
          foregroundColor: const Color(0xFF111A30),
        ),
      ],
    );
  }
}

class _CatalogDiscoverySection extends StatefulWidget {
  const _CatalogDiscoverySection({required this.viewModel});

  final HomeProductsViewModel viewModel;

  @override
  State<_CatalogDiscoverySection> createState() =>
      _CatalogDiscoverySectionState();
}

class _CatalogDiscoverySectionState extends State<_CatalogDiscoverySection> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(
      text: widget.viewModel.searchQuery,
    );
  }

  @override
  void didUpdateWidget(covariant _CatalogDiscoverySection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_searchController.text != widget.viewModel.searchQuery) {
      _searchController.value = _searchController.value.copyWith(
        text: widget.viewModel.searchQuery,
        selection: TextSelection.collapsed(
          offset: widget.viewModel.searchQuery.length,
        ),
      );
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = widget.viewModel;
    final textTheme = Theme.of(context).textTheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(30),
        boxShadow: const [
          BoxShadow(
            color: Color(0x10000000),
            blurRadius: 18,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _HomeSearchField(
              controller: _searchController,
              onChanged: viewModel.updateSearchQuery,
              onClear: () {
                _searchController.clear();
                viewModel.updateSearchQuery('');
              },
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Text(
                    viewModel.resultsSummary,
                    style: textTheme.bodyMedium?.copyWith(
                      color: const Color(0xFF5A6474),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                if (viewModel.hasActiveFilters)
                  _InlineClearButton(
                    onPressed: () {
                      _searchController.clear();
                      viewModel.clearFilters();
                    },
                  ),
              ],
            ),
            if (viewModel.availableCategories.isNotEmpty) ...[
              const SizedBox(height: 12),
              SizedBox(
                height: 40,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  itemCount: viewModel.availableCategories.length + 1,
                  separatorBuilder: (_, _) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return _CategoryChip(
                        label: 'Todos',
                        selected: viewModel.selectedCategory == null,
                        onPressed: () => viewModel.selectCategory(null),
                      );
                    }

                    final category = viewModel.availableCategories[index - 1];
                    return _CategoryChip(
                      label: category.label,
                      selected: viewModel.selectedCategory == category,
                      onPressed: () => viewModel.selectCategory(category),
                    );
                  },
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _HomeSearchField extends StatelessWidget {
  const _HomeSearchField({
    required this.controller,
    required this.onChanged,
    required this.onClear,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    if (isCupertinoContext(context)) {
      return CupertinoSearchTextField(
        controller: controller,
        placeholder: 'Buscar por nome, unidade ou categoria',
        onChanged: onChanged,
        onSuffixTap: onClear,
      );
    }

    return TextField(
      controller: controller,
      onChanged: onChanged,
      textInputAction: TextInputAction.search,
      decoration: InputDecoration(
        hintText: 'Buscar por nome, unidade ou categoria',
        prefixIcon: const Icon(Icons.search_rounded),
        suffixIcon: controller.text.isEmpty
            ? null
            : IconButton(
                tooltip: 'Limpar busca',
                onPressed: onClear,
                icon: const Icon(Icons.close_rounded),
              ),
        filled: true,
        fillColor: const Color(0xFFF7F8F5),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 14,
        ),
      ),
    );
  }
}

class _InlineClearButton extends StatelessWidget {
  const _InlineClearButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    if (isCupertinoContext(context)) {
      return CupertinoButton(
        padding: EdgeInsets.zero,
        minimumSize: Size.zero,
        onPressed: onPressed,
        child: Text(
          'Limpar',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: const Color(0xFF2F8B37),
            fontWeight: FontWeight.w900,
          ),
        ),
      );
    }

    return TextButton(onPressed: onPressed, child: const Text('Limpar'));
  }
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({
    required this.label,
    required this.selected,
    required this.onPressed,
  });

  final String label;
  final bool selected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final textColor = selected ? Colors.white : const Color(0xFF4B5563);
    final backgroundColor = selected
        ? const Color(0xFF2F8B37)
        : const Color(0xFFF1F3EE);

    final content = AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOutCubic,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: textColor,
          fontWeight: FontWeight.w800,
        ),
      ),
    );

    if (isCupertinoContext(context)) {
      return CupertinoButton(
        padding: EdgeInsets.zero,
        minimumSize: Size.zero,
        onPressed: onPressed,
        child: content,
      );
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(999),
        onTap: onPressed,
        child: content,
      ),
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

/// Sliver responsivo usado para exibir a lista de produtos da home.
///
/// A quantidade de colunas varia conforme a largura disponivel. Quando a
/// lista esta vazia, o widget delega para [_EmptyProductsState].
class _ProductsSliver extends StatelessWidget {
  const _ProductsSliver({
    required this.products,
    required this.hasActiveFilters,
  });

  final List<HomeProduct> products;
  final bool hasActiveFilters;

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) {
      return SliverFillRemaining(
        hasScrollBody: false,
        child: _EmptyProductsState(hasActiveFilters: hasActiveFilters),
      );
    }

    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(12, 6, 12, 24),
      sliver: SliverLayoutBuilder(
        builder: (context, constraints) {
          final crossAxisCount = switch (constraints.crossAxisExtent) {
            >= 900 => 4,
            >= 580 => 3,
            _ => 2,
          };
          const crossAxisSpacing = 14.0;
          final itemWidth =
              (constraints.crossAxisExtent -
                  (crossAxisCount - 1) * crossAxisSpacing) /
              crossAxisCount;
          final itemExtent = itemWidth + 136;

          return SliverGrid(
            delegate: SliverChildBuilderDelegate((context, index) {
              return _ProductCard(product: products[index]);
            }, childCount: products.length),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: crossAxisSpacing,
              mainAxisSpacing: 14,
              mainAxisExtent: itemExtent,
            ),
          );
        },
      ),
    );
  }
}

/// Estado vazio mostrado quando nao ha produtos para a fonte selecionada.
class _EmptyProductsState extends StatelessWidget {
  const _EmptyProductsState({required this.hasActiveFilters});

  final bool hasActiveFilters;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final icon = hasActiveFilters
        ? platformIcon(
            context,
            material: Icons.search_off_rounded,
            cupertino: CupertinoIcons.search,
          )
        : platformIcon(
            context,
            material: Icons.inventory_2_outlined,
            cupertino: CupertinoIcons.cube_box,
          );
    final action = hasActiveFilters
        ? (isCupertinoContext(context)
              ? CupertinoButton.filled(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 12,
                  ),
                  onPressed: () =>
                      context.read<HomeProductsViewModel>().clearFilters(),
                  child: Text(
                    'Limpar filtros',
                    style: textTheme.bodyMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                )
              : FilledButton(
                  onPressed: () =>
                      context.read<HomeProductsViewModel>().clearFilters(),
                  child: const Text('Limpar filtros'),
                ))
        : null;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 44, color: const Color(0xFF7C838D)),
            const SizedBox(height: 12),
            Text(
              hasActiveFilters
                  ? 'Nenhum produto combina com sua busca.'
                  : 'Nenhum produto encontrado.',
              style: textTheme.titleMedium?.copyWith(
                color: const Color(0xFF111A30),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              hasActiveFilters
                  ? 'Tente buscar por outro nome, trocar a categoria ou limpar os filtros para voltar ao catalogo completo.'
                  : 'Confira se o seed do Hive foi executado e se ha produtos persistidos na base local.',
              textAlign: TextAlign.center,
              style: textTheme.bodyMedium?.copyWith(
                color: const Color(0xFF6F7784),
              ),
            ),
            if (action != null) ...[const SizedBox(height: 16), action],
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
