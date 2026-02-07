import 'package:flutter/material.dart';
import '../../core/localization/app_localizations.dart';

/// Screen shown when app fails to initialize
class AppInitializationErrorScreen extends StatelessWidget {
  const AppInitializationErrorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline,
                  size: 64,
                  color: Colors.red,
                ),
                const SizedBox(height: 16),
                Text(
                  'error_app_init'.tr(context),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'msg_restart_app'.tr(context),
                  style: const TextStyle(color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    // Could trigger app restart or cleanup here
                  },
                  child: Text('retry'.tr(context)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
