import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import 'package:alnabali_driver/src/constants/app_styles.dart';
import 'package:alnabali_driver/src/features/auth/auth_controllers.dart';
import 'package:alnabali_driver/src/routing/app_router.dart';
import 'package:alnabali_driver/src/utils/string_hardcoded.dart';
import 'package:alnabali_driver/src/widgets/login_button.dart';
import 'package:alnabali_driver/src/widgets/otp_field.dart';
import 'package:alnabali_driver/src/widgets/progress_hud.dart';

class ForgetOTPScreen extends ConsumerStatefulWidget {
  const ForgetOTPScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ForgetOTPScreen> createState() => _ForgetOTPScreenState();
}

class _ForgetOTPScreenState extends ConsumerState<ForgetOTPScreen> {
  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue>(
      forgetOTPControllerProvider,
      (_, state) => state.whenOrNull(
        data: ((data) {
          if (data == true) {
            context.goNamed(AppRoute.forgetPwd.name);
          }
        }),
        error: (error, stackTrace) {},
      ),
    );

    final state = ref.watch(forgetOTPControllerProvider);

    return Scaffold(
      body: ProgressHUD(
        inAsyncCall: state.isLoading,
        child: SizedBox.expand(
          child: Container(
            decoration: kBgDecoration,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(flex: 1, child: SizedBox(height: 100.h)),
                  SizedBox(
                    height: 609.h,
                    child: Image.asset("assets/images/forget_icon.png"),
                  ),
                  Flexible(flex: 1, child: SizedBox(height: 90.h)),
                  Text(
                    "FORGET PASSWORD".hardcoded,
                    style: kTitleTextStyle,
                  ),
                  Flexible(flex: 1, child: SizedBox(height: 120.h)),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: kSubTitleTextStyle,
                      children: [
                        TextSpan(text: 'An '.hardcoded),
                        TextSpan(
                          text: 'OTP'.hardcoded,
                          style: const TextStyle(fontWeight: FontWeight.w800),
                        ),
                        TextSpan(
                            text:
                                ' was sent to your \n mobile number'.hardcoded),
                      ],
                    ),
                  ),
                  Flexible(flex: 2, child: SizedBox(height: 250.h)),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: kTextfieldW,
                        height: kTextfieldH,
                        // padding: const EdgeInsets.symmetric(
                        //   vertical: 10,
                        //   horizontal: 30,
                        // ),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.white,
                            width: 1.2,
                          ),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(100)),
                        ),
                      ),
                      Positioned(
                        bottom: 20.sp,
                        child: OTPTextField(
                          length: 4,
                          width: kTextfieldW,
                          fieldWidth: kTextfieldW / 9,
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w500,
                            fontSize: 70.sp,
                            color: Colors.white,
                          ),
                          textFieldAlignment: MainAxisAlignment.spaceAround,
                          onCompleted: (pin) {
                            //print("Completed: $pin");
                          },
                          onChanged: (value) {
                            //print("Completed: " + pin);
                          },
                        ),
                      ),
                    ],
                  ),
                  Flexible(flex: 2, child: SizedBox(height: 250.h)),
                  LoginButton(
                    btnType: LoginButtonType.verify,
                    onPressed: () {
                      ref
                          .read(forgetOTPControllerProvider.notifier)
                          .doVerifyOTP('otp-code');
                    },
                  ),
                  Flexible(flex: 1, child: SizedBox(height: 90.h)),
                  Text(
                    "Did not receive the verification OTP?".hardcoded,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w500,
                      fontSize: 36.sp,
                      color: Colors.white,
                    ),
                  ),
                  Flexible(flex: 1, child: SizedBox(height: 30.h)),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w700,
                        fontSize: 36.sp,
                        color: Colors.white,
                      ),
                      children: <TextSpan>[
                        TextSpan(text: 'Resend OTP in '.hardcoded),
                        const TextSpan(
                          text: '00:59',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: Color(0xFFFAED1F),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.symmetric(vertical: 20.h),
        child: SizedBox(
          height: 138.h,
          child: IconButton(
            onPressed: () => context.goNamed(AppRoute.forgetMobile.name),
            //iconSize: 89.h,
            icon: Image.asset('assets/images/btn_back.png'),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
    );
  }
}
