import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:skillswap/features/auth/data/auth_repository.dart';
import 'package:skillswap/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:skillswap/features/profile/data/user_repository.dart';
import 'package:skillswap/features/profile/presentation/cubit/profile_cubit.dart';

final GetIt sl = GetIt.instance;

Future<void> setupServiceLocator() async {
  // Firebase
  sl.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
  sl.registerLazySingleton<FirebaseFirestore>(() => FirebaseFirestore.instance);

  // Auth
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepository(sl<FirebaseAuth>()),
  );
  sl.registerFactory<AuthCubit>(() => AuthCubit(sl<AuthRepository>()));

  // Profile
  sl.registerLazySingleton<UserRepository>(
    () => UserRepository(sl<FirebaseFirestore>(), sl<FirebaseAuth>()),
  );
  sl.registerFactory<ProfileCubit>(() => ProfileCubit(sl<UserRepository>()));
}
