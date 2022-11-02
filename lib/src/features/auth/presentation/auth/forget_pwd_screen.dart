import 'package:flutter/material.dart';

import 'package:alnabali_driver/src/widgets/constants.dart';
import 'package:alnabali_driver/src/widgets/login_textfield.dart';
import 'package:alnabali_driver/src/widgets/login_button.dart';

class ForgetPwdScreen extends StatefulWidget {
  const ForgetPwdScreen({Key? key}) : super(key: key);

  @override
  State<ForgetPwdScreen> createState() => _ForgetPwdScreenState();
}

class _ForgetPwdScreenState extends State<ForgetPwdScreen> {
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
                height: 609 * SizeConfig.scaleY,
                child: Image.asset("assets/images/forget_icon3.png"),
              ),
              Flexible(
                  flex: 1, child: SizedBox(height: 100 * SizeConfig.scaleY)),
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
                  flex: 1, child: SizedBox(height: 110 * SizeConfig.scaleY)),
              const Text(
                "Enter your new password below",
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
              Flexible(
                  flex: 1, child: SizedBox(height: 180 * SizeConfig.scaleY)),
              const LoginTextField(
                  txtFieldType: LoginTextFieldType.newPassword),
              Flexible(
                  flex: 1, child: SizedBox(height: 130 * SizeConfig.scaleY)),
              const LoginTextField(
                  txtFieldType: LoginTextFieldType.confirmNewPwd),
              Flexible(
                  flex: 1, child: SizedBox(height: 185 * SizeConfig.scaleY)),
              LoginButton(
                btnType: LoginButtonType.reset,
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/home');
                },
              ),
              Flexible(
                  flex: 1, child: SizedBox(height: 250 * SizeConfig.scaleY)),
            ],
          ),
        ),
      ),
    );
  }
}
