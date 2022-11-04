import 'dart:developer' as developer;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:alnabali_driver/src/features/auth/auth_repository.dart';
import 'package:alnabali_driver/src/features/profile/profile.dart';
import 'package:alnabali_driver/src/network/dio_client.dart';

class ProfileRepository {
  ProfileRepository({required this.authRepo});

  AuthRepository authRepo;
  Profile? _profile;

  Profile? get profile => _profile;

  // * -------------------------------------------------------------------------

  Future<Profile?> doGetProfile() async {
    final data = await DioClient.getProfile(authRepo.uid!);
    final driver = data['driver'];
    developer.log('doGetProfile() returned: $data');

    if (driver != null) {
      _profile = Profile(
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
      return _profile;
    } else {
      throw UnimplementedError;
    }
  }

  // * -------------------------------------------------------------------------

  Future<String> doChangePassword(String currPwd, String newPwd) async {
    final data = await DioClient.postChangePwd(authRepo.uid!, currPwd, newPwd);
    developer.log('doChangePassword() returned: $data');

    return data['result'];
  }

  // * -------------------------------------------------------------------------

  Future<String> doEditProfile(
      String name, String phone, String birthday, String address) async {
    final data = await DioClient.postProfileEdit(
        authRepo.uid!, name, phone, birthday, address);
    developer.log('doEditProfile() returned: $data');

    if (data['result'] == 'Update successfully') {
      // update local profile data.
      _profile = _profile?.copyWith(name, phone, birthday, address);
    }

    return data['result'];
  }
}

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  return ProfileRepository(authRepo: ref.watch(authRepositoryProvider));
});
