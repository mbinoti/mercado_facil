import 'package:app_mercadofacil/model/user_profile.dart';
import 'package:app_mercadofacil/repository/profile_repository.dart';
import 'package:app_mercadofacil/viewmodel/profile_viewmodel.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ProfileViewModel', () {
    test('load preenche perfil e entra em success', () async {
      final repository = _FakeProfileRepository(profile: _sampleProfile);
      final viewModel = ProfileViewModel(repository: repository);

      await viewModel.load();

      expect(viewModel.state, ProfileViewState.success);
      expect(viewModel.profile?.fullName, 'Marcos Silva');
      expect(viewModel.errorMessage, isNull);
    });

    test('load entra em error quando o repositorio falha', () async {
      final repository = _FakeProfileRepository(throwOnLoad: true);
      final viewModel = ProfileViewModel(repository: repository);

      await viewModel.load();

      expect(viewModel.state, ProfileViewState.error);
      expect(viewModel.profile, isNull);
      expect(
        viewModel.errorMessage,
        'Nao foi possivel carregar seu perfil agora.',
      );
    });

    test('setDefaultPaymentMethod troca o metodo padrao', () async {
      final repository = _FakeProfileRepository(profile: _sampleProfile);
      final viewModel = ProfileViewModel(repository: repository);
      await viewModel.load();

      final success = await viewModel.setDefaultPaymentMethod(
        'credito_final_4242',
      );

      expect(success, isTrue);
      expect(viewModel.profile?.defaultPaymentMethod.id, 'credito_final_4242');
    });
  });
}

class _FakeProfileRepository implements ProfileRepository {
  _FakeProfileRepository({this.profile, this.throwOnLoad = false});

  UserProfile? profile;
  final bool throwOnLoad;

  @override
  Future<UserProfile?> loadProfile() async {
    if (throwOnLoad) {
      throw Exception('load failed');
    }
    return profile;
  }

  @override
  Future<UserProfile> savePersonalInfo({
    required String fullName,
    required String email,
    required String phone,
  }) async {
    profile = profile!.copyWith(fullName: fullName, email: email, phone: phone);
    return profile!;
  }

  @override
  Future<UserProfile> saveAddress(ProfileAddress address) async {
    profile = profile!.copyWith(defaultAddress: address);
    return profile!;
  }

  @override
  Future<UserProfile> savePreferences(ProfilePreferences preferences) async {
    profile = profile!.copyWith(preferences: preferences);
    return profile!;
  }

  @override
  Future<UserProfile> setDefaultPaymentMethod(String paymentMethodId) async {
    profile = profile!.copyWith(
      paymentMethods: profile!.paymentMethods
          .map(
            (method) =>
                method.copyWith(isDefault: method.id == paymentMethodId),
          )
          .toList(growable: false),
    );
    return profile!;
  }
}

const _sampleProfile = UserProfile(
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
    reference: 'Portao cinza',
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
      details: 'Parcelamento liberado',
    ),
  ],
  preferences: ProfilePreferences(
    pushNotificationsEnabled: true,
    marketingNotificationsEnabled: false,
    allowProductSubstitutions: true,
  ),
);
