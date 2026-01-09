// features/profile/domain/entities/patient_entity.dart
import 'package:equatable/equatable.dart';

class PatientEntity extends Equatable {
  final String? id;
  final String? userId;
  final int? age;
  final String? gender;
  final String? phone;
  final String? address;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const PatientEntity({
    this.id,
    this.userId,
    this.age,
    this.gender,
    this.phone,
    this.address,
    this.createdAt,
    this.updatedAt,
  });

  bool get isComplete {
    return age != null &&
        gender != null &&
        phone != null &&
        address != null;
  }

  @override
  List<Object?> get props => [
        id,
        userId,
        age,
        gender,
        phone,
        address,
        createdAt,
        updatedAt,
      ];
}