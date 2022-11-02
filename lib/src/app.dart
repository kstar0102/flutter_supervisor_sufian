import 'package:alnabali_driver/src/features/auth/presentation/auth/forget_OTP_screen.dart';
import 'package:alnabali_driver/src/features/auth/presentation/auth/forget_mobile_screen.dart';
import 'package:alnabali_driver/src/features/auth/presentation/auth/forget_pwd_screen.dart';
import 'package:alnabali_driver/src/features/auth/presentation/auth/login_screen.dart';
import 'package:alnabali_driver/src/features/auth/presentation/auth/splash_screen.dart';
import 'package:alnabali_driver/src/features/auth/presentation/account/change_password.dart';
import 'package:alnabali_driver/src/features/auth/presentation/account/edit_profile.dart';
import 'package:alnabali_driver/src/features/trip/presentation/home.dart';
import 'package:alnabali_driver/src/features/trip/presentation/trip_detail.dart';
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
        '/forget_mobile': (context) => const ForgetMobileScreen(),
        '/forget_otp': (context) => const ForgetOTPScreen(),
        '/forget_pwd': (context) => const ForgetPwdScreen(),
        '/change_pwd': (context) => const ChangePasswordScreen(),
        '/edit_profile': (context) => const EditProfileScreen(),
        '/home': (context) => const HomeScreen(),
        '/trip_detail': (context) => const TripDetailScreen(),
      },
    );
  }
}
