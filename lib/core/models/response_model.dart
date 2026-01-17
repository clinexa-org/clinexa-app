import 'dart:convert';
import 'package:equatable/equatable.dart';

import 'base_model.dart';

class ResponseModel<T> extends Equatable {
  final bool success;
  final String message;
  final T? data;

  const ResponseModel({
    required this.success,
    required this.message,
    required this.data,
  });

  ResponseModel<T> copyWith({
    bool? success,
    String? message,
    T? data,
  }) {
    return ResponseModel<T>(
      success: success ?? this.success,
      message: message ?? this.message,
      data: data ?? this.data,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'success': success,
      'message': message,
      'data': (data is BaseModel) ? (data as BaseModel).toMap() : data,
    };
  }

  factory ResponseModel.fromMap(
    Map<String, dynamic> map,
    T Function(Map<String, dynamic> map)? dataFromMap,
  ) {
    return ResponseModel<T>(
      success: map['success'] as bool? ?? false,
      message: map['message'] as String? ?? '',
      data: map['data'] != null && dataFromMap != null
          ? dataFromMap(map['data'] as Map<String, dynamic>)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ResponseModel.fromJson(
    String source,
    T Function(Map<String, dynamic> map)? dataFromMap,
  ) =>
      ResponseModel.fromMap(
        json.decode(source) as Map<String, dynamic>,
        dataFromMap,
      );

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [success, message, data];
}
