import 'package:alnabali_driver/src/features/auth/data/auth_repository.dart';
import 'package:alnabali_driver/src/features/auth/presentation/account/change_password_screen.dart';
import 'package:alnabali_driver/src/features/auth/presentation/account/edit_profile_screen.dart';
import 'package:alnabali_driver/src/features/auth/presentation/auth/forget_mobile_screen.dart';
import 'package:alnabali_driver/src/features/auth/presentation/auth/forget_otp_screen.dart';
import 'package:alnabali_driver/src/features/auth/presentation/auth/forget_pwd_screen.dart';
import 'package:alnabali_driver/src/features/auth/presentation/auth/login_screen.dart';
import 'package:alnabali_driver/src/features/auth/presentation/auth/splash_screen.dart';
import 'package:alnabali_driver/src/features/trip/presentation/home_screen.dart';
import 'package:alnabali_driver/src/features/trip/presentation/trip_detail_screen.dart';
import 'package:alnabali_driver/src/routing/go_router_refresh_stream.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

enum AppRoute {
  splash,
  login,
  forgetMobile,
  forgetOTP,
  forgetPwd,
  home,
  tripDetail,
  editProfile,
  changePwd,
}

final goRouterProvider = Provider<GoRouter>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);

  return GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: false,
    redirect: (context, state) {
      var user = authRepository.currentUser;
      if (user != null) {
        if (state.location == '/') {
          if (user.token.isNotEmpty) {
            return '/login';
          }
        } else if (state.location == '/login') {
          if (user.isLogined()) {
            return '/home';
          }
        }
      }
      return null;
    },
    refreshListenable: GoRouterRefreshStream(authRepository.userStateChanges()),
    routes: [
      GoRoute(
        path: '/',
        name: AppRoute.splash.name,
        builder: (context, state) => const SplashScreen(),
        routes: [
          GoRoute(
            path: 'login',
            name: AppRoute.login.name,
            pageBuilder: (context, state) => MaterialPage(
              key: state.pageKey,
              fullscreenDialog: true,
              child: const LoginScreen(),
            ),
            routes: [
              GoRoute(
                path: 'forget_mobile',
                name: AppRoute.forgetMobile.name,
                pageBuilder: (context, state) => MaterialPage(
                  key: state.pageKey,
                  child: const ForgetMobileScreen(),
                ),
                routes: [
                  GoRoute(
                    path: 'forget_otp',
                    name: AppRoute.forgetOTP.name,
                    pageBuilder: (context, state) => MaterialPage(
                      key: state.pageKey,
                      child: const ForgetOTPScreen(),
                    ),
                    routes: [
                      GoRoute(
                        path: 'forget_pwd',
                        name: AppRoute.forgetPwd.name,
                        pageBuilder: (context, state) => MaterialPage(
                          key: state.pageKey,
                          child: const ForgetPwdScreen(),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          GoRoute(
            path: 'home',
            name: AppRoute.home.name,
            pageBuilder: (context, state) => MaterialPage(
              key: state.pageKey,
              fullscreenDialog: true,
              child: const HomeScreen(),
            ),
            routes: [
              GoRoute(
                path: 'trip_detail',
                name: AppRoute.tripDetail.name,
                pageBuilder: (context, state) => MaterialPage(
                  key: state.pageKey,
                  fullscreenDialog: true,
                  child: const TripDetailScreen(),
                ),
              ),
              GoRoute(
                path: 'edit_profile',
                name: AppRoute.editProfile.name,
                pageBuilder: (context, state) => MaterialPage(
                  key: state.pageKey,
                  fullscreenDialog: true,
                  child: const EditProfileScreen(),
                ),
              ),
              GoRoute(
                path: 'change_pwd',
                name: AppRoute.changePwd.name,
                pageBuilder: (context, state) => MaterialPage(
                  key: state.pageKey,
                  fullscreenDialog: true,
                  child: const ChangePasswordScreen(),
                ),
              ),
            ],
          ),
        ],
      ),
    ],
  );
});
