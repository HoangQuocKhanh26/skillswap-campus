import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'screens/login_screen.dart';
import 'state/app_scope.dart';
import 'state/app_state.dart';
import 'theme/app_theme.dart';

class SkillSwapApp extends StatefulWidget {
  final String initialLanguage;
  final bool initialDark;

  const SkillSwapApp({
    super.key,
    this.initialLanguage = 'vi',
    this.initialDark = false,
  });

  @override
  State<SkillSwapApp> createState() => _SkillSwapAppState();
}

class _SkillSwapAppState extends State<SkillSwapApp> {
  late final AppState _state = AppState(
    languageCode: widget.initialLanguage,
    isDark: widget.initialDark,
  );

  @override
  void dispose() {
    _state.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScope(
      state: _state,
      child: ListenableBuilder(
        listenable: _state,
        builder: (context, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'SkillSwap Campus',
            theme: AppTheme.light(),
            darkTheme: AppTheme.dark(),
            themeMode: _state.isDark ? ThemeMode.dark : ThemeMode.light,
            locale: Locale(_state.languageCode),
            supportedLocales: const [
              Locale('vi'),
              Locale('en'),
            ],
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            home: const LoginScreen(),
          );
        },
      ),
    );
  }
}
