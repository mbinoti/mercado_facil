import 'package:app_mercadofacil/model/home_product.dart';

/// Linha do carrinho, composta por um produto e sua quantidade.
class CartItem {
  const CartItem({
    required this.product,
    required this.quantity,
  });

  final HomeProduct product;
  final int quantity;

  int get totalPriceCents => product.priceCents * quantity;
  String get totalPrice => formatPriceCents(totalPriceCents);

  CartItem copyWith({
    HomeProduct? product,
    int? quantity,
  }) {
    return CartItem(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
    );
  }
}
