import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/auth/presentation/pages/login_page.dart';
import '../features/home/presentation/pages/home_page.dart';
import '../features/myplans/presentation/pages/plans_page.dart';
import '../features/progress/presentation/pages/progress_page.dart';
import '../features/auth/presentation/providers/current_user_provider.dart';

/// Expose the router as a Riverpod provider so it can watch auth state
final appRouterProvider = Provider<GoRouter>((ref) {
  final user = ref.watch(currentUserProvider);

  return GoRouter(
    initialLocation: '/login',
    redirect: (context, state) {
      final loggingIn = state.matchedLocation == '/login';

      if (user == null && !loggingIn) {
        return '/login'; // not logged in → force login
      }
      if (user != null && loggingIn) {
        return '/'; // logged in → go home
      }
      return null; // stay put
    },
    routes: [
      GoRoute(path: '/', builder: (context, state) => const HomePage()),
      GoRoute(path: '/login', builder: (context, state) => const LoginPage()),
      GoRoute(path: '/plans', builder: (context, state) => const PlansPage()),
      GoRoute(
          path: '/progress', builder: (context, state) => const ProgressPage()),
    ],
  );
});
