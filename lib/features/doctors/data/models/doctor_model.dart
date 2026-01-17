import '../../domain/entities/doctor_entity.dart';

class DoctorModel extends DoctorEntity {
  const DoctorModel({
    required super.id,
    required super.name,
    required super.email,
    required super.specialization,
    required super.about,
    required super.phone,
    super.profileImage,
    super.rating,
    super.reviewsCount,
    super.patientsCount,
    super.clinicName,
    super.clinicAddress,
    super.consultationPrice,
  });

  factory DoctorModel.fromJson(Map<String, dynamic> json) {
    return DoctorModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? 'Unknown Doctor',
      email: json['email'] ?? '',
      specialization: json['specialization'] ?? 'General',
      about: json['about'] ?? '',
      phone: json['phone'] ?? '',
      profileImage: json['profile_image'],
      // Parse additional fields if available, otherwise defaults
      rating: (json['rating'] as num?)?.toDouble() ?? 4.5,
      reviewsCount: json['reviews_count'] ?? 0,
      patientsCount: json['patients_count'] ?? 0,
      clinicName: json['clinic_name'] ?? '',
      clinicAddress: json['clinic_address'] ?? '',
      consultationPrice:
          (json['consultation_price'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'name': name,
      'email': email,
      'specialization': specialization,
      'about': about,
      'phone': phone,
      'profile_image': profileImage,
      'rating': rating,
      'reviews_count': reviewsCount,
      'patients_count': patientsCount,
      'clinic_name': clinicName,
      'clinic_address': clinicAddress,
      'consultation_price': consultationPrice,
    };
  }
}
