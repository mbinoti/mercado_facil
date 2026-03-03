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
  List<HomeProduct> _products = const [];
  List<HomePromotionalBanner> _promotionalBanners = const [];

  /// Lista de produtos pronta para renderizacao.
  List<HomeProduct> get products => _products;

  /// Banners promocionais usados na faixa horizontal da home.
  List<HomePromotionalBanner> get promotionalBanners => _promotionalBanners;

  @override
  void dispose() {
    _repositoryListenable.removeListener(_handleRepositoryChanged);
    super.dispose();
  }

  void _handleRepositoryChanged() {
    _refreshCatalog(notify: true);
  }

  void _refreshCatalog({bool notify = false}) {
    _products = HiveFakeProductsRepository.getProducts();
    _promotionalBanners = HiveFakeProductsRepository.getPromotionalBanners();

    if (notify) {
      notifyListeners();
    }
  }
}
