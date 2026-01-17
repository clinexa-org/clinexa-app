import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_my_prescriptions_usecase.dart';
import 'prescriptions_state.dart';

class PrescriptionsCubit extends Cubit<PrescriptionsState> {
  final GetMyPrescriptionsUseCase getMyPrescriptionsUseCase;

  PrescriptionsCubit({required this.getMyPrescriptionsUseCase})
      : super(const PrescriptionsState());

  Future<void> getMyPrescriptions() async {
    emit(state.copyWith(status: PrescriptionsStatus.loading));

    final result = await getMyPrescriptionsUseCase();

    result.fold(
      (failure) => emit(state.copyWith(
        status: PrescriptionsStatus.failure,
        errorMessage: failure.message,
      )),
      (prescriptions) => emit(state.copyWith(
        status: PrescriptionsStatus.success,
        prescriptions: prescriptions,
      )),
    );
  }
}
