import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:binder_app/ui/pages/home_page.dart';
import 'package:binder_app/ui/pages/welcome_screen.dart';
import 'package:binder_app/l10n/generated/app_localizations.dart';

class BinderApp extends StatefulWidget {
  final bool hasSeenWelcomeScreen;
  const BinderApp({super.key, required this.hasSeenWelcomeScreen});

  @override
  State<BinderApp> createState() => _BinderAppState();

  static void setLocale(BuildContext context, Locale newLocale) {
    final state = context.findAncestorStateOfType<_BinderAppState>();
    state?.setLocale(newLocale);
  }
}

class _BinderAppState extends State<BinderApp> {
  Locale? _locale;

  void setLocale(Locale locale) {
    setState(() => _locale = locale);
  }

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((prefs) {
      final code = prefs.getString('language_code');
      if (code != null && mounted) {
        setLocale(Locale(code));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateTitle: (context) =>
          AppLocalizations.of(context)!.appTitle,
      localizationsDelegates:
          AppLocalizations.localizationsDelegates,
      supportedLocales:
          AppLocalizations.supportedLocales,
      locale: _locale,
      home: widget.hasSeenWelcomeScreen
          ? const HomePage()
          : const WelcomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
