

import 'package:equatable/equatable.dart';

enum AuthStatus {
  initial,
  loading,
  authenticated,
  unauthenticated,
  errorWithToast,
}

class AuthState extends Equatable {
  final AuthStatus status;
  final String? token;
  final String? errorMessage;

  const AuthState({
    this.status = AuthStatus.initial,
    this.token,
    this.errorMessage,
  });

  bool get isAuthed => status == AuthStatus.authenticated && (token?.isNotEmpty ?? false);

  AuthState copyWith({
    AuthStatus? status,
    String? token,
    String? errorMessage,
    bool clearError = false,
    bool clearToken = false,
  }) {
    return AuthState(
      status: status ?? this.status,
      token: clearToken ? null : (token ?? this.token),
      errorMessage: clearError ? null : errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, token, errorMessage];
}
