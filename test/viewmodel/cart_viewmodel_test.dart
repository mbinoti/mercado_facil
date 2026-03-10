import 'package:app_mercadofacil/model/cart_item.dart';
import 'package:app_mercadofacil/model/home_product.dart';
import 'package:app_mercadofacil/viewmodel/cart_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CartViewModel', () {
    test('addItems soma quantidades e registra aviso de recompra', () {
      final cart = CartViewModel();
      final banana = _buildProduct(id: 'banana_nanica', name: 'Banana nanica');
      final cafe = _buildProduct(
        id: 'cafe_grao',
        name: 'Cafe em graos',
        category: HomeProductCategory.mercearia,
      );

      cart.addProduct(banana, amount: 2);
      cart.addItems([
        CartItem(product: banana, quantity: 3),
        CartItem(product: cafe, quantity: 1),
      ], noticeMessage: 'Pedido PD-20260310-001 adicionado ao carrinho.');

      expect(cart.totalItems, 6);
      expect(cart.quantityFor(banana), 5);
      expect(cart.quantityFor(cafe), 1);
      expect(
        cart.noticeMessage,
        'Pedido PD-20260310-001 adicionado ao carrinho.',
      );
    });

    test('clearNoticeMessage remove o aviso sem alterar itens', () {
      final cart = CartViewModel();
      final produto = _buildProduct(id: 'maca_fuji', name: 'Maca Fuji');

      cart.addItems([
        CartItem(product: produto, quantity: 2),
      ], noticeMessage: 'Pedido PD-20260310-002 adicionado ao carrinho.');

      cart.clearNoticeMessage();

      expect(cart.totalItems, 2);
      expect(cart.noticeMessage, isNull);
    });

    test('removeSingleProduct atualiza subtotal e remove item ao zerar', () {
      final cart = CartViewModel();
      final produto = _buildProduct(id: 'kiwi_gold', name: 'Kiwi Gold');

      cart.addProduct(produto, amount: 2);
      expect(cart.subtotalCents, 1198);

      cart.removeSingleProduct(produto);
      expect(cart.quantityFor(produto), 1);
      expect(cart.subtotalCents, 599);

      cart.removeSingleProduct(produto);
      expect(cart.quantityFor(produto), 0);
      expect(cart.isEmpty, isTrue);
      expect(cart.subtotalCents, 0);
    });
  });
}

HomeProduct _buildProduct({
  required String id,
  required String name,
  HomeProductCategory category = HomeProductCategory.hortifruti,
}) {
  return HomeProduct(
    id: id,
    name: name,
    details: '1 un',
    category: category,
    priceCents: 599,
    emoji: '🛒',
    imageLabel: 'Oferta',
    imageColors: const [Color(0xFFE9F6EA), Color(0xFFC8E6C9)],
  );
}
