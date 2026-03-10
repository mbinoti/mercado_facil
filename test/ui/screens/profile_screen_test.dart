import 'package:app_mercadofacil/ui/screens/profile_screen.dart';
import 'package:app_mercadofacil/viewmodel/app_shell_viewmodel.dart';
import 'package:app_mercadofacil/viewmodel/cart_viewmodel.dart';
import 'package:app_mercadofacil/viewmodel/orders_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

void main() {
  testWidgets('exibe os dados principais do perfil apos carregar', (
    tester,
  ) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AppShellViewModel()),
          ChangeNotifierProvider(create: (_) => CartViewModel()),
          ChangeNotifierProvider(create: (_) => OrdersViewModel()),
        ],
        child: const MaterialApp(home: ProfileScreen()),
      ),
    );

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));

    expect(find.text('Perfil'), findsOneWidget);
    expect(find.text('Marcos Silva'), findsAtLeastNWidgets(1));
    final mainScrollView = find.byType(Scrollable).first;

    final addressFinder = find.text('Endereco padrao');
    await tester.scrollUntilVisible(
      addressFinder,
      240,
      scrollable: mainScrollView,
    );
    expect(addressFinder, findsOneWidget);

    final paymentFinder = find.text('Pagamento padrao');
    await tester.scrollUntilVisible(
      paymentFinder,
      240,
      scrollable: mainScrollView,
    );
    expect(paymentFinder, findsOneWidget);

    final preferencesFinder = find.text('Preferencias');
    await tester.scrollUntilVisible(
      preferencesFinder,
      240,
      scrollable: mainScrollView,
    );
    expect(preferencesFinder, findsOneWidget);
  });

  testWidgets('renderiza o perfil em contexto iOS sem erro de Material', (
    tester,
  ) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AppShellViewModel()),
          ChangeNotifierProvider(create: (_) => CartViewModel()),
          ChangeNotifierProvider(create: (_) => OrdersViewModel()),
        ],
        child: MaterialApp(
          theme: ThemeData(platform: TargetPlatform.iOS),
          home: const ProfileScreen(),
        ),
      ),
    );

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));

    expect(find.text('Perfil'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
