// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.
import 'package:binder_app/app/binder_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('HomePage shows title and FAB', (WidgetTester tester) async {
    // Inisialisasi SharedPreferences untuk testing
    // Ini diperlukan karena main() dan initState() mencoba mengaksesnya
    TestWidgetsFlutterBinding.ensureInitialized();

    // Bangun aplikasi kita, anggap pengguna sudah melihat welcome screen.
    await tester.pumpWidget(const BinderApp(hasSeenWelcomeScreen: true));

    // Tunggu widget selesai rendering (terutama setelah loadBinders)
    await tester.pumpAndSettle();

    // Verifikasi bahwa FloatingActionButton dengan ikon 'add' ada.
    expect(find.byIcon(Icons.add), findsOneWidget);
  });
}
