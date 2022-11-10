import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import 'package:alnabali_driver/src/constants/app_styles.dart';
import 'package:alnabali_driver/src/features/auth/auth_controllers.dart';
import 'package:alnabali_driver/src/features/auth/login_validators.dart';
import 'package:alnabali_driver/src/routing/app_router.dart';
import 'package:alnabali_driver/src/utils/async_value_ui.dart';
import 'package:alnabali_driver/src/utils/string_hardcoded.dart';
import 'package:alnabali_driver/src/utils/string_validators.dart';
import 'package:alnabali_driver/src/widgets/dialogs.dart';
import 'package:alnabali_driver/src/widgets/login_button.dart';
import 'package:alnabali_driver/src/widgets/progress_hud.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen>
    with EmailAndPasswordValidators {
  final _node = FocusScopeNode();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  String get username => _usernameController.text;
  String get password => _passwordController.text;

  @override
  void dispose() {
    // TextEditingControllers should be always disposed.
    _node.dispose();
    _usernameController.dispose();
    _passwordController.dispose();

    super.dispose();
  }

  void _submit() {
    // only submit if validation passes
    if (emailSubmitValidator.isValid(username) &&
        passwordSignInSubmitValidator.isValid(password)) {
      final controller = ref.read(loginControllerProvider.notifier);
      controller.doLogin(username, password).then(
        //controller.doLogin('driver1@gmail.com', '123123').then(
        (value) {
          // go home only if login success.
          if (value == true) {
            context.goNamed(AppRoute.home.name);
          }
        },
      );
    } else {
      showToastMessage('Please input email and password correctly.');
    }
  }

  void _emailEditingComplete() {
    if (canSubmitEmail(username)) {
      _node.nextFocus();
    }
  }

  void _passwordEditingComplete() {
    if (!canSubmitEmail(username)) {
      _node.previousFocus();
      return;
    }

    // i can't understand why this called multiple...
    if (ref.watch(loginControllerProvider).isLoading) return;

    _submit();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue>(loginControllerProvider,
        (_, state) => state.showAlertDialogOnError(context));

    final state = ref.watch(loginControllerProvider);

    return Scaffold(
      body: ProgressHUD(
        inAsyncCall: state.isLoading,
        child: SizedBox.expand(
          child: FocusScope(
            node: _node,
            child: Container(
              decoration: kBgDecoration,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Flexible(flex: 1, child: SizedBox(height: 200.h)),
                    SizedBox(
                      width: 998.w,
                      child: Image.asset("assets/images/login_icon.png"),
                    ),
                    Text(
                      "LOGIN".hardcoded,
                      style: kTitleTextStyle,
                    ),
                    Flexible(flex: 1, child: SizedBox(height: 250.h)),
                    SizedBox(
                      width: kTextfieldW,
                      height: kTextfieldH,
                      child: TextField(
                        controller: _usernameController,
                        //validator: (username) => emailErrorText(username ?? ''),
                        autocorrect: false,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.emailAddress,
                        cursorColor: Colors.white,
                        onEditingComplete: () => _emailEditingComplete(),
                        inputFormatters: <TextInputFormatter>[
                          ValidatorInputFormatter(
                              editingValidator: EmailEditingRegexValidator()),
                        ],
                        decoration: InputDecoration(
                          label: Padding(
                            padding: const EdgeInsets.only(left: 10, right: 10),
                            child: Text('USERNAME'.hardcoded),
                          ),
                          labelStyle: kLabelStyle,
                          errorStyle: kErrorStyle,
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          contentPadding: kContentPadding,
                          enabledBorder: kEnableBorder,
                          focusedBorder: kFocusBorder,
                          focusedErrorBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                        ),
                        style: kEditStyle,
                      ),
                    ),
                    Flexible(flex: 1, child: SizedBox(height: 130.h)),
                    SizedBox(
                      width: kTextfieldW,
                      height: kTextfieldH,
                      child: TextField(
                        controller: _passwordController,
                        keyboardType: TextInputType.visiblePassword,
                        //validator: (pwd) => passwordErrorText(pwd ?? ''),
                        obscureText: true,
                        autocorrect: false,
                        textInputAction: TextInputAction.done,
                        cursorColor: Colors.white,
                        onEditingComplete: () => _passwordEditingComplete(),
                        decoration: InputDecoration(
                          label: Padding(
                            padding: const EdgeInsets.only(left: 10, right: 10),
                            child: Text('PASSWORD'.hardcoded),
                          ),
                          labelStyle: kLabelStyle,
                          errorStyle: kErrorStyle,
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          contentPadding: kContentPadding,
                          enabledBorder: kEnableBorder,
                          focusedBorder: kFocusBorder,
                          focusedErrorBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                        ),
                        style: kEditStyle,
                      ),
                    ),
                    Flexible(flex: 1, child: SizedBox(height: 260.h)),
                    LoginButton(
                      btnType: LoginButtonType.logIn,
                      onPressed: () => _submit(),
                    ),
                    Flexible(flex: 1, child: SizedBox(height: 100.h)),
                    TextButton(
                      onPressed: () =>
                          context.goNamed(AppRoute.forgetMobile.name),
                      child: Text(
                        "FORGET PASSWORD".hardcoded,
                        style: TextStyle(
                          shadows: [
                            Shadow(
                                color: Colors.white, offset: Offset(0, -14.h))
                          ],
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w500,
                          fontSize: 37.sp,
                          color: Colors.transparent,
                          decoration: TextDecoration.underline,
                          decorationColor: Colors.white,
                          decorationThickness: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
