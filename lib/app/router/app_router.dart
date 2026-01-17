// app/router/app_router.dart
import 'package:clinexa_mobile/features/profile/presentation/pages/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/storage/cache_helper.dart';
import '../../features/auth/presentation/pages/forgot_password_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/onboarding/presentation/pages/onboarding_page.dart';
import '../../features/profile/presentation/pages/edit_profile_page.dart';
import '../../features/appointments/presentation/pages/appointment_details_page.dart';
import '../../features/appointments/domain/entities/appointment_entity.dart';
import 'route_names.dart';

class AppRouter {
  static GoRouter createRouter(CacheHelper cacheHelper, String initialLocation,
      GlobalKey<NavigatorState> navigatorKey) {
    return GoRouter(
      navigatorKey: navigatorKey,
      initialLocation: initialLocation,
      routes: [
        GoRoute(
          path: Routes.onboarding,
          name: Routes.onboardingName,
          builder: (context, state) => OnboardingPage(cacheHelper: cacheHelper),
        ),
        GoRoute(
          path: Routes.login,
          name: Routes.loginName,
          builder: (context, state) => const LoginPage(),
        ),
        GoRoute(
          path: Routes.register,
          name: Routes.registerName,
          builder: (context, state) => const RegisterPage(),
        ),
        GoRoute(
          path: Routes.forgotPassword,
          name: Routes.forgotPasswordName,
          builder: (context, state) => const ForgotPasswordPage(),
        ),
        GoRoute(
          path: Routes.home,
          name: Routes.homeName,
          builder: (context, state) => const HomePage(),
        ),
        GoRoute(
          path: Routes.profile,
          name: Routes.profileName,
          builder: (context, state) => const ProfilePage(),
        ),
        GoRoute(
          path: Routes.editProfile,
          name: Routes.editProfileName,
          builder: (context, state) => const EditProfilePage(),
        ),
        GoRoute(
          path: Routes.appointmentDetails,
          name: Routes.appointmentDetailsName,
          builder: (context, state) {
            final appointment = state.extra as AppointmentEntity;
            return AppointmentDetailsPage(appointment: appointment);
          },
        ),
      ],
    );
  }
}
