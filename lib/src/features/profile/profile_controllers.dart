import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:alnabali_driver/src/features/profile/profile.dart';
import 'package:alnabali_driver/src/features/profile/profile_repository.dart';

// * ---------------------------------------------------------------------------
// * HomeAccountPageController
// * ---------------------------------------------------------------------------

class HomeAccountController extends StateNotifier<AsyncValue<Profile?>> {
  HomeAccountController({required this.profileRepo})
      : super(const AsyncData(null));

  final ProfileRepository profileRepo;

  Future<Profile> doGetProfile() async {
    if (profileRepo.profile != null) {
      // already profile data fetched!
      return profileRepo.profile!;
    }

    state = const AsyncValue.loading();

    final newState = await AsyncValue.guard(() => profileRepo.doGetProfile());

    if (mounted) {
      state = newState;
    }

    return newState.value!;
  }
}

final homeAccountControllerProvider = StateNotifierProvider.autoDispose<
    HomeAccountController, AsyncValue<Profile?>>((ref) {
  return HomeAccountController(
      profileRepo: ref.watch(profileRepositoryProvider));
});

// * ---------------------------------------------------------------------------
// * ChangePasswordController
// * ---------------------------------------------------------------------------

class ChangePasswordController extends StateNotifier<AsyncValue<String>> {
  ChangePasswordController({required this.profileRepo})
      : super(const AsyncValue.data(''));

  final ProfileRepository profileRepo;

  Future<String> doChangePassword(String currPwd, String newPwd) async {
    state = const AsyncValue.loading();

    final newState = await AsyncValue.guard(
        () => profileRepo.doChangePassword(currPwd, newPwd));

    if (mounted) {
      state = newState;
    }

    return newState.value!;
  }
}

final changePasswordControllerProvider = StateNotifierProvider.autoDispose<
    ChangePasswordController, AsyncValue<String>>((ref) {
  return ChangePasswordController(
      profileRepo: ref.watch(profileRepositoryProvider));
});

// * ---------------------------------------------------------------------------
// * EditProfileController
// * ---------------------------------------------------------------------------

class EditProfileController extends StateNotifier<AsyncValue<String>> {
  EditProfileController({required this.profileRepo})
      : super(const AsyncValue.data(''));

  final ProfileRepository profileRepo;

  Profile? getCurrProfile() => profileRepo.profile;

  Future<String> doEditProfile(
      String name, String phone, String birthday, String address) async {
    state = const AsyncValue.loading();

    final newState = await AsyncValue.guard(
        () => profileRepo.doEditProfile(name, phone, birthday, address));

    if (mounted) {
      state = newState;
    }

    return newState.value!;
  }
}

final editProfileControllerProvider = StateNotifierProvider.autoDispose<
    EditProfileController, AsyncValue<String>>((ref) {
  return EditProfileController(
      profileRepo: ref.watch(profileRepositoryProvider));
});
