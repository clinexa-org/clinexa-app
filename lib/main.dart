import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'app/app.dart';
import 'app/router/app_router.dart';
import 'app/router/route_names.dart';
import 'core/config/env.dart';
import 'core/di/injection.dart';
import 'core/storage/onboarding_storage.dart';
import 'features/auth/presentation/cubit/auth_cubit.dart';
import 'features/profile/presentation/cubit/patient_cubit.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  const isProd = bool.fromEnvironment('dart.vm.product');

  await Env.load(isProd ? EnvFile.prod : EnvFile.dev);
  await configureDependencies(isProd: isProd);

  // Check onboarding status to determine initial route
  final onboardingStorage = sl<OnboardingStorage>();
  final hasSeenOnboarding = await onboardingStorage.hasSeenOnboarding();
  final initialRoute = hasSeenOnboarding ? Routes.login : Routes.onboarding;

  // Create router with initial route
  final router = AppRouter.createRouter(onboardingStorage, initialRoute);

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(
          create: (_) => sl<AuthCubit>()..init(),
        ),
        BlocProvider<PatientCubit>(
          create: (_) => sl<PatientCubit>(),
        ),
      ],
      child: ClinexaApp(router: router),
    ),
  );
}
