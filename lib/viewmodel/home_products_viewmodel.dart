import 'package:app_mercadofacil/model/home_product.dart';
import 'package:app_mercadofacil/model/home_promotional_banner.dart';
import 'package:app_mercadofacil/repository/hive_fake_products_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';

/// View model da home responsavel por expor o catalogo salvo em Hive.
///
/// A classe observa mudancas no repositorio persistido, mantem o estado
/// minimamente necessario para a tela e notifica a UI com `ChangeNotifier`.
class HomeProductsViewModel extends ChangeNotifier {
  HomeProductsViewModel() {
    _repositoryListenable = HiveFakeProductsRepository.listenable();
    _repositoryListenable.addListener(_handleRepositoryChanged);
    _refreshCatalog();
  }

  late final ValueListenable<Box<Map>> _repositoryListenable;
  List<HomeProduct> _catalogProducts = const [];
  List<HomeProduct> _products = const [];
  List<HomePromotionalBanner> _promotionalBanners = const [];
  List<HomeProductCategory> _availableCategories = const [];
  String _searchQuery = '';
  HomeProductCategory? _selectedCategory;

  /// Lista completa de produtos carregada do repositorio.
  List<HomeProduct> get catalogProducts => _catalogProducts;

  /// Lista de produtos pronta para renderizacao.
  List<HomeProduct> get products => _products;

  /// Banners promocionais usados na faixa horizontal da home.
  List<HomePromotionalBanner> get promotionalBanners => _promotionalBanners;

  /// Categorias simples usadas como atalhos horizontais na home.
  List<HomeProductCategory> get availableCategories => _availableCategories;

  /// Texto atual da busca.
  String get searchQuery => _searchQuery;

  /// Categoria atualmente aplicada, ou `null` quando o catalogo esta completo.
  HomeProductCategory? get selectedCategory => _selectedCategory;

  bool get hasActiveFilters =>
      _searchQuery.trim().isNotEmpty || _selectedCategory != null;

  String get resultsSummary {
    final countLabel = switch (_products.length) {
      0 => 'Nenhum resultado',
      1 => '1 resultado',
      _ => '${_products.length} resultados',
    };

    if (!hasActiveFilters) {
      return '$countLabel no catalogo de hoje';
    }

    final activeLabels = <String>[
      if (_selectedCategory != null) _selectedCategory!.label,
      if (_searchQuery.trim().isNotEmpty) '"${_searchQuery.trim()}"',
    ];

    return activeLabels.isEmpty
        ? countLabel
        : '$countLabel • ${activeLabels.join(' • ')}';
  }

  @override
  void dispose() {
    _repositoryListenable.removeListener(_handleRepositoryChanged);
    super.dispose();
  }

  void updateSearchQuery(String value) {
    if (_searchQuery == value) {
      return;
    }

    _searchQuery = value;
    _applyFilters(notify: true);
  }

  void selectCategory(HomeProductCategory? category) {
    if (_selectedCategory == category) {
      return;
    }

    _selectedCategory = category;
    _applyFilters(notify: true);
  }

  void clearFilters() {
    if (!hasActiveFilters) {
      return;
    }

    _searchQuery = '';
    _selectedCategory = null;
    _applyFilters(notify: true);
  }

  void _handleRepositoryChanged() {
    _refreshCatalog(notify: true);
  }

  void _refreshCatalog({bool notify = false}) {
    _catalogProducts = HiveFakeProductsRepository.getProducts();
    _promotionalBanners = HiveFakeProductsRepository.getPromotionalBanners();
    _availableCategories = _deriveAvailableCategories(_catalogProducts);
    if (_selectedCategory != null &&
        !_availableCategories.contains(_selectedCategory)) {
      _selectedCategory = null;
    }
    _applyFilters(notify: notify);
  }

  void _applyFilters({bool notify = false}) {
    final normalizedQuery = normalizeHomeCatalogText(_searchQuery);

    _products = _catalogProducts
        .where((product) {
          final matchesCategory =
              _selectedCategory == null ||
              product.category == _selectedCategory;
          final matchesQuery =
              normalizedQuery.isEmpty || product.matchesSearch(normalizedQuery);

          return matchesCategory && matchesQuery;
        })
        .toList(growable: false);

    if (notify) {
      notifyListeners();
    }
  }

  List<HomeProductCategory> _deriveAvailableCategories(
    List<HomeProduct> products,
  ) {
    final categories = <HomeProductCategory>{};

    for (final product in products) {
      categories.add(product.category);
    }

    return HomeProductCategory.values
        .where(categories.contains)
        .toList(growable: false);
  }
}
