import 'package:condo_hub_app/features/auth/presentation/pages/login_page.dart';
import 'package:condo_hub_app/features/home/presentation/pages/home_page.dart';
import 'package:condo_hub_app/features/onboarding/presentation/pages/onboarding_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.onboarding,
    routes: [
      GoRoute(
        path: AppRoutes.onboarding,
        name: 'onboarding',
        pageBuilder: (context, state) => NoTransitionPage(
          child: const OnboardingPage(),
        ),
      ),
      GoRoute(
        path: AppRoutes.login,
        name: 'login',
        pageBuilder: (context, state) => NoTransitionPage(
          child: const LoginPage(),
        ),
      ),
      GoRoute(
        path: AppRoutes.home,
        name: 'home',
        pageBuilder: (context, state) => NoTransitionPage(
          child: const HomePage(),
        ),
      ),
    ],
  );
}

class AppRoutes {
  static const String onboarding = '/';
  static const String login = '/login';
  static const String home = '/home';
}
