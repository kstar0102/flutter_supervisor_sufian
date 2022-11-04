import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import 'package:alnabali_driver/src/constants/app_styles.dart';
import 'package:alnabali_driver/src/features/auth/auth_controllers.dart';
import 'package:alnabali_driver/src/routing/app_router.dart';
import 'package:alnabali_driver/src/utils/string_hardcoded.dart';
import 'package:alnabali_driver/src/widgets/login_button.dart';
import 'package:alnabali_driver/src/widgets/progress_hud.dart';

class ForgetMobileScreen extends ConsumerStatefulWidget {
  const ForgetMobileScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ForgetMobileScreen> createState() => _ForgetMobileScreenState();
}

class _ForgetMobileScreenState extends ConsumerState<ForgetMobileScreen> {
  final _mobileController = TextEditingController();

  String get mobile => _mobileController.text;

  void _submit() async {
    //if (_mobileValidator.isValid(username)) {
    ref.read(forgetMobileControllerProvider.notifier).doSendMobile(mobile);
    //}
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue>(
      forgetMobileControllerProvider,
      (_, state) => state.whenOrNull(
        data: ((value) {
          if (value == true) {
            context.goNamed(AppRoute.forgetOTP.name);
          }
        }),
        error: (error, stackTrace) {},
      ),
    );

    final state = ref.watch(forgetMobileControllerProvider);

    return Scaffold(
      body: ProgressHUD(
        inAsyncCall: state.isLoading,
        child: SizedBox.expand(
          child: Container(
            decoration: kBgDecoration,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Flexible(flex: 1, child: SizedBox(height: 200.h)),
                  SizedBox(
                    width: 609.h,
                    child: Image.asset("assets/images/forget_icon.png"),
                  ),
                  Flexible(flex: 1, child: SizedBox(height: 90.h)),
                  Text(
                    "FORGET PASSWORD".hardcoded,
                    style: kTitleTextStyle,
                  ),
                  Flexible(flex: 1, child: SizedBox(height: 110.h)),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: kSubTitleTextStyle,
                      children: [
                        TextSpan(text: 'We will send a one time '.hardcoded),
                        TextSpan(
                          text: 'OTP'.hardcoded,
                          style: const TextStyle(fontWeight: FontWeight.w800),
                        ),
                        TextSpan(text: ' on \n your mobile number'.hardcoded),
                      ],
                    ),
                  ),
                  Flexible(flex: 1, child: SizedBox(height: 250.h)),
                  SizedBox(
                    width: kTextfieldW,
                    height: kTextfieldH,
                    child: TextField(
                      controller: _mobileController,
                      autocorrect: false,
                      textInputAction: TextInputAction.done,
                      keyboardType: TextInputType.phone,
                      cursorColor: Colors.white,
                      onEditingComplete: () => _submit(),
                      decoration: InputDecoration(
                        label: Padding(
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          child: Text('MOBILE NUMBER'.hardcoded),
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
                  Flexible(flex: 1, child: SizedBox(height: 250.h)),
                  LoginButton(
                    btnType: LoginButtonType.send,
                    onPressed: () => _submit(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.symmetric(vertical: 20.h),
        child: SizedBox(
          height: 150.h,
          child: IconButton(
            onPressed: () => context.goNamed(AppRoute.login.name),
            //iconSize: 89.h,
            icon: Image.asset('assets/images/btn_back.png'),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
    );
  }
}
