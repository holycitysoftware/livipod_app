import 'package:flutter/material.dart';

import '../../components/components.dart';
import '../../themes/livi_spacing/livi_spacing.dart';
import '../../themes/livi_themes.dart';
import '../../utils/strings.dart';
import '../views.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final TextEditingController fullNameController = TextEditingController();
    final TextEditingController phoneNumberController = TextEditingController();

    Future<void> goToCreateAccountPage(BuildContext context) async {
      await Navigator.push(context,
          MaterialPageRoute(builder: (context) => CreateAccountPage()));
    }

    Future<void> login(BuildContext context) async {
      //  Provider.of<AuthController>(context,listen: false).
    }

    return Scaffold(
      backgroundColor: LiviThemes.colors.baseWhite,
      resizeToAvoidBottomInset: true,
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: LiviFilledButton(
          showArrow: true,
          text: Strings.logIn,
          onTap: () {},
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          children: [
            LiviThemes.spacing.heightSpacer8(),
            LiviThemes.icons.logo,
            LiviThemes.spacing.heightSpacer16(),
            Align(
              child: LiviTextStyles.interSemiBold24(Strings.loginToYourAccount),
            ),
            LiviThemes.spacing.heightSpacer4(),
            Align(
              child: LiviTextStyles.interRegular16(
                  Strings.welcomeBackPleaseEnterDetails),
            ),
            LiviThemes.spacing.heightSpacer8(),
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
              title: Strings.phoneNumber,
              subTitle: Strings.optional,
              hint: Strings.steveJobsNumber,
              controller: phoneNumberController,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () => goToCreateAccountPage(context),
                    child: LiviTextStyles.interRegular16(
                      Strings.dontHaveAnAccount,
                      textAlign: TextAlign.start,
                      maxLines: 3,
                    ),
                  ),
                  LiviThemes.spacing.widthSpacer4(),
                  GestureDetector(
                    onTap: () => goToCreateAccountPage(context),
                    child: LiviTextStyles.interSemiBold16(
                      Strings.signUp,
                      color: LiviThemes.colors.brand600,
                      textAlign: TextAlign.start,
                      maxLines: 3,
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
