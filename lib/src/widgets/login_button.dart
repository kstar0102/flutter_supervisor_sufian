import 'package:flutter/material.dart';

import 'package:alnabali_driver/src/constants/app_styles.dart';
import 'package:alnabali_driver/src/utils/string_hardcoded.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// button types used in login course.
enum LoginButtonType { logIn, send, verify, reset }

class LoginButton extends StatefulWidget {
  final LoginButtonType btnType;
  final bool isLoading;
  final VoidCallback? onPressed;

  const LoginButton({
    Key? key,
    required this.btnType,
    this.isLoading = false,
    required this.onPressed,
  }) : super(key: key);

  @override
  State<LoginButton> createState() => _LoginButtonState();
}

class _LoginButtonState extends State<LoginButton> {
  @override
  Widget build(BuildContext context) {
    String btnTitle;
    switch (widget.btnType) {
      case LoginButtonType.logIn:
        btnTitle = 'LOGIN'.hardcoded;
        break;
      case LoginButtonType.send:
        btnTitle = 'SEND'.hardcoded;
        break;
      case LoginButtonType.verify:
        btnTitle = 'VERIFY'.hardcoded;
        break;
      case LoginButtonType.reset:
        btnTitle = 'RESET'.hardcoded;
        break;
      default:
        btnTitle = 'UNKNOWN'.hardcoded;
    }

    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: kTextfieldW - 40.w,
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: const BorderRadius.all(Radius.circular(100)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                spreadRadius: 1,
                blurRadius: 1,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Image.asset('assets/images/btn_login.png'),
        ),
        Positioned.fill(
          child: TextButton(
            style: TextButton.styleFrom(
              shape: const StadiumBorder(),
              foregroundColor: const Color(0xFF0055A6),
              textStyle: TextStyle(
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w700,
                fontSize: 46.sp,
              ),
            ),
            onPressed: widget.onPressed,
            child: Text(btnTitle),
          ),
        ),
      ],
    );
    // return Stack(
    //   children: [
    //     SizedBox(
    //       width: kTextfieldW,
    //       height: kTextfieldH,
    //       child: Image.asset('assets/images/btn_login.png'),
    //     ),
    //     Positioned.fill(
    //       child: widget.isLoading
    //           ? const SizedBox(
    //               child: Center(child: CircularProgressIndicator()))
    //           : TextButton(
    //               onPressed: widget.onPressed,
    //               child: Text(
    //                 btnTitle,
    //                 style: const TextStyle(
    //                   color: kColorPrimaryBlue,
    //                   fontFamily: 'Montserrat',
    //                   fontWeight: FontWeight.w700,
    //                   fontSize: 16,
    //                 ),
    //               ),
    //             ),
    //     ),
    //   ],
    // );
  }
}
