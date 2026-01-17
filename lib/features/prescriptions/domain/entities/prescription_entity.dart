import 'package:equatable/equatable.dart';

class PrescriptionEntity extends Equatable {
  final String id;
  final String date;
  final String doctorName;
  final String notes;
  final List<MedicineEntity> medicines;

  const PrescriptionEntity({
    required this.id,
    required this.date,
    required this.doctorName,
    required this.notes,
    required this.medicines,
  });

  @override
  List<Object?> get props => [id, date, doctorName, notes, medicines];
}

class MedicineEntity extends Equatable {
  final String name;
  final String dosage;
  final String type;
  final String duration;
  final String instructions;

  const MedicineEntity({
    required this.name,
    required this.dosage,
    required this.type,
    required this.duration,
    required this.instructions,
  });

  @override
  List<Object?> get props => [name, dosage, type, duration, instructions];
}
