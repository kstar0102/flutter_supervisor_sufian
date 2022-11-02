import 'package:flutter/material.dart';

import 'package:alnabali_driver/src/widgets/constants.dart';
import 'package:alnabali_driver/src/widgets/custom_painter.dart';
import 'package:alnabali_driver/src/widgets/dialogs.dart';

class HomeAccountPage extends StatefulWidget {
  const HomeAccountPage({Key? key}) : super(key: key);

  @override
  State<HomeAccountPage> createState() => _HomeAccountPageState();
}

class _HomeAccountPageState extends State<HomeAccountPage> {
  Widget _buildSummaryInfo(int index, String value) {
    double iconHeight;
    String greyText;
    if (index == 0) {
      iconHeight = 34;
      greyText = 'Working Hours';
    } else if (index == 1) {
      iconHeight = 28;
      greyText = 'Total Distance';
    } else {
      iconHeight = 38;
      greyText = 'Total Trips';
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 14),
            height: iconHeight,
            child: Image.asset('assets/images/user_icon$index.png'),
          ),
          Text(
            value,
            style: const TextStyle(
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w600,
              fontSize: 18,
              color: kColorPrimaryBlue,
            ),
          ),
          Text(
            greyText,
            style: const TextStyle(
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w500,
              fontSize: 14,
              color: Color(0xFF808080),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    final btnStyle = ButtonStyle(
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
            side: const BorderSide(color: kColorPrimaryBlue)),
      ),
    );
    const btnTextStyle = TextStyle(
      fontFamily: 'Montserrat',
      fontWeight: FontWeight.w600,
      fontSize: 18,
      color: kColorPrimaryBlue,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 10),
          height: 192 * SizeConfig.scaleY,
          child: Image.asset('assets/images/home_icon.png'),
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
                    margin: EdgeInsets.only(top: 170 * SizeConfig.scaleY),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: kColorAvatarBorder, width: 1.0),
                    ),
                    child: CircleAvatar(
                      radius: 165 * SizeConfig.scaleY,
                      backgroundColor: Colors.transparent,
                      backgroundImage:
                          const AssetImage('assets/images/user_avatar.png'),
                    ),
                  ),
                  Flexible(child: SizedBox(height: 30 * SizeConfig.scaleY)),
                  const Text(
                    'Sufian Abu Alabban',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w500,
                      fontSize: 19,
                      color: kColorPrimaryBlue,
                    ),
                  ),
                  Flexible(child: SizedBox(height: 70 * SizeConfig.scaleY)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      _buildSummaryInfo(0, '10.2'),
                      _buildSummaryInfo(1, '30 KM'),
                      _buildSummaryInfo(2, '20'),
                    ],
                  ),
                  Flexible(
                      flex: 2,
                      child: SizedBox(height: 190 * SizeConfig.scaleY)),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/edit_profile');
                    },
                    style: btnStyle,
                    child: Container(
                      alignment: Alignment.center,
                      width: 300,
                      height: 52,
                      child: const Text('Edit Profile', style: btnTextStyle),
                    ),
                  ),
                  Flexible(child: SizedBox(height: 30 * SizeConfig.scaleY)),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/change_pwd');
                    },
                    style: btnStyle,
                    child: Container(
                      alignment: Alignment.center,
                      width: 300,
                      height: 52,
                      child: const Text('Reset Password', style: btnTextStyle),
                    ),
                  ),
                  Flexible(child: SizedBox(height: 30 * SizeConfig.scaleY)),
                  TextButton(
                    onPressed: () {},
                    style: btnStyle,
                    child: Container(
                      alignment: Alignment.center,
                      width: 300,
                      height: 52,
                      child: const Text('Call App Supervisor',
                          style: btnTextStyle),
                    ),
                  ),
                  Flexible(child: SizedBox(height: 110 * SizeConfig.scaleY)),
                  TextButton(
                    onPressed: () {
                      showLogoutDialog(context);
                    },
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(kColorPrimaryBlue),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100),
                            side: const BorderSide(color: kColorPrimaryBlue)),
                      ),
                    ),
                    child: Container(
                      alignment: Alignment.center,
                      width: 300,
                      height: 52,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(right: 18),
                            height: 24,
                            child: Image.asset(
                                'assets/images/user_icon_logout.png'),
                          ),
                          const Text(
                            'LOG OUT',
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Flexible(child: SizedBox(height: 80 * SizeConfig.scaleY)),
                  const Text(
                    'App Version 0100.0',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      color: kColorPrimaryBlue,
                    ),
                  ),
                  Flexible(
                      flex: 3,
                      child: SizedBox(height: 170 * SizeConfig.scaleY)),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
