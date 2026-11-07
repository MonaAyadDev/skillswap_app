import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:skillswap/core/localization/locale_cubit.dart';
import 'package:skillswap/core/theme/theme_cubit.dart';
import 'package:skillswap/features/auth/data/auth_repository.dart';
import 'package:skillswap/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:skillswap/features/chat/data/chat_repository.dart';
import 'package:skillswap/features/matches/data/matches_repository.dart';
import 'package:skillswap/features/matches/presentation/cubit/matches_cubit.dart';
import 'package:skillswap/features/notifications/data/notifications_repository.dart';
import 'package:skillswap/features/notifications/presentation/cubit/notifications_cubit.dart';
import 'package:skillswap/features/profile/data/user_repository.dart';
import 'package:skillswap/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:skillswap/features/requests/data/requests_repository.dart';
import 'package:skillswap/features/requests/presentation/cubit/requests_cubit.dart';
import 'package:skillswap/features/settings/data/settings_repository.dart';
import 'package:skillswap/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:skillswap/features/skills/data/skills_repository.dart';
import 'package:skillswap/features/skills/presentation/cubit/choose_skills_cubit.dart';

final GetIt sl = GetIt.instance;

Future<void> setupServiceLocator() async {
  // Firebase
  sl.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
  sl.registerLazySingleton<FirebaseFirestore>(() => FirebaseFirestore.instance);

  // Core Features
  sl.registerLazySingleton<ThemeCubit>(() => ThemeCubit());
  sl.registerLazySingleton<LocaleCubit>(() => LocaleCubit());

  // Repositories
  sl.registerLazySingleton<AuthRepository>(() => AuthRepository(sl<FirebaseAuth>()));
  sl.registerLazySingleton<UserRepository>(() => UserRepository(sl<FirebaseFirestore>(), sl<FirebaseAuth>()));
  sl.registerLazySingleton<SettingsRepository>(() => SettingsRepository(sl<FirebaseAuth>(), sl<FirebaseFirestore>()));
  sl.registerLazySingleton<SkillsRepository>(() => SkillsRepository(sl<FirebaseFirestore>()));
  sl.registerLazySingleton<ChatRepository>(() => ChatRepository(sl<FirebaseFirestore>()));
  sl.registerLazySingleton<RequestsRepository>(() => RequestsRepository(sl<FirebaseFirestore>(), sl<FirebaseAuth>()));
  sl.registerLazySingleton<MatchesRepository>(() => MatchesRepository(sl<FirebaseFirestore>(), sl<FirebaseAuth>()));
  sl.registerLazySingleton<NotificationsRepository>(() => NotificationsRepository(sl<FirebaseFirestore>(), sl<FirebaseAuth>()));

  // Cubits
  sl.registerFactory<AuthCubit>(() => AuthCubit(sl<AuthRepository>()));
  sl.registerFactory<ProfileCubit>(() => ProfileCubit(sl<UserRepository>()));
  sl.registerFactory<SettingsCubit>(() => SettingsCubit(sl<SettingsRepository>()));
  sl.registerFactory<ChooseSkillsCubit>(() => ChooseSkillsCubit(sl<SkillsRepository>(), sl<UserRepository>()));
  sl.registerFactory<RequestsCubit>(() => RequestsCubit(sl<RequestsRepository>()));
  sl.registerFactory<MatchesCubit>(() => MatchesCubit(sl<MatchesRepository>()));
  sl.registerFactory<NotificationsCubit>(() => NotificationsCubit(sl<NotificationsRepository>()));
}
