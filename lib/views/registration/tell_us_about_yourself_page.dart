import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../components/components.dart';
import '../../components/widgets/bounding_card.dart';
import '../../components/widgets/icon_bounding_card.dart';
import '../../controllers/controllers.dart';
import '../../models/models.dart';
import '../../themes/livi_themes.dart';
import '../../utils/persona_page_info_list.dart';
import '../../utils/strings.dart';
import '../views.dart';

class TellUsAboutYourselfPage extends StatefulWidget {
  const TellUsAboutYourselfPage({
    super.key,
  });

  @override
  State<TellUsAboutYourselfPage> createState() =>
      _TellUsAboutYourselfPageState();
}

class _TellUsAboutYourselfPageState extends State<TellUsAboutYourselfPage> {
  void goToIdentifyPersonPage() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => IdentifyPersonaPage(
            personaPageInfo: personaPageInfoList.first,
          ),
        ),
      );
    });
  }

  void goToFinishRegistrationPage(AppUserType personaType) {
    Provider.of<AuthController>(context, listen: false)
        .setPersona(personaType: personaType);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => FinishRegistrationPage(),
        ),
      );
    });
  }

  Widget buildUserTypeCard({
    required String title,
    required String description,
    required AppUserType personaType,
  }) {
    return BoundingCard(
      key: Key(title),
      onTap: () => goToFinishRegistrationPage(personaType),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LiviTextStyles.interSemiBold16(title),
          LiviTextStyles.interRegular16(description),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).viewPadding.top,
              ),
              LiviThemes.spacing.heightSpacer16(),
              IconBoundingCard(
                child: LiviThemes.icons.messageChatCircleIcon(),
              ),
              LiviThemes.spacing.heightSpacer24(),
              LiviTextStyles.interSemiBold24(Strings.tellUsAboutYourself),
              LiviThemes.spacing.heightSpacer8(),
              LiviTextStyles.interRegular14(
                  Strings.yourVerificationCodeIsConfirmed),
              Spacer(),
              buildUserTypeCard(
                personaType: AppUserType.selfGuidedUser,
                title: Strings.selfGuidedUsers,
                description: Strings.iAmFullyIndependentAndCapable,
              ),
              LiviThemes.spacing.heightSpacer12(),
              buildUserTypeCard(
                personaType: AppUserType.assistedUser,
                title: Strings.assistedUsers,
                description: Strings.iMayRequireSomeLevelOf,
              ),
              LiviThemes.spacing.heightSpacer12(),
              buildUserTypeCard(
                personaType: AppUserType.caredForUser,
                title: Strings.caredForUsers,
                description: Strings.iRelyHeavily,
              ),
              Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: goToIdentifyPersonPage,
                    child: LiviTextStyles.interRegular16(
                      Strings.notSure,
                      textAlign: TextAlign.start,
                      maxLines: 3,
                    ),
                  ),
                  LiviThemes.spacing.widthSpacer4(),
                  GestureDetector(
                    onTap: goToIdentifyPersonPage,
                    child: LiviTextStyles.interSemiBold16(
                      Strings.letUsHelpYouFindOut,
                      color: LiviThemes.colors.brand600,
                      textAlign: TextAlign.start,
                      maxLines: 3,
                    ),
                  ),
                ],
              ),
              Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
