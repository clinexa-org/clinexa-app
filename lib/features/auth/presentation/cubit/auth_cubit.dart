// features/auth/presentation/cubit/auth_cubit.dart
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../domain/usecases/register_usecase.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository repository;
  final LoginUseCase loginUseCase;
  final RegisterUseCase registerUseCase;
  final LogoutUseCase logoutUseCase;

  AuthCubit({
    required this.repository,
    required this.loginUseCase,
    required this.registerUseCase,
    required this.logoutUseCase,
  }) : super(const AuthState());

  static AuthCubit get(BuildContext context, {bool listen = false}) =>
      BlocProvider.of<AuthCubit>(context, listen: listen);

  Future<void> init() async {
    final either = await repository.getCachedToken();

    either.fold(
          (failure) {
        emit(
          state.copyWith(
            status: AuthStatus.errorWithToast,
            errorMessage: failure.message,
          ),
        );
      },
          (token) {
        if (token != null && token.isNotEmpty) {
          emit(
            state.copyWith(
              status: AuthStatus.authenticated,
              token: token,
              clearError: true,
            ),
          );
        } else {
          emit(
            state.copyWith(
              status: AuthStatus.unauthenticated,
              clearToken: true,
              clearError: true,
            ),
          );
        }
      },
    );
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    emit(
      state.copyWith(
        status: AuthStatus.loading,
        clearError: true,
      ),
    );

    final either = await loginUseCase(email: email, password: password);

    either.fold(
          (failure) {
        emit(
          state.copyWith(
            status: AuthStatus.errorWithToast,
            errorMessage: failure.message,
          ),
        );
      },
          (session) {
        emit(
          state.copyWith(
            status: AuthStatus.authenticated,
            token: session.token,
            clearError: true,
          ),
        );
      },
    );
  }

  Future<void> register({
    required String name,
    required String email,
    required String password,
    String role = 'patient',
  }) async {
    emit(
      state.copyWith(
        status: AuthStatus.loading,
        clearError: true,
      ),
    );

    final either = await registerUseCase(
      name: name,
      email: email,
      password: password,
      role: role,
    );

    either.fold(
          (failure) {
        emit(
          state.copyWith(
            status: AuthStatus.errorWithToast,
            errorMessage: failure.message,
          ),
        );
      },
          (session) {
        emit(
          state.copyWith(
            status: AuthStatus.authenticated,
            token: session.token,
            clearError: true,
          ),
        );
      },
    );
  }

  Future<void> logout() async {
    final either = await logoutUseCase();

    either.fold(
          (failure) {
        emit(
          state.copyWith(
            status: AuthStatus.errorWithToast,
            errorMessage: failure.message,
          ),
        );
      },
          (_) {
        emit(
          state.copyWith(
            status: AuthStatus.unauthenticated,
            clearToken: true,
            clearError: true,
          ),
        );
      },
    );
  }

  void clearToast() {
    if (state.status == AuthStatus.errorWithToast) {
      emit(state.copyWith(status: AuthStatus.initial, clearError: true));
    }
  }
}