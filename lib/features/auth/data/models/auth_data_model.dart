import '../../../../core/models/base_model.dart';
import '../../domain/entities/auth_session_entity.dart';
import 'user_model.dart';

class AuthDataModel extends BaseModel {
  final UserModel user;
  final String token;

  const AuthDataModel({
    required this.user,
    required this.token,
  });

  AuthDataModel copyWith({
    UserModel? user,
    String? token,
  }) {
    return AuthDataModel(
      user: user ?? this.user,
      token: token ?? this.token,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'user': user.toMap(),
      'token': token,
    };
  }

  factory AuthDataModel.fromMap(Map<String, dynamic> map) {
    return AuthDataModel(
      user: UserModel.fromMap(map['user'] as Map<String, dynamic>),
      token: map['token'] as String,
    );
  }

  AuthSessionEntity toEntity() {
    return AuthSessionEntity(
      token: token,
      user: user.toEntity(),
    );
  }

  @override
  List<Object?> get props => [user, token];
}
