import 'package:flutter/material.dart';

import 'app.dart';
import 'state/settings_store.dart';

export 'app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final settings = await SettingsStore.load();
  runApp(
    SkillSwapApp(
      initialLanguage: settings.languageCode,
      initialDark: settings.isDark,
    ),
  );
}
