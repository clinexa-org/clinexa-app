// app/app.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:toastification/toastification.dart';

import 'theme/app_theme.dart';

class ClinexaApp extends StatelessWidget {
  final GoRouter router;

  const ClinexaApp({super.key, required this.router});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812), // iPhone X base design
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return ToastificationWrapper(
          child: MaterialApp.router(
            debugShowCheckedModeBanner: false,
            title: 'Clinexa',
            theme: AppTheme.darkTheme,
            routerConfig: router,
          ),
        );
      },
    );
  }
}
