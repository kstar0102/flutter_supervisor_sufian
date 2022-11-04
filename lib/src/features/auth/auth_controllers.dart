import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:alnabali_driver/src/features/auth/auth_repository.dart';

// *
// * LoginController
// *

class LoginController extends StateNotifier<AsyncValue<String>> {
  LoginController({required this.authRepo}) : super(const AsyncData(''));

  final AuthRepository authRepo;

  Future<void> doLogin(String email, String password) async {
    state = const AsyncValue.loading();

    final newState =
        await AsyncValue.guard(() => authRepo.doLogIn(email, password));

    // Check if the controller is mounted before setting the state to prevent:
    // Bad state: Tried to use Controller after `dispose` was called.
    if (mounted) {
      state = newState;
    }
  }
}

final loginControllerProvider =
    StateNotifierProvider.autoDispose<LoginController, AsyncValue<String>>(
        (ref) {
  return LoginController(authRepo: ref.watch(authRepositoryProvider));
});

// *
// * ForgetMobileController
// *

class ForgetMobileController extends StateNotifier<AsyncValue<bool>> {
  ForgetMobileController({required this.authRepo})
      : super(const AsyncData(false));

  final AuthRepository authRepo;

  Future<void> doSendMobile(String mobile) async {
    state = const AsyncValue.loading();

    final newState =
        await AsyncValue.guard(() => authRepo.doSendMobile(mobile));

    if (mounted) {
      state = newState;
    }
  }
}

final forgetMobileControllerProvider =
    StateNotifierProvider.autoDispose<ForgetMobileController, AsyncValue<bool>>(
        (ref) {
  return ForgetMobileController(authRepo: ref.watch(authRepositoryProvider));
});

// *
// * ForgetOTPController
// *

class ForgetOTPController extends StateNotifier<AsyncValue<bool>> {
  ForgetOTPController({required this.authRepo}) : super(const AsyncData(false));

  final AuthRepository authRepo;

  Future<void> doVerifyOTP(String otp) async {
    state = const AsyncValue.loading();

    final newState = await AsyncValue.guard(() => authRepo.doVerifyOTP(otp));

    if (mounted) {
      state = newState;
    }
  }
}

final forgetOTPControllerProvider =
    StateNotifierProvider.autoDispose<ForgetOTPController, AsyncValue<bool>>(
        (ref) {
  return ForgetOTPController(authRepo: ref.watch(authRepositoryProvider));
});

// *
// * ForgetOTPController
// *

class ResetPwdController extends StateNotifier<AsyncValue<bool>> {
  ResetPwdController({required this.authRepo}) : super(const AsyncData(false));

  final AuthRepository authRepo;

  Future<void> doVerifyOTP(String newPwd) async {
    state = const AsyncValue.loading();

    final newState = await AsyncValue.guard(() => authRepo.doResetPwd(newPwd));

    if (mounted) {
      state = newState;
    }
  }
}

final resetPwdControllerProvider =
    StateNotifierProvider.autoDispose<ResetPwdController, AsyncValue<bool>>(
        (ref) {
  return ResetPwdController(authRepo: ref.watch(authRepositoryProvider));
});
