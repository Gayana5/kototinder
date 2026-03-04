import 'package:flutter_test/flutter_test.dart';

import 'package:cat_tinder/domain/repositories/analytics_repository.dart';
import 'package:cat_tinder/domain/repositories/auth_repository.dart';
import 'package:cat_tinder/domain/usecases/check_auth.dart';
import 'package:cat_tinder/domain/usecases/sign_in.dart';
import 'package:cat_tinder/domain/usecases/sign_up.dart';
import 'package:cat_tinder/domain/usecases/result.dart';
import 'package:cat_tinder/domain/validators/auth_validator.dart';

class _FakeAnalyticsRepository implements AnalyticsRepository {
  @override
  Future<void> initialize() async {}

  @override
  Future<void> logEvent(String name, {Map<String, Object?> parameters = const {}}) async {}
}

class _InMemoryAuthRepository implements AuthRepository {
  String? _email;
  String? _password;
  bool _authorized = false;

  @override
  Future<Result<void>> signIn({required String email, required String password}) async {
    if (_email == null || _password == null) {
      return Result.failure('Пользователь не зарегистрирован');
    }
    if (email != _email || password != _password) {
      return Result.failure('Неверный email или пароль');
    }
    _authorized = true;
    return Result.success(null);
  }

  @override
  Future<Result<void>> signUp({required String email, required String password}) async {
    _email = email;
    _password = password;
    _authorized = true;
    return Result.success(null);
  }

  @override
  Future<Result<void>> signOut() async {
    _authorized = false;
    return Result.success(null);
  }

  @override
  Future<bool> isAuthorized() async => _authorized;

  @override
  Future<String?> savedEmail() async => _email;
}

void main() {
  group('Auth use cases', () {
    test('SignUp validates email and returns error on invalid input', () async {
      final repository = _InMemoryAuthRepository();
      const validator = AuthValidator();
      final analytics = _FakeAnalyticsRepository();
      final useCase = SignUpUseCase(repository, validator, analytics);

      final result = await useCase(email: 'invalid-email', password: '123456');

      expect(result.isSuccess, isFalse);
      expect(result.error, isNotNull);
    });

    test('SignIn succeeds after SignUp and persists auth status', () async {
      final repository = _InMemoryAuthRepository();
      const validator = AuthValidator();
      final analytics = _FakeAnalyticsRepository();
      final signUp = SignUpUseCase(repository, validator, analytics);
      final signIn = SignInUseCase(repository, validator, analytics);
      final checkAuth = CheckAuthUseCase(repository);

      final signUpResult = await signUp(email: 'test@example.com', password: 'secret123');
      expect(signUpResult.isSuccess, isTrue);

      final signInResult = await signIn(email: 'test@example.com', password: 'secret123');
      expect(signInResult.isSuccess, isTrue);

      final isAuthorized = await checkAuth();
      expect(isAuthorized, isTrue);
    });
  });
}
