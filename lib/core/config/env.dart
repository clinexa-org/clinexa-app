import 'package:flutter_dotenv/flutter_dotenv.dart';

enum EnvFile { dev, prod }

class Env {
  static Future<void> load(EnvFile file) async {
    final path = switch (file) {
      EnvFile.dev => 'assets/env/.env.dev',
      EnvFile.prod => 'assets/env/.env.prod',
    };
    await dotenv.load(fileName: path);
  }

  static String get baseUrl {
    final v = dotenv.env['BASE_URL'] ?? '';
    if (v.isEmpty) {
      throw Exception('BASE_URL is missing from .env file');
    }
    return v;
  }
}
