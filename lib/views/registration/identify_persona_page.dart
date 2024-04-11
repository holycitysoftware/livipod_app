import 'package:flutter/material.dart';

import '../../components/components.dart';
import '../../utils/strings.dart';

class IdentifyPersonaPage extends StatelessWidget {
  const IdentifyPersonaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          LiviTextStyles.interMedium24(Strings.howOftenDoYouNeedAssistance),
          LiviTextStyles.interRegular16(Strings.selectTheMostAccurateAnswer),
        ],
      ),
    );
  }
}
