import 'package:flutter/material.dart';

import 'package:alnabali_driver/src/widgets/constants.dart';
import 'package:alnabali_driver/src/widgets/login_textfield.dart';
import 'package:alnabali_driver/src/widgets/login_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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
              Flexible(
                  flex: 1, child: SizedBox(height: 160 * SizeConfig.scaleY)),
              SizedBox(
                height: 497 * SizeConfig.scaleY,
                child: Image.asset("assets/images/login_icon.png"),
              ),
              const Text(
                "LOGIN",
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w700,
                  fontSize: 28,
                  color: Colors.white,
                ),
              ),
              Flexible(
                  flex: 1, child: SizedBox(height: 250 * SizeConfig.scaleY)),
              const LoginTextField(txtFieldType: LoginTextFieldType.username),
              Flexible(
                  flex: 1, child: SizedBox(height: 125 * SizeConfig.scaleY)),
              const LoginTextField(txtFieldType: LoginTextFieldType.password),
              Flexible(
                  flex: 1, child: SizedBox(height: 260 * SizeConfig.scaleY)),
              LoginButton(
                btnType: LoginButtonType.logIn,
                onPressed: () {
                  //Navigator.pushReplacementNamed(context, '/home');
                },
              ),
              Flexible(
                  flex: 1, child: SizedBox(height: 310 * SizeConfig.scaleY)),
              TextButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/forget1');
                },
                child: const Text(
                  "FORGET PASSWORD",
                  style: TextStyle(
                    shadows: [
                      Shadow(color: Colors.white, offset: Offset(0, -6))
                    ],
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w400,
                    fontSize: 13,
                    color: Colors.transparent,
                    decoration: TextDecoration.underline,
                    decorationColor: Colors.white,
                    decorationThickness: 2,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
