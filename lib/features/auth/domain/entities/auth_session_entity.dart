import 'package:equatable/equatable.dart';
import 'user_entity.dart';

class AuthSessionEntity extends Equatable {
  final String token;
  final UserEntity? user;

  const AuthSessionEntity({
    required this.token,
    this.user,
  });

  @override
  List<Object?> get props => [token, user];
}
