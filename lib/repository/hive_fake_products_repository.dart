import 'package:flutter/foundation.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';

class HiveFakeProductsRepository {
  HiveFakeProductsRepository._();

  static const String boxName = 'fake_products_box';
  static const String _metaKey = '__meta__';
  static const int _seedVersion = 2;

  static const List<Map<String, Object>> _seedProducts = [
    {
      'type': 'product',
      'id': 'tomate_italiano',
      'sortOrder': 0,
      'name': 'Tomate Italiano',
      'details': 'kg',
      'priceCents': 1190,
      'visualKey': 'tomato',
      'imageLabel': 'Horta',
      'imageColorHexes': [0xFFF8CBC5, 0xFFE87063],
    },
    {
      'type': 'product',
      'id': 'kefir_natural',
      'sortOrder': 1,
      'name': 'Kefir Natural',
      'details': 'garrafa 500ml',
      'priceCents': 1290,
      'visualKey': 'yogurt',
      'imageLabel': 'Probiótico',
      'imageColorHexes': [0xFFF4F1EA, 0xFFD4C5B2],
    },
    {
      'type': 'product',
      'id': 'maca_fuji',
      'sortOrder': 2,
      'name': 'Maçã Fuji',
      'details': 'kg',
      'priceCents': 899,
      'visualKey': 'apple',
      'imageLabel': 'Crocante',
      'imageColorHexes': [0xFFF9D4D4, 0xFFE35D5B],
    },
    {
      'type': 'product',
      'id': 'kiwi_gold',
      'sortOrder': 3,
      'name': 'Kiwi Gold',
      'details': 'bandeja 4 un',
      'priceCents': 1349,
      'visualKey': 'kiwi',
      'imageLabel': 'Importado',
      'imageColorHexes': [0xFFE6F0C4, 0xFFB8C95A],
    },
    {
      'type': 'product',
      'id': 'bebida_de_aveia_barista',
      'sortOrder': 4,
      'name': 'Bebida de Aveia Barista',
      'details': 'caixa 1L',
      'priceCents': 990,
      'visualKey': 'oat_milk',
      'imageLabel': 'Vegano',
      'imageColorHexes': [0xFFF2E7D8, 0xFFD2B38E],
    },
    {
      'type': 'product',
      'id': 'parmesao_ralado',
      'sortOrder': 5,
      'name': 'Parmesão Ralado',
      'details': 'pacote 100g',
      'priceCents': 780,
      'visualKey': 'cheese',
      'imageLabel': 'Especial',
      'imageColorHexes': [0xFFFFF0B2, 0xFFF5C84A],
    },
    {
      'type': 'product',
      'id': 'cappuccino_cremoso',
      'sortOrder': 6,
      'name': 'Cappuccino Cremoso',
      'details': 'pote 200g',
      'priceCents': 1590,
      'visualKey': 'coffee',
      'imageLabel': 'Café',
      'imageColorHexes': [0xFFE4D0BE, 0xFFB57D4F],
    },
    {
      'type': 'product',
      'id': 'quinoa_branca',
      'sortOrder': 7,
      'name': 'Quinoa Branca',
      'details': 'pacote 500g',
      'priceCents': 1499,
      'visualKey': 'quinoa',
      'imageLabel': 'Grãos',
      'imageColorHexes': [0xFFF1E6D6, 0xFFD8C1A1],
    },
    {
      'type': 'product',
      'id': 'lentilha_selecionada',
      'sortOrder': 8,
      'name': 'Lentilha Selecionada',
      'details': 'pacote 500g',
      'priceCents': 689,
      'visualKey': 'lentils',
      'imageLabel': 'Seleção',
      'imageColorHexes': [0xFFE6DCC4, 0xFFB59A61],
    },
    {
      'type': 'product',
      'id': 'suco_de_uva_integral',
      'sortOrder': 9,
      'name': 'Suco de Uva Integral',
      'details': 'garrafa 1,5L',
      'priceCents': 1699,
      'visualKey': 'grape_juice',
      'imageLabel': 'Integral',
      'imageColorHexes': [0xFFE3D5F1, 0xFF8C63B8],
    },
    {
      'type': 'product',
      'id': 'brioche_artesanal',
      'sortOrder': 10,
      'name': 'Brioche Artesanal',
      'details': 'pacote 400g',
      'priceCents': 1149,
      'visualKey': 'bread',
      'imageLabel': 'Padaria',
      'imageColorHexes': [0xFFF3E0C9, 0xFFC99658],
    },
    {
      'type': 'product',
      'id': 'coxa_sobrecoxa',
      'sortOrder': 11,
      'name': 'Coxa e Sobrecoxa',
      'details': 'bandeja 1kg',
      'priceCents': 1390,
      'visualKey': 'chicken',
      'imageLabel': 'Açougue',
      'imageColorHexes': [0xFFF6D8CC, 0xFFD98D74],
    },
    {
      'type': 'product',
      'id': 'salmao_em_postas',
      'sortOrder': 12,
      'name': 'Salmão em Postas',
      'details': 'bandeja 500g',
      'priceCents': 3690,
      'visualKey': 'salmon',
      'imageLabel': 'Peixaria',
      'imageColorHexes': [0xFFF5D7CF, 0xFFE18A73],
    },
    {
      'type': 'product',
      'id': 'limpador_multiuso_citrus',
      'sortOrder': 13,
      'name': 'Limpador Multiuso Citrus',
      'details': 'frasco 500ml',
      'priceCents': 579,
      'visualKey': 'cleaner',
      'imageLabel': 'Limpeza',
      'imageColorHexes': [0xFFD8F1DD, 0xFF68C67D],
    },
    {
      'type': 'product',
      'id': 'guardanapo_folha_dupla',
      'sortOrder': 14,
      'name': 'Guardanapo Folha Dupla',
      'details': 'pacote 50 un',
      'priceCents': 429,
      'visualKey': 'napkins',
      'imageLabel': 'Mesa',
      'imageColorHexes': [0xFFF6F3EF, 0xFFD9D1C5],
    },
    {
      'type': 'product',
      'id': 'shampoo_hidratante',
      'sortOrder': 15,
      'name': 'Shampoo Hidratante',
      'details': 'frasco 350ml',
      'priceCents': 1490,
      'visualKey': 'shampoo',
      'imageLabel': 'Higiene',
      'imageColorHexes': [0xFFE1F0F5, 0xFF80BDD2],
    },
    {
      'type': 'product',
      'id': 'cookie_chocolate',
      'sortOrder': 16,
      'name': 'Cookie de Chocolate',
      'details': 'caixa 120g',
      'priceCents': 659,
      'visualKey': 'cookie',
      'imageLabel': 'Lanche',
      'imageColorHexes': [0xFFE6D5CB, 0xFF9B715F],
    },
    {
      'type': 'product',
      'id': 'mix_de_castanhas',
      'sortOrder': 17,
      'name': 'Mix de Castanhas',
      'details': 'pacote 250g',
      'priceCents': 1990,
      'visualKey': 'nuts',
      'imageLabel': 'Snack',
      'imageColorHexes': [0xFFF0DFC7, 0xFFC58B53],
    },
    {
      'type': 'product',
      'id': 'agua_de_coco',
      'sortOrder': 18,
      'name': 'Água de Coco',
      'details': 'garrafa 1L',
      'priceCents': 839,
      'visualKey': 'coconut_water',
      'imageLabel': 'Tropical',
      'imageColorHexes': [0xFFEBF6E2, 0xFF8CC87B],
    },
    {
      'type': 'product',
      'id': 'ovos_jumbo',
      'sortOrder': 19,
      'name': 'Ovos Jumbo',
      'details': 'cartela 10 un',
      'priceCents': 1399,
      'visualKey': 'eggs',
      'imageLabel': 'Granja',
      'imageColorHexes': [0xFFF6ECD4, 0xFFDABA77],
    },
  ];

