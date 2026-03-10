import 'package:app_mercadofacil/ui/screens/onboarding_screen.dart';
import 'package:app_mercadofacil/ui/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('avanca pelas paginas e conclui no ultimo passo', (tester) async {
    tester.view.physicalSize = const Size(1200, 2200);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    var completed = false;

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme(),
        home: OnboardingScreen(
          onFinish: () async {
            completed = true;
          },
        ),
      ),
    );

    expect(find.text('Seu mercado da semana em poucos toques'), findsOneWidget);
    expect(find.text('Etapa 1 de 3'), findsOneWidget);

    await tester.tap(find.byKey(const Key('onboarding_primary_button')));
    await tester.pumpAndSettle();

    expect(
      find.text('Escolha retirada, expressa ou compra planejada'),
      findsOneWidget,
    );
    expect(find.text('Etapa 2 de 3'), findsOneWidget);

    await tester.tap(find.byKey(const Key('onboarding_primary_button')));
    await tester.pumpAndSettle();

    expect(
      find.text('Volte ao que funciona e acompanhe o que vale a pena'),
      findsOneWidget,
    );
    expect(find.text('Entrar agora'), findsOneWidget);

    await tester.tap(find.byKey(const Key('onboarding_primary_button')));
    await tester.pumpAndSettle();

    expect(completed, isTrue);
  });

  testWidgets('pular conclui onboarding imediatamente', (tester) async {
    tester.view.physicalSize = const Size(1200, 2200);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    var skipped = false;

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme(),
        home: OnboardingScreen(
          onFinish: () async {
            skipped = true;
          },
        ),
      ),
    );

    await tester.tap(find.widgetWithText(TextButton, 'Pular'));
    await tester.pumpAndSettle();

    expect(skipped, isTrue);
  });
}
