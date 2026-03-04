import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/datasources/appmetrica_data_source.dart';
import '../../data/datasources/auth_local_data_source.dart';
import '../../data/datasources/cat_api_service.dart';
import '../../data/datasources/onboarding_local_data_source.dart';
import '../../data/repositories/analytics_repository_impl.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../data/repositories/cat_repository_impl.dart';
import '../../data/repositories/onboarding_repository_impl.dart';
import '../../domain/repositories/analytics_repository.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/repositories/cat_repository.dart';
import '../../domain/repositories/onboarding_repository.dart';
import '../../domain/usecases/check_auth.dart';
import '../../domain/usecases/complete_onboarding.dart';
import '../../domain/usecases/get_breeds.dart';
import '../../domain/usecases/get_random_cat.dart';
import '../../domain/usecases/is_onboarding_complete.dart';
import '../../domain/usecases/sign_in.dart';
import '../../domain/usecases/sign_out.dart';
import '../../domain/usecases/sign_up.dart';
import '../../domain/validators/auth_validator.dart';

class AppDependencies {
  AppDependencies._({
    required this.analyticsRepository,
    required this.authRepository,
    required this.catRepository,
    required this.onboardingRepository,
    required this.checkAuth,
    required this.completeOnboarding,
    required this.getBreeds,
    required this.getRandomCat,
    required this.isOnboardingComplete,
    required this.signIn,
    required this.signOut,
    required this.signUp,
  });

  final AnalyticsRepository analyticsRepository;
  final AuthRepository authRepository;
  final CatRepository catRepository;
  final OnboardingRepository onboardingRepository;

  final CheckAuthUseCase checkAuth;
  final CompleteOnboardingUseCase completeOnboarding;
  final GetBreedsUseCase getBreeds;
  final GetRandomCatUseCase getRandomCat;
  final IsOnboardingCompleteUseCase isOnboardingComplete;
  final SignInUseCase signIn;
  final SignOutUseCase signOut;
  final SignUpUseCase signUp;

  static Future<AppDependencies> initialize() async {
    final preferences = await SharedPreferences.getInstance();
    const secureStorage = FlutterSecureStorage();

    final authLocal = AuthLocalDataSource(preferences, secureStorage);
    final onboardingLocal = OnboardingLocalDataSource(preferences);

    final analyticsDataSource = AppMetricaDataSource(
      const String.fromEnvironment('APPMETRICA_API_KEY'),
    );
    final analyticsRepository = AnalyticsRepositoryImpl(analyticsDataSource);
    await analyticsRepository.initialize();

    final authRepository = AuthRepositoryImpl(authLocal);
    final onboardingRepository = OnboardingRepositoryImpl(onboardingLocal);

    final catApi = CatApiService(client: http.Client());
    final catRepository = CatRepositoryImpl(catApi);

    const validator = AuthValidator();

    return AppDependencies._(
      analyticsRepository: analyticsRepository,
      authRepository: authRepository,
      catRepository: catRepository,
      onboardingRepository: onboardingRepository,
      checkAuth: CheckAuthUseCase(authRepository),
      completeOnboarding: CompleteOnboardingUseCase(onboardingRepository),
      getBreeds: GetBreedsUseCase(catRepository),
      getRandomCat: GetRandomCatUseCase(catRepository),
      isOnboardingComplete: IsOnboardingCompleteUseCase(onboardingRepository),
      signIn: SignInUseCase(authRepository, validator, analyticsRepository),
      signOut: SignOutUseCase(authRepository),
      signUp: SignUpUseCase(authRepository, validator, analyticsRepository),
    );
  }
}
