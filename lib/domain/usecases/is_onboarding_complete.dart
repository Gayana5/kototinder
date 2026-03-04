import '../repositories/onboarding_repository.dart';

class IsOnboardingCompleteUseCase {
  IsOnboardingCompleteUseCase(this._repository);

  final OnboardingRepository _repository;

  Future<bool> call() => _repository.isCompleted();
}
