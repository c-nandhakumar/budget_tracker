import 'package:flutter/widgets.dart';


///Used to get the size of the mobile device
///Useful for Responsiveness
class SizeConfig {
  static MediaQueryData? _mediaQueryData;
  static double? screenWidth;
  static double? screenHeight;
  static double? blockSizeHorizontal;
  static double? blockSizeVertical;

  static double? _safeAreaHorizontal;
  static double? _safeAreaVertical;
  static double? width;
  static double? height;
  static double? titleSize;

  void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData!.size.width;
    screenHeight = _mediaQueryData!.size.height;
    print(screenHeight);
    blockSizeHorizontal = screenWidth! / 100;
    blockSizeVertical = screenHeight! / 100;
    //Calculating the size of SafeArea
    _safeAreaHorizontal =
        _mediaQueryData!.padding.left + _mediaQueryData!.padding.right;
    _safeAreaVertical =
        _mediaQueryData!.padding.top + _mediaQueryData!.padding.bottom;

    //Difference between Total Size and Safe Area
    width = (screenWidth! - _safeAreaHorizontal!) / 100;
    height = (screenHeight! - _safeAreaVertical!) / 100;
    titleSize = width! * 10;
  }
}
