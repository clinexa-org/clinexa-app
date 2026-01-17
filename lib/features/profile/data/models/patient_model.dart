// features/profile/data/models/patient_model.dart
import 'package:equatable/equatable.dart';
import '../../../../core/models/base_model.dart';
import '../../domain/entities/patient_entity.dart';

class PatientDataModel extends BaseModel {
  final PatientModel patient;

  const PatientDataModel({required this.patient});

  factory PatientDataModel.fromMap(Map<String, dynamic> map) {
    return PatientDataModel(
      patient: PatientModel.fromJson(map['patient'] as Map<String, dynamic>),
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {'patient': patient.toJson()};
  }

  @override
  List<Object?> get props => [patient];
}

/// User model for populated user_id field
class UserModel extends Equatable {
  final String? id;
  final String? name;
  final String? email;
  final String? avatar;

  const UserModel({
    this.id,
    this.name,
    this.email,
    this.avatar,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: (json['_id'] ?? json['id'])?.toString(),
      name: json['name']?.toString(),
      email: json['email']?.toString(),
      avatar: json['avatar']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) '_id': id,
      if (name != null) 'name': name,
      if (email != null) 'email': email,
      if (avatar != null) 'avatar': avatar,
    };
  }

  UserEntity toEntity() {
    return UserEntity(
      id: id,
      name: name,
      email: email,
      avatar: avatar,
    );
  }

  @override
  List<Object?> get props => [id, name, email, avatar];
}

class PatientModel extends Equatable {
  final String? id;
  final UserModel? user; // Populated user with avatar
  final int? age;
  final String? gender;
  final String? phone;
  final String? address;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const PatientModel({
    this.id,
    this.user,
    this.age,
    this.gender,
    this.phone,
    this.address,
    this.createdAt,
    this.updatedAt,
  });

  factory PatientModel.fromJson(Map<String, dynamic> json) {
    // user_id can be a string (ID) or an object (populated user)
    UserModel? user;
    final userIdField = json['user_id'];
    if (userIdField is Map<String, dynamic>) {
      user = UserModel.fromJson(userIdField);
    }

    return PatientModel(
      id: (json['_id'] ?? json['id'])?.toString(),
      user: user,
      age: json['age'] as int?,
      gender: json['gender']?.toString(),
      phone: json['phone']?.toString(),
      address: json['address']?.toString(),
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString())
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'].toString())
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) '_id': id,
      if (user != null) 'user_id': user!.toJson(),
      if (age != null) 'age': age,
      if (gender != null) 'gender': gender,
      if (phone != null) 'phone': phone,
      if (address != null) 'address': address,
    };
  }

  PatientEntity toEntity() {
    return PatientEntity(
      id: id,
      user: user?.toEntity(),
      age: age,
      gender: gender,
      phone: phone,
      address: address,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  @override
  List<Object?> get props =>
      [id, user, age, gender, phone, address, createdAt, updatedAt];
}
