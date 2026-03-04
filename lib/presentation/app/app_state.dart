import 'package:flutter/foundation.dart';

import '../../core/di/app_dependencies.dart';

enum AppFlow { loading, onboarding, auth, home }

class AppState extends ChangeNotifier {
  AppState(this._dependencies);

  final AppDependencies _dependencies;

  bool _isOnboardingComplete = false;
  bool _isAuthorized = false;
  bool _isLoading = true;

  AppFlow get flow {
    if (_isLoading) {
      return AppFlow.loading;
    }
    if (!_isOnboardingComplete) {
      return AppFlow.onboarding;
    }
    if (!_isAuthorized) {
      return AppFlow.auth;
    }
    return AppFlow.home;
  }

  Future<void> load() async {
    _isLoading = true;
    notifyListeners();
    _isOnboardingComplete = await _dependencies.isOnboardingComplete();
    _isAuthorized = await _dependencies.checkAuth();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> completeOnboarding() async {
    await _dependencies.completeOnboarding();
    _isOnboardingComplete = true;
    notifyListeners();
  }

  Future<void> refreshAuth() async {
    _isAuthorized = await _dependencies.checkAuth();
    notifyListeners();
  }

  Future<void> signOut() async {
    await _dependencies.signOut();
    await refreshAuth();
  }
}
