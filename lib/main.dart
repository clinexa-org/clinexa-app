import 'package:clinexa_mobile/features/appointments/presentation/cubit/appointments_cubit.dart';
import 'package:clinexa_mobile/features/prescriptions/presentation/cubit/prescriptions_cubit.dart';
import 'package:clinexa_mobile/features/notifications/presentation/cubit/notifications_cubit.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:pretty_bloc_observer/pretty_bloc_observer.dart';

import 'app/app.dart';
import 'app/router/app_router.dart';
import 'app/router/route_names.dart';
import 'app/screens/app_initialization_error_screen.dart';
import 'core/config/env.dart';
import 'core/config/firebase_config.dart';
import 'core/di/injection.dart';
import 'core/presentation/cubit/layout_cubit.dart';
import 'core/services/notification_service.dart';
import 'core/services/socket_service.dart';
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
    await FirebaseConfig.initialize();
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

  // 5. Determine Initial Route & Load Language
  String initialRoute = Routes.login;
  final layoutCubit = sl<LayoutCubit>();
  try {
    await layoutCubit.determineInitialRoute();
    await layoutCubit.loadSavedLanguage();
    initialRoute = layoutCubit.state.initialRoute ?? Routes.login;
  } catch (e) {
    debugPrint('Initial Route Check Failed: $e');
  }

  // 6. Initialize Notification Services (if logged in)
  final notificationService = sl<NotificationService>();
  final socketService = sl<SocketService>();
  final appointmentsCubit = sl<AppointmentsCubit>();
  final prescriptionsCubit = sl<PrescriptionsCubit>();

  // Only fetch data if already authenticated
  if (authCubit.state.isAuthed) {
    appointmentsCubit.getMyAppointments();
    prescriptionsCubit.getMyPrescriptions();
    await _initializeNotifications(
      notificationService: notificationService,
      socketService: socketService,
      token: await sl<CacheHelper>().readToken() ?? '',
      appointmentsCubit: appointmentsCubit,
      prescriptionsCubit: prescriptionsCubit,
    );
  }

  // 7. Router Setup
  final router = AppRouter.createRouter(
    sl<CacheHelper>(),
    initialRoute,
    navigatorKey,
  );

  // 8. Run App
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>.value(value: authCubit),
        BlocProvider<PatientCubit>(create: (_) => sl<PatientCubit>()),
        BlocProvider<AppointmentsCubit>.value(value: appointmentsCubit),
        BlocProvider<PrescriptionsCubit>.value(value: prescriptionsCubit),
        BlocProvider<NotificationsCubit>(
            create: (_) => sl<NotificationsCubit>()),
      ],
      child: ClinexaApp(
        router: router,
        layoutCubit: layoutCubit,
      ),
    ),
  );
}

/// Initialize notification and socket services for authenticated users
Future<void> _initializeNotifications({
  required NotificationService notificationService,
  required SocketService socketService,
  required String token,
  required AppointmentsCubit appointmentsCubit,
  required PrescriptionsCubit prescriptionsCubit,
}) async {
  try {
    // Initialize FCM and local notifications
    await notificationService.initialize();
    await notificationService.registerDeviceToken();

    // Connect to socket server
    if (token.isNotEmpty) {
      // Connect to socket server
      // 1. Remove /api suffix
      // 2. Remove trailing slash if present to avoid double slashes
      var socketUrl = Env.baseUrl.replaceAll('/api', '');
      if (socketUrl.endsWith('/')) {
        socketUrl = socketUrl.substring(0, socketUrl.length - 1);
      }

      debugPrint('Connecting to socket at: $socketUrl');
      socketService.connect(socketUrl, token);

      // Start listening to RTDB notifications (foreground updates)
      final userId = await sl<CacheHelper>().getUserId();
      if (userId != null && userId.isNotEmpty) {
        notificationService.listenToRealtimeNotifications(userId);
      }

      // Listen for patient-specific events
      socketService.listenForPatientEvents(
        onAppointmentUpdated: (data) {
          debugPrint('Appointment updated via socket: $data');
          appointmentsCubit.getMyAppointments();
        },
        onPrescriptionCreated: (data) {
          debugPrint('Prescription created via socket: $data');
          prescriptionsCubit.getMyPrescriptions();
        },
      );
    }
  } catch (e) {
    debugPrint('Notification initialization failed: $e');
  }
}
