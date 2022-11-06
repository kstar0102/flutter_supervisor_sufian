import 'dart:developer' as developer;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:alnabali_driver/src/exceptions/app_exception.dart';
import 'package:alnabali_driver/src/features/auth/auth_repository.dart';
import 'package:alnabali_driver/src/features/profile/profile.dart';
import 'package:alnabali_driver/src/network/dio_client.dart';
import 'package:alnabali_driver/src/utils/in_memory_store.dart';

class ProfileRepository {
  ProfileRepository({required this.authRepo});

  AuthRepository authRepo;
  final _profileState = InMemoryStore<Profile?>(null);

  Stream<Profile?> profileStateChanges() => _profileState.stream;
  Profile? get currProfile => _profileState.value;

  // * -------------------------------------------------------------------------

  Future<void> doGetProfile() async {
    final data = await DioClient.getProfile(authRepo.uid!);
    developer.log('doGetProfile() returned: $data');

    final driver = data['driver'];
    if (driver != null) {
      _profileState.value = Profile(
        username: driver['user_name'],
        profileImage:
            driver['profile_image'] ?? 'assets/images/user_avatar.png',
        nameEN: driver['name_en'],
        phone: driver['phone'],
        birthday: driver['age'],
        address: driver['address'],
        // ! following data must be from server...
        workingHours: 10.2,
        totalDistance: 30,
        totalTrips: 20,
      );
    } else {
      throw UnimplementedError;
    }
  }

  // * -------------------------------------------------------------------------

  Future<bool> doChangePassword(String currPwd, String newPwd) async {
    final data = await DioClient.postChangePwd(authRepo.uid!, currPwd, newPwd);
    developer.log('doChangePassword() returned: $data');

    var result = data['result'];
    if (result == 'Changed successfully') {
      return true;
    } else if (result == 'Invalid Driver') {
      throw const AppException.userNotFound();
    } else if (result == 'Invalid Password') {
      throw const AppException.wrongPassword();
    }

    return false;
  }

  // * -------------------------------------------------------------------------

  Future<bool> doEditProfile(
      String name, String phone, String birthday, String address) async {
    final data = await DioClient.postProfileEdit(
        authRepo.uid!, name, phone, birthday, address);
    developer.log('doEditProfile() returned: $data');

    var result = data['result'];
    if (result == 'Update successfully') {
      // update local profile data.
      _profileState.value =
          _profileState.value?.copyWith(name, phone, birthday, address);
      return true;
    } else if (result == 'Invalid Driver') {
      throw const AppException.userNotFound();
    }

    return false;
  }

  // * -------------------------------------------------------------------------

  Future<void> doLogout() async {
    // clear profile and uid, later we may need to notify server...
    _profileState.value = null;
    authRepo.doLogOut();
  }
}

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  return ProfileRepository(authRepo: ref.watch(authRepositoryProvider));
});

final profileStateChangesProvider = StreamProvider<Profile?>((ref) {
  final profileRepo = ref.watch(profileRepositoryProvider);
  return profileRepo.profileStateChanges();
});
