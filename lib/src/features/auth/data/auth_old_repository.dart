import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:alnabali_driver/src/exceptions/app_exception.dart';
import 'package:alnabali_driver/src/features/auth/domain/app_user.dart';
import 'package:alnabali_driver/src/network/dio_client.dart';
import 'package:alnabali_driver/src/utils/in_memory_store.dart';

class AuthOldRepository {
  final _userState = InMemoryStore<AppUser?>(null);

  Stream<AppUser?> userStateChanges() => _userState.stream;
  AppUser? get currentUser => _userState.value;

  Future<void> tryGetToken() async {
    // final response = await DioClient._getToken();

    // _userState.value = AppUser(token: response.data['token']);
  }

  Future<void> tryLogIn(String username, String password) async {
    var user = _userState.value;
    if (user == null || user.token.isEmpty) {
      return; // token not ready yet.
    }

    final response = await DioClient.postLogin(username, password);

    var result = response['result'];
    if (result == 'Login Successfully') {
      _userState.value = user.copyWith(
        uid: response['id'].toString(),
        username: username,
      );
    } else if (result == 'Invalid Driver') {
      throw const AppException.userNotFound();
    } else if (result == 'Invalid Password') {
      throw const AppException.wrongPassword();
    }
  }

  Future<void> tryGetProfile() async {
    var user = _userState.value;
    if (user == null || !user.isLogined()) {
      return; // trying for invalid user.
    } else if (user.profile != null) {
      return; // already profile data fetched.
    }

    final response = await DioClient.getProfile(user.uid);

    var driver = response.data['driver'];
    // ? these null values must be from server?
    final profileImg = driver['profile_image'] ?? '';
    final addr = driver['address'] ?? '';
    _userState.value = user.copyWith(
      profile: Profile(
        profileImage: profileImg,
        nameEN: driver['name_en'],
        phone: driver['phone'],
        birthday: driver['age'],
        address: addr,
      ),
    );
  }

  Future<void> tryEditProfile(
      String name, String phone, String birthday, String address) async {
    var user = _userState.value;
    if (user == null || !user.isLogined()) {
      return; // trying for invalid user.
    }

    final response = await DioClient.postProfileEdit(
        user.uid, name, phone, birthday, address);
    var result = response.data['result'];
    if (result == 'Update successfully') {
      //print('change ok');
    } else if (result == 'Invalid Password') {
      throw const AppException.wrongPassword();
    }
  }

  Future<void> tryChangePwd(String currPwd, String newPwd) async {
    var user = _userState.value;
    if (user == null || !user.isLogined()) {
      return; // trying for invalid user.
    }

    final response = await DioClient.postChangePwd(user.uid, currPwd, newPwd);
    var result = response.data['result'];
    if (result == 'Changed successfully') {
      //print('change ok');
    } else if (result == 'Invalid Password') {
      throw const AppException.wrongPassword();
    }
  }

  Future<void> tryLogOut() async {
    await Future.delayed(const Duration(seconds: 2));
  }

  void dispose() {
    _userState.close();
  }
}

final authRepositoryProvider = Provider<AuthOldRepository>((ref) {
  final auth = AuthOldRepository();
  ref.onDispose(() => auth.dispose());
  return auth;
});

final userStateChangesProvider = StreamProvider<AppUser?>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return authRepository.userStateChanges();
});
