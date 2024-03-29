import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../livi_themes.dart';

class LiviIcons {
  static const String svgPath = 'assets/svg';
  Widget get liviPod => SvgPicture.asset(
        '$svgPath/livipod.svg',
      );
}
