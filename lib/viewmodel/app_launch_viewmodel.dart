import 'package:app_mercadofacil/repository/hive_onboarding_repository.dart';
import 'package:app_mercadofacil/viewmodel/view_state.dart';
import 'package:flutter/foundation.dart';

/// Decide qual experiencia inicial deve ser mostrada ao abrir o app.
class AppLaunchViewModel extends ChangeNotifier {
  AppLaunchViewModel({required OnboardingRepository onboardingRepository})
    : _onboardingRepository = onboardingRepository;

  final OnboardingRepository _onboardingRepository;

  ViewState _state = ViewState.initial;
  bool _shouldShowOnboarding = false;
  String? _errorMessage;

  ViewState get state => _state;
  bool get shouldShowOnboarding => _shouldShowOnboarding;
  String? get errorMessage => _errorMessage;

  Future<void> load() async {
    _updateState(ViewState.loading);

    try {
      _shouldShowOnboarding = !await _onboardingRepository.isCompleted();
      _errorMessage = null;
      _updateState(ViewState.success);
    } catch (_) {
      _errorMessage =
          'Nao foi possivel preparar a experiencia inicial. Tente novamente.';
      _updateState(ViewState.error);
    }
  }

  Future<void> completeOnboarding() async {
    try {
      await _onboardingRepository.complete();
      _shouldShowOnboarding = false;
      _errorMessage = null;
      _updateState(ViewState.success);
    } catch (_) {
      _errorMessage =
          'Nao foi possivel salvar sua preferencia inicial. Tente novamente.';
      _updateState(ViewState.error);
    }
  }

  Future<void> resetOnboarding() async {
    try {
      await _onboardingRepository.reset();
      _shouldShowOnboarding = true;
      _errorMessage = null;
      _updateState(ViewState.success);
    } catch (_) {
      _errorMessage =
          'Nao foi possivel redefinir a onboarding agora. Tente novamente.';
      _updateState(ViewState.error);
    }
  }

  Future<void> retry() => load();

  void _updateState(ViewState nextState) {
    if (_state == nextState) {
      notifyListeners();
      return;
    }

    _state = nextState;
    notifyListeners();
  }
}
