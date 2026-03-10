import 'package:app_mercadofacil/model/cart_item.dart';
import 'package:app_mercadofacil/model/home_product.dart';
import 'package:app_mercadofacil/model/order.dart';
import 'package:app_mercadofacil/ui/screens/orders_screen.dart';
import 'package:app_mercadofacil/viewmodel/app_shell_viewmodel.dart';
import 'package:app_mercadofacil/viewmodel/cart_viewmodel.dart';
import 'package:app_mercadofacil/viewmodel/orders_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

void main() {
  testWidgets(
    'comprar novamente envia itens para o carrinho e muda para aba de carrinho',
    (tester) async {
      tester.view.physicalSize = const Size(1200, 2200);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final appShell = AppShellViewModel();
      final cart = CartViewModel();
      final orders = OrdersViewModel();
      final produto = HomeProduct(
        id: 'banana_nanica',
        name: 'Banana nanica',
        details: '1 kg',
        category: HomeProductCategory.hortifruti,
        priceCents: 899,
        emoji: '🍌',
        imageLabel: 'Fresca',
        imageColors: const [Color(0xFFE9F6EA), Color(0xFFC8E6C9)],
      );

      orders.placeOrder(
        [CartItem(product: produto, quantity: 2)],
        checkout: const OrderCheckoutDetails(
          recipientName: 'Marcos',
          fulfillmentType: OrderFulfillmentType.expressDelivery,
          paymentMethod: OrderPaymentMethod.pix,
          addressLine: 'Rua das Acacias, 245',
          neighborhood: 'Centro',
        ),
      );

      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider.value(value: appShell),
            ChangeNotifierProvider.value(value: cart),
            ChangeNotifierProvider.value(value: orders),
          ],
          child: const MaterialApp(home: OrdersScreen()),
        ),
      );

      final repeatOrderButton = find.widgetWithText(
        FilledButton,
        'Comprar novamente 2 itens',
      );
      await tester.ensureVisible(repeatOrderButton);
      await tester.tap(repeatOrderButton);
      await tester.pumpAndSettle();

      expect(cart.totalItems, 2);
      expect(cart.quantityFor(produto), 2);
      expect(
        cart.noticeMessage,
        'Pedido ${orders.latestOrder!.code} adicionado ao carrinho.',
      );
      expect(appShell.currentTab, AppShellTab.cart);
    },
  );
}
