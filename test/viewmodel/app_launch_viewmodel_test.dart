import 'package:app_mercadofacil/repository/hive_onboarding_repository.dart';
import 'package:app_mercadofacil/viewmodel/app_launch_viewmodel.dart';
import 'package:app_mercadofacil/viewmodel/view_state.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppLaunchViewModel', () {
    test(
      'mostra onboarding quando a preferencia ainda nao foi salva',
      () async {
        final viewModel = AppLaunchViewModel(
          onboardingRepository: _FakeOnboardingRepository(completed: false),
        );

        await viewModel.load();

        expect(viewModel.state, ViewState.success);
        expect(viewModel.shouldShowOnboarding, isTrue);
        expect(viewModel.errorMessage, isNull);
      },
    );

    test(
      'segue direto para o app quando onboarding ja foi concluida',
      () async {
        final viewModel = AppLaunchViewModel(
          onboardingRepository: _FakeOnboardingRepository(completed: true),
        );

        await viewModel.load();

        expect(viewModel.state, ViewState.success);
        expect(viewModel.shouldShowOnboarding, isFalse);
      },
    );

    test('persiste a conclusao da onboarding e libera a home', () async {
      final repository = _FakeOnboardingRepository(completed: false);
      final viewModel = AppLaunchViewModel(onboardingRepository: repository);

      await viewModel.load();
      await viewModel.completeOnboarding();

      expect(repository.completed, isTrue);
      expect(viewModel.state, ViewState.success);
      expect(viewModel.shouldShowOnboarding, isFalse);
    });

    test('entra em erro quando a leitura inicial falha', () async {
      final viewModel = AppLaunchViewModel(
        onboardingRepository: _FakeOnboardingRepository(
          completed: false,
          shouldThrowOnRead: true,
        ),
      );

      await viewModel.load();

      expect(viewModel.state, ViewState.error);
      expect(viewModel.errorMessage, isNotNull);
    });

    test('entra em erro quando a persistencia da onboarding falha', () async {
      final viewModel = AppLaunchViewModel(
        onboardingRepository: _FakeOnboardingRepository(
          completed: false,
          shouldThrowOnWrite: true,
        ),
      );

      await viewModel.load();
      await viewModel.completeOnboarding();

      expect(viewModel.state, ViewState.error);
      expect(viewModel.shouldShowOnboarding, isTrue);
      expect(viewModel.errorMessage, isNotNull);
    });
  });
}

class _FakeOnboardingRepository implements OnboardingRepository {
  _FakeOnboardingRepository({
    required this.completed,
    this.shouldThrowOnRead = false,
    this.shouldThrowOnWrite = false,
  });

  bool completed;
  final bool shouldThrowOnRead;
  final bool shouldThrowOnWrite;

  @override
  Future<void> complete() async {
    if (shouldThrowOnWrite) {
      throw Exception('write failed');
    }

    completed = true;
  }

  @override
  Future<bool> isCompleted() async {
    if (shouldThrowOnRead) {
      throw Exception('read failed');
    }

    return completed;
  }

  @override
  Future<void> reset() async {
    completed = false;
  }
}
