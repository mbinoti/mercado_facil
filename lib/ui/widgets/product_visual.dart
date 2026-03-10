import 'dart:math' as math;

import 'package:app_mercadofacil/model/home_product.dart';
import 'package:flutter/material.dart';

/// Arte reutilizavel do produto, baseada em gradiente, selo e emoji.
///
/// O widget foi extraido para manter a identidade visual consistente entre
/// home, detalhes e carrinho sem duplicar a mesma composicao grafica.
class ProductVisual extends StatelessWidget {
  const ProductVisual({
    super.key,
    required this.product,
    this.borderRadius = 12,
    this.emojiSize = 70,
    this.padding = const EdgeInsets.all(12),
    this.preferAssetImage = false,
  });

  final HomeProduct product;
  final double borderRadius;
  final double emojiSize;
  final EdgeInsetsGeometry padding;
  final bool preferAssetImage;

  @override
  Widget build(BuildContext context) {
    if (preferAssetImage) {
      final primaryAssetPath = 'assets/images/products/${product.id}.png';
      final emojiAssetPath =
          'assets/images/products/emoji_${_emojiAssetToken(product.emoji)}.png';

      return ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: SizedBox.expand(
          child: Image.asset(
            primaryAssetPath,
            fit: BoxFit.cover,
            filterQuality: FilterQuality.high,
            errorBuilder: (context, error, stackTrace) {
              return Image.asset(
                emojiAssetPath,
                fit: BoxFit.cover,
                filterQuality: FilterQuality.high,
                errorBuilder: (context, error, stackTrace) {
                  return _buildFallbackVisual(context);
                },
              );
            },
          ),
        ),
      );
    }

    return _buildFallbackVisual(context);
  }

  Widget _buildFallbackVisual(BuildContext context) {
    final resolvedPadding = padding.resolve(Directionality.of(context));

    return LayoutBuilder(
      builder: (context, constraints) {
        final shortestSide = constraints.biggest.shortestSide;
        final contentWidth = math.max(
          1,
          constraints.maxWidth - resolvedPadding.horizontal,
        );
        final contentHeight = math.max(
          1,
          constraints.maxHeight - resolvedPadding.vertical,
        );
        final compact = shortestSide < 110;
        final chipFontSize = compact ? 10.0 : 12.0;
        final chipHorizontalPadding = compact ? 8.0 : 10.0;
        final chipVerticalPadding = compact ? 4.0 : 5.0;
        final reservedTop = math.min(
          40,
          math.max(28, (contentHeight * 0.34).round()),
        ).toDouble();
        final effectiveEmojiSize = math.min(
          emojiSize,
          math.min(
            contentWidth * 0.72,
            math.max(18, contentHeight - reservedTop) * 0.9,
          ),
        );
        final topCircleSize = math.min(72.0, math.max(40.0, shortestSide * 0.75));
        final bottomCircleSize = math.min(
          92.0,
          math.max(54.0, shortestSide * 0.95),
        );

        return DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: product.imageColors,
            ),
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          child: Stack(
            children: [
              Positioned(
                top: -topCircleSize * 0.25,
                right: -topCircleSize * 0.16,
                child: Container(
                  width: topCircleSize,
                  height: topCircleSize,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.25),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Positioned(
                bottom: -bottomCircleSize * 0.26,
                left: -bottomCircleSize * 0.15,
                child: Container(
                  width: bottomCircleSize,
                  height: bottomCircleSize,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.18),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Padding(
                padding: resolvedPadding,
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.86),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: chipHorizontalPadding,
                            vertical: chipVerticalPadding,
                          ),
                          child: Text(
                            product.imageLabel,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  fontSize: chipFontSize,
                                  color: const Color(0xFF3A3A3A),
                                  fontWeight: FontWeight.w800,
                                ),
                          ),
                        ),
                      ),
                    ),
                    Positioned.fill(
                      top: reservedTop,
                      child: Center(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            product.emoji,
                            style: TextStyle(
                              fontSize: effectiveEmojiSize,
                              height: 1,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _emojiAssetToken(String emoji) {
    final segments = emoji.runes.map((rune) => 'u${rune.toRadixString(16)}');
    return segments.join('_');
  }
}
