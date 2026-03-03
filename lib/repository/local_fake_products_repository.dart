import 'package:app_mercadofacil/model/home_product.dart';
import 'package:flutter/material.dart';

/// Fonte estatica de produtos inteiramente em memoria.
///
/// Este repositorio existe para alimentar a home com um catalogo fake sem
/// depender de persistencia ou transformacoes extras. Ele funciona como seed
/// visual imediato e como referencia simples para comparacao com a fonte Hive.
class LocalFakeProductsRepository {
  LocalFakeProductsRepository._();

  static const List<HomeProduct> _products = [
    HomeProduct(
      id: 'local_tomate_cereja',
      name: 'Tomate Cereja',
      details: 'bandeja 250g',
      priceCents: 999,
      emoji: '🍅',
      imageLabel: 'Fresco',
      imageColors: [Color(0xFFFAC9C4), Color(0xFFF38C85)],
    ),
    HomeProduct(
      id: 'local_iogurte_natural_yomax',
      name: 'Iogurte Natural Yomax',
      details: 'pote 500g',
      priceCents: 599,
      emoji: '🥛',
      imageLabel: 'Natural',
      imageColors: [Color(0xFFF5F2E8), Color(0xFFE2D7C7)],
    ),
    HomeProduct(
      id: 'local_banana_prata',
      name: 'Banana Prata',
      details: 'cacho 1kg',
      priceCents: 649,
      emoji: '🍌',
      imageLabel: 'Doce',
      imageColors: [Color(0xFFFFE48B), Color(0xFFF7C948)],
    ),
    HomeProduct(
      id: 'local_abacate_hass',
      name: 'Abacate Hass',
      details: 'unidade',
      priceCents: 790,
      emoji: '🥑',
      imageLabel: 'Cremoso',
      imageColors: [Color(0xFFD9F0D8), Color(0xFF9BCB78)],
    ),
    HomeProduct(
      id: 'local_leite_integral',
      name: 'Leite Integral',
      details: 'caixa 1L',
      priceCents: 489,
      emoji: '🥛',
      imageLabel: 'Integral',
      imageColors: [Color(0xFFF6F7FB), Color(0xFFDDE3F0)],
    ),
    HomeProduct(
      id: 'local_queijo_minas_frescal',
      name: 'Queijo Minas Frescal',
      details: 'peça 400g',
      priceCents: 1450,
      emoji: '🧀',
      imageLabel: 'Minas',
      imageColors: [Color(0xFFFFF1B8), Color(0xFFFFD45A)],
    ),
    HomeProduct(
      id: 'local_cafe_torrado_premium',
      name: 'Café Torrado Premium',
      details: 'pacote 500g',
      priceCents: 1890,
      emoji: '☕',
      imageLabel: 'Premium',
      imageColors: [Color(0xFFE7D3BE), Color(0xFFC08A57)],
    ),
    HomeProduct(
      id: 'local_arroz_integral',
      name: 'Arroz Integral',
      details: 'pacote 1kg',
      priceCents: 879,
      emoji: '🍚',
      imageLabel: 'Integral',
      imageColors: [Color(0xFFF4ECDC), Color(0xFFE0D2B7)],
    ),
    HomeProduct(
      id: 'local_feijao_carioca',
      name: 'Feijão Carioca',
      details: 'pacote 1kg',
      priceCents: 799,
      emoji: '🫘',
      imageLabel: 'Carioca',
      imageColors: [Color(0xFFE6D5C7), Color(0xFFC79A79)],
    ),
    HomeProduct(
      id: 'local_suco_de_laranja',
      name: 'Suco de Laranja',
      details: 'garrafa 900ml',
      priceCents: 1099,
      emoji: '🍊',
      imageLabel: 'Gelado',
      imageColors: [Color(0xFFFFDEB5), Color(0xFFFFA845)],
    ),
    HomeProduct(
      id: 'local_pao_de_forma',
      name: 'Pão de Forma',
      details: 'pacote 500g',
      priceCents: 849,
      emoji: '🍞',
      imageLabel: 'Macio',
      imageColors: [Color(0xFFF0DFC8), Color(0xFFD3AB74)],
    ),
    HomeProduct(
      id: 'local_peito_de_frango',
      name: 'Peito de Frango',
      details: 'bandeja 1kg',
      priceCents: 1690,
      emoji: '🍗',
      imageLabel: 'Proteína',
      imageColors: [Color(0xFFF9DED1), Color(0xFFEAA37E)],
    ),
    HomeProduct(
      id: 'local_file_de_tilapia',
      name: 'Filé de Tilápia',
      details: 'bandeja 600g',
      priceCents: 2490,
      emoji: '🐟',
      imageLabel: 'Leve',
      imageColors: [Color(0xFFD9ECF7), Color(0xFF87B9D8)],
    ),
    HomeProduct(
      id: 'local_detergente_neutro',
      name: 'Detergente Neutro',
      details: 'frasco 500ml',
      priceCents: 269,
      emoji: '🧴',
      imageLabel: 'Casa',
      imageColors: [Color(0xFFDFF5EA), Color(0xFF94D7AF)],
    ),
    HomeProduct(
      id: 'local_papel_toalha',
      name: 'Papel Toalha',
      details: 'pacote 2 rolos',
      priceCents: 699,
      emoji: '🧻',
      imageLabel: 'Multiuso',
      imageColors: [Color(0xFFF5F2EE), Color(0xFFE0D9D1)],
    ),
    HomeProduct(
      id: 'local_sabonete_vegetal',
      name: 'Sabonete Vegetal',
      details: 'barra 90g',
      priceCents: 349,
      emoji: '🧼',
      imageLabel: 'Suave',
      imageColors: [Color(0xFFE2F2F4), Color(0xFF9FD2D7)],
    ),
    HomeProduct(
      id: 'local_chocolate_70',
      name: 'Chocolate 70%',
      details: 'barra 100g',
      priceCents: 949,
      emoji: '🍫',
      imageLabel: 'Cacau',
      imageColors: [Color(0xFFE3D2CA), Color(0xFF9B6B5A)],
    ),
    HomeProduct(
      id: 'local_granola_tradicional',
      name: 'Granola Tradicional',
      details: 'pacote 800g',
      priceCents: 1390,
      emoji: '🥣',
      imageLabel: 'Crocante',
      imageColors: [Color(0xFFF3E3BF), Color(0xFFD6A960)],
    ),
    HomeProduct(
      id: 'local_agua_com_gas',
      name: 'Água com Gás',
      details: 'garrafa 1,5L',
      priceCents: 299,
      emoji: '💧',
      imageLabel: 'Refrescante',
      imageColors: [Color(0xFFDDF0FF), Color(0xFF8BC0E8)],
    ),
    HomeProduct(
      id: 'local_ovos_caipiras',
      name: 'Ovos Caipiras',
      details: 'cartela 12 un',
      priceCents: 1290,
      emoji: '🥚',
      imageLabel: 'Caipira',
      imageColors: [Color(0xFFF7EFD8), Color(0xFFE3C887)],
    ),
  ];

  /// Retorna a colecao local de produtos usada pela home.
  static List<HomeProduct> getProducts() {
    return _products;
  }
}
