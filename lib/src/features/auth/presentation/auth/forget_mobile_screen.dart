import 'package:alnabali_driver/src/routing/app_router.dart';
import 'package:flutter/material.dart';

import 'package:alnabali_driver/src/widgets/constants.dart';
import 'package:alnabali_driver/src/widgets/login_textfield.dart';
import 'package:alnabali_driver/src/widgets/login_button.dart';
import 'package:go_router/go_router.dart';

class ForgetMobileScreen extends StatefulWidget {
  const ForgetMobileScreen({Key? key}) : super(key: key);

  @override
  State<ForgetMobileScreen> createState() => _ForgetMobileScreenState();
}

class _ForgetMobileScreenState extends State<ForgetMobileScreen> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: SizeConfig.screenW,
          height: SizeConfig.screenH,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/bg_normal.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                width: 609 * SizeConfig.scaleY,
                child: Image.asset("assets/images/forget_icon.png"),
              ),
              Flexible(
                  flex: 1, child: SizedBox(height: 90 * SizeConfig.scaleY)),
              const Text(
                "FORGET PASSWORD",
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w700,
                  fontSize: 28,
                  color: Colors.white,
                ),
              ),
              Flexible(
                  flex: 1, child: SizedBox(height: 120 * SizeConfig.scaleY)),
              RichText(
                textAlign: TextAlign.center,
                text: const TextSpan(
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w400,
                    fontSize: 18,
                    color: Colors.white,
                  ),
                  children: <TextSpan>[
                    TextSpan(text: 'We will send a one time '),
                    TextSpan(
                      text: 'OTP',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                    TextSpan(text: ' on \n your mobile number'),
                  ],
                ),
              ),
              Flexible(
                  flex: 1, child: SizedBox(height: 260 * SizeConfig.scaleY)),
              const LoginTextField(
                  txtFieldType: LoginTextFieldType.mobileNumber),
              Flexible(
                  flex: 1, child: SizedBox(height: 350 * SizeConfig.scaleY)),
              LoginButton(
                btnType: LoginButtonType.send,
                onPressed: () {
                  context.goNamed(AppRoute.forgetOTP.name);
                },
              ),
              Flexible(
                  flex: 1, child: SizedBox(height: 320 * SizeConfig.scaleY)),
            ],
          ),
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: IconButton(
          onPressed: () {
            context.goNamed(AppRoute.login.name);
          },
          iconSize: 89 * SizeConfig.scaleY,
          icon: Image.asset('assets/images/btn_back.png'),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
    );
  }
}
