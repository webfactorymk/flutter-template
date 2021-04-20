import 'package:flutter/cupertino.dart';

class ScreenSizeUtil {
  static bool isNarrow(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return screenSize.width <= 380;
  }
}
