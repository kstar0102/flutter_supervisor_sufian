import 'package:flutter/material.dart';

import 'package:alnabali_driver/src/widgets/constants.dart';
import 'package:alnabali_driver/src/widgets/login_button.dart';
import 'package:alnabali_driver/src/widgets/otp_field.dart';

class ForgetOTPScreen extends StatefulWidget {
  const ForgetOTPScreen({Key? key}) : super(key: key);

  @override
  State<ForgetOTPScreen> createState() => _ForgetOTPScreenState();
}

class _ForgetOTPScreenState extends State<ForgetOTPScreen> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final otpW = SizeConfig.screenW * 0.69;

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
                    TextSpan(text: 'An '),
                    TextSpan(
                      text: 'OTP',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                    TextSpan(text: ' was sent to your \n mobile number'),
                  ],
                ),
              ),
              Flexible(
                  flex: 2, child: SizedBox(height: 290 * SizeConfig.scaleY)),
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: otpW,
                    height: otpW * 0.16,
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 30,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.white,
                        width: 1.6,
                      ),
                      borderRadius: const BorderRadius.all(Radius.circular(50)),
                    ),
                  ),
                  Positioned(
                    bottom: 8,
                    child: OTPTextField(
                      length: 4,
                      width: otpW,
                      fieldWidth: otpW / 9,
                      style: const TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w400,
                        fontSize: 24,
                        color: Colors.white,
                      ),
                      textFieldAlignment: MainAxisAlignment.spaceAround,
                      onCompleted: (pin) {
                        //print("Completed: " + pin);
                      },
                      onChanged: (value) {
                        //print("Completed: " + pin);
                      },
                    ),
                  ),
                ],
              ),
              Flexible(
                  flex: 2, child: SizedBox(height: 300 * SizeConfig.scaleY)),
              LoginButton(
                btnType: LoginButtonType.verify,
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/forget_pwd');
                },
              ),
              Flexible(
                  flex: 1, child: SizedBox(height: 95 * SizeConfig.scaleY)),
              const Text(
                "Did not receive the verification OTP?",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w400,
                  fontSize: 13,
                  color: Colors.white,
                ),
              ),
              Flexible(
                  flex: 1, child: SizedBox(height: 10 * SizeConfig.scaleY)),
              RichText(
                textAlign: TextAlign.center,
                text: const TextSpan(
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w500,
                    fontSize: 13,
                    color: Colors.white,
                  ),
                  children: <TextSpan>[
                    TextSpan(text: 'Resend OTP in '),
                    TextSpan(
                      text: '00:59',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Color(0xFFFAED1F),
                      ),
                    ),
                  ],
                ),
              ),
              Flexible(
                  flex: 1, child: SizedBox(height: 150 * SizeConfig.scaleY)),
            ],
          ),
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: IconButton(
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/forget1');
          },
          iconSize: 89 * SizeConfig.scaleY,
          icon: Image.asset('assets/images/btn_back.png'),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
    );
  }
}
