import 'package:app_mercadofacil/model/cart_item.dart';
import 'package:app_mercadofacil/model/home_product.dart';
import 'package:flutter/foundation.dart';

/// Estado global do carrinho de compras.
///
/// Mantem as linhas do carrinho indexadas por id de produto, calcula totais e
/// notifica a interface sempre que quantidades forem alteradas.
class CartViewModel extends ChangeNotifier {
  final Map<String, CartItem> _itemsByProductId = <String, CartItem>{};

  List<CartItem> get items => _itemsByProductId.values.toList(growable: false);

  bool get isEmpty => _itemsByProductId.isEmpty;

  int get totalItems {
    return _itemsByProductId.values.fold(
      0,
      (sum, item) => sum + item.quantity,
    );
  }

  int get subtotalCents {
    return _itemsByProductId.values.fold(
      0,
      (sum, item) => sum + item.totalPriceCents,
    );
  }

  String get subtotal => formatPriceCents(subtotalCents);

  int quantityFor(HomeProduct product) {
    return _itemsByProductId[product.id]?.quantity ?? 0;
  }

  void addProduct(HomeProduct product, {int amount = 1}) {
    if (amount <= 0) {
      return;
    }

    final current = _itemsByProductId[product.id];
    final nextQuantity = (current?.quantity ?? 0) + amount;
    _itemsByProductId[product.id] = CartItem(
      product: product,
      quantity: nextQuantity,
    );
    notifyListeners();
  }

  void removeSingleProduct(HomeProduct product) {
    final current = _itemsByProductId[product.id];
    if (current == null) {
      return;
    }

    if (current.quantity <= 1) {
      _itemsByProductId.remove(product.id);
    } else {
      _itemsByProductId[product.id] = current.copyWith(
        quantity: current.quantity - 1,
      );
    }

    notifyListeners();
  }

  void removeProduct(HomeProduct product) {
    if (_itemsByProductId.remove(product.id) != null) {
      notifyListeners();
    }
  }

  void clear() {
    if (_itemsByProductId.isEmpty) {
      return;
    }

    _itemsByProductId.clear();
    notifyListeners();
  }
}
