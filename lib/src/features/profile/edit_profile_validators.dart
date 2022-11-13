import 'package:alnabali_driver/src/utils/string_hardcoded.dart';
import 'package:alnabali_driver/src/utils/string_validators.dart';

/// Mixin class to be used for client-side email & password validation
mixin EidtProfileValidators {
  final nonEmptyValidator = NonEmptyStringValidator();
  final phoneValidator = PhoneRegexValidator();
  final birthValidator = DateRegexValidator();

  String? usernameErrorText(String username) {
    if (nonEmptyValidator.isValid(username)) {
      return null;
    }

    return 'Username can\'t be empty.'.hardcoded;
  }

  String? phoneErrorText(String phone) {
    if (nonEmptyValidator.isValid(phone)) {
      //if (phoneValidator.isValid(phone)) {
      return null;
    }

    return 'Phone number is not valid.'.hardcoded;
  }

  String? birthErrorText(String birth) {
    if (nonEmptyValidator.isValid(birth)) {
      //if (phoneValidator.isValid(birth)) {
      return null;
    }

    return birth.isEmpty
        ? 'Date of birth can\'t be empty.'
        : 'Date of birth is not valid.'.hardcoded;
  }

  String? addressErrorText(String address) {
    if (nonEmptyValidator.isValid(address)) {
      return null;
    }

    return 'Address can\'t be empty.'.hardcoded;
  }
}
