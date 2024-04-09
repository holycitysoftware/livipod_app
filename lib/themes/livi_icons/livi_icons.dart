import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LiviIcons {
  static const String svgPath = 'assets/svg';
  static const String imagesPath = 'assets/images';

  Widget get liviPod => SvgPicture.asset(
        '$svgPath/livipod.svg',
      );

  Widget get logo => SvgPicture.asset(
        '$svgPath/logo.svg',
      );

  Widget get logoWhite => SvgPicture.asset(
        '$svgPath/logo_white.svg',
      );

  Widget get livipodText => SvgPicture.asset(
        '$svgPath/livipod_text.svg',
      );

  Widget get checkCircle => SvgPicture.asset(
        '$svgPath/check_circle.svg',
      );

  Widget get chevronLeft => SvgPicture.asset(
        '$svgPath/chevron_left.svg',
      );

  //Images
  Widget get liviPodImage => Image.asset(
        '$imagesPath/livipod.png',
      );

  AssetImage get splashBackgroundImage =>
      AssetImage('$imagesPath/splash_background.png');
}
