// features/profile/data/models/patient_model.dart
import '../../domain/entities/patient_entity.dart';

class PatientModel {
  final String? id;
  final String? userId;
  final int? age;
  final String? gender;
  final String? phone;
  final String? address;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const PatientModel({
    this.id,
    this.userId,
    this.age,
    this.gender,
    this.phone,
    this.address,
    this.createdAt,
    this.updatedAt,
  });

  factory PatientModel.fromJson(Map<String, dynamic> json) {
    return PatientModel(
      id: (json['_id'] ?? json['id'])?.toString(),
      userId: json['user_id']?.toString(),
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
      if (age != null) 'age': age,
      if (gender != null) 'gender': gender,
      if (phone != null) 'phone': phone,
      if (address != null) 'address': address,
    };
  }

  PatientEntity toEntity() {
    return PatientEntity(
      id: id,
      userId: userId,
      age: age,
      gender: gender,
      phone: phone,
      address: address,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}