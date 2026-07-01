import 'package:flutter_reminders/core/network/dio_client.dart';
import 'package:flutter_reminders/core/storage/local_storage.dart';
import 'package:flutter_reminders/core/storage/token_storage.dart';
import 'package:flutter_reminders/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:flutter_reminders/features/auth/domain/repositories/auth_repository.dart';
import 'package:flutter_reminders/features/auth/domain/usecases/checkauthstatus_logout_usecase.dart';
import 'package:flutter_reminders/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter_reminders/features/reminder/domain/usecases/add_reminder_usecase.dart';
import 'package:flutter_reminders/features/reminder/domain/usecases/delete_reminder_usecase.dart';
import 'package:flutter_reminders/features/reminder/domain/usecases/get_reminder_by_id_usecase.dart';
import 'package:flutter_reminders/features/reminder/domain/usecases/get_reminders_usecase.dart';
import 'package:flutter_reminders/features/reminder/domain/usecases/update_reminder_usecase.dart';
import 'package:flutter_reminders/features/reminder/presentation/bloc/reminder_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/settings/settings_cubit.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/usecases/login_usecase.dart';
import 'features/auth/domain/usecases/signup_usecase.dart';
import 'features/profile/data/datasource/profile_remote_data_source.dart';
import 'features/profile/data/repositories/profile_repository_impl.dart';
import 'features/profile/domain/repositories/profile_repository.dart';
import 'features/profile/domain/usecases/getprofile_usecase.dart';
import 'features/profile/presentation/cubit/profile_cubit.dart';
import 'features/reminder/data/datasource/reminder_remote_data_source.dart';
import 'features/reminder/data/repositories/reminder_repository_impl.dart';
import 'features/reminder/domain/repositories/reminder_repository.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  const secureStorage = FlutterSecureStorage();
  serviceLocator.registerLazySingleton<SharedPreferences>(
    () => sharedPreferences,
  );
  serviceLocator.registerLazySingleton<FlutterSecureStorage>(
    () => secureStorage,
  );

  serviceLocator.registerLazySingleton<TokenStorage>(
    () => TokenStorage(serviceLocator()),
  );

  serviceLocator.registerLazySingleton<LocalStorage>(
    () => LocalStorage(serviceLocator()),
  );

  serviceLocator.registerLazySingleton<DioClient>(
    () => DioClient(serviceLocator(), serviceLocator()),
  );

  serviceLocator.registerLazySingleton(() => SettingsCubit(serviceLocator()));

  _initAuth();
  _initProfile();
  _initReminder();
}

void _initAuth() {
  serviceLocator.registerFactory<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(serviceLocator()),
  );
  serviceLocator.registerFactory<AuthRepository>(
    () => AuthRepositoryImpl(
      serviceLocator(),
      serviceLocator(),
      serviceLocator(),
    ),
  );
  serviceLocator.registerFactory(() => LoginUsecase(serviceLocator()));
  serviceLocator.registerFactory(() => SignupUsecase(serviceLocator()));
  serviceLocator.registerFactory(
    () => CheckAuthStatusUseCase(serviceLocator()),
  );

  serviceLocator.registerFactory(() => LogoutUseCase(serviceLocator()));

  serviceLocator.registerLazySingleton(
    () => AuthBloc(
      loginUsecase: serviceLocator(),
      signupUsecase: serviceLocator(),
      checkAuthStatusUseCase: serviceLocator(),
      logoutUseCase: serviceLocator(),
    ),
  );
}

void _initProfile() {
  serviceLocator.registerFactory<ProfileRemoteDataSource>(
    () => ProfileRemoteDataSourceImpl(serviceLocator()),
  );
  serviceLocator.registerFactory<ProfileRepository>(
    () => ProfileRepositoryImpl(serviceLocator(), serviceLocator()),
  );
  serviceLocator.registerFactory(() => GetProfileUseCase(serviceLocator()));
  serviceLocator.registerFactory(() => ProfileCubit(serviceLocator()));
}

void _initReminder() {
  serviceLocator.registerFactory<ReminderRemoteDataSource>(
    () => ReminderRemoteDataSourceImpl(serviceLocator()),
  );
  serviceLocator.registerFactory<ReminderRepository>(
    () => ReminderRepositoryImpl(serviceLocator()),
  );
  serviceLocator.registerFactory(() => AddReminderUsecase(serviceLocator()));
  serviceLocator.registerFactory(() => GetRemindersUsecase(serviceLocator()));
  serviceLocator.registerFactory(
    () => GetReminderByIdUsecase(serviceLocator()),
  );
  serviceLocator.registerFactory(() => UpdateReminderUsecase(serviceLocator()));
  serviceLocator.registerFactory(() => DeleteReminderUsecase(serviceLocator()));
  serviceLocator.registerFactory(
    () => ReminderBloc(
      addReminderUsecase: serviceLocator(),
      getRemindersUsecase: serviceLocator(),
      getReminderByIdUsecase: serviceLocator(),
      updateReminderUsecase: serviceLocator(),
      deleteReminderUsecase: serviceLocator(),
    ),
  );
}
