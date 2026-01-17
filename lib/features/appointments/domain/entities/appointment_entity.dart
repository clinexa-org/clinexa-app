import 'package:equatable/equatable.dart';

class AppointmentEntity extends Equatable {
  final String id;
  final String date;
  final String time;
  final String reason;
  final String status;
  final String doctorName;
  final String doctorSpecialty;
  final String doctorImage;
  final String clinicName;
  final String clinicAddress;
  final double? latitude;
  final double? longitude;

  const AppointmentEntity({
    required this.id,
    required this.date,
    required this.time,
    required this.reason,
    required this.status,
    required this.doctorName,
    required this.doctorSpecialty,
    required this.doctorImage,
    required this.clinicName,
    required this.clinicAddress,
    this.latitude,
    this.longitude,
  });

  @override
  List<Object?> get props => [
        id,
        date,
        time,
        reason,
        status,
        doctorName,
        doctorSpecialty,
        doctorImage,
        clinicName,
        clinicAddress,
        latitude,
        longitude
      ];
}
