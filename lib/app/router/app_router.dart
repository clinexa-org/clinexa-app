// app/router/app_router.dart
import 'package:clinexa_mobile/features/profile/presentation/pages/profile_page.dart';
import 'package:go_router/go_router.dart';

import '../../core/storage/onboarding_storage.dart';
import '../../features/auth/presentation/pages/forgot_password_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/onboarding/presentation/pages/onboarding_page.dart';
import '../../features/profile/presentation/pages/edit_profile_page.dart';
import 'route_names.dart';

class AppRouter {
  static GoRouter createRouter(
      OnboardingStorage onboardingStorage, String initialLocation) {
    return GoRouter(
      initialLocation: initialLocation,
      routes: [
        GoRoute(
          path: Routes.onboarding,
          builder: (context, state) =>
              OnboardingPage(onboardingStorage: onboardingStorage),
        ),
        GoRoute(
          path: Routes.login,
          builder: (context, state) => const LoginPage(),
        ),
        GoRoute(
          path: Routes.register,
          builder: (context, state) => const RegisterPage(),
        ),
        GoRoute(
          path: Routes.forgotPassword,
          builder: (context, state) => const ForgotPasswordPage(),
        ),
        GoRoute(
          path: Routes.home,
          builder: (context, state) => const HomePage(),
        ),
        GoRoute(
          path: Routes.profile,
          builder: (context, state) => const ProfilePage(),
        ),
        GoRoute(
          path: Routes.editProfile,
          builder: (context, state) => const EditProfilePage(),
        ),
      ],
    );
  }
}
