// features/profile/presentation/cubit/patient_cubit.dart
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/get_my_profile_usecase.dart';
import '../../domain/usecases/update_profile_usecase.dart';
import 'patient_state.dart';

class PatientCubit extends Cubit<PatientState> {
  final GetMyProfileUseCase getMyProfileUseCase;
  final UpdateProfileUseCase updateProfileUseCase;

  PatientCubit({
    required this.getMyProfileUseCase,
    required this.updateProfileUseCase,
  }) : super(const PatientState());

  static PatientCubit get(BuildContext context, {bool listen = false}) =>
      BlocProvider.of<PatientCubit>(context, listen: listen);

  Future<void> getMyProfile() async {
    emit(state.copyWith(status: PatientStatus.loading, clearError: true));

    final either = await getMyProfileUseCase();

    either.fold(
      (failure) {
        emit(
          state.copyWith(
            status: PatientStatus.error,
            errorMessage: failure.message,
          ),
        );
      },
      (patient) {
        emit(
          state.copyWith(
            status: PatientStatus.success,
            patient: patient,
            clearError: true,
          ),
        );
      },
    );
  }

  Future<void> updateProfile({
    required String name,
    required int age,
    required String gender,
    required String phone,
    required String address,
    File? avatar,
  }) async {
    emit(state.copyWith(status: PatientStatus.loading, clearError: true));

    final either = await updateProfileUseCase(
      name: name,
      age: age,
      gender: gender,
      phone: phone,
      address: address,
      avatar: avatar,
    );

    either.fold(
      (failure) {
        emit(
          state.copyWith(
            status: PatientStatus.error,
            errorMessage: failure.message,
          ),
        );
      },
      (patient) {
        emit(
          state.copyWith(
            status: PatientStatus.success,
            patient: patient,
            clearError: true,
          ),
        );
      },
    );
  }

  void clearError() {
    if (state.status == PatientStatus.error) {
      emit(state.copyWith(
        status: PatientStatus.initial,
        clearError: true,
      ));
    }
  }
}
