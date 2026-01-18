// features/auth/domain/usecases/forgot_password_usecase.dart
import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../repositories/auth_repository.dart';

class ForgotPasswordUseCase {
  final AuthRepository repository;

  ForgotPasswordUseCase(this.repository);

  /// Returns the OTP expiration time in seconds
  Future<Either<Failure, int>> call({required String email}) {
    return repository.forgotPassword(email: email);
  }
}
