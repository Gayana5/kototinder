import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/result.dart';
import '../datasources/auth_local_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._local);

  final AuthLocalDataSource _local;

  @override
  Future<Result<void>> signIn({required String email, required String password}) async {
    try {
      final stored = await _local.readCredentials();
      if (stored == null) {
        return Result.failure('Пользователь не зарегистрирован');
      }
      if (stored['email'] != email || stored['password'] != password) {
        return Result.failure('Неверный email или пароль');
      }
      await _local.setAuthorized(true);
      return Result.success(null);
    } catch (_) {
      return Result.failure('Не удалось выполнить вход');
    }
  }

  @override
  Future<Result<void>> signUp({required String email, required String password}) async {
    try {
      await _local.saveCredentials(email: email, password: password);
      return Result.success(null);
    } catch (_) {
      return Result.failure('Не удалось сохранить учетные данные');
    }
  }

  @override
  Future<Result<void>> signOut() async {
    try {
      await _local.clearCredentials();
      return Result.success(null);
    } catch (_) {
      return Result.failure('Не удалось выйти');
    }
  }

  @override
  Future<bool> isAuthorized() => _local.isAuthorized();

  @override
  Future<String?> savedEmail() => _local.savedEmail();
}
