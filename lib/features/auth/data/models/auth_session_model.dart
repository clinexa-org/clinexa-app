// import '../../domain/entities/auth_session_entity.dart';
// import 'user_model.dart';

// class AuthSessionModel {
//   final String token;
//   final UserModel? user;

//   const AuthSessionModel({
//     required this.token,
//     this.user,
//   });

//   factory AuthSessionModel.fromJson(Map<String, dynamic> json) {
//     final data = json['data'];
//     final rootToken = json['token'];
//     String? token;

//     if (data is Map<String, dynamic> && data['token'] is String) {
//       token = data['token'] as String;
//     } else if (rootToken is String) {
//       token = rootToken;
//     }

//     final userJson = (data is Map<String, dynamic>) ? data['user'] : json['user'];
//     UserModel? user;
//     if (userJson is Map<String, dynamic>) {
//       user = UserModel.fromMap(userJson);
//     }

//     return AuthSessionModel(
//       token: token ?? '',
//       user: user,
//     );
//   }

//   AuthSessionEntity toEntity() {
//     return AuthSessionEntity(
//       token: token,
//       user: user?.toEntity(),
//     );
//   }
// }
