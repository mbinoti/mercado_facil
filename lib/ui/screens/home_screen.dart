import 'package:app_mercadofacil/model/home_product.dart';
import 'package:app_mercadofacil/viewmodel/home_products_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    super.key,
    this.initialSource = HomeProductsSource.local,
    this.showSourceSwitcher = true,
  });

  final HomeProductsSource initialSource;
  final bool showSourceSwitcher;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HomeProductsViewModel(initialSource: initialSource),
      child: _HomeScreenView(showSourceSwitcher: showSourceSwitcher),
    );
  }
}

class _HomeScreenView extends StatelessWidget {
  const _HomeScreenView({required this.showSourceSwitcher});

  final bool showSourceSwitcher;

  @override
  Widget build(BuildContext context) {
    return Selector<HomeProductsViewModel, HomeProductsSource>(
      selector: (context, viewModel) => viewModel.selectedSource,
      builder: (context, selectedSource, child) {
        final visuals = _visualsForSource(selectedSource);

        return Scaffold(
          backgroundColor: visuals.backgroundColor,
          body: AnimatedContainer(
            duration: const Duration(milliseconds: 260),
            curve: Curves.easeOutCubic,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  visuals.backgroundColor,
                  visuals.backgroundColor,
                  visuals.backgroundColor.withValues(alpha: 0.92),
                ],
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  if (showSourceSwitcher)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(12, 12, 12, 6),
                      child: Consumer<HomeProductsViewModel>(
                        builder: (context, viewModel, child) {
                          return _HomeSourceSwitcher(
                            selectedSource: viewModel.selectedSource,
                            visuals: visuals,
                            onChanged: context
                                .read<HomeProductsViewModel>()
                                .selectSource,
                          );
                        },
                      ),
                    ),
                  Expanded(
                    child: Selector<HomeProductsViewModel, List<HomeProduct>>(
                      selector: (context, viewModel) => viewModel.products,
                      builder: (context, products, child) {
                        return _ProductsGrid(products: products);
                      },
                    ),
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

class _HomeSourceSwitcher extends StatelessWidget {
  const _HomeSourceSwitcher({
    required this.selectedSource,
    required this.visuals,
    required this.onChanged,
  });

  final HomeProductsSource selectedSource;
  final _SourceVisuals visuals;
  final ValueChanged<HomeProductsSource> onChanged;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Produtos',
          style: textTheme.headlineMedium?.copyWith(
            fontSize: 28,
            fontWeight: FontWeight.w900,
            color: const Color(0xFF111A30),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Escolha entre os dados locais da tela ou os dados fake salvos no Hive.',
          style: textTheme.bodyMedium?.copyWith(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF6F7784),
          ),
        ),
        const SizedBox(height: 10),
        DecoratedBox(
          decoration: BoxDecoration(
            color: visuals.accentColor.withValues(alpha: 0.14),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(
              color: visuals.accentColor.withValues(alpha: 0.24),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(visuals.icon, size: 16, color: visuals.accentColor),
                const SizedBox(width: 6),
                Text(
                  'Fonte atual: ${visuals.label}',
                  style: textTheme.bodySmall?.copyWith(
                    color: visuals.accentColor,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: SegmentedButton<HomeProductsSource>(
            showSelectedIcon: false,
            segments: const [
              ButtonSegment<HomeProductsSource>(
                value: HomeProductsSource.local,
                label: Text('Local'),
              ),
              ButtonSegment<HomeProductsSource>(
                value: HomeProductsSource.hiveRepository,
                label: Text('Hive'),
              ),
            ],
            selected: {selectedSource},
            onSelectionChanged: (selection) {
              onChanged(selection.first);
            },
          ),
        ),
      ],
    );
  }
}

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
        final itemExtent = itemWidth + 120;

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

class _EmptyProductsState extends StatelessWidget {
  const _EmptyProductsState();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.inventory_2_outlined,
              size: 44,
              color: Color(0xFF7C838D),
            ),
            const SizedBox(height: 12),
            Text(
              'Nenhum produto encontrado.',
              style: textTheme.titleMedium?.copyWith(
                color: const Color(0xFF111A30),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Confira se o seed do Hive foi executado ou mude para a fonte local.',
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

class _ProductCard extends StatelessWidget {
  const _ProductCard({required this.product});

  final HomeProduct product;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return LayoutBuilder(
      builder: (context, constraints) {
        final imageSide = constraints.maxWidth - 24;

        return DecoratedBox(
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
                SizedBox.square(
                  dimension: imageSide,
                  child: _ProductImage(product: product),
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
                Text(
                  product.price,
                  style: textTheme.headlineMedium?.copyWith(
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    color: const Color(0xFF2F8B37),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ProductImage extends StatelessWidget {
  const _ProductImage({required this.product});

  final HomeProduct product;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: product.imageColors,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -18,
            right: -12,
            child: Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.25),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            bottom: -24,
            left: -14,
            child: Container(
              width: 92,
              height: 92,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.18),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.86),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    child: Text(
                      product.imageLabel,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: const Color(0xFF3A3A3A),
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
                const Spacer(),
                Center(
                  child: Text(
                    product.emoji,
                    style: const TextStyle(fontSize: 70, height: 1),
                  ),
                ),
                const Spacer(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SourceVisuals {
  const _SourceVisuals({
    required this.label,
    required this.icon,
    required this.backgroundColor,
    required this.accentColor,
  });

  final String label;
  final IconData icon;
  final Color backgroundColor;
  final Color accentColor;
}

_SourceVisuals _visualsForSource(HomeProductsSource source) {
  return switch (source) {
    HomeProductsSource.local => const _SourceVisuals(
      label: 'Local',
      icon: Icons.phone_android_rounded,
      backgroundColor: Color(0xFFF6F1EB),
      accentColor: Color(0xFF8F5D3B),
    ),
    HomeProductsSource.hiveRepository => const _SourceVisuals(
      label: 'Hive',
      icon: Icons.storage_rounded,
      backgroundColor: Color(0xFFEEF6EA),
      accentColor: Color(0xFF2F8B37),
    ),
  };
}
