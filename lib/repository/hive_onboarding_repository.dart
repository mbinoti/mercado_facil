import 'package:hive_ce_flutter/hive_flutter.dart';

/// Contrato para persistir o estado de primeira abertura do app.
abstract interface class OnboardingRepository {
  Future<bool> isCompleted();

  Future<void> complete();

  Future<void> reset();
}

/// Implementacao em Hive para controlar a exibicao da onboarding.
class HiveOnboardingRepository implements OnboardingRepository {
  static const String boxName = 'app_preferences_box';
  static const String _completedKey = 'onboarding_completed';

  /// Garante que a box de preferencias esteja aberta antes do uso.
  static Future<void> initialize() async {
    if (!Hive.isBoxOpen(boxName)) {
      await Hive.openBox<dynamic>(boxName);
    }
  }

  @override
  Future<bool> isCompleted() async {
    final box = await _openBox();
    return box.get(_completedKey, defaultValue: false) as bool;
  }

  @override
  Future<void> complete() async {
    final box = await _openBox();
    await box.put(_completedKey, true);
  }

  @override
  Future<void> reset() async {
    final box = await _openBox();
    await box.delete(_completedKey);
  }

  Future<Box<dynamic>> _openBox() async {
    if (!Hive.isBoxOpen(boxName)) {
      await Hive.openBox<dynamic>(boxName);
    }

    return Hive.box<dynamic>(boxName);
  }
}
