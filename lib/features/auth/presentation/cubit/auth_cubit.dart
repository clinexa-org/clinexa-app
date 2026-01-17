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
      (token) async {
        if (token != null && token.isNotEmpty) {
          // Token found, try to get user details
          final userResult = await repository.getCachedUser();
          String? userName;
          String? userId;
          String? role;
          String? avatar;

          userResult.fold(
            (_) {}, // Ignore cached user error, just proceed with token
            (user) {
              userName = user?.name;
              userId = user?.id;
              role = user?.role;
              avatar = user?.avatar;
            },
          );

          emit(
            state.copyWith(
              status: AuthStatus.authenticatedFromCache,
              token: token,
              userName: userName,
              userId: userId,
              role: role,
              avatar: avatar,
              clearError: true,
            ),
          );
        } else {
          emit(
            state.copyWith(
              status: AuthStatus.unauthenticated,
              clearToken: true, // This also clears user details in AuthState
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
        status: AuthStatus.loadingLogin,
        clearError: true,
      ),
    );

    final either = await loginUseCase(email: email, password: password);

    either.fold(
      (failure) {
        emit(
          state.copyWith(
            status: AuthStatus.errorLogin,
            errorMessage: failure.message,
          ),
        );
      },
      (session) {
        emit(
          state.copyWith(
            status: AuthStatus.authenticatedFromLogin,
            token: session.token,
            userName: session.user?.name,
            userId: session.user?.id,
            role: session.user?.role,
            avatar: session.user?.avatar,
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
        status: AuthStatus.loadingRegister,
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
            status: AuthStatus.errorRegister,
            errorMessage: failure.message,
          ),
        );
      },
      (session) {
        emit(
          state.copyWith(
            status: AuthStatus.authenticatedFromRegister,
            token: session.token,
            userName: session.user?.name,
            userId: session.user?.id,
            role: session.user?.role,
            avatar: session.user?.avatar,
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

  void updateUser({String? name, String? avatar}) {
    emit(state.copyWith(
      userName: name,
      avatar: avatar,
    ));
  }
}
