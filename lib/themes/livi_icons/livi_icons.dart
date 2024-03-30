import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LiviIcons {
  static const String svgPath = 'assets/svg';
  static const String imagesPath = 'assets/images';

  Widget get liviPod => SvgPicture.asset(
        '$svgPath/livipod.svg',
      );

  Widget get liviPodImage => Image.asset(
        '$imagesPath/livipod.png',
      );
  Widget get logo => SvgPicture.asset(
        '$svgPath/logo.svg',
      );
}
