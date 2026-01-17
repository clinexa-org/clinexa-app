import 'package:equatable/equatable.dart';

class DoctorEntity extends Equatable {
  final String id;
  final String name;
  final String email;
  final String specialization;
  final String about;
  final String phone;
  final String? profileImage;
  final double rating;
  final int reviewsCount;
  final int patientsCount;
  final String clinicName;
  final String clinicAddress;
  final double consultationPrice;

  const DoctorEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.specialization,
    required this.about,
    required this.phone,
    this.profileImage,
    this.rating = 0.0,
    this.reviewsCount = 0,
    this.patientsCount = 0,
    this.clinicName = '',
    this.clinicAddress = '',
    this.consultationPrice = 0.0,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        email,
        specialization,
        about,
        phone,
        profileImage,
        rating,
        reviewsCount,
        patientsCount,
        clinicName,
        clinicAddress,
        consultationPrice,
      ];
}
