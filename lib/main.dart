// main.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screen/splash_screen.dart';
import 'screen/onboarding_screen.dart';
import 'screen/home_screen.dart';
import 'screen/register/register_screen.dart';
import 'screen/login/login_screen.dart';
import 'screen/verify/verify_screen.dart';

void main() {
  // Đảm bảo thanh trạng thái có màu sáng
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarIconBrightness: Brightness.dark, // Icon (đồng hồ, pin) màu đen
      statusBarBrightness: Brightness.light, // (Chỉ cho iOS)
      statusBarColor: Colors.transparent, // Màu nền thanh trạng thái trong suốt
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task-Wan Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Poppins',
        scaffoldBackgroundColor: Colors.white,
        textTheme: const TextTheme(
          // Style cho Tiêu đề (VD: "Easy Time Management")
          headlineSmall: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
          // Style cho Mô tả
          bodyMedium: TextStyle(
            fontSize: 16,
            color: Colors.black54,
            height: 1.5, // Giãn dòng
          ),
        ),
      ),
      // Bắt đầu ứng dụng với SplashScreen
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/onboarding': (context) => const OnboardingScreen(),
        '/home': (context) => const HomeScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/verify': (context) => const VerificationScreen(),
      },
    );
  }
}