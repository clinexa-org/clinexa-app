import 'package:intl/intl.dart';
import '../../domain/entities/prescription_entity.dart';
import '../../../../core/utils/date_extensions.dart';

class PrescriptionModel extends PrescriptionEntity {
  const PrescriptionModel({
    required super.id,
    required super.date,
    required super.doctorName,
    required super.notes,
    required super.medicines,
  });

  factory PrescriptionModel.fromJson(Map<String, dynamic> json) {
    // Parse date if needed, or use raw string if API returns formatted date
    // Assuming API might return ISO date, let's format it simply or keep raw
    // Postman example says "date": "...", let's assume it's a string for now or parse it

    final doctorData = json['doctor_id'];
    String doctorName = 'Unknown Doctor';
    if (doctorData is Map<String, dynamic>) {
      final userData = doctorData['user_id'];
      if (userData is Map<String, dynamic>) {
        doctorName = userData['name'] ?? 'Unknown Doctor';
      }
    }

    final items = json['items'] as List? ?? [];

    final createdAtStr = json['createdAt'] as String?;
    String formattedDate = '';
    if (createdAtStr != null) {
      final date = DateTime.parse(createdAtStr).toCairoTime;
      formattedDate = DateFormat('dd MMM yyyy • hh:mm a').format(date);
    }

    return PrescriptionModel(
      id: json['_id'] ?? '',
      date: formattedDate,
      doctorName: doctorName,
      notes: json['notes'] ?? '',
      medicines: items.map((e) => MedicineModel.fromJson(e)).toList(),
    );
  }
}

class MedicineModel extends MedicineEntity {
  const MedicineModel({
    required super.name,
    required super.dosage,
    required super.type,
    required super.duration,
    required super.instructions,
  });

  factory MedicineModel.fromJson(Map<String, dynamic> json) {
    return MedicineModel(
      name: json['name'] ?? '',
      dosage: json['dosage'] ?? '',
      type: json['type'] ?? 'Medicine',
      duration: json['duration'] ?? '',
      instructions: json['instructions'] ?? '',
    );
  }
}
