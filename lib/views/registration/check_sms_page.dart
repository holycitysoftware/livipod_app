import 'package:flutter/material.dart';

import '../../components/components.dart';
import '../../themes/livi_themes.dart';
import '../../utils/strings.dart';

class CheckSmsPage extends StatelessWidget {
  const CheckSmsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar:
          LiviFilledButton(text: Strings.verifyCode, onTap: () {}),
      body: Column(
        children: [
          LiviTextStyles.interSemiBold16(Strings.verification),
          const Spacer(),
          LiviTextStyles.interSemiBold24(Strings.checkYourSms),
          LiviTextStyles.interRegular16(Strings.weSentAVerificationCodeTo),
          Row(
            children: [
              LiviTextStyles.interRegular16(Strings.didntReceiveTheSMS),
              LiviTextStyles.interSemiBold16(Strings.clickToResend,
                  color: LiviThemes.colors.brand600),
            ],
          ),
        ],
      ),
    );
  }
}
