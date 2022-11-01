import 'package:flutter/material.dart';

import 'package:alnabali_driver/src/widgets/constants.dart';
import 'package:alnabali_driver/src/widgets/gradient_button.dart';

Widget _buildDialogTitle(String companyName, String tripName) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Text(
        companyName,
        style: const TextStyle(
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.w700,
          fontSize: 19,
          color: Color(0xFF333333),
        ),
      ),
      Text(
        tripName,
        style: const TextStyle(
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.w500,
          fontSize: 15,
          color: kColorPrimaryGrey,
        ),
      ),
    ],
  );
}

///
/// Trip Accept/Finish Okay Dialog
///

Future<void> showOkayDialog(
  BuildContext context,
  String companyName,
  String tripName,
  int tripNo,
  bool isAccept,
) {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      SizeConfig().init(context);

      final btnW = 268 * SizeConfig.scaleX;
      final btnH = btnW * 0.26;
      String title = '';
      if (isAccept) {
        title = 'You have accepted trip # $tripNo';
      } else {
        title = 'You have finished trip # $tripNo';
      }

      return AlertDialog(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(18))),
        titlePadding: const EdgeInsets.only(top: 36),
        title: _buildDialogTitle(companyName, tripName),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 38, vertical: 30),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 30),
              height: 150 * SizeConfig.scaleY,
              child: Image.asset('assets/images/icon_dialog.png'),
            ),
            SizedBox(
              width: 660 * SizeConfig.scaleX,
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w600,
                  fontSize: 17,
                  color: kColorPrimaryBlue,
                ),
              ),
            ),
          ],
        ),
        actionsAlignment: MainAxisAlignment.center,
        actionsPadding: const EdgeInsets.only(bottom: 24),
        actions: <Widget>[
          SizedBox(
            width: btnW,
            height: btnH,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: kColorPrimaryBlue,
                shape: const StadiumBorder(),
              ),
              child: const Text(
                'OKAY',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w700,
                  fontSize: 10,
                ),
              ),
            ),
          ),
        ],
      );
    },
  );
}

///
/// Trip Accept Dialog
///

Future<bool?> showAcceptFinishDialog(
  BuildContext context,
  String companyName,
  String tripName,
  int tripNo,
  bool isAccept,
) async {
  return showDialog<bool>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      SizeConfig().init(context);

      final btnW = 268 * SizeConfig.scaleX;
      final btnH = btnW * 0.26;
      String title = '';
      if (isAccept) {
        title = 'Are you sure you want to accept the trip # $tripNo ?';
      } else {
        title = 'Are you sure you want to finish the trip # $tripNo ?';
      }

      return AlertDialog(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(18))),
        titlePadding: const EdgeInsets.only(top: 36),
        title: _buildDialogTitle(companyName, tripName),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 38, vertical: 30),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 30),
              height: 150 * SizeConfig.scaleY,
              child: Image.asset('assets/images/icon_dialog.png'),
            ),
            SizedBox(
              width: 660 * SizeConfig.scaleX,
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w600,
                  fontSize: 17,
                  color: kColorPrimaryBlue,
                ),
              ),
            ),
          ],
        ),
        actionsAlignment: MainAxisAlignment.center,
        actionsPadding: const EdgeInsets.only(bottom: 24),
        buttonPadding: const EdgeInsets.symmetric(horizontal: 3),
        actions: <Widget>[
          SizedBox(
            width: btnW,
            height: btnH,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: kColorPrimaryBlue,
                shape: const StadiumBorder(),
              ),
              child: const Text(
                'YES',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w700,
                  fontSize: 10,
                ),
              ),
            ),
          ),
          GradientButton(
            width: btnW,
            height: btnH,
            onPressed: () {
              Navigator.pop(context, false);
            },
            title: 'NO',
          ),
        ],
      );
    },
  );
}

///
/// Trip Reject Dialog
///

Future<String?> showRejectDialog(
  BuildContext context,
  String companyName,
  String tripName,
  int tripNo,
) async {
  return showDialog<String>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      SizeConfig().init(context);

      final btnW = 268 * SizeConfig.scaleX;
      final btnH = btnW * 0.26;

      return AlertDialog(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(18))),
        titlePadding: const EdgeInsets.only(top: 36),
        title: _buildDialogTitle(companyName, tripName),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 38, vertical: 10),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 30),
              height: 150 * SizeConfig.scaleY,
              child: Image.asset('assets/images/icon_dialog.png'),
            ),
            SizedBox(
              width: 660 * SizeConfig.scaleX,
              child: Text(
                'You have rejected trip # $tripNo',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w600,
                  fontSize: 17,
                  color: kColorPrimaryBlue,
                ),
              ),
            ),
            const Text(
              'Please fill the reason for rejection!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w400,
                fontSize: 11,
                color: kColorPrimaryGrey,
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 6),
              child: TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: kColorAvatarBorder)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: kColorPrimaryBlue)),
                ),
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w500,
                  fontSize: 13,
                  color: kColorPrimaryGrey,
                ),
                maxLines: 3,
                cursorColor: kColorPrimaryBlue,
              ),
            ),
          ],
        ),
        actionsAlignment: MainAxisAlignment.center,
        actionsPadding: const EdgeInsets.only(bottom: 24),
        actions: <Widget>[
          SizedBox(
            width: btnW,
            height: btnH,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: kColorPrimaryBlue,
                shape: const StadiumBorder(),
              ),
              child: const Text(
                'OKAY',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w700,
                  fontSize: 10,
                ),
              ),
            ),
          ),
        ],
      );
    },
  );
}

///
/// Trip Logout Dialog
///

Future<void> showLogoutDialog(BuildContext context) {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      SizeConfig().init(context);

      final btnW = 268 * SizeConfig.scaleX;
      final btnH = btnW * 0.26;

      return AlertDialog(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(18))),
        titlePadding: const EdgeInsets.only(top: 36),
        title: const Align(
          child: Text(
            'Log Out',
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w700,
              fontSize: 19,
              color: Color(0xFF333333),
            ),
          ),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 38, vertical: 20),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 30),
              height: 150 * SizeConfig.scaleY,
              child: Image.asset('assets/images/icon_dialog.png'),
            ),
            SizedBox(
              width: 680 * SizeConfig.scaleX,
              child: const Text(
                'Are you sure you want to logout ?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w600,
                  fontSize: 17,
                  color: kColorPrimaryBlue,
                ),
              ),
            ),
          ],
        ),
        actionsAlignment: MainAxisAlignment.center,
        actionsPadding: const EdgeInsets.symmetric(vertical: 30),
        buttonPadding: const EdgeInsets.symmetric(horizontal: 3),
        actions: <Widget>[
          SizedBox(
            width: btnW,
            height: btnH,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: kColorPrimaryBlue,
                shape: const StadiumBorder(),
              ),
              child: const Text(
                'YES',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w700,
                  fontSize: 10,
                ),
              ),
            ),
          ),
          GradientButton(
            width: btnW,
            height: btnH,
            onPressed: () {
              Navigator.pop(context, false);
            },
            title: 'NO',
          ),
        ],
      );
    },
  );
}
