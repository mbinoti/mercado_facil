import 'package:flutter/material.dart';

class HomeProduct {
  const HomeProduct({
    required this.name,
    required this.details,
    required this.price,
    required this.emoji,
    required this.imageLabel,
    required this.imageColors,
  });

  factory HomeProduct.fromRepositoryMap(Map<String, dynamic> map) {
    final hexes = (map['imageColorHexes'] as List<dynamic>? ?? const [])
        .whereType<int>()
        .map(Color.new)
        .toList(growable: false);

    return HomeProduct(
      name: map['name'] as String? ?? 'Produto',
      details: map['details'] as String? ?? 'Sem detalhes',
      price: _formatPrice(map['priceCents'] as int? ?? 0),
      emoji: _emojiForVisualKey(map['visualKey'] as String?),
      imageLabel: map['imageLabel'] as String? ?? 'Mock',
      imageColors: hexes.isEmpty
          ? const [Color(0xFFE7E7E7), Color(0xFFD8D8D8)]
          : hexes,
    );
  }

  final String name;
  final String details;
  final String price;
  final String emoji;
  final String imageLabel;
  final List<Color> imageColors;
}

String _formatPrice(int cents) {
  final reais = cents ~/ 100;
  final centavos = (cents % 100).toString().padLeft(2, '0');
  return 'R\$ $reais,$centavos';
}

String _emojiForVisualKey(String? visualKey) {
  return switch (visualKey) {
    'tomato' => '🍅',
    'yogurt' => '🥛',
    'banana' => '🍌',
    'apple' => '🍎',
    'kiwi' => '🥝',
    'avocado' => '🥑',
    'milk' => '🥛',
    'oat_milk' => '🥛',
    'cheese' => '🧀',
    'coffee' => '☕',
    'rice' => '🍚',
    'quinoa' => '🍚',
    'beans' => '🫘',
    'lentils' => '🫘',
    'orange_juice' => '🍊',
    'grape_juice' => '🍇',
    'bread' => '🍞',
    'chicken' => '🍗',
    'fish' => '🐟',
    'salmon' => '🐟',
    'cleaner' => '🧴',
    'paper_towel' => '🧻',
    'napkins' => '🧻',
    'soap' => '🧼',
    'shampoo' => '🧴',
    'chocolate' => '🍫',
    'cookie' => '🍪',
    'granola' => '🥣',
    'nuts' => '🥜',
    'sparkling_water' => '💧',
    'coconut_water' => '🥥',
    'eggs' => '🥚',
    _ => '🛒',
  };
}
