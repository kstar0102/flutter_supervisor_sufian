import 'package:alnabali_driver/src/features/auth/data/auth_repository.dart';
import 'package:alnabali_driver/src/utils/string_hardcoded.dart';
import 'package:alnabali_driver/src/utils/string_validators.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginState {
  LoginState({this.value = const AsyncValue.data(null)});

  final AsyncValue<void> value;
  final StringValidator emailSubmitValidator = EmailSubmitRegexValidator();
  final StringValidator passwordSignInSubmitValidator =
      NonEmptyStringValidator();

  bool get isLoading => value.isLoading;

  LoginState copyWith({AsyncValue<void>? value}) {
    return LoginState(value: value ?? this.value);
  }

  bool canSubmitEmail(String email) {
    return emailSubmitValidator.isValid(email);
  }

  bool canSubmitPassword(String password) {
    return passwordSignInSubmitValidator.isValid(password);
  }

  String? emailErrorText(String email) {
    final bool showErrorText = !canSubmitEmail(email);
    final String errorText = email.isEmpty
        ? 'Email can\'t be empty'.hardcoded
        : 'Invalid email'.hardcoded;
    return showErrorText ? errorText : null;
  }

  String? passwordErrorText(String password) {
    final bool showErrorText = !canSubmitPassword(password);
    final String errorText = password.isEmpty
        ? 'Password can\'t be empty'.hardcoded
        : 'Password is too short'.hardcoded;
    return showErrorText ? errorText : null;
  }

  @override
  String toString() => 'LoginState(value: $value)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is LoginState && other.value == value;
  }

  @override
  int get hashCode => value.hashCode;
}

class LoginController extends StateNotifier<LoginState> {
  LoginController({required this.authRepository}) : super(LoginState());

  final AuthRepository authRepository;

  Future<bool> submit(String email, String password) async {
    state = state.copyWith(value: const AsyncValue.loading());

    final value =
        await AsyncValue.guard(() => authRepository.logIn(email, password));
    state = state.copyWith(value: value);

    return value.hasError == false;
  }
}

final loginControllerProvider =
    StateNotifierProvider.autoDispose<LoginController, LoginState>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return LoginController(authRepository: authRepository);
});
