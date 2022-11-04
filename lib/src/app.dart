import 'package:alnabali_driver/src/routing/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AlnabaliDriverApp extends ConsumerWidget {
  const AlnabaliDriverApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ScreenUtilInit(
      designSize: const Size(1125, 2436),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        final goRouter = ref.watch(goRouterProvider);
        return MaterialApp.router(
          routerConfig: goRouter,
          debugShowCheckedModeBanner: false,
          title: 'Alnabali Driver',
          // theme: ThemeData(
          //     pageTransitionsTheme: const PageTransitionsTheme(builders: {
          //   TargetPlatform.iOS: ZoomPageTransitionsBuilder(),
          //   TargetPlatform.android: CupertinoPageTransitionsBuilder(),
          // })),
        );
      },
    );
  }
}
