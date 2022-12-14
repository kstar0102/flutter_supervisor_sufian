import 'dart:developer' as developer;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:alnabali_driver/src/exceptions/app_exception.dart';
import 'package:alnabali_driver/src/network/dio_client.dart';

class AuthRepository {
  String? _uid; // AuthRepository will not use data model.

  String? get uid => _uid;

  Future<bool> doLogIn(String username, String password) async {
    final data = await DioClient.postLogin(username, password);
    developer.log('doLogin() returned: $data');

    var result = data['result'];
    if (result == 'Login Successfully') {
      _uid = data['id'].toString();
      return true;
    } else if (result == 'Invalid Driver') {
      throw const AppException.userNotFound();
    } else if (result == 'Invalid Password') {
      throw const AppException.wrongPassword();
    }

    return false;
  }

  Future<bool> doSendMobile(String phone) async {
    await Future.delayed(const Duration(seconds: 1));

    return true;
  }

  Future<bool> doVerifyOTP(String otp) async {
    await Future.delayed(const Duration(seconds: 1));

    return true;
  }

  Future<bool> doResetPwd(String newPwd) async {
    await Future.delayed(const Duration(seconds: 1));

    return true;
  }

  Future<void> doLogOut() async {
    _uid = null;
  }
}

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository();
});
