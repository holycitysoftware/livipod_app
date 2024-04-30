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
import 'identify_persona_page.dart';

class TellUsAboutYourselfPage extends StatefulWidget {
  static const String routeName = '/tell-us-about-yourself-page';
  const TellUsAboutYourselfPage({
    super.key,
  });

  @override
  State<TellUsAboutYourselfPage> createState() =>
      _TellUsAboutYourselfPageState();
}

class _TellUsAboutYourselfPageState extends State<TellUsAboutYourselfPage> {
  void goToIdentifyPersonPage() {
    Navigator.pushNamed(
      context,
      IdentifyPersonaPage.routeName,
      arguments: IdentifyPersonaPageArguments(
        personaPageInfo: personaPageInfoList.first,
        key: Key('identify-persona-page'),
      ),
    );
  }

  Future<void> goToFinishRegistrationPage(AppUserType personaType) async {
    await Provider.of<AuthController>(context, listen: false)
        .setPersona(personaType: personaType);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => FinishRegistrationPage(),
      ),
    );
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
        backgroundColor: LiviThemes.colors.baseWhite,
        bottomNavigationBar: Padding(
          padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewPadding.bottom + 16),
          child: Row(
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
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SingleChildScrollView(
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
                LiviThemes.spacing.heightSpacer16(),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
