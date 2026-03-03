import 'package:app_mercadofacil/repository/hive_fake_products_repository.dart';
import 'package:app_mercadofacil/ui/platform/platform_ui.dart';
import 'package:app_mercadofacil/ui/screens/app_shell_screen.dart';
import 'package:app_mercadofacil/ui/theme/app_theme.dart';
import 'package:app_mercadofacil/viewmodel/app_shell_viewmodel.dart';
import 'package:app_mercadofacil/viewmodel/cart_viewmodel.dart';
import 'package:app_mercadofacil/viewmodel/orders_viewmodel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

const List<LocalizationsDelegate<dynamic>> _appLocalizationsDelegates = [
  GlobalMaterialLocalizations.delegate,
  GlobalCupertinoLocalizations.delegate,
  GlobalWidgetsLocalizations.delegate,
];

const List<Locale> _appSupportedLocales = [
  Locale('pt', 'BR'),
  Locale('en', 'US'),
];

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveFakeProductsRepository.initialize();
  runApp(const MercadoFacilApp());
}

/// Widget raiz da aplicacao.
///
/// Centraliza a configuracao global do `MaterialApp`, incluindo tema,
/// titulo e tela inicial. O bootstrap de infraestrutura fica em `main()`,
/// entao esta classe permanece focada apenas na composicao da UI.
class MercadoFacilApp extends StatelessWidget {
  const MercadoFacilApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppShellViewModel()),
        ChangeNotifierProvider(create: (_) => CartViewModel()),
        ChangeNotifierProvider(create: (_) => OrdersViewModel()),
      ],
      child: usesCupertinoWidgets
          ? const _MercadoFacilCupertinoApp()
          : const _MercadoFacilMaterialApp(),
    );
  }
}

class _MercadoFacilMaterialApp extends StatelessWidget {
  const _MercadoFacilMaterialApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mercado Fácil',
      theme: AppTheme.lightTheme(platform: TargetPlatform.android),
      localizationsDelegates: _appLocalizationsDelegates,
      supportedLocales: _appSupportedLocales,
      home: const AppShellScreen(),
    );
  }
}

class _MercadoFacilCupertinoApp extends StatelessWidget {
  const _MercadoFacilCupertinoApp();

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      debugShowCheckedModeBanner: false,
      title: 'Mercado Fácil',
      theme: AppTheme.cupertinoTheme(),
      localizationsDelegates: _appLocalizationsDelegates,
      supportedLocales: _appSupportedLocales,
      builder: (context, child) {
        return Theme(
          data: AppTheme.lightTheme(platform: TargetPlatform.iOS),
          child: child ?? const SizedBox.shrink(),
        );
      },
      home: const AppShellScreen(),
    );
  }
}
