import '../repositories/auth_repository.dart';

class CheckAuthUseCase {
  CheckAuthUseCase(this._repository);

  final AuthRepository _repository;

  Future<bool> call() => _repository.isAuthorized();
}
