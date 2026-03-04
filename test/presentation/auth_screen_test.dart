import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:cat_tinder/domain/repositories/analytics_repository.dart';
import 'package:cat_tinder/domain/repositories/auth_repository.dart';
import 'package:cat_tinder/domain/usecases/result.dart';
import 'package:cat_tinder/domain/usecases/sign_in.dart';
import 'package:cat_tinder/domain/usecases/sign_up.dart';
import 'package:cat_tinder/domain/validators/auth_validator.dart';
import 'package:cat_tinder/presentation/auth/auth_controller.dart';
import 'package:cat_tinder/presentation/auth/auth_screen.dart';

class _FakeAnalyticsRepository implements AnalyticsRepository {
  @override
  Future<void> initialize() async {}

  @override
  Future<void> logEvent(String name, {Map<String, Object?> parameters = const {}}) async {}
}

class _AcceptAllAuthRepository implements AuthRepository {
  @override
  Future<Result<void>> signIn({required String email, required String password}) async {
    return Result.success(null);
  }

  @override
  Future<Result<void>> signUp({required String email, required String password}) async {
    return Result.success(null);
  }

  @override
  Future<Result<void>> signOut() async {
    return Result.success(null);
  }

  @override
  Future<bool> isAuthorized() async => true;

  @override
  Future<String?> savedEmail() async => null;
}

void main() {
  testWidgets('Shows validation error on empty input', (tester) async {
    final repository = _AcceptAllAuthRepository();
    const validator = AuthValidator();
    final analytics = _FakeAnalyticsRepository();
    final controller = AuthController(
      signIn: SignInUseCase(repository, validator, analytics),
      signUp: SignUpUseCase(repository, validator, analytics),
      authRepository: repository,
    );

    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(useMaterial3: true),
        home: AuthScreen(
          controller: controller,
          onAuthSuccess: () async {},
        ),
      ),
    );

    await tester.tap(find.byKey(const ValueKey('auth.submit')));
    await tester.pump();

    expect(find.text('Введите email'), findsOneWidget);
  });

  testWidgets('Successful sign-in triggers success callback', (tester) async {
    final repository = _AcceptAllAuthRepository();
    const validator = AuthValidator();
    final analytics = _FakeAnalyticsRepository();
    final controller = AuthController(
      signIn: SignInUseCase(repository, validator, analytics),
      signUp: SignUpUseCase(repository, validator, analytics),
      authRepository: repository,
    );

    var didComplete = false;

    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(useMaterial3: true),
        home: AuthScreen(
          controller: controller,
          onAuthSuccess: () async {
            didComplete = true;
          },
        ),
      ),
    );

    await tester.enterText(find.byKey(const ValueKey('auth.email')), 'user@example.com');
    await tester.enterText(find.byKey(const ValueKey('auth.password')), 'password123');
    await tester.tap(find.byKey(const ValueKey('auth.submit')));
    await tester.pumpAndSettle();

    expect(didComplete, isTrue);
  });
}
