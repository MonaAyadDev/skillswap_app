import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:skillswap/core/localization/locale_cubit.dart';
import 'package:skillswap/core/routes/app_routers.dart';
import 'package:skillswap/core/theme/theme_cubit.dart';
import 'core/di/service_locator.dart';
import 'core/theme/app_theme.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await setupServiceLocator();
  runApp(const SkillSwapApp());
}

class SkillSwapApp extends StatelessWidget {
  const SkillSwapApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeMode>(
      bloc: sl<ThemeCubit>(),
      builder: (context, themeMode) {
        return BlocBuilder<LocaleCubit, Locale>(
          bloc: sl<LocaleCubit>(),
          builder: (context, locale) {
            final fontFamily = locale.languageCode == 'ar' ? 'Cairo' : 'Poppins';

            return MaterialApp.router(
              title: 'SkillSwap',
              debugShowCheckedModeBanner: false,
              theme: AppTheme.light(fontFamily),
              darkTheme: AppTheme.dark(fontFamily),
              themeMode: themeMode,
              locale: locale,
              supportedLocales: const [
                Locale('en'),
                Locale('ar'),
              ],
              localizationsDelegates: const [
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              routerConfig: AppRouter.router,
            );
          },
        );
      },
    );
  }
}
