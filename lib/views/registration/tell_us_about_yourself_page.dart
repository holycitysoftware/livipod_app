import 'package:flutter/material.dart';

import '../../components/components.dart';
import '../../themes/livi_themes.dart';
import '../../utils/strings.dart';

class TellUsAboutYourselfPage extends StatelessWidget {
  const TellUsAboutYourselfPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
              decoration: BoxDecoration(
                border: Border.all(color: LiviThemes.colors.gray200),
                borderRadius: BorderRadius.circular(12),
              ),
              child: LiviThemes.icons.checkCircle),
          LiviTextStyles.interSemiBold24(Strings.tellUsAboutYourself),
          LiviTextStyles.interRegular16(
              Strings.yourVerificationCodeIsConfirmed),
          LiviTextStyles.interSemiBold16(Strings.selfGuidedUsers),
          LiviTextStyles.interRegular16(Strings.iAmFullyIndependentAndCapable),
        ],
      ),
    );
  }
}
