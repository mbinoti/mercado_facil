import 'package:app_mercadofacil/model/home_product.dart';
import 'package:app_mercadofacil/model/home_promotional_banner.dart';
import 'package:app_mercadofacil/ui/screens/promotional_collection_screen.dart';
import 'package:app_mercadofacil/viewmodel/cart_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

void main() {
  testWidgets(
    'renderiza promocao com grade compacta sem overflow',
    (tester) async {
      tester.view.physicalSize = const Size(360, 800);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      const banner = HomePromotionalBanner(
        id: 'banner_cafe_manha',
        badge: 'Oferta relampago',
        title: 'Cafe da manha em ritmo express',
        subtitle: 'Selecao pronta para pedidos rapidos.',
        ctaLabel: 'Ver selecao',
        backgroundColors: [Color(0xFF111A30), Color(0xFF2A4F72)],
        textColor: Colors.white,
        targetProductIds: [
          'cappuccino_cremoso',
          'brioche_artesanal',
          'bebida_de_aveia_barista',
        ],
      );
      final products = [
        const HomeProduct(
          id: 'cappuccino_cremoso',
          name: 'Cappuccino Cremoso',
          details: 'pote 200g',
          category: HomeProductCategory.bebidas,
          priceCents: 1590,
          emoji: '☕',
          imageLabel: 'Cafe',
          imageColors: [Color(0xFFE4D0BE), Color(0xFFB57D4F)],
        ),
        const HomeProduct(
          id: 'brioche_artesanal',
          name: 'Brioche Artesanal',
          details: 'pacote 400g',
          category: HomeProductCategory.padaria,
          priceCents: 1149,
          emoji: '🍞',
          imageLabel: 'Padaria',
          imageColors: [Color(0xFFF3E0C9), Color(0xFFC99658)],
        ),
        const HomeProduct(
          id: 'bebida_de_aveia_barista',
          name: 'Bebida de Aveia Barista',
          details: 'caixa 1L',
          category: HomeProductCategory.bebidas,
          priceCents: 990,
          emoji: '🥛',
          imageLabel: 'Vegano',
          imageColors: [Color(0xFFF2E7D8), Color(0xFFD2B38E)],
        ),
      ];

      await tester.pumpWidget(
        ChangeNotifierProvider(
          create: (_) => CartViewModel(),
          child: MaterialApp(
            home: PromotionalCollectionScreen(banner: banner, products: products),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Promocao'), findsOneWidget);
      expect(find.text('Cafe da manha em ritmo express'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );
}
