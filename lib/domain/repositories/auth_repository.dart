import '../usecases/result.dart';

abstract class AuthRepository {
  Future<Result<void>> signUp({required String email, required String password});
  Future<Result<void>> signIn({required String email, required String password});
  Future<Result<void>> signOut();
  Future<bool> isAuthorized();
  Future<String?> savedEmail();
}
