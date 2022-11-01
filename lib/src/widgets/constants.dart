import 'package:flutter/material.dart';

// *
// * main colors used in app.
// *

const Color kColorPrimaryBlue = Color(0xFF0055A6);
const Color kColorPrimaryGrey = Color(0xFF808080);
const Color kColorSecondaryGrey = Color(0xFF4E4E4E);
const Color kColorAvatarBorder = Color(0xFFADB4BA);

// *
// * configuration for device screen.
// *

class SizeConfig {
  static double screenW = 0;
  static double screenH = 0;
  static double scaleX = 1;
  static double scaleY = 1;

  void init(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    screenW = screenSize.width;
    screenH = screenSize.height;

    const designSize = Size(1125, 2436);
    scaleX = screenW / designSize.width;
    scaleY = screenH / designSize.height;
  }
}
