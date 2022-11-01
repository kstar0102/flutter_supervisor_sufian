import 'package:alnabali_driver/src/features/auth/presentation/login_screen.dart';
import 'package:alnabali_driver/src/features/auth/presentation/splash_screen.dart';
import 'package:flutter/material.dart';

class AlnabaliDriverApp extends StatelessWidget {
  const AlnabaliDriverApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Alnabali Driver',
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
      },
    );
  }
}
