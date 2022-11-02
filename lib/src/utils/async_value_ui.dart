import 'package:alnabali_driver/src/widgets/alert_dialogs.dart';
//import 'package:alnabali_driver/src/exceptions/app_exception.dart';
import 'package:alnabali_driver/src/utils/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

extension AsyncValueUI on AsyncValue {
  bool showAlertDialogOnError(BuildContext context) {
    if (!isRefreshing && hasError) {
      final message = _errorMessage(error);
      showExceptionAlertDialog(
        context: context,
        title: 'Error'.hardcoded,
        exception: message,
      );
      return true;
    }
    return false;
  }

  String _errorMessage(Object? error) {
    // if (error is AppException) {
    //   return error.details.message;
    // } else {
    return error.toString();
    // }
  }
}
