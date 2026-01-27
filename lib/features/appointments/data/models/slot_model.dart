import '../../domain/entities/slot_entity.dart';

class SlotModel extends SlotEntity {
  const SlotModel({required super.time, required super.status});

  factory SlotModel.fromJson(Map<String, dynamic> json) {
    return SlotModel(
      time: DateTime.parse(json['time']),
      status: json['status'],
    );
  }
}
