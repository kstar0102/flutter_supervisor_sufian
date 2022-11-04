import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import 'package:alnabali_driver/src/constants/app_styles.dart';
import 'package:alnabali_driver/src/features/auth/auth_controllers.dart';
import 'package:alnabali_driver/src/routing/app_router.dart';
import 'package:alnabali_driver/src/utils/string_hardcoded.dart';
import 'package:alnabali_driver/src/utils/string_validators.dart';
import 'package:alnabali_driver/src/widgets/login_button.dart';
import 'package:alnabali_driver/src/widgets/progress_hud.dart';

class ForgetPwdScreen extends ConsumerStatefulWidget {
  const ForgetPwdScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ForgetPwdScreen> createState() => _ForgetPwdScreenState();
}

class _ForgetPwdScreenState extends ConsumerState<ForgetPwdScreen> {
  final _node = FocusScopeNode();
  final _pwdOneController = TextEditingController();
  final _pwdTwoController = TextEditingController();
  final _passwordValidator = NonEmptyStringValidator();

  String get pwdOne => _pwdOneController.text;
  String get pwdTwo => _pwdTwoController.text;

  void _pwdOneEditingComplete() {
    _node.nextFocus();
  }

  void _pwdTwoEditingComplete() {
    if (!_passwordValidator.isValid(pwdOne) || pwdOne != pwdTwo) {
      _node.previousFocus();
      return;
    }

    _submit();
  }

  void _submit() {
    ref.read(resetPwdControllerProvider.notifier).doVerifyOTP(pwdOne);
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue>(
      resetPwdControllerProvider,
      (_, state) => state.whenOrNull(
        data: ((data) {
          if (data == true) {
            context.goNamed(AppRoute.home.name);
          }
        }),
        error: (error, stackTrace) {},
      ),
    );

    final state = ref.watch(resetPwdControllerProvider);

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
                    Flexible(child: SizedBox(height: 100.h)),
                    SizedBox(
                      height: 609.h,
                      child: Image.asset("assets/images/forget_icon3.png"),
                    ),
                    Flexible(child: SizedBox(height: 90.h)),
                    Text(
                      'FORGET PASSWORD'.hardcoded,
                      style: kTitleTextStyle,
                    ),
                    Flexible(child: SizedBox(height: 100.h)),
                    Text(
                      "Enter your new password below".hardcoded,
                      style: kSubTitleTextStyle,
                    ),
                    Flexible(child: SizedBox(height: 200.h)),
                    SizedBox(
                      width: kTextfieldW,
                      height: kTextfieldH,
                      child: TextField(
                        controller: _pwdOneController,
                        keyboardType: TextInputType.visiblePassword,
                        //validator: (pwd) => state.passwordErrorText(pwd ?? ''),
                        obscureText: true,
                        autocorrect: false,
                        textInputAction: TextInputAction.done,
                        cursorColor: Colors.white,
                        onEditingComplete: () => _pwdOneEditingComplete(),
                        decoration: InputDecoration(
                          label: Padding(
                            padding: const EdgeInsets.only(left: 10, right: 10),
                            child: Text('NEW PASSWORD'.hardcoded),
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
                    Flexible(child: SizedBox(height: 140.h)),
                    SizedBox(
                      width: kTextfieldW,
                      height: kTextfieldH,
                      child: TextField(
                        controller: _pwdTwoController,
                        keyboardType: TextInputType.visiblePassword,
                        //validator: (pwd) => state.passwordErrorText(pwd ?? ''),
                        obscureText: true,
                        autocorrect: false,
                        textInputAction: TextInputAction.done,
                        cursorColor: Colors.white,
                        onEditingComplete: () => _pwdTwoEditingComplete(),
                        decoration: InputDecoration(
                          label: Padding(
                            padding: const EdgeInsets.only(left: 10, right: 10),
                            child: Text('CONFIRM PASSWORD'.hardcoded),
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
                    Flexible(child: SizedBox(height: 200.h)),
                    LoginButton(
                      btnType: LoginButtonType.reset,
                      onPressed: _submit,
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
