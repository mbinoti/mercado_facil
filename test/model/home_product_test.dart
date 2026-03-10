import 'package:app_mercadofacil/model/home_product.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('HomeProduct', () {
    test('normaliza categoria vinda do repositorio', () {
      final product = HomeProduct.fromRepositoryMap({
        'id': 'maca_fuji',
        'name': 'Maçã Fuji',
        'details': 'kg',
        'category': 'hortifruti',
        'priceCents': 899,
        'visualKey': 'apple',
        'imageLabel': 'Crocante',
        'imageColorHexes': [0xFFF9D4D4, 0xFFE35D5B],
      });

      expect(product.category, HomeProductCategory.hortifruti);
      expect(product.category.label, 'Hortifruti');
    });

    test('busca ignora acentos e pontuacao', () {
      final product = HomeProduct.fromRepositoryMap({
        'id': 'maca_fuji',
        'name': 'Maçã Fuji',
        'details': 'kg',
        'category': 'hortifruti',
        'priceCents': 899,
        'visualKey': 'apple',
        'imageLabel': 'Crocante',
        'imageColorHexes': [0xFFF9D4D4, 0xFFE35D5B],
      });

      expect(product.matchesSearch('maca'), isTrue);
      expect(product.matchesSearch('hortifruti'), isTrue);
      expect(product.matchesSearch('1,5l'), isFalse);
    });
  });
}
