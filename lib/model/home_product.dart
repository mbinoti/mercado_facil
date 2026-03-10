import 'package:flutter/material.dart';

enum HomeProductCategory {
  hortifruti,
  bebidas,
  mercearia,
  padaria,
  proteinas,
  limpeza,
  higiene,
  lanches,
}

/// Modelo de dominio usado pela home para renderizar um produto.
///
/// A classe representa exatamente o que a UI precisa: nome, detalhes,
/// preco numerico, identidade visual simplificada com emoji e as cores
/// usadas na arte do card.
///
/// Quando os dados chegam de uma estrutura mais bruta, como os mapas salvos
/// no Hive, a factory [HomeProduct.fromRepositoryMap] faz a normalizacao
/// necessaria para entregar um objeto pronto para apresentacao.
class HomeProduct {
  const HomeProduct({
    required this.id,
    required this.name,
    required this.details,
    required this.category,
    required this.priceCents,
    required this.emoji,
    required this.imageLabel,
    required this.imageColors,
    this.longDescription,
  });

  /// Converte um mapa vindo do repositorio em um [HomeProduct].
  ///
  /// Aplica fallbacks seguros para campos ausentes, transforma inteiros
  /// hexadecimais em `Color`, formata preco em centavos para texto e resolve
  /// uma chave visual em emoji para a camada de apresentacao.
  factory HomeProduct.fromRepositoryMap(Map<String, dynamic> map) {
    final hexes = (map['imageColorHexes'] as List<dynamic>? ?? const [])
        .whereType<int>()
        .map(Color.new)
        .toList(growable: false);

    return HomeProduct(
      id: map['id'] as String? ?? 'produto_sem_id',
      name: map['name'] as String? ?? 'Produto',
      details: map['details'] as String? ?? 'Sem detalhes',
      category: homeProductCategoryFromRepositoryValue(
        map['category'] as String?,
      ),
      priceCents: map['priceCents'] as int? ?? 0,
      emoji: _emojiForVisualKey(map['visualKey'] as String?),
      imageLabel: map['imageLabel'] as String? ?? 'Mock',
      imageColors: hexes.isEmpty
          ? const [Color(0xFFE7E7E7), Color(0xFFD8D8D8)]
          : hexes,
      longDescription: map['description'] as String?,
    );
  }

  /// Identificador estavel do produto, usado por navegacao e carrinho.
  final String id;

  /// Nome principal exibido no card.
  final String name;

  /// Descricao curta complementar, como peso, volume ou unidade.
  final String details;

  /// Categoria exibida nos atalhos da home e usada em filtros simples.
  final HomeProductCategory category;

  /// Valor bruto em centavos, usado para calculos de carrinho e subtotal.
  final int priceCents;

  /// Elemento visual simplificado usado no lugar de imagem real.
  final String emoji;

  /// Selo textual exibido sobre a arte do produto.
  final String imageLabel;

  /// Paleta usada no gradiente da area visual do card.
  final List<Color> imageColors;

  /// Descricao longa opcional para a pagina de detalhes.
  final String? longDescription;

  /// Preco formatado para exibicao em texto.
  String get price => formatPriceCents(priceCents);

  /// Indica se o produto corresponde a uma busca textual simples da home.
  bool matchesSearch(String query) {
    final normalizedQuery = normalizeHomeCatalogText(query);
    if (normalizedQuery.isEmpty) {
      return true;
    }

    final haystack = normalizeHomeCatalogText(
      '$name $details ${category.label} $imageLabel',
    );

    return haystack.contains(normalizedQuery);
  }

  /// Texto descritivo usado na pagina de detalhes quando nao ha copy
  /// especifica persistida para o produto.
  String get description {
    return longDescription ??
        '$name em $details, com destaque para ${imageLabel.toLowerCase()} e '
            'selecao pensada para compras do dia a dia com reposicao rapida.';
  }
}

/// Formata um valor inteiro em centavos para o padrao monetario usado na UI.
String formatPriceCents(int cents) {
  final reais = cents ~/ 100;
  final centavos = (cents % 100).toString().padLeft(2, '0');
  return 'R\$ $reais,$centavos';
}

HomeProductCategory homeProductCategoryFromRepositoryValue(String? value) {
  return switch (value) {
    'hortifruti' => HomeProductCategory.hortifruti,
    'bebidas' => HomeProductCategory.bebidas,
    'padaria' => HomeProductCategory.padaria,
    'proteinas' => HomeProductCategory.proteinas,
    'limpeza' => HomeProductCategory.limpeza,
    'higiene' => HomeProductCategory.higiene,
    'lanches' => HomeProductCategory.lanches,
    _ => HomeProductCategory.mercearia,
  };
}

String normalizeHomeCatalogText(String value) {
  var normalized = value.toLowerCase().trim();

  const replacements = {
    'á': 'a',
    'à': 'a',
    'ã': 'a',
    'â': 'a',
    'ä': 'a',
    'é': 'e',
    'ê': 'e',
    'ë': 'e',
    'í': 'i',
    'ï': 'i',
    'ó': 'o',
    'ô': 'o',
    'õ': 'o',
    'ö': 'o',
    'ú': 'u',
    'ü': 'u',
    'ç': 'c',
  };

  replacements.forEach((source, target) {
    normalized = normalized.replaceAll(source, target);
  });

  return normalized
      .replaceAll(RegExp(r'[^a-z0-9]+'), ' ')
      .replaceAll(RegExp(r'\s+'), ' ')
      .trim();
}

extension HomeProductCategoryPresentation on HomeProductCategory {
  String get label {
    return switch (this) {
      HomeProductCategory.hortifruti => 'Hortifruti',
      HomeProductCategory.bebidas => 'Bebidas',
      HomeProductCategory.mercearia => 'Mercearia',
      HomeProductCategory.padaria => 'Padaria',
      HomeProductCategory.proteinas => 'Proteinas',
      HomeProductCategory.limpeza => 'Limpeza',
      HomeProductCategory.higiene => 'Higiene',
      HomeProductCategory.lanches => 'Lanches',
    };
  }
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
