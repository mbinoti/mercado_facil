import 'package:flutter/material.dart';

import 'app_routes.dart';
import 'ui/screens/address_selection_screen.dart';
import 'ui/screens/cart_screen.dart';
import 'ui/screens/category_list_screen.dart';
import 'ui/screens/checkout_screen.dart';
import 'ui/screens/home_screen.dart';
import 'ui/screens/login_screen.dart';
import 'ui/screens/onboarding_screen.dart';
import 'ui/screens/order_confirmed_screen.dart';
import 'ui/screens/product_details_screen.dart';
import 'ui/screens/screens_index_page.dart';
import 'ui/screens/search_results_screen.dart';
import 'ui/theme/app_theme.dart';

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
