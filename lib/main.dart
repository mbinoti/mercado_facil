import 'package:app_mercadofacil/repository/hive_fake_products_repository.dart';
import 'package:app_mercadofacil/ui/screens/home_screen.dart';
import 'package:app_mercadofacil/ui/theme/app_theme.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveFakeProductsRepository.initialize();
  runApp(const MercadoFacilApp());
}

class MercadoFacilApp extends StatelessWidget {
  const MercadoFacilApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mercado Fácil',
      theme: AppTheme.lightTheme(),
      home: const HomeScreen(),
    );
  }
}
