import 'package:app_mercadofacil/model/user_profile.dart';
import 'package:app_mercadofacil/repository/profile_repository.dart';
import 'package:flutter/foundation.dart';

/// Estados padronizados da feature de perfil.
enum ProfileViewState { initial, loading, success, empty, error }

/// ViewModel da aba de perfil com leitura e mutacoes do snapshot do usuario.
class ProfileViewModel extends ChangeNotifier {
  ProfileViewModel({required ProfileRepository repository})
    : _repository = repository;

  final ProfileRepository _repository;

  ProfileViewState _state = ProfileViewState.initial;
  UserProfile? _profile;
  String? _errorMessage;
  bool _isSaving = false;

  ProfileViewState get state => _state;
  UserProfile? get profile => _profile;
  String? get errorMessage => _errorMessage;
  bool get isSaving => _isSaving;

  Future<void> load() async {
    _state = ProfileViewState.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      final profile = await _repository.loadProfile();
      if (profile == null) {
        _profile = null;
        _state = ProfileViewState.empty;
      } else {
        _profile = profile;
        _state = ProfileViewState.success;
      }
    } catch (_) {
      _profile = null;
      _state = ProfileViewState.error;
      _errorMessage = 'Nao foi possivel carregar seu perfil agora.';
    }

    notifyListeners();
  }

  Future<void> retry() async {
    await load();
  }

  Future<bool> updatePersonalInfo({
    required String fullName,
    required String email,
    required String phone,
  }) {
    return _applyMutation(
      () => _repository.savePersonalInfo(
        fullName: fullName,
        email: email,
        phone: phone,
      ),
    );
  }

  Future<bool> updateAddress(ProfileAddress address) {
    return _applyMutation(() => _repository.saveAddress(address));
  }

  Future<bool> updatePushNotifications(bool value) {
    final current = _profile;
    if (current == null) {
      return SynchronousFuture(false);
    }

    return _applyMutation(
      () => _repository.savePreferences(
        current.preferences.copyWith(pushNotificationsEnabled: value),
      ),
    );
  }

  Future<bool> updateMarketingNotifications(bool value) {
    final current = _profile;
    if (current == null) {
      return SynchronousFuture(false);
    }

    return _applyMutation(
      () => _repository.savePreferences(
        current.preferences.copyWith(marketingNotificationsEnabled: value),
      ),
    );
  }

  Future<bool> updateProductSubstitutions(bool value) {
    final current = _profile;
    if (current == null) {
      return SynchronousFuture(false);
    }

    return _applyMutation(
      () => _repository.savePreferences(
        current.preferences.copyWith(allowProductSubstitutions: value),
      ),
    );
  }

  Future<bool> setDefaultPaymentMethod(String paymentMethodId) {
    return _applyMutation(
      () => _repository.setDefaultPaymentMethod(paymentMethodId),
    );
  }

  Future<bool> _applyMutation(Future<UserProfile> Function() action) async {
    _errorMessage = null;
    _isSaving = true;
    notifyListeners();

    try {
      _profile = await action();
      _state = ProfileViewState.success;
      return true;
    } catch (_) {
      _errorMessage = 'Nao foi possivel salvar as alteracoes do perfil.';
      if (_profile == null) {
        _state = ProfileViewState.error;
      }
      return false;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }
}
