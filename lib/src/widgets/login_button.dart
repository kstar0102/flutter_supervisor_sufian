import 'package:flutter/material.dart';

import 'package:alnabali_driver/src/widgets/constants.dart';

// button types used in login course.
enum LoginButtonType { logIn, send, verify, reset }

class LoginButton extends StatefulWidget {
  final LoginButtonType btnType;
  final bool isLoading;
  final VoidCallback onPressed;

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
        btnTitle = 'LOGIN';
        break;
      case LoginButtonType.send:
        btnTitle = 'SEND';
        break;
      case LoginButtonType.verify:
        btnTitle = 'VERIFY';
        break;
      case LoginButtonType.reset:
        btnTitle = 'RESET';
        break;
      default:
        btnTitle = 'UNKNOWN';
    }

    SizeConfig().init(context);
    final btnW = SizeConfig.screenW * 0.69;

    // return Stack(
    //   alignment: Alignment.center,
    //   children: [
    //     Container(
    //       width: btnW,
    //       decoration: BoxDecoration(
    //         color: Colors.transparent,
    //         borderRadius: const BorderRadius.all(Radius.circular(50)),
    //         boxShadow: [
    //           BoxShadow(
    //             color: Colors.black.withOpacity(0.2),
    //             spreadRadius: 1,
    //             blurRadius: 1,
    //             offset: const Offset(0, 2),
    //           ),
    //         ],
    //       ),
    //       child: Image.asset('assets/images/btn_login.png'),
    //     ),
    //     Positioned.fill(
    //       child: TextButton(
    //         style: TextButton.styleFrom(
    //           shape: const StadiumBorder(),
    //           foregroundColor: const Color(0xFF0055A6),
    //           textStyle: const TextStyle(
    //             fontFamily: 'Montserrat',
    //             fontWeight: FontWeight.w700,
    //             fontSize: 16,
    //           ),
    //         ),
    //         onPressed: widget.onPressed,
    //         child: Text(btnTitle),
    //       ),
    //     ),
    //   ],
    // );
    return Stack(
      children: [
        SizedBox(
          width: btnW,
          height: btnW * 0.16,
          child: Image.asset('assets/images/btn_login.png'),
        ),
        Positioned.fill(
          child: widget.isLoading
              ? const SizedBox(
                  child: Center(child: CircularProgressIndicator()))
              : TextButton(
                  onPressed: widget.onPressed,
                  child: Text(
                    btnTitle,
                    style: const TextStyle(
                      color: kColorPrimaryBlue,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                ),
        ),
      ],
    );
  }
}
