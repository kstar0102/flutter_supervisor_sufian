import 'package:flutter/widgets.dart';

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
