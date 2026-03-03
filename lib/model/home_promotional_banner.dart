import 'package:flutter/material.dart';

/// Banner promocional exibido na faixa horizontal da home.
///
/// O modelo representa apenas o que a interface precisa para compor o card:
/// copy curta, CTA, identidade visual e, opcionalmente, um produto em
/// destaque para abrir os detalhes ao tocar na promocao.
class HomePromotionalBanner {
  const HomePromotionalBanner({
    required this.id,
    required this.badge,
    required this.title,
    required this.subtitle,
    required this.ctaLabel,
    required this.backgroundColors,
    required this.textColor,
    this.targetProductId,
  });

  factory HomePromotionalBanner.fromRepositoryMap(Map<String, dynamic> map) {
    final backgroundColors =
        (map['backgroundColorHexes'] as List<dynamic>? ?? const [])
            .whereType<int>()
            .map(Color.new)
            .toList(growable: false);

    return HomePromotionalBanner(
      id: map['id'] as String? ?? 'banner_sem_id',
      badge: map['badge'] as String? ?? 'Promocao',
      title: map['title'] as String? ?? 'Oferta especial',
      subtitle:
          map['subtitle'] as String? ?? 'Confira as oportunidades do dia.',
      ctaLabel: map['ctaLabel'] as String? ?? 'Ver oferta',
      backgroundColors: backgroundColors.isEmpty
          ? const [Color(0xFF2F8B37), Color(0xFF79BE7E)]
          : backgroundColors,
      textColor: Color(map['textColorHex'] as int? ?? 0xFFFFFFFF),
      targetProductId: map['targetProductId'] as String?,
    );
  }

  final String id;
  final String badge;
  final String title;
  final String subtitle;
  final String ctaLabel;
  final List<Color> backgroundColors;
  final Color textColor;
  final String? targetProductId;
}
