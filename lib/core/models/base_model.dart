import 'dart:convert';
import 'package:equatable/equatable.dart';

abstract class BaseModel extends Equatable {
  const BaseModel();

  Map<String, dynamic> toMap();

  String toJson() => json.encode(toMap());

  Map<String, dynamic> toJsonMap() => toMap();

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [];
}
