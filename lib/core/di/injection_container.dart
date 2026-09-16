import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';

import 'package:idiomatic_app/core/network/dio_client.dart';
import 'package:idiomatic_app/core/storage/token_storage.dart';
import 'package:idiomatic_app/core/theme/theme_cubit.dart';
import 'package:idiomatic_app/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:idiomatic_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:idiomatic_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:idiomatic_app/features/auth/domain/usecases/login.dart';
import 'package:idiomatic_app/features/auth/domain/usecases/signup.dart';
import 'package:idiomatic_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:idiomatic_app/features/idioms/data/datasources/idiom_remote_datasource.dart';
import 'package:idiomatic_app/features/idioms/data/repositories/idiom_repository_impl.dart';
import 'package:idiomatic_app/features/idioms/domain/repositories/idiom_repository.dart';
import 'package:idiomatic_app/features/idioms/domain/usecases/get_due_idioms.dart';
import 'package:idiomatic_app/features/idioms/domain/usecases/get_idioms.dart';
import 'package:idiomatic_app/features/idioms/domain/usecases/get_next_due_at.dart';
import 'package:idiomatic_app/features/idioms/domain/usecases/get_quiz_options.dart';
import 'package:idiomatic_app/features/idioms/domain/usecases/submit_review.dart';
import 'package:idiomatic_app/features/idioms/presentation/bloc/browse_cubit.dart';
import 'package:idiomatic_app/features/progress/data/datasources/progress_remote_datasource.dart';
import 'package:idiomatic_app/features/progress/data/repositories/progress_repository_impl.dart';
import 'package:idiomatic_app/features/progress/domain/repositories/progress_repository.dart';
import 'package:idiomatic_app/features/progress/domain/usecases/get_progress_stats.dart';
import 'package:idiomatic_app/features/progress/presentation/bloc/progress_cubit.dart';
import 'package:idiomatic_app/features/quiz/presentation/bloc/quiz_bloc.dart';
import 'package:idiomatic_app/features/review/presentation/bloc/review_bloc.dart';

final GetIt sl = GetIt.instance;

/// Registers every dependency in the app. Called once from `main()` before
/// `runApp`. Each feature contributes its own registration block below.
Future<void> initDependencies() async {
  // ---- Core ----
  sl.registerLazySingleton(() => const FlutterSecureStorage());
  sl.registerLazySingleton(() => TokenStorage(sl()));
  sl.registerLazySingleton(() => DioClient(sl()).dio);
  sl.registerLazySingleton(() => ThemeCubit());

  // ---- Auth feature ----
  sl.registerLazySingleton<AuthRemoteDataSource>(() => AuthRemoteDataSourceImpl(sl()));
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: sl(), tokenStorage: sl(), secureStorage: sl()),
  );
  sl.registerLazySingleton(() => Signup(sl()));
  sl.registerLazySingleton(() => Login(sl()));
  sl.registerLazySingleton(() => AuthBloc(signup: sl(), login: sl(), repository: sl()));

  // ---- Idioms feature ----
  sl.registerLazySingleton<IdiomRemoteDataSource>(() => IdiomRemoteDataSourceImpl(sl()));
  sl.registerLazySingleton<IdiomRepository>(() => IdiomRepositoryImpl(sl()));
  sl.registerLazySingleton(() => GetIdioms(sl()));
  sl.registerLazySingleton(() => GetDueIdioms(sl()));
  sl.registerLazySingleton(() => GetNextDueAt(sl()));
  sl.registerLazySingleton(() => SubmitReview(sl()));
  sl.registerLazySingleton(() => GetQuizOptions(sl()));

  // ---- Progress feature ----
  sl.registerLazySingleton<ProgressRemoteDataSource>(() => ProgressRemoteDataSourceImpl(sl()));
  sl.registerLazySingleton<ProgressRepository>(() => ProgressRepositoryImpl(sl()));
  sl.registerLazySingleton(() => GetProgressStats(sl()));

  // ---- Presentation-layer blocs/cubits (factories: fresh instance per page) ----
  sl.registerFactory(() => ReviewBloc(getDueIdioms: sl(), getNextDueAt: sl(), submitReview: sl()));
  sl.registerFactory(() => QuizBloc(getIdioms: sl(), getQuizOptions: sl()));
  sl.registerFactory(() => ProgressCubit(sl()));
  sl.registerFactory(() => BrowseCubit(getIdioms: sl(), getProgressStats: sl()));
}
