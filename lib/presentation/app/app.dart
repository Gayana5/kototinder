import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/di/app_dependencies.dart';
import '../auth/auth_screen.dart';
import '../home/home_tabs.dart';
import '../onboarding/onboarding_screen.dart';
import '../theme/app_theme.dart';
import 'app_state.dart';

class CatTinderApp extends StatelessWidget {
  const CatTinderApp({super.key, required this.dependencies});

  final AppDependencies dependencies;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider.value(value: dependencies),
        ChangeNotifierProvider(
          create: (_) => AppState(dependencies)..load(),
        ),
      ],
      child: MaterialApp(
        title: 'Cat Tinder',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const _AppRoot(),
      ),
    );
  }
}

class _AppRoot extends StatelessWidget {
  const _AppRoot();

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, state, _) {
        switch (state.flow) {
          case AppFlow.loading:
            return const _SplashScreen();
          case AppFlow.onboarding:
            return OnboardingScreen(onCompleted: state.completeOnboarding);
          case AppFlow.auth:
            return AuthScreen(onAuthSuccess: state.refreshAuth);
          case AppFlow.home:
            return const HomeTabs();
        }
      },
    );
  }
}

class _SplashScreen extends StatelessWidget {
  const _SplashScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
