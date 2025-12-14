import 'package:flutter/material.dart';
import 'dart:async';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Chờ 2 giây rồi chuyển sang màn hình Onboarding
    Timer(
      const Duration(seconds: 2),
          () => Navigator.pushReplacementNamed(context, '/login'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        // Hiển thị logo của bạn. Ở đây tôi dùng Text để mô phỏng
        child: Text(
          'TASK-WAN',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.blue[600],
          ),
        ),
      ),
    );
  }
}