import 'package:dio/dio.dart';

import 'package:alnabali_driver/src/network/dio_exception.dart';

class DioClient {
  static final _baseOptions = BaseOptions(
    baseUrl: 'http://167.86.102.230/Alnabali/public/android',
    //connectTimeout: 10000, receiveTimeout: 10000,
    headers: {
      'Content-type': 'application/x-www-form-urlencoded',
      'Accept': 'application/json',
      'Cookie':
          'XSRF-TOKEN=eyJpdiI6Inc1YW0wQ29WVlJaUUF3V2RkUXRVaVE9PSIsInZhbHVlIjoibDkrMmRmSFFNQkxZbENybFFscXo1d3hHUXAySFVBWE1XbEthRFoybStRT0ZETk9BcXlLRXkrQmZYSnRzODZ6aHRjamtNZ1RyK2VKbmFlS3BNTGtSS1g1NnhjNjJ0RHVReUVjTFpBMzhlaytCc3hVWDBJZWxNOTVUYURrakRud3YiLCJtYWMiOiIzYzNmOTU1NDA0ODkxZTU3NWQzMDQyMmMzZThmMDU2OWQ3ODkzYTY2ZGI1ZWViNmU0M2VmMmMwZDBhYjg1YzlmIn0%3D; laravel_session=eyJpdiI6IndwREYyUnNob3B2aUtiam5JdEE0ckE9PSIsInZhbHVlIjoiL1FUejBJbUEwcG9lWnl5NmtXVlQzQ1VRVzZZWEhZZDIwbnpnNFBuSTBuclpESjBKTkhPaFdhdlFTQWFuNUh4MWErOGdSTVdkVkZyYnEvOEJ1RVhTWUEvRlA0TlRPZC9jL0NVZlRRWkRCaUZXUHlEYWNqVTIzV2hwZnBPZzhVVjEiLCJtYWMiOiIzZDczOWM1Y2ViZDE0OTE2N2M5ODYyNDdkMmRlYzMyOGUwNjU2MmY0NTcxZGU2NGI4MTM1ZTEwZWE2MGY5ZWVmIn0%3D',
    },
  );

  // * keep token for future usage.
  static String _token = '';

  // * GET: '/token'
  static Future<String> _getToken() async {
    if (_token.isNotEmpty) {
      return _token;
    }

    var dio = Dio(_baseOptions);
    try {
      final response = await dio.get('/driver/token');
      _token = response.data['token'];

      return _token;
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw errorMessage;
    }
  }

  // * POST: '/login'
  static Future<dynamic> postLogin(String email, String password) async {
    final token = await _getToken();

    var dio = Dio(_baseOptions);
    dio.options.headers['X-CSRF-TOKEN'] = token;
    try {
      final response = await dio
          .post('/driver/login', data: {'email': email, 'password': password});
      return response.data;
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw errorMessage;
    }
  }

  // static Future<Map<String, dynamic>> postSendMobile(String phone) async {
  //   final token = await _getToken();

  //   var dio = Dio(_baseOptions);
  //   dio.options.headers['X-CSRF-TOKEN'] = token;
  //   try {
  //     final response = await dio.post('/send', data: {'phone': phone});
  //     return response.data;
  //   } on DioError {
  //     rethrow;
  //   }
  // }

  // * GET: '/profile/uid'
  static Future<dynamic> getProfile(String uid) async {
    final token = await _getToken();

    var dio = Dio(_baseOptions);
    dio.options.headers['X-CSRF-TOKEN'] = token;
    try {
      final response = await dio.get('/driver/profile/$uid');
      return response.data;
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw errorMessage;
    }
  }

  // * POST '/profile_edit'
  static Future<dynamic> postProfileEdit(
    String uid,
    String name,
    String phone,
    String birthday,
    String address, // ? Map<> is better???
  ) async {
    final token = await _getToken();

    var dio = Dio(_baseOptions);
    dio.options.headers['X-CSRF-TOKEN'] = token;
    try {
      final response = await dio.post(
        '/driver/profile_edit',
        data: {
          'id': uid,
          'name': name,
          'phone': phone,
          'birthday': birthday,
          'address': address,
        },
      );
      return response.data;
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw errorMessage;
    }
  }

  // * POST '/pwd/change'
  static Future<dynamic> postChangePwd(
      String uid, String currPwd, String newPwd) async {
    final token = await _getToken();

    var dio = Dio(_baseOptions);
    dio.options.headers['X-CSRF-TOKEN'] = token;
    try {
      final response = await dio.post(
        '/driver/pwd/change',
        data: {'id': uid, 'current_pwd': currPwd, 'new_pwd': newPwd},
      );
      return response.data;
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw errorMessage;
    }
  }

  // * POST '/daily-trip/today'
  static Future<dynamic> postDailyTripToday() async {
    final token = await _getToken();

    var dio = Dio(_baseOptions);
    dio.options.headers['X-CSRF-TOKEN'] = token;

    try {
      final response = await dio.post(
        '/daily-trip/today',
        data: {'driver_name': 'all'},
      );
      return response.data;
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw errorMessage;
    }
  }

  // * POST '/daily-trip/last'
  static Future<dynamic> postDailyTripLast() async {
    final token = await _getToken();

    var dio = Dio(_baseOptions);
    dio.options.headers['X-CSRF-TOKEN'] = token;

    try {
      final response = await dio.post(
        '/daily-trip/last',
        data: {'driver_name': 'all'},
      );
      return response.data;
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw errorMessage;
    }
  }

  // * POST '/daily-trip/command'
  static Future<dynamic> postDailyTripCommand(String id, String cmd) async {
    final token = await _getToken();

    var dio = Dio(_baseOptions);
    dio.options.headers['X-CSRF-TOKEN'] = token;

    try {
      final response = await dio.post(
        '/daily-trip/command',
        data: {'id': id, 'command': cmd},
      );
      return response.data;
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw errorMessage;
    }
  }

  // * POST '/notification/all'
  static Future<dynamic> postNotificationAll() async {
    final token = await _getToken();

    var dio = Dio(_baseOptions);
    dio.options.headers['X-CSRF-TOKEN'] = token;

    try {
      final response = await dio.get('/notification/all');
      return response.data;
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw errorMessage;
    }
  }

  // * POST '/notification/today'
  static Future<dynamic> postNotificationToday() async {
    final token = await _getToken();

    var dio = Dio(_baseOptions);
    dio.options.headers['X-CSRF-TOKEN'] = token;

    try {
      final response = await dio.get('/notification/today');
      return response.data;
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw errorMessage;
    }
  }
}
