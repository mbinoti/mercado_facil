import 'package:app_mercadofacil/model/home_product.dart';
import 'package:app_mercadofacil/repository/hive_fake_products_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';

enum HomeProductsSource { local, hiveRepository }

class HomeProductsViewModel extends ChangeNotifier {
  HomeProductsViewModel({
    HomeProductsSource initialSource = HomeProductsSource.local,
  }) : _selectedSource = initialSource {
    _repositoryListenable = HiveFakeProductsRepository.listenable();
    _repositoryListenable.addListener(_handleRepositoryChanged);
    _products = _resolveProducts();
  }

  late final ValueListenable<Box<Map>> _repositoryListenable;
  HomeProductsSource _selectedSource;
  List<HomeProduct> _products = const [];

  HomeProductsSource get selectedSource => _selectedSource;
  List<HomeProduct> get products => _products;

  void selectSource(HomeProductsSource source) {
    if (_selectedSource == source) {
      return;
    }

    _selectedSource = source;
    _products = _resolveProducts();
    notifyListeners();
  }

  @override
  void dispose() {
    _repositoryListenable.removeListener(_handleRepositoryChanged);
    super.dispose();
  }

  void _handleRepositoryChanged() {
    if (_selectedSource != HomeProductsSource.hiveRepository) {
      return;
    }

    _products = _resolveProducts();
    notifyListeners();
  }

  List<HomeProduct> _resolveProducts() {
    switch (_selectedSource) {
      case HomeProductsSource.local:
        return _localProducts;
      case HomeProductsSource.hiveRepository:
        return HiveFakeProductsRepository.getCachedProducts()
            .map(HomeProduct.fromRepositoryMap)
            .toList(growable: false);
    }
  }

  static const List<HomeProduct> _localProducts = [
    HomeProduct(
      name: 'Tomate Cereja',
      details: 'bandeja 250g',
      price: 'R\$ 9,99',
      emoji: '🍅',
      imageLabel: 'Fresco',
      imageColors: [Color(0xFFFAC9C4), Color(0xFFF38C85)],
    ),
    HomeProduct(
      name: 'Iogurte Natural Yomax',
      details: 'pote 500g',
      price: 'R\$ 5,99',
      emoji: '🥛',
      imageLabel: 'Natural',
      imageColors: [Color(0xFFF5F2E8), Color(0xFFE2D7C7)],
    ),
    HomeProduct(
      name: 'Banana Prata',
      details: 'cacho 1kg',
      price: 'R\$ 6,49',
      emoji: '🍌',
      imageLabel: 'Doce',
      imageColors: [Color(0xFFFFE48B), Color(0xFFF7C948)],
    ),
    HomeProduct(
      name: 'Abacate Hass',
      details: 'unidade',
      price: 'R\$ 7,90',
      emoji: '🥑',
      imageLabel: 'Cremoso',
      imageColors: [Color(0xFFD9F0D8), Color(0xFF9BCB78)],
    ),
    HomeProduct(
      name: 'Leite Integral',
      details: 'caixa 1L',
      price: 'R\$ 4,89',
      emoji: '🥛',
      imageLabel: 'Integral',
      imageColors: [Color(0xFFF6F7FB), Color(0xFFDDE3F0)],
    ),
    HomeProduct(
      name: 'Queijo Minas Frescal',
      details: 'peça 400g',
      price: 'R\$ 14,50',
      emoji: '🧀',
      imageLabel: 'Minas',
      imageColors: [Color(0xFFFFF1B8), Color(0xFFFFD45A)],
    ),
    HomeProduct(
      name: 'Café Torrado Premium',
      details: 'pacote 500g',
      price: 'R\$ 18,90',
      emoji: '☕',
      imageLabel: 'Premium',
      imageColors: [Color(0xFFE7D3BE), Color(0xFFC08A57)],
    ),
    HomeProduct(
      name: 'Arroz Integral',
      details: 'pacote 1kg',
      price: 'R\$ 8,79',
      emoji: '🍚',
      imageLabel: 'Integral',
      imageColors: [Color(0xFFF4ECDC), Color(0xFFE0D2B7)],
    ),
    HomeProduct(
      name: 'Feijão Carioca',
      details: 'pacote 1kg',
      price: 'R\$ 7,99',
      emoji: '🫘',
      imageLabel: 'Carioca',
      imageColors: [Color(0xFFE6D5C7), Color(0xFFC79A79)],
    ),
    HomeProduct(
      name: 'Suco de Laranja',
      details: 'garrafa 900ml',
      price: 'R\$ 10,99',
      emoji: '🍊',
      imageLabel: 'Gelado',
      imageColors: [Color(0xFFFFDEB5), Color(0xFFFFA845)],
    ),
    HomeProduct(
      name: 'Pão de Forma',
      details: 'pacote 500g',
      price: 'R\$ 8,49',
      emoji: '🍞',
      imageLabel: 'Macio',
      imageColors: [Color(0xFFF0DFC8), Color(0xFFD3AB74)],
    ),
    HomeProduct(
      name: 'Peito de Frango',
      details: 'bandeja 1kg',
      price: 'R\$ 16,90',
      emoji: '🍗',
      imageLabel: 'Proteína',
      imageColors: [Color(0xFFF9DED1), Color(0xFFEAA37E)],
    ),
    HomeProduct(
      name: 'Filé de Tilápia',
      details: 'bandeja 600g',
      price: 'R\$ 24,90',
      emoji: '🐟',
      imageLabel: 'Leve',
      imageColors: [Color(0xFFD9ECF7), Color(0xFF87B9D8)],
    ),
    HomeProduct(
      name: 'Detergente Neutro',
      details: 'frasco 500ml',
      price: 'R\$ 2,69',
      emoji: '🧴',
      imageLabel: 'Casa',
      imageColors: [Color(0xFFDFF5EA), Color(0xFF94D7AF)],
    ),
    HomeProduct(
      name: 'Papel Toalha',
      details: 'pacote 2 rolos',
      price: 'R\$ 6,99',
      emoji: '🧻',
      imageLabel: 'Multiuso',
      imageColors: [Color(0xFFF5F2EE), Color(0xFFE0D9D1)],
    ),
    HomeProduct(
      name: 'Sabonete Vegetal',
      details: 'barra 90g',
      price: 'R\$ 3,49',
      emoji: '🧼',
      imageLabel: 'Suave',
      imageColors: [Color(0xFFE2F2F4), Color(0xFF9FD2D7)],
    ),
    HomeProduct(
      name: 'Chocolate 70%',
      details: 'barra 100g',
      price: 'R\$ 9,49',
      emoji: '🍫',
      imageLabel: 'Cacau',
      imageColors: [Color(0xFFE3D2CA), Color(0xFF9B6B5A)],
    ),
    HomeProduct(
      name: 'Granola Tradicional',
      details: 'pacote 800g',
      price: 'R\$ 13,90',
      emoji: '🥣',
      imageLabel: 'Crocante',
      imageColors: [Color(0xFFF3E3BF), Color(0xFFD6A960)],
    ),
    HomeProduct(
      name: 'Água com Gás',
      details: 'garrafa 1,5L',
      price: 'R\$ 2,99',
      emoji: '💧',
      imageLabel: 'Refrescante',
      imageColors: [Color(0xFFDDF0FF), Color(0xFF8BC0E8)],
    ),
    HomeProduct(
      name: 'Ovos Caipiras',
      details: 'cartela 12 un',
      price: 'R\$ 12,90',
      emoji: '🥚',
      imageLabel: 'Caipira',
      imageColors: [Color(0xFFF7EFD8), Color(0xFFE3C887)],
    ),
  ];
}
