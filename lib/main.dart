import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // 1. Import flutter_bloc

// 2. Import các Service và Cubit của bạn (Kiểm tra lại đường dẫn nếu báo đỏ)
import 'services/task_service.dart';
import './screen/task/bloc/task_bloc.dart';
import 'services/notification_service.dart';
import './screen/notification/bloc/notification_bloc.dart';

// Import các màn hình
import 'screen/splash_screen.dart';
import 'screen/onboarding_screen.dart';
import 'screen/home_screen.dart';
import 'screen/register/register_screen.dart';
import 'screen/login/login_screen.dart';
import 'screen/verify/verify_screen.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
      statusBarColor: Colors.transparent,
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // 3. Khởi tạo các Service (Data Layer)
    final taskService = TaskService();
    final notificationService = NotificationService();

    // 4. Bọc MaterialApp bằng MultiBlocProvider
    return MultiBlocProvider(
      providers: [
        // Cung cấp TaskCubit cho toàn App & load data ngay
        BlocProvider<TaskCubit>(
          create: (context) => TaskCubit(taskService)..loadTasks(),
        ),

        // Cung cấp NotificationCubit cho toàn App & load data ngay
        BlocProvider<NotificationCubit>(
          create: (context) => NotificationCubit(notificationService)..getNotificationData(),
        ),
      ],

      child: MaterialApp(
        title: 'Task-Wan Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          fontFamily: 'Poppins',
          scaffoldBackgroundColor: Colors.white,
          textTheme: const TextTheme(
            headlineSmall: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
            bodyMedium: TextStyle(
              fontSize: 16,
              color: Colors.black54,
              height: 1.5,
            ),
          ),
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const SplashScreen(),
          '/onboarding': (context) => const OnboardingScreen(),
          '/home': (context) => const HomeScreen(),
          '/login': (context) => const LoginScreen(),
          '/register': (context) => const RegisterScreen(),
          '/verify': (context) => const VerificationScreen(),
        },
      ),
    );
  }
}