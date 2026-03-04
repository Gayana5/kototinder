import '../repositories/analytics_repository.dart';
import '../repositories/auth_repository.dart';
import '../validators/auth_validator.dart';
import 'result.dart';

class SignUpUseCase {
  SignUpUseCase(this._repository, this._validator, this._analytics);

  final AuthRepository _repository;
  final AuthValidator _validator;
  final AnalyticsRepository _analytics;

  Future<Result<void>> call({required String email, required String password}) async {
    final emailError = _validator.validateEmail(email);
    final passwordError = _validator.validatePassword(password);
    if (emailError != null) {
      await _analytics.logEvent('signup_error', parameters: {'reason': 'email'});
      return Result.failure(emailError);
    }
    if (passwordError != null) {
      await _analytics.logEvent('signup_error', parameters: {'reason': 'password'});
      return Result.failure(passwordError);
    }
    final result = await _repository.signUp(email: email.trim(), password: password);
    if (result.isSuccess) {
      await _analytics.logEvent('signup_success');
    } else {
      await _analytics.logEvent('signup_error', parameters: {'reason': 'storage'});
    }
    return result;
  }
}
