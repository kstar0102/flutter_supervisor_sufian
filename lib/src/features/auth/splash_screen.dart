import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import 'package:alnabali_driver/src/routing/app_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) => _goAfterDelay(context));
  }

  void _goAfterDelay(BuildContext context) {
    Future.delayed(const Duration(seconds: 1), () {
      context.goNamed(AppRoute.login.name);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: GestureDetector(
          onTap: () {
            //context.goNamed(AppRoute.login.name);
          },
          child: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/bg_splash.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              children: [
                SizedBox(height: 500.h),
                SizedBox(
                  width: 681.w,
                  child: Image.asset('assets/images/icon.png'),
                ),
                //const TokenGetterWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
