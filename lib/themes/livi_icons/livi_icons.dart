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

  String get _alarmClockIconPath => '$svgPath/alarm_clock.svg';

  Widget alarmClockIcon({
    Color? color,
    double? height,
  }) {
    color ??= LiviThemes.colors.brand600;

    return SvgPicture.asset(
      _alarmClockIconPath,
      colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
      height: height,
    );
  }

  String get _chevronUpIconPath => '$svgPath/chevron_up.svg';

  Widget chevronUpIcon({
    Color? color,
    double? height,
  }) {
    color ??= LiviThemes.colors.brand600;

    return SvgPicture.asset(
      _chevronUpIconPath,
      colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
      height: height,
    );
  }

  String get _heartHandIconPath => '$svgPath/heart_hand.svg';

  Widget heartHandIcon({
    Color? color,
    double? height,
  }) {
    color ??= LiviThemes.colors.brand600;

    return SvgPicture.asset(
      _heartHandIconPath,
      colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
      height: height,
    );
  }

  String get _moon1Path => '$svgPath/moon_01.svg';

  Widget moon1Icon({
    Color? color,
    double? height,
  }) {
    color ??= LiviThemes.colors.brand600;

    return SvgPicture.asset(
      _moon1Path,
      colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
      height: height,
    );
  }

  String get _rocket2Path => '$svgPath/rocket_02.svg';

  Widget rocket2Icon({
    Color? color,
    double? height,
  }) {
    color ??= LiviThemes.colors.brand600;

    return SvgPicture.asset(
      _rocket2Path,
      colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
      height: height,
    );
  }

  String get _sunSetting1Path => '$svgPath/sun_setting_01.svg';

  Widget sunSetting1Icon({
    Color? color,
    double? height,
  }) {
    color ??= LiviThemes.colors.brand600;

    return SvgPicture.asset(
      _sunSetting1Path,
      colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
      height: height,
    );
  }

  String get _sunPath => '$svgPath/sun.svg';

  Widget sunIcon({
    Color? color,
    double? height,
  }) {
    color ??= LiviThemes.colors.brand600;

    return SvgPicture.asset(
      _sunPath,
      colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
      height: height,
    );
  }

  String get _caregiverPath => '$svgPath/caregiver.svg';

  Widget caregiverIcon({
    Color? color,
    double? height,
  }) {
    return SvgPicture.asset(
      _caregiverPath,
      height: height,
    );
  }

  String get _devicesPath => '$svgPath/devices.svg';

  Widget devicesIcon({
    Color? color,
    double? height,
  }) {
    return SvgPicture.asset(
      _devicesPath,
      height: height,
    );
  }

  String get _schedulePath => '$svgPath/schedule.svg';

  Widget scheduleIcon({
    Color? color,
    double? height,
  }) {
    color ??= LiviThemes.colors.brand600;

    return SvgPicture.asset(
      _schedulePath,
      colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
      height: height,
    );
  }

  String get _smallLiviPodPath => '$svgPath/small_livi_pod.svg';

  Widget smallLiviPodIcon({
    Color? color,
    double? height,
  }) {
    return SvgPicture.asset(
      _smallLiviPodPath,
      height: height,
    );
  }

  String get _wifiPath => '$svgPath/wifi.svg';

  Widget wifiIcon({
    Color? color,
    double? height,
  }) {
    return SvgPicture.asset(
      _wifiPath,
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

  String get _chevronPath => '$svgPath/chevron_right.svg';

  Widget chevronRight({
    Color? color,
    double? height,
  }) {
    color ??= LiviThemes.colors.randomGray;

    return SvgPicture.asset(
      _chevronPath,
      colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
      height: height,
    );
  }

  String get _boxPath => '$svgPath/box.svg';

  Widget boxRight({
    Color? color,
    double? height,
  }) {
    color ??= LiviThemes.colors.randomGray;

    return SvgPicture.asset(
      _boxPath,
      colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
      height: height,
    );
  }

  String get _edit1Path => '$svgPath/edit_1.svg';

  Widget edit1Widget({
    Color? color,
    double? height,
  }) {
    color ??= LiviThemes.colors.randomGray;

    return SvgPicture.asset(
      _edit1Path,
      colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
      height: height,
    );
  }

  String get _minusPath => '$svgPath/minus.svg';

  Widget minusWidget({
    Color? color,
    double? height,
  }) {
    color ??= LiviThemes.colors.baseWhite;

    return SvgPicture.asset(
      _minusPath,
      colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
      height: height,
    );
  }

  String get _pencilPath => '$svgPath/pencil.svg';

  Widget pencilWidget({
    Color? color,
    double? height,
  }) {
    color ??= LiviThemes.colors.randomGray;

    return SvgPicture.asset(
      _pencilPath,
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

  String get _injectionPath => '$svgPath/injection.svg';

  Widget injectionIcon({
    Color? color,
    double? height,
  }) {
    color ??= LiviThemes.colors.randomGray;

    return SvgPicture.asset(
      _injectionPath,
      colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
      height: height,
    );
  }

  String get _calendarPath => '$svgPath/calendar.svg';

  Widget calendarIcon({
    Color? color,
    double? height,
  }) {
    // color ??= LiviThemes.colors.randomGray;

    return SvgPicture.asset(
      _calendarPath,
      // colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
      height: height,
    );
  }

  String get _capsulePath => '$svgPath/capsule.svg';

  Widget capsuleIcon({
    Color? color,
    double? height,
  }) {
    return SvgPicture.asset(
      _capsulePath,
      colorFilter:
          color != null ? ColorFilter.mode(color, BlendMode.srcIn) : null,
      height: height,
    );
  }

  String get _tabletPath => '$svgPath/tablet.svg';

  Widget tabletIcon({
    Color? color,
    double? height,
  }) {
    // color ??= LiviThemes.colors.randomGray;

    return SvgPicture.asset(
      _tabletPath,
      colorFilter:
          color != null ? ColorFilter.mode(color, BlendMode.srcIn) : null,
      height: height,
    );
  }

  String get _dropsPath => '$svgPath/drops.svg';

  Widget dropsIcon({
    Color? color,
    double? height,
  }) {
    // color ??= LiviThemes.colors.randomGray;

    return SvgPicture.asset(
      _dropsPath,
      colorFilter:
          color != null ? ColorFilter.mode(color, BlendMode.srcIn) : null,
      height: height,
    );
  }

  String get _liquidPath => '$svgPath/liquid.svg';

  Widget liquidIcon({
    Color? color,
    double? height,
  }) {
    // color ??= LiviThemes.colors.randomGray;

    return SvgPicture.asset(
      _liquidPath,
      colorFilter:
          color != null ? ColorFilter.mode(color, BlendMode.srcIn) : null,
      height: height,
    );
  }

  String get _patchPath => '$svgPath/patch.svg';

  Widget patchIcon({
    Color? color,
    double? height,
  }) {
    // color ??= LiviThemes.colors.randomGray;

    return SvgPicture.asset(
      _patchPath,
      colorFilter:
          color != null ? ColorFilter.mode(color, BlendMode.srcIn) : null,
      height: height,
    );
  }

  String get _otherDotsHorizontalPath => '$svgPath/dots_horizontal.svg';

  Widget otherDotsHorizontalIcon({
    Color? color,
    double? height,
  }) {
    // color ??= LiviThemes.colors.randomGray;

    return SvgPicture.asset(
      _otherDotsHorizontalPath,
      colorFilter:
          color != null ? ColorFilter.mode(color, BlendMode.srcIn) : null,
      height: height,
    );
  }

  String get _ointmentPath => '$svgPath/ointment.svg';

  Widget ointmentIcon({
    Color? color,
    double? height,
  }) {
    // color ??= LiviThemes.colors.randomGray;

    return SvgPicture.asset(
      _ointmentPath,
      colorFilter:
          color != null ? ColorFilter.mode(color, BlendMode.srcIn) : null,
      height: height,
    );
  }

  String get _trash1Icon => '$svgPath/trash_01.svg';

  Widget trash1Icon({
    Color? color,
    double? height,
  }) {
    // color ??= LiviThemes.colors.randomGray;

    return SvgPicture.asset(
      _trash1Icon,
      colorFilter:
          color != null ? ColorFilter.mode(color, BlendMode.srcIn) : null,
      height: height,
    );
  }

  String get _closeIcon => '$svgPath/close.svg';

  Widget closeIcon({
    Color? color,
    double? height,
  }) {
    // color ??= LiviThemes.colors.randomGray;

    return SvgPicture.asset(
      _closeIcon,
      colorFilter:
          color != null ? ColorFilter.mode(color, BlendMode.srcIn) : null,
      height: height,
    );
  }

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
