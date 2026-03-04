import 'package:flutter/foundation.dart';

import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/sign_in.dart';
import '../../domain/usecases/sign_up.dart';

enum AuthMode { signIn, signUp }

class AuthController extends ChangeNotifier {
  AuthController({
    required SignInUseCase signIn,
    required SignUpUseCase signUp,
    required AuthRepository authRepository,
  })  : _signIn = signIn,
        _signUp = signUp,
        _authRepository = authRepository;

  final SignInUseCase _signIn;
  final SignUpUseCase _signUp;
  final AuthRepository _authRepository;

  AuthMode _mode = AuthMode.signIn;
  String _email = '';
  String _password = '';
  String? _error;
  bool _isLoading = false;

  AuthMode get mode => _mode;
  String get email => _email;
  String get password => _password;
  String? get error => _error;
  bool get isLoading => _isLoading;

  Future<void> loadSavedEmail() async {
    final saved = await _authRepository.savedEmail();
    if (saved != null && saved.isNotEmpty) {
      _email = saved;
      notifyListeners();
    }
  }

  void setMode(AuthMode mode) {
    if (_mode == mode) {
      return;
    }
    _mode = mode;
    _error = null;
    notifyListeners();
  }

  void updateEmail(String value) {
    _email = value;
    if (_error != null) {
      _error = null;
      notifyListeners();
    }
  }

  void updatePassword(String value) {
    _password = value;
    if (_error != null) {
      _error = null;
      notifyListeners();
    }
  }

  Future<bool> submit() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    final result = _mode == AuthMode.signIn
        ? await _signIn(email: _email, password: _password)
        : await _signUp(email: _email, password: _password);

    _isLoading = false;
    if (result.isSuccess) {
      _error = null;
      notifyListeners();
      return true;
    }
    _error = result.error ?? 'Неизвестная ошибка';
    notifyListeners();
    return false;
  }
}
