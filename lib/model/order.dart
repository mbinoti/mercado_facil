import 'package:app_mercadofacil/model/cart_item.dart';
import 'package:app_mercadofacil/model/home_product.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Status exibido para um pedido fechado no historico.
enum OrderStatus { confirmed }

/// Modalidades de recebimento disponiveis no checkout.
enum OrderFulfillmentType { expressDelivery, scheduledDelivery, storePickup }

/// Formas de pagamento disponiveis para concluir a compra.
enum OrderPaymentMethod { pix, creditCard, cardOnDelivery }

/// Dados escolhidos pelo usuario durante o checkout.
class OrderCheckoutDetails {
  const OrderCheckoutDetails({
    required this.recipientName,
    required this.fulfillmentType,
    required this.paymentMethod,
    required this.addressLine,
    required this.neighborhood,
    this.reference = '',
    this.creditInstallments = 1,
  }) : assert(creditInstallments >= 1),
       assert(
         paymentMethod == OrderPaymentMethod.creditCard ||
             creditInstallments == 1,
       );

  final String recipientName;
  final OrderFulfillmentType fulfillmentType;
  final OrderPaymentMethod paymentMethod;
  final String addressLine;
  final String neighborhood;
  final String reference;
  final int creditInstallments;

  int get deliveryFeeCents => fulfillmentType.feeCents;

  String get deliveryFee => formatPriceCents(deliveryFeeCents);

  bool get isPickup => fulfillmentType == OrderFulfillmentType.storePickup;

  bool get usesCreditCardInstallments =>
      paymentMethod == OrderPaymentMethod.creditCard;

  String get paymentLabel =>
      paymentMethod.labelWithInstallments(creditInstallments);

  String get installmentPlanLabel =>
      paymentMethod.installmentPlanLabel(creditInstallments);

  String get destinationLabel {
    if (isPickup) {
      return fulfillmentType.storeAddress;
    }

    return '$addressLine • $neighborhood';
  }

  String get referenceLabel {
    if (reference.trim().isEmpty) {
      return isPickup
          ? 'Retire com um documento e informe o codigo do pedido.'
          : 'Sem complemento adicional informado.';
    }

    return reference.trim();
  }
}

/// Snapshot imutavel de uma compra confirmada a partir do carrinho.
class Order {
  const Order({
    required this.id,
    required this.code,
    required this.createdAt,
    required this.items,
    required this.checkout,
    this.status = OrderStatus.confirmed,
  });

  final String id;
  final String code;
  final DateTime createdAt;
  final List<CartItem> items;
  final OrderCheckoutDetails checkout;
  final OrderStatus status;

  int get totalItems {
    return items.fold(0, (sum, item) => sum + item.quantity);
  }

  int get subtotalCents {
    return items.fold(0, (sum, item) => sum + item.totalPriceCents);
  }

  String get subtotal => formatPriceCents(subtotalCents);

  int get totalCents => subtotalCents + checkout.deliveryFeeCents;

  String get total => formatPriceCents(totalCents);

  String get placedAtLabel {
    final day = createdAt.day.toString().padLeft(2, '0');
    final month = createdAt.month.toString().padLeft(2, '0');
    final year = createdAt.year.toString();
    final hour = createdAt.hour.toString().padLeft(2, '0');
    final minute = createdAt.minute.toString().padLeft(2, '0');

    return '$day/$month/$year • $hour:$minute';
  }
}

extension OrderStatusPresentation on OrderStatus {
  String get label {
    return switch (this) {
      OrderStatus.confirmed => 'Confirmado',
    };
  }

  String get description {
    return switch (this) {
      OrderStatus.confirmed => 'Pedido confirmado e enviado para separacao.',
    };
  }

  Color get accentColor {
    return switch (this) {
      OrderStatus.confirmed => const Color(0xFF2F8B37),
    };
  }

  IconData get materialIcon {
    return switch (this) {
      OrderStatus.confirmed => Icons.check_circle_outline_rounded,
    };
  }

  IconData get cupertinoIcon {
    return switch (this) {
      OrderStatus.confirmed => CupertinoIcons.check_mark_circled,
    };
  }
}

