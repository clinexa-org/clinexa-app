// app/app.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../core/localization/app_localizations.dart';
import '../core/presentation/cubit/layout_cubit.dart';
import '../core/presentation/cubit/layout_state.dart';
import '../features/auth/presentation/cubit/auth_cubit.dart';
import '../features/auth/presentation/cubit/auth_state.dart';
import '../features/appointments/presentation/cubit/appointments_cubit.dart';
import '../features/prescriptions/presentation/cubit/prescriptions_cubit.dart';
import 'router/route_names.dart';

// Global navigator key for handling navigation from interceptors
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

// Global function to handle unauthorized state
void handleUnauthorized() {
  // Navigate to login screen
  navigatorKey.currentContext?.go(Routes.login);
}

class ClinexaApp extends StatelessWidget {
  final GoRouter router;
  final LayoutCubit layoutCubit;

  const ClinexaApp({
    super.key,
    required this.router,
    required this.layoutCubit,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LayoutCubit>.value(
      value: layoutCubit,
      child: BlocListener<AuthCubit, AuthState>(
        listenWhen: (previous, current) =>
            !previous.isAuthed && current.isAuthed,
        listener: (context, state) {
          // User just logged in - refresh data
          context.read<AppointmentsCubit>().getMyAppointments();
          context.read<PrescriptionsCubit>().getMyPrescriptions();
        },
        child: ScreenUtilInit(
          designSize: const Size(375, 812),
          minTextAdapt: true,
          splitScreenMode: true,
          builder: (context, child) {
            return BlocBuilder<LayoutCubit, LayoutState>(
              builder: (context, layoutState) {
                return MaterialApp.router(
                  debugShowCheckedModeBanner: false,
                  title: 'Clinexa',
                  routerConfig: router,

                  // Localization
                  locale: layoutState.locale,
                  supportedLocales: const [
                    Locale('en'),
                    Locale('ar'),
                  ],
                  localizationsDelegates: const [
                    AppLocalizations.delegate,
                    GlobalMaterialLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate,
                    GlobalCupertinoLocalizations.delegate,
                  ],

                  theme: ThemeData(
                    brightness: Brightness.dark,
                    scaffoldBackgroundColor: const Color(0xFF181A1B),
                    useMaterial3: true,
                  ),
                  darkTheme: ThemeData(
                    brightness: Brightness.dark,
                    scaffoldBackgroundColor: const Color(0xFF181A1B),
                    useMaterial3: true,
                  ),
                  themeMode: ThemeMode.dark,
                );
              },
            );
          },
        ),
      ),
    );
  }
}
