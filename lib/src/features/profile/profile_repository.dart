import 'dart:developer' as developer;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:alnabali_driver/src/exceptions/app_exception.dart';
import 'package:alnabali_driver/src/features/auth/auth_repository.dart';
import 'package:alnabali_driver/src/features/profile/profile.dart';
import 'package:alnabali_driver/src/network/dio_client.dart';
import 'package:alnabali_driver/src/utils/in_memory_store.dart';

class ProfileRepository {
  ProfileRepository({required this.authRepo});

  final AuthRepository authRepo;
  Profile? _profile;

  Profile? get currProfile => _profile;

  final _profileState = InMemoryStore<Profile?>(null);
  Stream<Profile?> profileStateChanges() => _profileState.stream;

  // * -------------------------------------------------------------------------

  Future<Profile?> doGetProfile() async {
    if (_profile != null) {
      return _profile; // profile fetched already.
    }

    final data = await DioClient.getProfile(authRepo.uid!);
    //developer.log('doGetProfile() returned: $data');

    _profile = Profile.fromMap(data);

    return _profile;
  }

  // * -------------------------------------------------------------------------

  Future<Profile?> doChangePassword(String currPwd, String newPwd) async {
    final data = await DioClient.postChangePwd(authRepo.uid!, currPwd, newPwd);
    developer.log('doChangePassword() returned: $data');

    var result = data['result'];
    if (result == 'Changed successfully') {
      return _profile;
    } else if (result == 'Invalid Driver') {
      throw const AppException.userNotFound();
    } else if (result == 'Invalid Password') {
      throw const AppException.wrongPassword();
    }

    return null;
  }

  // * -------------------------------------------------------------------------

  Future<Profile?> doEditProfile(
      String name, String phone, String birthday, String address) async {
    final data = await DioClient.postProfileEdit(
        authRepo.uid!, name, phone, birthday, address);
    developer.log('doEditProfile() returned: $data');

    var result = data['result'];
    if (result == 'Update successfully') {
      // update local profile data.
      _profile = _profile?.copyWith(name, phone, birthday, address);
      return _profile;
    } else if (result == 'Invalid Driver') {
      throw const AppException.userNotFound();
    }

    return null;
  }

  // * -------------------------------------------------------------------------

  Future<Profile?> doLogout() async {
    // clear profile and uid, later we may need to notify server...
    _profile = null;
    authRepo.doLogOut();

    return null;
  }
}

final profileRepositoryProvider = StateProvider<ProfileRepository>((ref) {
  return ProfileRepository(authRepo: ref.watch(authRepositoryProvider));
});

final profileStateChangesProvider = StreamProvider<Profile?>((ref) {
  final profileRepo = ref.watch(profileRepositoryProvider);
  return profileRepo.profileStateChanges();
});
