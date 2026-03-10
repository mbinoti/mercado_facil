import 'package:app_mercadofacil/model/user_profile.dart';

/// Contrato da feature de perfil para leitura e atualizacao do snapshot atual.
abstract class ProfileRepository {
  Future<UserProfile?> loadProfile();

  Future<UserProfile> savePersonalInfo({
    required String fullName,
    required String email,
    required String phone,
  });

  Future<UserProfile> saveAddress(ProfileAddress address);

  Future<UserProfile> savePreferences(ProfilePreferences preferences);

  Future<UserProfile> setDefaultPaymentMethod(String paymentMethodId);
}
