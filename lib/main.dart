import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:pretty_bloc_observer/pretty_bloc_observer.dart';

import 'app/app.dart';
import 'app/router/app_router.dart';
import 'app/router/route_names.dart';
import 'app/screens/app_initialization_error_screen.dart';
import 'core/config/env.dart';
import 'core/di/injection.dart';
import 'core/presentation/cubit/layout_cubit.dart';
import 'core/storage/cache_helper.dart';
import 'features/auth/presentation/cubit/auth_cubit.dart';
import 'features/profile/presentation/cubit/patient_cubit.dart';

void main() async {
  // 1. Core Bindings
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = PrettyBlocObserver();
  await CacheHelper.init();

  // 2. Global Error Handling
  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    debugPrint('Flutter Error: ${details.exception}');
  };
  PlatformDispatcher.instance.onError = (error, stack) {
    debugPrint('Platform Error: $error');
    return true;
  };

  // 3. Environment & Dependencies
  const isProd = bool.fromEnvironment('dart.vm.product');
  try {
    await Env.load(isProd ? EnvFile.prod : EnvFile.dev);
    await configureDependencies(isProd: isProd);
  } catch (e, stack) {
    debugPrint('Dependency Init Failed: $e\n$stack');
    runApp(const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AppInitializationErrorScreen(),
    ));
    return;
  }

  // 4. Initialize Auth Cubit
  final authCubit = sl<AuthCubit>();
  await authCubit.init();

  // 5. Determine Initial Route
  String initialRoute = Routes.login;
  try {
    final layoutCubit = sl<LayoutCubit>();
    await layoutCubit.determineInitialRoute();
    initialRoute = layoutCubit.state.initialRoute ?? Routes.login;
  } catch (e) {
    debugPrint('Initial Route Check Failed: $e');
  }

  // 6. Router Setup
  final router = AppRouter.createRouter(
    sl<CacheHelper>(),
    initialRoute,
  );

  // 7. Run App
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>.value(value: authCubit),
        BlocProvider<PatientCubit>(create: (_) => sl<PatientCubit>()),
      ],
      child: ClinexaApp(router: router),
    ),
  );
}
