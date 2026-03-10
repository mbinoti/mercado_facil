import 'dart:io';

import 'package:app_mercadofacil/model/home_product.dart';
import 'package:app_mercadofacil/repository/hive_fake_products_repository.dart';
import 'package:app_mercadofacil/viewmodel/home_products_viewmodel.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const pathProviderChannel = MethodChannel('plugins.flutter.io/path_provider');
  final tempDirectory = Directory.systemTemp.createTempSync(
    'mercado_facil_tests_',
  );

  setUpAll(() async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(pathProviderChannel, (methodCall) async {
          return tempDirectory.path;
        });
    await HiveFakeProductsRepository.initialize();
  });

  setUp(() async {
    await HiveFakeProductsRepository.reseed();
  });

  tearDownAll(() async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(pathProviderChannel, null);
    if (tempDirectory.existsSync()) {
      tempDirectory.deleteSync(recursive: true);
    }
  });

  group('HomeProductsViewModel', () {
    test(
      'deriva categorias disponiveis e filtra por categoria selecionada',
      () {
        final viewModel = HomeProductsViewModel();
        addTearDown(viewModel.dispose);

        expect(
          viewModel.availableCategories,
          containsAll(HomeProductCategory.values),
        );

        viewModel.selectCategory(HomeProductCategory.bebidas);

        expect(viewModel.selectedCategory, HomeProductCategory.bebidas);
        expect(viewModel.products, isNotEmpty);
        expect(
          viewModel.products.every(
            (product) => product.category == HomeProductCategory.bebidas,
          ),
          isTrue,
        );
      },
    );

    test('combina busca textual com filtro de categoria e permite limpar', () {
      final viewModel = HomeProductsViewModel();
      addTearDown(viewModel.dispose);

      viewModel.selectCategory(HomeProductCategory.bebidas);
      viewModel.updateSearchQuery('cappuccino');

      expect(viewModel.products, hasLength(1));
      expect(viewModel.products.single.id, 'cappuccino_cremoso');

      viewModel.clearFilters();

      expect(viewModel.selectedCategory, isNull);
      expect(viewModel.searchQuery, isEmpty);
      expect(viewModel.products.length, viewModel.catalogProducts.length);
    });
  });
}
