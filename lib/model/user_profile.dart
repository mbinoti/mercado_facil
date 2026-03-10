import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Tipos de pagamento exibidos na area de perfil.
enum ProfilePaymentMethodType { pix, creditCard, mealVoucher }

/// Endereco padrao do cliente exibido e editado no perfil.
class ProfileAddress {
  const ProfileAddress({
    required this.label,
    required this.street,
    required this.neighborhood,
    required this.city,
    this.reference = '',
  });

  final String label;
  final String street;
  final String neighborhood;
  final String city;
  final String reference;

  String get summary => '$street • $neighborhood';

  String get details {
    if (reference.trim().isEmpty) {
      return city;
    }

    return '$city • $reference';
  }

  ProfileAddress copyWith({
    String? label,
    String? street,
    String? neighborhood,
    String? city,
    String? reference,
  }) {
    return ProfileAddress(
      label: label ?? this.label,
      street: street ?? this.street,
      neighborhood: neighborhood ?? this.neighborhood,
      city: city ?? this.city,
      reference: reference ?? this.reference,
    );
  }
}

/// Metodo salvo no perfil com possibilidade de marcacao como padrao.
class ProfilePaymentMethod {
  const ProfilePaymentMethod({
    required this.id,
    required this.type,
    required this.label,
    required this.details,
    this.isDefault = false,
  });

  final String id;
  final ProfilePaymentMethodType type;
  final String label;
  final String details;
  final bool isDefault;

  ProfilePaymentMethod copyWith({
    String? id,
    ProfilePaymentMethodType? type,
    String? label,
    String? details,
    bool? isDefault,
  }) {
    return ProfilePaymentMethod(
      id: id ?? this.id,
      type: type ?? this.type,
      label: label ?? this.label,
      details: details ?? this.details,
      isDefault: isDefault ?? this.isDefault,
    );
  }
}

/// Preferencias operacionais controladas pela tela de perfil.
class ProfilePreferences {
  const ProfilePreferences({
    required this.pushNotificationsEnabled,
    required this.marketingNotificationsEnabled,
    required this.allowProductSubstitutions,
  });

  final bool pushNotificationsEnabled;
  final bool marketingNotificationsEnabled;
  final bool allowProductSubstitutions;

  ProfilePreferences copyWith({
    bool? pushNotificationsEnabled,
    bool? marketingNotificationsEnabled,
    bool? allowProductSubstitutions,
  }) {
    return ProfilePreferences(
      pushNotificationsEnabled:
          pushNotificationsEnabled ?? this.pushNotificationsEnabled,
      marketingNotificationsEnabled:
          marketingNotificationsEnabled ?? this.marketingNotificationsEnabled,
      allowProductSubstitutions:
          allowProductSubstitutions ?? this.allowProductSubstitutions,
    );
  }
}

/// Snapshot completo do perfil apresentado ao usuario.
class UserProfile {
  const UserProfile({
    required this.fullName,
    required this.email,
    required this.phone,
    required this.membershipLabel,
    required this.savedThisMonthCents,
    required this.preferredDeliveryWindowLabel,
    required this.defaultAddress,
    required this.paymentMethods,
    required this.preferences,
  });

  final String fullName;
  final String email;
  final String phone;
  final String membershipLabel;
  final int savedThisMonthCents;
  final String preferredDeliveryWindowLabel;
  final ProfileAddress defaultAddress;
  final List<ProfilePaymentMethod> paymentMethods;
  final ProfilePreferences preferences;

  String get initials {
    final parts = fullName
        .split(' ')
        .map((part) => part.trim())
        .where((part) => part.isNotEmpty)
        .toList(growable: false);

    if (parts.isEmpty) {
      return 'MF';
    }

    final first = parts.first.characters.first.toUpperCase();
    final last = parts.length == 1
        ? ''
        : parts.last.characters.first.toUpperCase();

    return '$first$last';
  }

  ProfilePaymentMethod get defaultPaymentMethod {
    return paymentMethods.firstWhere(
      (method) => method.isDefault,
      orElse: () => paymentMethods.first,
    );
  }

  UserProfile copyWith({
    String? fullName,
    String? email,
    String? phone,
    String? membershipLabel,
    int? savedThisMonthCents,
    String? preferredDeliveryWindowLabel,
    ProfileAddress? defaultAddress,
    List<ProfilePaymentMethod>? paymentMethods,
    ProfilePreferences? preferences,
  }) {
    return UserProfile(
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      membershipLabel: membershipLabel ?? this.membershipLabel,
      savedThisMonthCents: savedThisMonthCents ?? this.savedThisMonthCents,
      preferredDeliveryWindowLabel:
          preferredDeliveryWindowLabel ?? this.preferredDeliveryWindowLabel,
      defaultAddress: defaultAddress ?? this.defaultAddress,
      paymentMethods: paymentMethods ?? this.paymentMethods,
      preferences: preferences ?? this.preferences,
    );
  }
}

extension ProfilePaymentMethodTypePresentation on ProfilePaymentMethodType {
  String get label {
    return switch (this) {
      ProfilePaymentMethodType.pix => 'Pix',
      ProfilePaymentMethodType.creditCard => 'Cartao de credito',
      ProfilePaymentMethodType.mealVoucher => 'Vale refeicao',
    };
  }

  String get description {
    return switch (this) {
      ProfilePaymentMethodType.pix =>
        'Pagamento rapido com aprovacao imediata.',
      ProfilePaymentMethodType.creditCard =>
        'Cartao salvo para fechar pedidos com agilidade.',
      ProfilePaymentMethodType.mealVoucher =>
        'Opcao para compras elegiveis com beneficio.',
    };
  }

  IconData get materialIcon {
    return switch (this) {
      ProfilePaymentMethodType.pix => Icons.pix,
      ProfilePaymentMethodType.creditCard => Icons.credit_card_rounded,
      ProfilePaymentMethodType.mealVoucher => Icons.restaurant_rounded,
    };
  }

  IconData get cupertinoIcon {
    return switch (this) {
      ProfilePaymentMethodType.pix => CupertinoIcons.qrcode,
      ProfilePaymentMethodType.creditCard => CupertinoIcons.creditcard,
      ProfilePaymentMethodType.mealVoucher => CupertinoIcons.ticket,
    };
  }
}
