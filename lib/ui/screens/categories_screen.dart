import 'package:app_mercadofacil/model/home_product.dart';
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

/// Tela dedicada a navegacao por categorias do catalogo.
class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HomeProductsViewModel(),
      child: const _CategoriesScreenView(),
    );
  }
}

class _CategoriesScreenView extends StatelessWidget {
  const _CategoriesScreenView();

  @override
  Widget build(BuildContext context) {
    final isCupertino = isCupertinoContext(context);
    final body = DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            _categoriesBackgroundColor,
            _categoriesBackgroundColor,
            _categoriesBackgroundColor.withValues(alpha: 0.94),
          ],
        ),
      ),
      child: SafeArea(
        child: Consumer<HomeProductsViewModel>(
          builder: (context, viewModel, child) {
            final selectedVisuals = _visualsForCategory(
              viewModel.selectedCategory,
            );
            final cartItemCount = context.watch<CartViewModel>().totalItems;

            return LayoutBuilder(
              builder: (context, constraints) {
                final crossAxisCount = switch (constraints.maxWidth) {
                  >= 1180 => 4,
                  >= 860 => 3,
                  >= 560 => 2,
                  _ => 1,
                };
                const spacing = 14.0;
                final gridItemWidth =
                    (constraints.maxWidth -
                        24 -
                        ((crossAxisCount - 1) * spacing)) /
                    crossAxisCount;
                final gridItemExtent = gridItemWidth + 116;

                return CustomScrollView(
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    const SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(12, 12, 12, 8),
                        child: _CategoriesHeader(),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                        child: _CategoriesSearchPanel(viewModel: viewModel),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                        child: _CategoryHeroCard(
                          visuals: selectedVisuals,
                          selectedCategory: viewModel.selectedCategory,
                          resultsSummary: viewModel.resultsSummary,
                          availableCategoriesCount:
                              viewModel.availableCategories.length,
                          totalCartItems: cartItemCount,
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                        child: _CategorySelectorSection(viewModel: viewModel),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
                        child: _ProductsSectionHeader(
                          selectedCategory: viewModel.selectedCategory,
                          productsCount: viewModel.products.length,
                        ),
                      ),
                    ),
                    if (viewModel.products.isEmpty)
                      SliverFillRemaining(
                        hasScrollBody: false,
                        child: _EmptyCategoryProductsState(
                          hasActiveFilters: viewModel.hasActiveFilters,
                        ),
                      )
                    else
                      SliverPadding(
                        padding: const EdgeInsets.fromLTRB(12, 0, 12, 24),
                        sliver: SliverGrid(
                          delegate: SliverChildBuilderDelegate((
                            context,
                            index,
                          ) {
                            return _CategoryProductCard(
                              product: viewModel.products[index],
                              highlightCategory:
                                  viewModel.selectedCategory == null,
                            );
                          }, childCount: viewModel.products.length),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: crossAxisCount,
                                crossAxisSpacing: spacing,
                                mainAxisSpacing: spacing,
                                mainAxisExtent: gridItemExtent,
                              ),
                        ),
                      ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );

    if (isCupertino) {
      return CupertinoPageScaffold(
        backgroundColor: _categoriesBackgroundColor,
        child: body,
      );
    }

    return Scaffold(backgroundColor: _categoriesBackgroundColor, body: body);
  }
}

class _CategoriesHeader extends StatelessWidget {
  const _CategoriesHeader();

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
                'Categorias',
                style: textTheme.headlineMedium?.copyWith(
                  fontSize: 30,
                  fontWeight: FontWeight.w900,
                  color: const Color(0xFF111A30),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Navegue por secoes do catalogo, compare volumes por categoria e adicione itens ao carrinho sem sair do fluxo.',
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

class _CategoriesSearchPanel extends StatefulWidget {
  const _CategoriesSearchPanel({required this.viewModel});

  final HomeProductsViewModel viewModel;

  @override
  State<_CategoriesSearchPanel> createState() => _CategoriesSearchPanelState();
}

class _CategoriesSearchPanelState extends State<_CategoriesSearchPanel> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(
      text: widget.viewModel.searchQuery,
    );
  }

  @override
  void didUpdateWidget(covariant _CategoriesSearchPanel oldWidget) {
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
    final textTheme = Theme.of(context).textTheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.94),
        borderRadius: BorderRadius.circular(30),
        boxShadow: const [
          BoxShadow(
            color: Color(0x12000000),
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
            _CategoriesSearchField(
              controller: _searchController,
              onChanged: widget.viewModel.updateSearchQuery,
              onClear: () {
                _searchController.clear();
                widget.viewModel.updateSearchQuery('');
              },
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Text(
                    widget.viewModel.resultsSummary,
                    style: textTheme.bodyMedium?.copyWith(
                      color: const Color(0xFF5A6474),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                if (widget.viewModel.hasActiveFilters)
                  _InlineResetButton(
                    onPressed: () {
                      _searchController.clear();
                      widget.viewModel.clearFilters();
                    },
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoriesSearchField extends StatelessWidget {
  const _CategoriesSearchField({
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
        placeholder: 'Buscar por produto, unidade ou categoria',
        onChanged: onChanged,
        onSuffixTap: onClear,
      );
    }

    return TextField(
      controller: controller,
      onChanged: onChanged,
      textInputAction: TextInputAction.search,
      decoration: InputDecoration(
        hintText: 'Buscar por produto, unidade ou categoria',
        prefixIcon: const Icon(Icons.search_rounded),
        suffixIcon: controller.text.isEmpty
            ? null
            : IconButton(
                tooltip: 'Limpar busca',
                onPressed: onClear,
                icon: const Icon(Icons.close_rounded),
              ),
        filled: true,
        fillColor: const Color(0xFFF7F3EE),
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

class _InlineResetButton extends StatelessWidget {
  const _InlineResetButton({required this.onPressed});

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
            color: const Color(0xFF8F5D3B),
            fontWeight: FontWeight.w900,
          ),
        ),
      );
    }

    return TextButton(onPressed: onPressed, child: const Text('Limpar'));
  }
}

class _CategoryHeroCard extends StatelessWidget {
  const _CategoryHeroCard({
    required this.visuals,
    required this.selectedCategory,
    required this.resultsSummary,
    required this.availableCategoriesCount,
    required this.totalCartItems,
  });

  final _CategoryVisuals visuals;
  final HomeProductCategory? selectedCategory;
  final String resultsSummary;
  final int availableCategoriesCount;
  final int totalCartItems;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final icon = platformIcon(
      context,
      material: visuals.materialIcon,
      cupertino: visuals.cupertinoIcon,
    );

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [visuals.accentColor, visuals.secondaryColor],
        ),
        borderRadius: BorderRadius.circular(30),
        boxShadow: const [
          BoxShadow(
            color: Color(0x16000000),
            blurRadius: 24,
            offset: Offset(0, 12),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
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
                  horizontal: 12,
                  vertical: 8,
                ),
                child: Text(
                  selectedCategory == null
                      ? 'Mapa do catalogo'
                      : 'Categoria ativa',
                  style: textTheme.bodySmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        selectedCategory?.label ?? 'Todas as categorias',
                        style: textTheme.headlineMedium?.copyWith(
                          fontSize: 30,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        visuals.description,
                        style: textTheme.bodyMedium?.copyWith(
                          color: Colors.white.withValues(alpha: 0.86),
                          height: 1.45,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.14),
                    shape: BoxShape.circle,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: Icon(icon, size: 32, color: Colors.white),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                _HeroMetricChip(label: 'Resumo', value: resultsSummary),
                _HeroMetricChip(
                  label: 'Categorias',
                  value: '$availableCategoriesCount disponiveis',
                ),
                _HeroMetricChip(
                  label: 'Carrinho',
                  value: totalCartItems == 0
                      ? 'vazio'
                      : '$totalCartItems item(ns)',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _HeroMetricChip extends StatelessWidget {
  const _HeroMetricChip({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: textTheme.bodySmall?.copyWith(
                color: Colors.white.withValues(alpha: 0.78),
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: textTheme.bodyMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CategorySelectorSection extends StatelessWidget {
  const _CategorySelectorSection({required this.viewModel});

  final HomeProductsViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final totalProducts = viewModel.catalogProducts.length;

    return LayoutBuilder(
      builder: (context, constraints) {
        final cards = <Widget>[
          _CategorySelectorCard(
            label: 'Todos',
            description: 'Exibe o catalogo completo em uma unica vitrine.',
            productCount: totalProducts,
            visuals: _visualsForCategory(null),
            selected: viewModel.selectedCategory == null,
            onPressed: () => viewModel.selectCategory(null),
          ),
          for (final category in viewModel.availableCategories)
            _CategorySelectorCard(
              label: category.label,
              description: _visualsForCategory(category).description,
              productCount: _productCountForCategory(
                viewModel.catalogProducts,
                category,
              ),
              visuals: _visualsForCategory(category),
              selected: viewModel.selectedCategory == category,
              onPressed: () => viewModel.selectCategory(category),
            ),
        ];

        final columns = switch (constraints.maxWidth) {
          >= 1040 => 4,
          >= 720 => 3,
          >= 460 => 2,
          _ => 1,
        };
        const spacing = 12.0;
        final cardWidth =
            (constraints.maxWidth - ((columns - 1) * spacing)) / columns;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Escolha uma categoria',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w900,
                color: const Color(0xFF111A30),
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: spacing,
              runSpacing: spacing,
              children: [
                for (final card in cards)
                  SizedBox(width: cardWidth, child: card),
              ],
            ),
          ],
        );
      },
    );
  }
}

class _CategorySelectorCard extends StatelessWidget {
  const _CategorySelectorCard({
    required this.label,
    required this.description,
    required this.productCount,
    required this.visuals,
    required this.selected,
    required this.onPressed,
  });

  final String label;
  final String description;
  final int productCount;
  final _CategoryVisuals visuals;
  final bool selected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final foregroundColor = selected ? Colors.white : const Color(0xFF111A30);
    final descriptionColor = selected
        ? Colors.white.withValues(alpha: 0.82)
        : const Color(0xFF66707F);
    final background = selected
        ? LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [visuals.accentColor, visuals.secondaryColor],
          )
        : null;
    final icon = platformIcon(
      context,
      material: visuals.materialIcon,
      cupertino: visuals.cupertinoIcon,
    );
    final content = AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOutCubic,
      decoration: BoxDecoration(
        gradient: background,
        color: selected ? null : Colors.white.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: selected
              ? Colors.white.withValues(alpha: 0.16)
              : const Color(0xFFE5DDD2),
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x10000000),
            blurRadius: 18,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                color: selected
                    ? Colors.white.withValues(alpha: 0.14)
                    : visuals.tintColor,
                shape: BoxShape.circle,
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Icon(
                  icon,
                  color: selected ? Colors.white : visuals.accentColor,
                  size: 22,
                ),
              ),
            ),
            const SizedBox(height: 14),
            Text(
              label,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w900,
                color: foregroundColor,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              '$productCount produto(s)',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w800,
                color: selected
                    ? Colors.white.withValues(alpha: 0.84)
                    : visuals.accentColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              description,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: descriptionColor,
                height: 1.4,
              ),
            ),
          ],
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
        borderRadius: BorderRadius.circular(24),
        onTap: onPressed,
        child: content,
      ),
    );
  }
}

class _ProductsSectionHeader extends StatelessWidget {
  const _ProductsSectionHeader({
    required this.selectedCategory,
    required this.productsCount,
  });

  final HomeProductCategory? selectedCategory;
  final int productsCount;

  @override
  Widget build(BuildContext context) {
    final title = selectedCategory == null
        ? 'Produtos do catalogo'
        : 'Produtos em ${selectedCategory!.label}';
    final countLabel = switch (productsCount) {
      0 => 'Nenhum produto',
      1 => '1 produto',
      _ => '$productsCount produtos',
    };

    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w900,
              color: const Color(0xFF111A30),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          countLabel,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: const Color(0xFF66707F),
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}

class _EmptyCategoryProductsState extends StatelessWidget {
  const _EmptyCategoryProductsState({required this.hasActiveFilters});

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
            material: Icons.grid_view_outlined,
            cupertino: CupertinoIcons.square_grid_2x2,
          );

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 46, color: const Color(0xFF7C838D)),
              const SizedBox(height: 14),
              Text(
                hasActiveFilters
                    ? 'Nenhum item encontrado nesta combinacao.'
                    : 'Nenhum produto disponivel nas categorias.',
                textAlign: TextAlign.center,
                style: textTheme.titleMedium?.copyWith(
                  color: const Color(0xFF111A30),
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                hasActiveFilters
                    ? 'Limpe a busca ou troque a categoria para voltar ao catalogo completo.'
                    : 'Confira se o catalogo seedado no Hive esta disponivel.',
                textAlign: TextAlign.center,
                style: textTheme.bodyMedium?.copyWith(
                  color: const Color(0xFF6F7784),
                  height: 1.45,
                ),
              ),
              if (hasActiveFilters) ...[
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: () =>
                      context.read<HomeProductsViewModel>().clearFilters(),
                  child: const Text('Limpar filtros'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _CategoryProductCard extends StatelessWidget {
  const _CategoryProductCard({
    required this.product,
    required this.highlightCategory,
  });

  final HomeProduct product;
  final bool highlightCategory;

  @override
  Widget build(BuildContext context) {
    final isCupertino = isCupertinoContext(context);
    final textTheme = Theme.of(context).textTheme;

    return LayoutBuilder(
      builder: (context, constraints) {
        final imageSide = constraints.maxWidth - 24;
        final visuals = _visualsForCategory(product.category);
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
                          borderRadius: 22,
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
                if (highlightCategory) ...[
                  DecoratedBox(
                    decoration: BoxDecoration(
                      color: visuals.tintColor,
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
                          color: visuals.accentColor,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
                Text(
                  product.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w900,
                    color: const Color(0xFF111A30),
                    height: 1.05,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  product.details,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.bodyMedium?.copyWith(
                    color: const Color(0xFF848B96),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        product.price,
                        style: textTheme.headlineMedium?.copyWith(
                          fontSize: constraints.maxWidth < 210 ? 24 : 28,
                          fontWeight: FontWeight.w900,
                          color: visuals.accentColor,
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
                            color: visuals.tintColor,
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: SizedBox(
                            width: 42,
                            height: 42,
                            child: Icon(
                              CupertinoIcons.plus,
                              color: visuals.accentColor,
                            ),
                          ),
                        ),
                      )
                    else
                      IconButton.filledTonal(
                        tooltip: 'Adicionar ao carrinho',
                        onPressed: () => _addProductToCart(context, product),
                        style: IconButton.styleFrom(
                          backgroundColor: visuals.tintColor,
                          foregroundColor: visuals.accentColor,
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

class _CategoryVisuals {
  const _CategoryVisuals({
    required this.description,
    required this.accentColor,
    required this.secondaryColor,
    required this.tintColor,
    required this.materialIcon,
    required this.cupertinoIcon,
  });

  final String description;
  final Color accentColor;
  final Color secondaryColor;
  final Color tintColor;
  final IconData materialIcon;
  final IconData cupertinoIcon;
}

const Color _categoriesBackgroundColor = Color(0xFFF7F1E9);

int _productCountForCategory(
  List<HomeProduct> products,
  HomeProductCategory category,
) {
  return products.where((product) => product.category == category).length;
}

_CategoryVisuals _visualsForCategory(HomeProductCategory? category) {
  return switch (category) {
    HomeProductCategory.hortifruti => const _CategoryVisuals(
      description:
          'Frutas, legumes e vegetais para abastecer a semana com itens frescos.',
      accentColor: Color(0xFF2F8B37),
      secondaryColor: Color(0xFF5DBB63),
      tintColor: Color(0xFFEAF6E6),
      materialIcon: Icons.eco_rounded,
      cupertinoIcon: CupertinoIcons.leaf_arrow_circlepath,
    ),
    HomeProductCategory.bebidas => const _CategoryVisuals(
      description:
          'Cafe, sucos e bebidas para consumo rapido ou reposicao da geladeira.',
      accentColor: Color(0xFF8A5A3B),
      secondaryColor: Color(0xFFC08A57),
      tintColor: Color(0xFFF7EEE4),
      materialIcon: Icons.local_cafe_rounded,
      cupertinoIcon: CupertinoIcons.drop,
    ),
    HomeProductCategory.mercearia => const _CategoryVisuals(
      description:
          'Base da despensa com itens secos, graos e ingredientes de uso diario.',
      accentColor: Color(0xFF5B3A29),
      secondaryColor: Color(0xFFB57D4F),
      tintColor: Color(0xFFF4E6DA),
      materialIcon: Icons.kitchen_rounded,
      cupertinoIcon: CupertinoIcons.cube_box,
    ),
    HomeProductCategory.padaria => const _CategoryVisuals(
      description:
          'Paes e itens frescos para cafe da manha, lanche e reposicao rapida.',
      accentColor: Color(0xFFC47D28),
      secondaryColor: Color(0xFFE2A34A),
      tintColor: Color(0xFFFFF2DE),
      materialIcon: Icons.breakfast_dining_rounded,
      cupertinoIcon: CupertinoIcons.bag,
    ),
    HomeProductCategory.proteinas => const _CategoryVisuals(
      description:
          'Carnes, peixes e ovos para montar refeicoes com mais sustancia.',
      accentColor: Color(0xFFD36F53),
      secondaryColor: Color(0xFFE79B81),
      tintColor: Color(0xFFFBE6DE),
      materialIcon: Icons.set_meal_rounded,
      cupertinoIcon: CupertinoIcons.flame,
    ),
    HomeProductCategory.limpeza => const _CategoryVisuals(
      description:
          'Produtos para casa, mesa e manutencao da rotina com reposicao pratica.',
      accentColor: Color(0xFF3A8C82),
      secondaryColor: Color(0xFF73BEB5),
      tintColor: Color(0xFFE6F5F2),
      materialIcon: Icons.cleaning_services_rounded,
      cupertinoIcon: CupertinoIcons.sparkles,
    ),
    HomeProductCategory.higiene => const _CategoryVisuals(
      description:
          'Cuidado pessoal com itens de rotina para complementar o pedido.',
      accentColor: Color(0xFF3A6D84),
      secondaryColor: Color(0xFF82B8CC),
      tintColor: Color(0xFFE9F3F7),
      materialIcon: Icons.spa_rounded,
      cupertinoIcon: CupertinoIcons.drop,
    ),
    HomeProductCategory.lanches => const _CategoryVisuals(
      description:
          'Snacks, doces e complementos para pausas curtas ao longo do dia.',
      accentColor: Color(0xFF8F5D3B),
      secondaryColor: Color(0xFFC98E5B),
      tintColor: Color(0xFFF7EEE4),
      materialIcon: Icons.cookie_rounded,
      cupertinoIcon: CupertinoIcons.sun_max,
    ),
    null => const _CategoryVisuals(
      description:
          'Veja todo o catalogo em uma unica camada e troque de categoria sem perder o contexto do carrinho.',
      accentColor: Color(0xFF8F5D3B),
      secondaryColor: Color(0xFFC98E5B),
      tintColor: Color(0xFFF7EEE4),
      materialIcon: Icons.grid_view_rounded,
      cupertinoIcon: CupertinoIcons.square_grid_2x2,
    ),
  };
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
