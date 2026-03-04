import '../repositories/onboarding_repository.dart';

class CompleteOnboardingUseCase {
  CompleteOnboardingUseCase(this._repository);

  final OnboardingRepository _repository;

  Future<void> call() => _repository.markCompleted();
}
