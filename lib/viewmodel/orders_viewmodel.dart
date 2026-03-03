import 'package:app_mercadofacil/model/cart_item.dart';
import 'package:app_mercadofacil/model/order.dart';
import 'package:flutter/foundation.dart';

/// Estado global do historico de pedidos concluídos pelo usuario.
class OrdersViewModel extends ChangeNotifier {
  final List<Order> _orders = <Order>[];
  int _nextSequence = 1;

  List<Order> get orders => List<Order>.unmodifiable(_orders);

  bool get isEmpty => _orders.isEmpty;

  int get totalOrders => _orders.length;

  int get totalSpentCents {
    return _orders.fold(0, (sum, order) => sum + order.totalCents);
  }

  String get totalSpent {
    final reais = totalSpentCents ~/ 100;
    final centavos = (totalSpentCents % 100).toString().padLeft(2, '0');
    return 'R\$ $reais,$centavos';
  }

  Order? get latestOrder => _orders.isEmpty ? null : _orders.first;

  Order placeOrder(
    List<CartItem> cartItems, {
    required OrderCheckoutDetails checkout,
  }) {
    final now = DateTime.now();
    final order = Order(
      id: 'order-${now.microsecondsSinceEpoch}',
      code: _buildCode(now, _nextSequence++),
      createdAt: now,
      items: cartItems.map((item) => item.copyWith()).toList(growable: false),
      checkout: checkout,
    );

    _orders.insert(0, order);
    notifyListeners();
    return order;
  }

  String _buildCode(DateTime createdAt, int sequence) {
    final year = createdAt.year.toString();
    final month = createdAt.month.toString().padLeft(2, '0');
    final day = createdAt.day.toString().padLeft(2, '0');
    final serial = sequence.toString().padLeft(3, '0');

    return 'PD-$year$month$day-$serial';
  }
}
