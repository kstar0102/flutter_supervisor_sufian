import 'package:flutter/material.dart';

import 'package:alnabali_driver/src/widgets/constants.dart';
import 'package:alnabali_driver/src/widgets/custom_painter.dart';
import 'package:alnabali_driver/src/widgets/profile_textfield.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({Key? key}) : super(key: key);

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    final spacer = Flexible(child: SizedBox(height: 28 * SizeConfig.scaleY));

    return Scaffold(
      body: Container(
        width: SizeConfig.screenW,
        height: SizeConfig.screenH,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/bg_normal.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.symmetric(vertical: 90 * SizeConfig.scaleY),
              child: const Text(
                'CHANGE PASSWORD',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w800,
                  fontSize: 19,
                  color: Colors.white,
                ),
              ),
            ),
            Expanded(
              child: Stack(
                alignment: AlignmentDirectional.topCenter,
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 170 * SizeConfig.scaleY),
                    child: SizedBox.expand(
                      child: CustomPaint(painter: AccountBgPainter()),
                    ),
                  ),
                  Column(
                    children: [
                      Container(
                        height: 192 * SizeConfig.scaleY,
                        margin: EdgeInsets.only(top: 50 * SizeConfig.scaleY),
                        child: Image.asset('assets/images/home_icon.png'),
                      ),
                      Flexible(
                          child: SizedBox(height: 660 * SizeConfig.scaleY)),
                      const ProfileTextField(
                          txtFieldType: ProfileTextFieldType.currPassword),
                      spacer,
                      const ProfileTextField(
                          txtFieldType: ProfileTextFieldType.newPassword),
                      spacer,
                      const ProfileTextField(
                          txtFieldType: ProfileTextFieldType.confirmPassword),
                      Flexible(
                          child: SizedBox(height: 260 * SizeConfig.scaleY)),
                      SizedBox(
                        width: 685 * SizeConfig.scaleX,
                        height: 120 * SizeConfig.scaleY,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: kColorPrimaryBlue,
                            shape: const StadiumBorder(),
                          ),
                          child: const Text(
                            'SAVE',
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w700,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                      //const Expanded(child: SizedBox(height: double.infinity)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          iconSize: 89 * SizeConfig.scaleY,
          icon: Image.asset('assets/images/btn_back.png'),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
    );
  }
}
