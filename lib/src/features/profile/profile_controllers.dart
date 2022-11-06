import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:alnabali_driver/src/features/profile/profile.dart';
import 'package:alnabali_driver/src/features/profile/profile_repository.dart';

// * ---------------------------------------------------------------------------
// * HomeAccountPageController
// * ---------------------------------------------------------------------------

class HomeAccountController extends StateNotifier<AsyncValue<void>> {
  HomeAccountController({required this.profileRepo})
      : super(const AsyncData(null));

  final ProfileRepository profileRepo;

  Future<void> doGetProfile() async {
    if (profileRepo.currProfile != null) {
      return; // already profile data fetched!
    }

    state = const AsyncValue.loading();

    final newState = await AsyncValue.guard(() => profileRepo.doGetProfile());

    if (mounted) {
      state = newState;
    }
  }

  Future<void> doLogout() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => profileRepo.doLogout());
  }
}

final homeAccountCtrProvider =
    StateNotifierProvider.autoDispose<HomeAccountController, AsyncValue<void>>(
        (ref) {
  return HomeAccountController(
      profileRepo: ref.watch(profileRepositoryProvider));
});

// * ---------------------------------------------------------------------------
// * ChangePasswordController
// * ---------------------------------------------------------------------------

class ChangePasswordController extends StateNotifier<AsyncValue<bool>> {
  ChangePasswordController({required this.profileRepo})
      : super(const AsyncData(false));

  final ProfileRepository profileRepo;

  Future<bool> doChangePassword(String currPwd, String newPwd) async {
    state = const AsyncValue.loading();

    final newState = await AsyncValue.guard(
        () => profileRepo.doChangePassword(currPwd, newPwd));

    if (mounted) {
      state = newState;
    }

    return newState.hasValue;
  }
}

final changePasswordControllerProvider = StateNotifierProvider.autoDispose<
    ChangePasswordController, AsyncValue<bool>>((ref) {
  return ChangePasswordController(
      profileRepo: ref.watch(profileRepositoryProvider));
});

// * ---------------------------------------------------------------------------
// * EditProfileController
// * ---------------------------------------------------------------------------

class EditProfileController extends StateNotifier<AsyncValue<bool>> {
  EditProfileController({required this.profileRepo})
      : super(const AsyncData(false));

  final ProfileRepository profileRepo;

  // at here, profile repository must have valid profile object!
  Profile get currProfile => profileRepo.currProfile!;

  Future<bool> doEditProfile(
      String name, String phone, String birthday, String address) async {
    state = const AsyncValue.loading();

    final newState = await AsyncValue.guard(
        () => profileRepo.doEditProfile(name, phone, birthday, address));

    if (mounted) {
      state = newState;
    }

    return newState.hasValue;
  }
}

final editProfileControllerProvider =
    StateNotifierProvider.autoDispose<EditProfileController, AsyncValue<bool>>(
        (ref) {
  return EditProfileController(
      profileRepo: ref.watch(profileRepositoryProvider));
});
