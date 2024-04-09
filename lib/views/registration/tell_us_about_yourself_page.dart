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
          LiviTextStyles.interRegular16(Strings.selectPersona),
          LiviTextStyles.interSemiBold16(Strings.assistedUsers),  
          LiviTextStyles.interRegular16(Strings.iMayRequireSomeLevelOf),
          LiviTextStyles.interRegular16(Strings.selectPersona),
      LiviTextStyles.interSemiBold16(Strings.caredForUsers),         
      LiviTextStyles.interRegular16(Strings.iRelyHeavily),
           LiviTextStyles.interRegular16(Strings.selectPersona), 
                   LiviTextStyles.interRegular16(Strings.notSure),       
            LiviTextStyles.interRegular16(Strings.letUsHelpYouFindOut),  
        ],
        
      ),
    );
  }
}
