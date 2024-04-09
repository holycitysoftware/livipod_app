import 'package:flutter/material.dart';

import '../../components/components.dart';
import '../../themes/livi_spacing/livi_spacing.dart';
import '../../themes/livi_themes.dart';
import '../../utils/strings.dart';

class CreateAccountPage extends StatefulWidget {
  const CreateAccountPage({super.key});
  @override
  _CreateAccountPageState createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  bool _agreedToTOS = false;

  void _setAgreedToTOS(bool newValue) {
    setState(() {
      _agreedToTOS = newValue;
    });
  }

  Future<void> goToCreateAccountPage(BuildContext context) async {
    await Navigator.push(
        context, MaterialPageRoute(builder: (context) => CreateAccountPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LiviThemes.colors.baseWhite,
      resizeToAvoidBottomInset: true,
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: LiviFilledButton(
          showArrow: true,
          text: Strings.continueText,
          onTap: () {},
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          children: [
            LiviThemes.spacing.heightSpacer8(),
            BackBar(),
            LiviThemes.icons.logo,
            LiviThemes.spacing.heightSpacer16(),
            Align(
              child: LiviTextStyles.interSemiBold24(Strings.createAnAccount),
            ),
            LiviThemes.spacing.heightSpacer8(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: kSpacer_16),
              child: LiviTextStyles.interRegular16(
                Strings.afterCreatingYourAccount,
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: kSpacer_16),
            LiviInputField(
              padding: const EdgeInsets.symmetric(
                  horizontal: kSpacer_16, vertical: kSpacer_8),
              title: Strings.fullName,
              hint: Strings.steveJobsFullName,
              controller: fullNameController,
            ),
            LiviInputField(
              padding: const EdgeInsets.symmetric(
                  horizontal: kSpacer_16, vertical: kSpacer_8),
              title: Strings.email,
              subTitle: Strings.optional,
              hint: Strings.steveJobsEmail,
              controller: emailController,
            ),
            LiviInputField(
              padding: const EdgeInsets.symmetric(
                  horizontal: kSpacer_16, vertical: kSpacer_8),
              title: Strings.phoneNumber,
              subTitle: Strings.optional,
              hint: Strings.steveJobsNumber,
              controller: phoneNumberController,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Checkbox(
                    value: _agreedToTOS,
                    onChanged: (e) {},
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _setAgreedToTOS(!_agreedToTOS),
                      child: LiviTextStyles.interRegular16(
                        Strings.iHaveReadAndAgreeToThePrivacyPolicy,
                        textAlign: TextAlign.start,
                        maxLines: 3,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
