import 'package:intl/intl.dart';
import '../../domain/entities/appointment_entity.dart';
import '../../../../core/utils/date_extensions.dart';

class AppointmentModel extends AppointmentEntity {
  const AppointmentModel({
    required super.id,
    required super.date,
    required super.time,
    required super.reason,
    required super.status,
    required super.doctorName,
    required super.doctorSpecialty,
    required super.doctorImage,
    required super.clinicName,
    required super.clinicAddress,
    super.latitude,
    super.longitude,
  });

  factory AppointmentModel.fromJson(Map<String, dynamic> json) {
    final startTimeString = json['start_time'];
    final startTime = startTimeString != null
        ? DateTime.parse(startTimeString)
        : DateTime.now();

    // Handle nested doctor data: doctor_id -> user_id -> name
    final doctorData = json['doctor_id'];
    String doctorName = 'Unknown Doctor';
    String doctorImage = '';
    String doctorSpecialty = 'General';

    if (doctorData is Map) {
      final userData = doctorData['user_id'];
      if (userData is Map) {
        doctorName = userData['name'] ?? 'Unknown Doctor';
        doctorImage = userData['avatar'] ?? '';
      }
      doctorSpecialty = doctorData['specialization'] ?? 'General';
    }

    final clinic = json['clinic_id'] ?? json['clinic'] ?? {};

    final cairoTime = startTime.toCairoTime;

    return AppointmentModel(
      id: json['_id'] ?? '',
      date: DateFormat('yyyy-MM-dd').format(cairoTime),
      time: DateFormat('hh:mm a').format(cairoTime),
      reason: json['reason'] ?? '',
      status: json['status'] ?? 'pending',
      doctorName: doctorName,
      doctorSpecialty: doctorSpecialty,
      doctorImage: doctorImage,
      clinicName: clinic['name'] ?? 'Unknown Clinic',
      clinicAddress: clinic['address'] ?? '',
      latitude: clinic['location'] != null &&
              clinic['location']['coordinates'] != null
          ? (clinic['location']['coordinates'][1] as num).toDouble()
          : null,
      longitude: clinic['location'] != null &&
              clinic['location']['coordinates'] != null
          ? (clinic['location']['coordinates'][0] as num).toDouble()
          : null,
    );
  }
}
