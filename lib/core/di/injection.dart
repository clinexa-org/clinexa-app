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
import '../config/env.dart';
import '../network/api_client.dart';
import '../network/dio_factory.dart';
import '../presentation/cubit/layout_cubit.dart';
import '../storage/cache_helper.dart';

import '../../features/auth/data/datasources/auth_local_data_source.dart';
import '../../features/auth/data/datasources/auth_remote_data_source.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/login_usecase.dart';
import '../../features/auth/domain/usecases/logout_usecase.dart';
import '../../features/auth/domain/usecases/register_usecase.dart';
import '../../features/auth/presentation/cubit/auth_cubit.dart';

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

  sl.registerFactory<AuthCubit>(
    () => AuthCubit(
      repository: sl(),
      loginUseCase: sl(),
      registerUseCase: sl(),
      logoutUseCase: sl(),
    ),
  );

  /// Patient
  sl.registerLazySingleton<PatientRemoteDataSource>(
    () => PatientRemoteDataSource(sl()),
  );

  sl.registerLazySingleton<PatientRepository>(() => PatientRepositoryImpl(
        remote: sl(),
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
}
