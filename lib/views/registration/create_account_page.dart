import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/components.dart';
import '../../controllers/controllers.dart';
import '../../models/app_user.dart';
import '../../themes/livi_spacing/livi_spacing.dart';
import '../../themes/livi_themes.dart';
import '../../utils/strings.dart';
import '../views.dart';

class CreateAccountPage extends StatefulWidget {
  const CreateAccountPage({super.key});
  @override
  _CreateAccountPageState createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  bool agreedToTOS = false;
  bool loading = false;
  late AppUser appUser;

  void _setAgreedToTOS(bool newValue) {
    setState(() {
      agreedToTOS = newValue;
    });
  }

  Future<void> goToCreateAccountPage(BuildContext context) async {
    await Navigator.push(
        context, MaterialPageRoute(builder: (context) => CreateAccountPage()));
  }

  Future<void> verifyPhoneNumber() async {
    await Provider.of<AuthController>(context, listen: false)
        .verifyPhoneNumber(phoneNumberController.text);
  }

//  Future<String> getTimeZone() async{
// return await FlutterNativeTimezone.getLocal();
//   }

  Future<void> verifyNumber() async {
    setState(() {
      loading = true;
    });
    appUser = AppUser(
      firstName: fullNameController.text,
      useEmail: emailController.text.isNotEmpty,
      email: emailController.text,
      phoneNumber: phoneNumberController.text,
    );
    await verifyPhoneNumber();
  }

  Future<void> goToCheckSmsPge() async {
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
          isLoading: loading,
          isCloseToNotch: true,
          onTap: verifyNumber,
        ),
      ),
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              BackBar(),
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
                hint: Strings.steveJobsNumber,
                controller: phoneNumberController,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Checkbox(
                      value: agreedToTOS,
                      onChanged: (e) {
                        setState(() {
                          agreedToTOS = !(e ?? false);
                        });
                      },
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => _setAgreedToTOS(!agreedToTOS),
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
      ),
    );
  }
}