  static bool _initialized = false;

  static Future<void> initialize() async {
    if (_initialized) {
      return;
    }

    await Hive.initFlutter();
    await Hive.openBox<Map>(boxName);
    _initialized = true;
    await seedIfNeeded();
  }

  static ValueListenable<Box<Map>> listenable() {
    return _box.listenable();
  }

  static List<Map<String, dynamic>> getCachedProducts() {
    final products = _box.values
        .whereType<Map>()
        .map((item) => Map<String, dynamic>.from(item))
        .where((item) => item['type'] == 'product')
        .toList(growable: false);

    products.sort(
      (left, right) =>
          (left['sortOrder'] as int).compareTo(right['sortOrder'] as int),
    );

    return products;
  }

  static Map<String, dynamic>? getCachedProductById(String id) {
    final product = _box.get(id);
    if (product == null) {
      return null;
    }

    return Map<String, dynamic>.from(product);
  }

  static Future<void> seedIfNeeded() async {
    final meta = _box.get(_metaKey);
    final savedVersion = meta == null
        ? null
        : Map<String, dynamic>.from(meta)['seedVersion'] as int?;
    final hasProducts = _box.keys.any((key) => key != _metaKey);

    if (savedVersion == _seedVersion && hasProducts) {
      return;
    }

    await reseed();
  }

  static Future<void> reseed() async {
    await _box.clear();

    for (final product in _seedProducts) {
      await _box.put(product['id']! as String, product);
    }

    await _box.put(_metaKey, {
      'type': 'meta',
      'seedVersion': _seedVersion,
      'updatedAt': DateTime.now().toIso8601String(),
    });
  }

  static Future<void> saveProduct(Map<String, dynamic> product) async {
    final id = product['id'] as String?;
    if (id == null || id.isEmpty) {
      throw ArgumentError('Product id is required.');
    }

    final normalized = Map<String, dynamic>.from(product)..['type'] = 'product';
    await _box.put(id, normalized);
  }

  static Future<void> deleteProduct(String id) async {
    await _box.delete(id);
  }

  static Box<Map> get _box {
    if (!Hive.isBoxOpen(boxName)) {
      throw StateError(
        'HiveFakeProductsRepository.initialize() must run before accessing the box.',
      );
    }

    return Hive.box<Map>(boxName);
  }
}
