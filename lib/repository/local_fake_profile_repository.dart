import 'package:app_mercadofacil/model/user_profile.dart';
import 'package:app_mercadofacil/repository/profile_repository.dart';

/// Repositorio local em memoria para a aba de perfil.
class LocalFakeProfileRepository implements ProfileRepository {
  static UserProfile _profile = const UserProfile(
    fullName: 'Marcos Silva',
    email: 'marcos@mercadofacil.app',
    phone: '(11) 99876-5432',
    membershipLabel: 'Cliente Prime',
    savedThisMonthCents: 3840,
    preferredDeliveryWindowLabel: 'Hoje, 18h-20h',
    defaultAddress: ProfileAddress(
      label: 'Casa',
      street: 'Rua das Acacias, 245',
      neighborhood: 'Centro',
      city: 'Sao Paulo - SP',
      reference: 'Portao cinza ao lado da farmacia',
    ),
    paymentMethods: [
      ProfilePaymentMethod(
        id: 'pix_principal',
        type: ProfilePaymentMethodType.pix,
        label: 'Pix principal',
        details: 'Banco Mercado Facil',
        isDefault: true,
      ),
      ProfilePaymentMethod(
        id: 'credito_final_4242',
        type: ProfilePaymentMethodType.creditCard,
        label: 'Visa final 4242',
        details: 'Parcelamento liberado em ate 6x',
      ),
      ProfilePaymentMethod(
        id: 'vale_refeicao_flash',
        type: ProfilePaymentMethodType.mealVoucher,
        label: 'Flash Beneficios',
        details: 'Uso em itens elegiveis do catalogo',
      ),
    ],
    preferences: ProfilePreferences(
      pushNotificationsEnabled: true,
      marketingNotificationsEnabled: false,
      allowProductSubstitutions: true,
    ),
  );

  @override
  Future<UserProfile?> loadProfile() async {
    await Future<void>.delayed(const Duration(milliseconds: 160));
    return _profile;
  }

  @override
  Future<UserProfile> savePersonalInfo({
    required String fullName,
    required String email,
    required String phone,
  }) async {
    _profile = _profile.copyWith(
      fullName: fullName,
      email: email,
      phone: phone,
    );
    return _profile;
  }

  @override
  Future<UserProfile> saveAddress(ProfileAddress address) async {
    _profile = _profile.copyWith(defaultAddress: address);
    return _profile;
  }

  @override
  Future<UserProfile> savePreferences(ProfilePreferences preferences) async {
    _profile = _profile.copyWith(preferences: preferences);
    return _profile;
  }

  @override
  Future<UserProfile> setDefaultPaymentMethod(String paymentMethodId) async {
    final hasMethod = _profile.paymentMethods.any(
      (method) => method.id == paymentMethodId,
    );
    if (!hasMethod) {
      throw StateError('Payment method not found: $paymentMethodId');
    }

    final paymentMethods = _profile.paymentMethods
        .map(
          (method) => method.copyWith(isDefault: method.id == paymentMethodId),
        )
        .toList(growable: false);

    _profile = _profile.copyWith(paymentMethods: paymentMethods);
    return _profile;
  }
}
