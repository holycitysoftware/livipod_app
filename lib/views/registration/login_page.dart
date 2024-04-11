import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/components.dart';
import '../../controllers/controllers.dart';
import '../../models/app_user.dart';
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
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  bool loading = false;
  late AppUser appUser;

  Future<void> goToCreateAccountPage(BuildContext context) async {
    await Navigator.push(
        context, MaterialPageRoute(builder: (context) => CreateAccountPage()));
  }

  Future<void> verifyPhoneNumber() async {
    await Provider.of<AuthController>(context, listen: false)
        .verifyPhoneNumber(phoneNumberController.text);
  }

  Future<void> verifyNumber() async {
    setState(() {
      loading = true;
    });
    appUser = AppUser(
      firstName: fullNameController.text,
      phoneNumber: phoneNumberController.text,
    );
    await verifyPhoneNumber();
  }

  Future<void> goToCheckSmsPge() async {
    if (loading) {
      loading = false;
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CheckSmsPage(
            appUser: appUser,
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    if (mounted) {
      Provider.of<AuthController>(context, listen: false)
          .clearVerificationError();
    }
    super.dispose();
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
          isCloseToNotch: true,
          isLoading: loading,
          text: Strings.logIn,
          onTap: verifyNumber,
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          children: [
            Consumer<AuthController>(
              builder: (context, authController, child) {
                if (authController.promptForUserCode &&
                    authController.firebaseAuthUser == null) {
                  if (mounted) {
                    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                      goToCheckSmsPge();
                    });
                  }
                }
                return SizedBox();
              },
            ),
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
            Consumer<AuthController>(builder: (context, authController, child) {
              return LiviInputField(
                padding: const EdgeInsets.symmetric(
                    horizontal: kSpacer_16, vertical: kSpacer_8),
                title: Strings.phoneNumber,
                errorText: authController.verificationError,
                hint: Strings.steveJobsNumber,
                controller: phoneNumberController,
              );
            }),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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
