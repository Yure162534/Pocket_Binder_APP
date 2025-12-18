import 'package:flutter/material.dart';

import 'package:binder_app/app/binder_app.dart';
import 'package:binder_app/core/database/supabase_service.dart';
import 'package:binder_app/core/storages/preferences_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SupabaseService.init();
  final hasSeenWelcome = await PreferencesService.hasSeenWelcome();

  runApp(BinderApp(hasSeenWelcomeScreen: hasSeenWelcome));
}

// import 'package:binder_app/ui/pages/home_page.dart';
// import 'package:binder_app/ui/pages/welcome_screen.dart';
// import 'package:binder_app/l10n/generated/app_localizations.dart';
// import 'package:flutter/foundation.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();

//   final prefs = await SharedPreferences.getInstance();
//   final bool hasSeenWelcomeScreen = prefs.getBool('hasSeenWelcomeScreen') ?? false;

//   await Supabase.initialize(
//     // TODO: Consider moving credentials to a separate, git-ignored file.
//     url: 'https://jzpwxdiuotspcmlkhgwa.supabase.co',
//     anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imp6cHd4ZGl1b3RzcGNtbGtoZ3dhIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjQ5MjA1MTAsImV4cCI6MjA4MDQ5NjUxMH0.W73iZsm9xcZvgn6b8ikMpergVtzfRmSBKxmW2QjgOHk',
//   );

//   // Kode diagnosis ini bagus untuk debugging, tetapi bisa dihapus atau
//   // dibungkus dengan pengecekan mode debug untuk rilis produksi.
//   if (kDebugMode) {
//     // ===== KODE DIAGNOSIS =====
//     try {
//       print('Mencoba mengambil data dari tabel "AEDatabase"...');
//       final response = await Supabase.instance.client.from('AEDatabase').select();
//       print('Respon dari Supabase:');
//       print(response);
//       if (response.isEmpty) {
//         print('HASIL: Supabase mengembalikan daftar kosong. Ini bisa karena RLS aktif tanpa policy, atau tabel memang kosong.');
//       }
//     } catch (e) {
//       print('ERROR SAAT DIAGNOSIS: Terjadi kesalahan saat mengambil data: $e');
//     }
//     // ===== AKHIR KODE DIAGNOSIS =====
//   }

//   runApp(BinderApp(hasSeenWelcomeScreen: hasSeenWelcomeScreen));
// }

// class BinderApp extends StatefulWidget {
//   final bool hasSeenWelcomeScreen;
//   const BinderApp({super.key, required this.hasSeenWelcomeScreen});

//   @override
//   State<BinderApp> createState() => _BinderAppState();

//   static void setLocale(BuildContext context, Locale newLocale) {
//     _BinderAppState? state = context.findAncestorStateOfType<_BinderAppState>();
//     state?.setLocale(newLocale);
//   }
// }

// class _BinderAppState extends State<BinderApp> {
//   Locale? _locale;

//   void setLocale(Locale locale) {
//     setState(() {
//       _locale = locale;
//     });
//   }

//   // Memuat locale yang tersimpan saat aplikasi pertama kali dimulai.
//   @override
//   void initState() {
//     super.initState();
//     SharedPreferences.getInstance().then((prefs) {
//       final languageCode = prefs.getString('language_code');
//       if (languageCode != null && mounted) {
//         setLocale(Locale(languageCode));
//       }
//     });
//   }
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       onGenerateTitle: (context) => AppLocalizations.of(context)!.appTitle,
//       theme: ThemeData(primarySwatch: Colors.indigo),
//       localizationsDelegates: AppLocalizations.localizationsDelegates,
//       supportedLocales: AppLocalizations.supportedLocales,
//       locale: _locale,
//       home: widget.hasSeenWelcomeScreen ? const HomePage() : const WelcomeScreen(),
//       debugShowCheckedModeBanner: false,
//     );
//   }}

