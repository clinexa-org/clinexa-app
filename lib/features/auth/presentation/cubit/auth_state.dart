import 'package:equatable/equatable.dart';

enum AuthStatus {
  initial,
  // Generic states
  loading, // Kept for compatibility
  authenticated, // Kept for compatibility
  unauthenticated,
  errorWithToast, // Kept for compatibility
  // Cache auth
  authenticatedFromCache, // Silent auth from cached token
  // Login states
  loadingLogin,
  authenticatedFromLogin,
  errorLogin,
  // Register states
  loadingRegister,
  authenticatedFromRegister,
  errorRegister,
  // Forgot password states
  loadingForgotPassword,
  forgotPasswordSuccess,
  errorForgotPassword,
  // Reset password states
  loadingResetPassword,
  resetPasswordSuccess,
  errorResetPassword,
}

class AuthState extends Equatable {
  final AuthStatus status;
  final String? token;
  final String? userName;
  final String? userId;
  final String? role;
  final String? avatar;
  final String? errorMessage;

  const AuthState({
    this.status = AuthStatus.initial,
    this.token,
    this.userName,
    this.userId,
    this.role,
    this.avatar,
    this.errorMessage,
  });

  bool get isAuthed =>
      (status == AuthStatus.authenticated ||
          status == AuthStatus.authenticatedFromCache ||
          status == AuthStatus.authenticatedFromLogin ||
          status == AuthStatus.authenticatedFromRegister) &&
      (token?.isNotEmpty ?? false);

  AuthState copyWith({
    AuthStatus? status,
    String? token,
    String? userName,
    String? userId,
    String? role,
    String? avatar,
    String? errorMessage,
    bool clearError = false,
    bool clearToken = false,
  }) {
    return AuthState(
      status: status ?? this.status,
      token: clearToken ? null : (token ?? this.token),
      userName: clearToken ? null : (userName ?? this.userName),
      userId: clearToken ? null : (userId ?? this.userId),
      role: clearToken ? null : (role ?? this.role),
      avatar: clearToken ? null : (avatar ?? this.avatar),
      errorMessage: clearError ? null : errorMessage,
    );
  }

  @override
  List<Object?> get props =>
      [status, token, userName, userId, role, avatar, errorMessage];
}
