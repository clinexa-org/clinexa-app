// core/di/injection.dart
import 'package:clinexa_mobile/features/profile/domain/repositories/patient_repository.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';

import '../../features/profile/data/datasources/patient_remote_data_source.dart';
import '../../features/profile/data/repositories/patient_repository_impl.dart';
import '../../features/profile/domain/usecases/get_my_profile_usecase.dart';
import '../../features/profile/domain/usecases/update_profile_usecase.dart';
import '../../features/profile/presentation/cubit/patient_cubit.dart';

import '../../features/appointments/data/datasources/appointment_remote_data_source.dart';
import '../../features/appointments/data/repositories/appointments_repository_impl.dart';
import '../../features/appointments/domain/repositories/appointments_repository.dart';
import '../../features/appointments/domain/usecases/create_appointment_usecase.dart';
import '../../features/appointments/domain/usecases/get_my_appointments_usecase.dart';
import '../../features/appointments/domain/usecases/reschedule_appointment_usecase.dart';
import '../../features/appointments/domain/usecases/cancel_appointment_usecase.dart';
import '../../features/appointments/domain/usecases/get_slots_usecase.dart';
import '../../features/appointments/presentation/cubit/appointments_cubit.dart';

import '../../features/prescriptions/data/datasources/prescription_remote_data_source.dart';
import '../../features/prescriptions/data/repositories/prescriptions_repository_impl.dart';
import '../../features/prescriptions/domain/repositories/prescriptions_repository.dart';
import '../../features/prescriptions/domain/usecases/get_my_prescriptions_usecase.dart';
import '../../features/prescriptions/presentation/cubit/prescriptions_cubit.dart';

import '../../features/doctors/data/datasources/doctor_remote_data_source.dart';
import '../../features/doctors/data/repositories/doctors_repository_impl.dart';
import '../../features/doctors/domain/repositories/doctors_repository.dart';
import '../../features/doctors/domain/usecases/get_doctors_usecase.dart';
import '../../features/doctors/presentation/cubit/doctors_cubit.dart';

import '../../app/app.dart';
import '../network/api_client.dart';
import '../network/dio_factory.dart';
import '../presentation/cubit/layout_cubit.dart';
import '../storage/cache_helper.dart';

import '../../features/auth/data/datasources/auth_local_data_source.dart';
import '../../features/auth/data/datasources/auth_remote_data_source.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/forgot_password_usecase.dart';
import '../../features/auth/domain/usecases/login_usecase.dart';
import '../../features/auth/domain/usecases/logout_usecase.dart';
import '../../features/auth/domain/usecases/register_usecase.dart';
import '../../features/auth/domain/usecases/reset_password_usecase.dart';
import '../../features/auth/presentation/cubit/auth_cubit.dart';

import '../services/notification_service.dart';
import '../services/socket_service.dart';
import '../../features/notifications/data/datasources/notification_remote_data_source.dart';
import '../../features/notifications/data/repositories/notifications_repository_impl.dart';
import '../../features/notifications/domain/repositories/notifications_repository.dart';
import '../../features/notifications/domain/usecases/get_notifications_usecase.dart';
import '../../features/notifications/domain/usecases/mark_notification_read_usecase.dart';
import '../../features/notifications/presentation/cubit/notifications_cubit.dart';

final sl = GetIt.instance;

