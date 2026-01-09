import 'package:go_router/go_router.dart';

import '../../presentation/auth/sign_in_screen.dart';
import '../../presentation/auth/sign_up_screen.dart';
import '../../presentation/cocktail_detail/cocktail_detail_screen.dart';
import '../../presentation/onboarding/onboarding_screen.dart';
import '../../presentation/shell/cocktail_shell.dart';
import '../../presentation/splash/splash_screen.dart';
import '../../state/auth_controller.dart';

GoRouter createRouter(AuthController auth) {
  return GoRouter(
    initialLocation: '/splash',
    refreshListenable: auth, // ✅ router reacts to login/logout
    redirect: (context, state) {
      final loc = state.matchedLocation;

      // allow these routes without auth (optional)
      final isSplash = loc == '/splash';
      final isOnboarding = loc == '/onboarding';
      final isSignIn = loc == '/sign-in';
      final isSignUp = loc == '/sign-up';

      final authed = auth.isAuthenticated;
      final initialized = auth.isInitialized;

      // While auth is initializing, stay on splash
      if (!initialized) {
        return isSplash ? null : '/splash';
      }

      // If not authed: force sign-in (except splash/onboarding/auth pages)
      if (!authed) {
        if (isSignIn || isSignUp || isSplash || isOnboarding) return null;
        return '/sign-in';
      }

      // If authed: prevent returning to sign-in/up/splash
      if (authed && (isSignIn || isSignUp || isSplash)) {
        return '/';
      }

      return null;
    },
    routes: [
      GoRoute(path: '/splash', builder: (_, __) => const SplashScreen()),
      GoRoute(
        path: '/onboarding',
        builder: (_, __) => const OnboardingScreen(),
      ),

      GoRoute(path: '/sign-in', builder: (_, __) => const SignInScreen()),
      GoRoute(path: '/sign-up', builder: (_, __) => const SignUpScreen()),

      GoRoute(
        path: '/',
        builder: (_, __) => const CocktailShell(),
        routes: [
          GoRoute(
            path: 'cocktail/:id',
            builder: (context, state) {
              final id = state.pathParameters['id']!;
              return CocktailDetailScreen(cocktailId: id);
            },
          ),
        ],
      ),
    ],
  );
}
