import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_clean_bloc_skeleton/presentation/theme/app_theme.dart';

import 'generated/codegen_loader.g.dart';
import 'core/constants/app_constants.dart';
import 'core/constants/locale_constants.dart';
import 'core/di/injection.dart';
import 'presentation/router/app_router.dart';
import 'presentation/theme/theme_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();
  runApp(
    EasyLocalization(
      supportedLocales: const [
        LocaleConstants.enUS,
        LocaleConstants.viVN,
        LocaleConstants.jaJP,
      ],
      path: AppConstants.assetTranslationPath,
      fallbackLocale: LocaleConstants.enUS,
      assetLoader: const CodegenLoader(),
      startLocale: LocaleConstants.enUS,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ThemeCubit(getIt())..loadTheme(),
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return MaterialApp.router(
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeMode,
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
            routerConfig: AppRouter.router,
          );
        },
      ),
    );
  }
}

