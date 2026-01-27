import 'package:equatable/equatable.dart';

class SlotEntity extends Equatable {
  final DateTime time;
  final String status;

  const SlotEntity({required this.time, required this.status});

  bool get isBooked => status == 'booked';

  @override
  List<Object?> get props => [time, status];
}