extension OrderFulfillmentTypePresentation on OrderFulfillmentType {
  String get label {
    return switch (this) {
      OrderFulfillmentType.expressDelivery => 'Entrega expressa',
      OrderFulfillmentType.scheduledDelivery => 'Entrega agendada',
      OrderFulfillmentType.storePickup => 'Retirada na loja',
    };
  }

  String get description {
    return switch (this) {
      OrderFulfillmentType.expressDelivery =>
        'Receba em 45 a 60 minutos no endereco informado.',
      OrderFulfillmentType.scheduledDelivery =>
        'Agendado para a proxima janela disponivel hoje.',
      OrderFulfillmentType.storePickup =>
        'Retire na loja sem taxa e com preparo em cerca de 30 minutos.',
    };
  }

  int get feeCents {
    return switch (this) {
      OrderFulfillmentType.expressDelivery => 1290,
      OrderFulfillmentType.scheduledDelivery => 690,
      OrderFulfillmentType.storePickup => 0,
    };
  }

  String get feeLabel => feeCents == 0 ? 'Gratis' : formatPriceCents(feeCents);

  String get etaLabel {
    return switch (this) {
      OrderFulfillmentType.expressDelivery => '45-60 min',
      OrderFulfillmentType.scheduledDelivery => 'Hoje, 18h-20h',
      OrderFulfillmentType.storePickup => 'Retirada em 30 min',
    };
  }

  String get storeAddress => 'Retirada na loja • Rua das Palmeiras, 240';

  IconData get materialIcon {
    return switch (this) {
      OrderFulfillmentType.expressDelivery => Icons.delivery_dining_rounded,
      OrderFulfillmentType.scheduledDelivery => Icons.event_available_rounded,
      OrderFulfillmentType.storePickup => Icons.storefront_rounded,
    };
  }

  IconData get cupertinoIcon {
    return switch (this) {
      OrderFulfillmentType.expressDelivery => CupertinoIcons.paperplane,
      OrderFulfillmentType.scheduledDelivery => CupertinoIcons.calendar,
      OrderFulfillmentType.storePickup => CupertinoIcons.bag,
    };
  }
}

extension OrderPaymentMethodPresentation on OrderPaymentMethod {
  String get label {
    return switch (this) {
      OrderPaymentMethod.pix => 'Pix',
      OrderPaymentMethod.creditCard => 'Cartao de credito',
      OrderPaymentMethod.cardOnDelivery => 'Cartao na entrega',
    };
  }

  String get description {
    return switch (this) {
      OrderPaymentMethod.pix => 'Aprovacao imediata e conferida no fechamento.',
      OrderPaymentMethod.creditCard =>
        'Pagamento processado no aplicativo antes da confirmacao, com parcelamento no cartao.',
      OrderPaymentMethod.cardOnDelivery =>
        'Pagamento na maquininha quando o pedido chegar.',
    };
  }

  String labelWithInstallments(int creditInstallments) {
    if (this != OrderPaymentMethod.creditCard) {
      return label;
    }

    final normalizedInstallments = creditInstallments < 1
        ? 1
        : creditInstallments;

    return '$label • ${normalizedInstallments}x';
  }

  String installmentPlanLabel(int creditInstallments) {
    final normalizedInstallments = creditInstallments < 1
        ? 1
        : creditInstallments;

    return '$normalizedInstallments'
        'x sem juros';
  }

  IconData get materialIcon {
    return switch (this) {
      OrderPaymentMethod.pix => Icons.pix_rounded,
      OrderPaymentMethod.creditCard => Icons.credit_card_rounded,
      OrderPaymentMethod.cardOnDelivery => Icons.point_of_sale_rounded,
    };
  }

  IconData get cupertinoIcon {
    return switch (this) {
      OrderPaymentMethod.pix => CupertinoIcons.qrcode,
      OrderPaymentMethod.creditCard => CupertinoIcons.creditcard,
      OrderPaymentMethod.cardOnDelivery => CupertinoIcons.device_phone_portrait,
    };
  }
}