Future<void> configureDependencies({required bool isProd}) async {
  /// Core
  sl.registerLazySingleton<FlutterSecureStorage>(
      () => const FlutterSecureStorage());
  sl.registerLazySingleton<CacheHelper>(() => CacheHelper());

  sl.registerLazySingleton<Dio>(() {
    final factory = DioFactory(
      cacheHelper: sl(),
      isProd: isProd,
      onUnauthorized: handleUnauthorized,
    );
    return factory.create();
  });

  sl.registerLazySingleton<ApiClient>(() => ApiClient(sl()));

  /// Auth
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSource(sl()),
  );

  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(
        remote: sl(),
        local: sl(),
      ));

  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => RegisterUseCase(sl()));
  sl.registerLazySingleton(() => LogoutUseCase(sl()));
  sl.registerLazySingleton(() => ForgotPasswordUseCase(sl()));
  sl.registerLazySingleton(() => ResetPasswordUseCase(sl()));

  sl.registerFactory<AuthCubit>(
    () => AuthCubit(
      repository: sl(),
      loginUseCase: sl(),
      registerUseCase: sl(),
      logoutUseCase: sl(),
      forgotPasswordUseCase: sl(),
      resetPasswordUseCase: sl(),
    ),
  );

  /// Patient
  sl.registerLazySingleton<PatientRemoteDataSource>(
    () => PatientRemoteDataSourceImpl(sl()),
  );

  sl.registerLazySingleton<PatientRepository>(() => PatientRepositoryImpl(
        remote: sl(),
        local: sl(),
      ));

  sl.registerLazySingleton(() => GetMyProfileUseCase(sl()));
  sl.registerLazySingleton(() => UpdateProfileUseCase(sl()));

  sl.registerFactory<PatientCubit>(
    () => PatientCubit(
      getMyProfileUseCase: sl(),
      updateProfileUseCase: sl(),
    ),
  );

  /// Layout/App
  sl.registerFactory<LayoutCubit>(
    () => LayoutCubit(
      cacheHelper: sl(),
      authRepository: sl(),
    ),
  );

  /// Appointments
  sl.registerLazySingleton<AppointmentRemoteDataSource>(
    () => AppointmentRemoteDataSourceImpl(sl()),
  );

  sl.registerLazySingleton<AppointmentsRepository>(
      () => AppointmentsRepositoryImpl(remoteDataSource: sl()));

  sl.registerLazySingleton(() => GetMyAppointmentsUseCase(sl()));
  sl.registerLazySingleton(() => CreateAppointmentUseCase(sl()));
  sl.registerLazySingleton(() => RescheduleAppointmentUseCase(sl()));
  sl.registerLazySingleton(() => CancelAppointmentUseCase(sl()));
  sl.registerLazySingleton(() => GetSlotsUseCase(sl()));

  sl.registerFactory<AppointmentsCubit>(
    () => AppointmentsCubit(
      getMyAppointmentsUseCase: sl(),
      createAppointmentUseCase: sl(),
      rescheduleAppointmentUseCase: sl(),
      cancelAppointmentUseCase: sl(),
      getSlotsUseCase: sl(),
    ),
  );

  /// Prescriptions
  sl.registerLazySingleton<PrescriptionRemoteDataSource>(
    () => PrescriptionRemoteDataSourceImpl(sl()),
  );

  sl.registerLazySingleton<PrescriptionsRepository>(
      () => PrescriptionsRepositoryImpl(remoteDataSource: sl()));

  sl.registerLazySingleton(() => GetMyPrescriptionsUseCase(sl()));

  sl.registerFactory<PrescriptionsCubit>(
    () => PrescriptionsCubit(getMyPrescriptionsUseCase: sl()),
  );

  /// Doctors
  sl.registerLazySingleton<DoctorRemoteDataSource>(
    () => DoctorRemoteDataSourceImpl(sl()),
  );

  sl.registerLazySingleton<DoctorsRepository>(
      () => DoctorsRepositoryImpl(remoteDataSource: sl()));

  sl.registerLazySingleton(() => GetDoctorsUseCase(sl()));

  sl.registerFactory<DoctorsCubit>(
    () => DoctorsCubit(getDoctorsUseCase: sl()),
  );

  /// Notification Services
  sl.registerLazySingleton<NotificationService>(
    () => NotificationService(sl()),
  );
  sl.registerLazySingleton<SocketService>(() => SocketService());

  /// Notifications Feature
  sl.registerLazySingleton<NotificationRemoteDataSource>(
    () => NotificationRemoteDataSourceImpl(sl()),
  );

  sl.registerLazySingleton<NotificationsRepository>(
      () => NotificationsRepositoryImpl(remoteDataSource: sl()));

  sl.registerLazySingleton(() => GetNotificationsUseCase(sl()));
  sl.registerLazySingleton(() => MarkNotificationReadUseCase(sl()));

  sl.registerFactory<NotificationsCubit>(
    () => NotificationsCubit(
      getNotificationsUseCase: sl(),
      markNotificationReadUseCase: sl(),
    ),
  );
}
