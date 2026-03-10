import 'package:flutter/material.dart';

/// Banner promocional exibido na faixa horizontal da home.
///
/// O modelo representa apenas o que a interface precisa para compor o card:
/// copy curta, CTA, identidade visual e uma lista opcional de produtos em
/// destaque para abrir uma promocao com selecao de itens ao tocar no banner.
class HomePromotionalBanner {
  const HomePromotionalBanner({
    required this.id,
    required this.badge,
    required this.title,
    required this.subtitle,
    required this.ctaLabel,
    required this.backgroundColors,
    required this.textColor,
    this.targetProductIds = const [],
  });

  factory HomePromotionalBanner.fromRepositoryMap(Map<String, dynamic> map) {
    final backgroundColors =
        (map['backgroundColorHexes'] as List<dynamic>? ?? const [])
            .whereType<int>()
            .map(Color.new)
            .toList(growable: false);
    final targetProductIds =
        (map['targetProductIds'] as List<dynamic>? ?? const [])
            .whereType<String>()
            .map((id) => id.trim())
            .where((id) => id.isNotEmpty)
            .toList(growable: false);
    final legacyTargetProductId = (map['targetProductId'] as String?)?.trim();
    final normalizedTargetProductIds = targetProductIds.isNotEmpty
        ? targetProductIds
        : [
            if (legacyTargetProductId != null &&
                legacyTargetProductId.isNotEmpty)
              legacyTargetProductId,
          ];

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
      targetProductIds: normalizedTargetProductIds,
    );
  }

  final String id;
  final String badge;
  final String title;
  final String subtitle;
  final String ctaLabel;
  final List<Color> backgroundColors;
  final Color textColor;
  final List<String> targetProductIds;

  /// Mantem compatibilidade com fluxos que ainda esperam um produto primario.
  String? get targetProductId =>
      targetProductIds.isEmpty ? null : targetProductIds.first;

  bool get opensCollection => targetProductIds.length > 1;
}
