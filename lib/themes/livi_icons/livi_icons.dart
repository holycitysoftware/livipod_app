import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../livi_themes.dart';

class LiviIcons {
  static const String svgPath = 'assets/svg';
  static const String imagesPath = 'assets/images';

  Widget get liviPod => SvgPicture.asset(
        '$svgPath/livipod.svg',
      );

//TODO:Remove this
  Widget get logo => SvgPicture.asset(
        '$svgPath/logo.svg',
      );

  String get _blueBackGroundLogoPath => '$svgPath/blue_background_logo.svg';

  String get _checkIconPath => '$svgPath/check.svg';

  Widget checkIcon({
    Color? color,
    double? height,
  }) {
    color ??= LiviThemes.colors.brand600;

    return SvgPicture.asset(
      _checkIconPath,
      colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
      height: height,
    );
  }

  Widget blueBackgroundLogo({
    Color? color,
    double? height,
  }) {
    color ??= LiviThemes.colors.randomGray;

    return SvgPicture.asset(
      _blueBackGroundLogoPath,
      colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
      height: height,
    );
  }

  String get _whiteBackGroundLogoPath => '$svgPath/white_background_logo.svg';

  Widget whiteBackgroundLogo({
    Color? color,
    double? height,
  }) {
    color ??= LiviThemes.colors.randomGray;

    return SvgPicture.asset(
      _whiteBackGroundLogoPath,
      colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
      height: height,
    );
  }

  Widget get logoWhite => SvgPicture.asset(
        '$svgPath/logo_white.svg',
      );

  Widget get livipodText => SvgPicture.asset(
        '$svgPath/livipod_text.svg',
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

  Widget get injection => SvgPicture.asset(
        '$svgPath/injection.svg',
      );

  Widget get liquid => SvgPicture.asset(
        '$svgPath/liquid.svg',
      );

  Widget get patch => SvgPicture.asset(
        '$svgPath/patch.svg',
      );

  final String _messageChatCirclePath = '$svgPath/message_chat_circle.svg';

  Widget messageChatCircleIcon({
    Color? color,
    double? height,
  }) {
    color ??= LiviThemes.colors.brand600;

    return SvgPicture.asset(
      _messageChatCirclePath,
      colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
      height: height,
    );
  }

  final String _plusPath = '$svgPath/plus.svg';

  Widget plusIcon({
    Color? color,
    double? height,
  }) {
    color ??= LiviThemes.colors.brand600;

    return SvgPicture.asset(
      _plusPath,
      colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
      height: height,
    );
  }

  String get _searchLgPath => '$svgPath/search_lg.svg';

  Widget searchLgIcon({
    Color? color,
    double? height,
  }) {
    color ??= LiviThemes.colors.randomGray;

    return SvgPicture.asset(
      _searchLgPath,
      colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
      height: height,
    );
  }

  String get _searchMdPath => '$svgPath/search_md.svg';

  Widget searchMdIcon({
    Color? color,
    double? height,
  }) {
    color ??= LiviThemes.colors.randomGray;

    return SvgPicture.asset(
      _searchMdPath,
      colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
      height: height,
    );
  }

  String get _settingsPath => '$svgPath/settings.svg';

  Widget settingsIcon({
    Color? color,
    double? height,
  }) {
    color ??= LiviThemes.colors.randomGray;

    return SvgPicture.asset(
      _settingsPath,
      colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
      height: height,
    );
  }

  String get _leaderboardPath => '$svgPath/leaderboard.svg';

  Widget leaderboardIcon({
    Color? color,
    double? height,
  }) {
    color ??= LiviThemes.colors.randomGray;

    return SvgPicture.asset(
      _leaderboardPath,
      colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
      height: height,
    );
  }

  String get _alarmAddPath => '$svgPath/alarm_add.svg';

  Widget alarmAddIcon({
    Color? color,
    double? height,
  }) {
    color ??= LiviThemes.colors.randomGray;

    return SvgPicture.asset(
      _alarmAddPath,
      colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
      height: height,
    );
  }

  String get _homePath => '$svgPath/home.svg';

  Widget homeIcon({
    Color? color,
    double? height,
  }) {
    color ??= LiviThemes.colors.randomGray;

    return SvgPicture.asset(
      _homePath,
      colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
      height: height,
    );
  }

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
