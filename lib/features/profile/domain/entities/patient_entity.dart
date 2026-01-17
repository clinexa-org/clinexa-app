// features/profile/domain/entities/patient_entity.dart
import 'package:equatable/equatable.dart';

/// User entity with avatar
class UserEntity extends Equatable {
  final String? id;
  final String? name;
  final String? email;
  final String? avatar;

  const UserEntity({
    this.id,
    this.name,
    this.email,
    this.avatar,
  });

  @override
  List<Object?> get props => [id, name, email, avatar];
}

class PatientEntity extends Equatable {
  final String? id;
  final UserEntity? user; // User with avatar
  final int? age;
  final String? gender;
  final String? phone;
  final String? address;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const PatientEntity({
    this.id,
    this.user,
    this.age,
    this.gender,
    this.phone,
    this.address,
    this.createdAt,
    this.updatedAt,
  });

  /// Get avatar URL from user
  String? get avatar => user?.avatar;

  /// Get user name
  String? get name => user?.name;

  /// Get user email
  String? get email => user?.email;

  bool get isComplete {
    return age != null && gender != null && phone != null && address != null;
  }

  @override
  List<Object?> get props => [
        id,
        user,
        age,
        gender,
        phone,
        address,
        createdAt,
        updatedAt,
      ];
}
