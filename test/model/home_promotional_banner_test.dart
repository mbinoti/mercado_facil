import 'package:app_mercadofacil/model/home_promotional_banner.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('HomePromotionalBanner', () {
    test('normaliza lista de produtos alvo da promocao', () {
      final banner = HomePromotionalBanner.fromRepositoryMap({
        'id': 'banner_cafe_manha',
        'badge': 'Oferta relampago',
        'title': 'Cafe da manha em ritmo express',
        'subtitle': 'Selecao pronta para o pedido.',
        'ctaLabel': 'Ver selecao',
        'targetProductIds': [
          'cappuccino_cremoso',
          'brioche_artesanal',
          'bebida_de_aveia_barista',
        ],
        'backgroundColorHexes': [0xFF111A30, 0xFF2A4F72],
        'textColorHex': 0xFFFFFFFF,
      });

      expect(
        banner.targetProductIds,
        [
          'cappuccino_cremoso',
          'brioche_artesanal',
          'bebida_de_aveia_barista',
        ],
      );
      expect(banner.targetProductId, 'cappuccino_cremoso');
      expect(banner.opensCollection, isTrue);
    });

    test('mantem compatibilidade com banner legado de um item', () {
      final banner = HomePromotionalBanner.fromRepositoryMap({
        'id': 'banner_higiene',
        'title': 'Casa e cuidado',
        'targetProductId': 'shampoo_hidratante',
      });

      expect(banner.targetProductIds, ['shampoo_hidratante']);
      expect(banner.targetProductId, 'shampoo_hidratante');
      expect(banner.opensCollection, isFalse);
    });
  });
}
