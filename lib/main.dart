import 'package:flutter/material.dart';

import 'app_routes.dart';
import 'screens/address_selection_screen.dart';
import 'screens/cart_screen.dart';
import 'screens/category_list_screen.dart';
import 'screens/checkout_screen.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/order_confirmed_screen.dart';
import 'screens/product_details_screen.dart';
import 'screens/screens_index_page.dart';
import 'screens/search_results_screen.dart';
import 'theme/app_theme.dart';

import 'package:hive_ce_flutter/hive_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  await Hive.openBox('settings');

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});
  //

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      initialRoute: AppRoutes.onboarding,
      routes: {
        AppRoutes.index: (_) => const ScreensIndexPage(),
        AppRoutes.onboarding: (_) => const OnboardingScreen(),
        AppRoutes.login: (_) => const LoginScreen(),
        AppRoutes.address: (_) => const AddressSelectionScreen(),
        AppRoutes.home: (_) => const HomeScreen(),
        AppRoutes.search: (_) => const SearchResultsScreen(),
        AppRoutes.categories: (_) => const CategoryListScreen(),
        AppRoutes.product: (_) => const ProductDetailsScreen(),
        AppRoutes.cart: (_) => const CartScreen(),
        AppRoutes.checkout: (_) => const CheckoutScreen(),
        AppRoutes.confirmed: (_) => const OrderConfirmedScreen(),
      },
    );
  }
}
