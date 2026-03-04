import 'package:shared_preferences/shared_preferences.dart';

class OnboardingLocalDataSource {
  OnboardingLocalDataSource(this._preferences);

  static const _keyCompleted = 'onboarding.completed';

  final SharedPreferences _preferences;

  Future<bool> isCompleted() async => _preferences.getBool(_keyCompleted) ?? false;

  Future<void> markCompleted() async {
    await _preferences.setBool(_keyCompleted, true);
  }
}
