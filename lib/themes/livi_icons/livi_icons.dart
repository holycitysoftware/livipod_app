import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../livi_themes.dart';

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

  Widget get alarmAdd => SvgPicture.asset(
        '$svgPath/alarm_add.svg',
      );

  Widget get capsule => SvgPicture.asset(
        '$svgPath/capsule.svg',
      );
  Widget get dotsHorizontal => SvgPicture.asset(
        '$svgPath/dots_horizontal.svg',
      );
  Widget get drops => SvgPicture.asset(
        '$svgPath/drops.svg',
      );
  Widget get home => SvgPicture.asset(
        '$svgPath/home.svg',
      );
  Widget get injection => SvgPicture.asset(
        '$svgPath/injection.svg',
      );
  Widget get leaderboard => SvgPicture.asset(
        '$svgPath/leaderboard.svg',
      );

  Widget get liquid => SvgPicture.asset(
        '$svgPath/liquid.svg',
      );

  Widget get patch => SvgPicture.asset(
        '$svgPath/patch.svg',
      );

  Widget get plus => SvgPicture.asset(
        '$svgPath/plus.svg',
      );

  Widget get searchLg => SvgPicture.asset(
        '$svgPath/search_lg.svg',
      );

  Widget get searchMd => SvgPicture.asset(
        '$svgPath/search_md.svg',
      );

  Widget get settings => SvgPicture.asset(
        '$svgPath/settings.svg',
      );

  Widget get tablet => SvgPicture.asset(
        '$svgPath/tablet.svg',
      );

  Widget get trash1 => SvgPicture.asset(
        '$svgPath/trash_01.svg',
      );

  Widget get arrowNarrowright => SvgPicture.asset(
        '$svgPath/arrow_narrow_right.svg',
        colorFilter:
            ColorFilter.mode(LiviThemes.colors.baseWhite, BlendMode.srcIn),
      );
  Widget get arrowNarrowrightGray => SvgPicture.asset(
        '$svgPath/arrow_narrow_right.svg',
        colorFilter:
            ColorFilter.mode(LiviThemes.colors.gray400, BlendMode.srcIn),
      );

  Widget get checkCircle => SvgPicture.asset(
        '$svgPath/check_circle.svg',
      );

  Widget get chevronLeft => SvgPicture.asset(
        '$svgPath/chevron_left.svg',
      );
  Widget get chevronDownGray => SvgPicture.asset('$svgPath/chevron_down.svg',
      colorFilter:
          ColorFilter.mode(LiviThemes.colors.gray400, BlendMode.srcIn));

  //Images
  Widget get liviPodImage => Image.asset(
        '$imagesPath/livipod.png',
      );

  AssetImage get splashBackgroundImage =>
      AssetImage('$imagesPath/splash_background.png');
}
