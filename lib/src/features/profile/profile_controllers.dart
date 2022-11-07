import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:alnabali_driver/src/features/profile/profile.dart';
import 'package:alnabali_driver/src/features/profile/profile_repository.dart';

// * ---------------------------------------------------------------------------
// * Used in HomAccountPage, EditProfileScreen, ChangePwdScreen.
// * ---------------------------------------------------------------------------

class ProfileController extends StateNotifier<AsyncValue<Profile?>> {
  ProfileController({required this.profileRepo}) : super(const AsyncData(null));

  final ProfileRepository profileRepo;

  Profile? get currProfile => profileRepo.currProfile;

  Future<void> doGetProfile() async {
    state = const AsyncValue.loading();
    final newState = await AsyncValue.guard(() => profileRepo.doGetProfile());

    if (mounted) {
      state = newState;
    }
  }

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

  Future<bool> doChangePassword(String currPwd, String newPwd) async {
    state = const AsyncValue.loading();

    final newState = await AsyncValue.guard(
        () => profileRepo.doChangePassword(currPwd, newPwd));

    if (mounted) {
      state = newState;
    }

    return newState.hasValue;
  }

  Future<void> doLogout() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => profileRepo.doLogout());
  }
}

final profileControllerProvider =
    StateNotifierProvider.autoDispose<ProfileController, AsyncValue<Profile?>>(
        (ref) {
  return ProfileController(profileRepo: ref.watch(profileRepositoryProvider));
});
