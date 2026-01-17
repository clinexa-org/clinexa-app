// core/presentation/cubit/layout_cubit.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app/router/route_names.dart';
import '../../../features/auth/domain/repositories/auth_repository.dart';
import '../../storage/cache_helper.dart';
import 'layout_state.dart';

class LayoutCubit extends Cubit<LayoutState> {
  final CacheHelper cacheHelper;
  final AuthRepository authRepository;

  LayoutCubit({
    required this.cacheHelper,
    required this.authRepository,
  }) : super(const LayoutState());

  Future<void> determineInitialRoute() async {
    emit(state.copyWith(status: LayoutStatus.loading));

    final hasSeenOnboarding = await cacheHelper.hasSeenOnboarding();

    String initialRoute;

    if (!hasSeenOnboarding) {
      initialRoute = Routes.onboarding;
    } else {
      // Check if user is logged in
      final result = await authRepository.getCachedToken();

      final hasValidToken = result.fold(
        (failure) => false,
        (token) => token != null && token.isNotEmpty,
      );

      initialRoute = hasValidToken ? Routes.home : Routes.login;
    }

    emit(
      state.copyWith(
        status: LayoutStatus.ready,
        initialRoute: initialRoute,
      ),
    );
  }

  /// Load saved language from cache
  Future<void> loadSavedLanguage() async {
    final langCode = await cacheHelper.getCachedLanguageCode();
    final locale = Locale(langCode ?? 'en');
    emit(state.copyWith(locale: locale));
  }

  /// Change app language
  Future<void> changeLanguage(String languageCode) async {
    await cacheHelper.saveUserLang(languageCode);
    final locale = Locale(languageCode);
    emit(state.copyWith(locale: locale));
  }

  /// Check if current language is RTL
  bool get isRTL => state.isRTL;
}
