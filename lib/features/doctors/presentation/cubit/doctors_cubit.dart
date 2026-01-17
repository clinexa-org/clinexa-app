import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/doctor_entity.dart';
import '../../domain/usecases/get_doctors_usecase.dart';
import 'doctors_state.dart';

class DoctorsCubit extends Cubit<DoctorsState> {
  final GetDoctorsUseCase getDoctorsUseCase;

  DoctorsCubit({required this.getDoctorsUseCase}) : super(const DoctorsState());

  Future<void> getDoctors() async {
    emit(state.copyWith(status: DoctorsStatus.loading));

    final result = await getDoctorsUseCase();

    result.fold(
      (failure) => emit(state.copyWith(
        status: DoctorsStatus.failure,
        errorMessage: failure.message,
      )),
      (doctors) => emit(state.copyWith(
        status: DoctorsStatus.success,
        doctors: doctors,
      )),
    );
  }

  void selectDoctor(DoctorEntity doctor) {
    emit(state.copyWith(selectedDoctor: doctor));
  }
}
