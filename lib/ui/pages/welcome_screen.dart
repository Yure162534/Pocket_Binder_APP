import 'package:binder_app/ui/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 1. Background Image
          Image.asset(
            'assets/welcome_screen.jpg',
            fit: BoxFit.cover,
          ),
          // 2. Bottom Box
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: screenHeight * 0.36,
              width: screenWidth,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              decoration: const BoxDecoration(
                color: Color(0xFF1E1E2A),
                // Optional: add rounded corners on top
                // borderRadius: BorderRadius.only(
                //   topLeft: Radius.circular(20),
                //   topRight: Radius.circular(20),
                // ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // 3. Texts
                  const Text(
                    'Selamat Datang di Pocket Binder',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFFE5E5E5),
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Lihat Koleksi Kartumu Dimanapun, Kapanpun',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: Color(0xFFE5E5E5),
                      fontSize: 16,
                    ),
                  ),
                  const Spacer(),
                  // 4. Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        // 1. Simpan status bahwa welcome screen sudah dilihat
                        final prefs = await SharedPreferences.getInstance();
                        await prefs.setBool('hasSeenWelcomeScreen', true);

                        // Navigate to HomePage and remove WelcomeScreen from stack
                        Navigator.of(context, rootNavigator: true).pushReplacement(
                          MaterialPageRoute(builder: (_) => const HomePage()),
                        );
                      },
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.resolveWith<Color>(
                          (Set<WidgetState> states) {
                            if (states.contains(WidgetState.pressed)) {
                              // Warna lebih gelap saat tombol ditekan
                              return const Color(0xFF085A73); 
                            }
                            // Warna default
                            return const Color(0xFF0A6D8C); 
                          },
                        ),
                        padding: WidgetStateProperty.all(const EdgeInsets.symmetric(vertical: 16)),
                        shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                      ),
                      child: const Text('Ayo mulai', style: TextStyle(color: Color(0xFFE5E5E5), fontSize: 16)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}