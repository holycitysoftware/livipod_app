import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/components.dart';
import '../../controllers/controllers.dart';
import '../../models/models.dart';
import '../../themes/livi_spacing/livi_spacing.dart';
import '../../themes/livi_themes.dart';
import '../../utils/countries.dart';
import '../../utils/strings.dart';

class CreateAccountPage extends StatefulWidget {
  const CreateAccountPage({super.key});
  @override
  _CreateAccountPageState createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController fullNameController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final FocusNode fullNameFocus = FocusNode();
  final FocusNode emailFocus = FocusNode();
  final FocusNode phoneFocus = FocusNode();
  bool navigateToCheckSmsPage = false;
  bool agreedToTOS = false;
  Country country = getUS();

  @override
  void initState() {
    setFocusListeners();
    fullNameController.addListener(() {
      setState(() {});
    });
    phoneNumberController.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  void setFocusListeners() {
    fullNameFocus.addListener(animateFieldsToCenter);
    emailFocus.addListener(animateFieldsToCenter);
    phoneFocus.addListener(animateFieldsToCenter);
  }

  void animateFieldsToCenter() {
    if (emailFocus.hasFocus || phoneFocus.hasFocus || fullNameFocus.hasFocus) {
      Future.delayed(Duration(milliseconds: 350), () {
        if (scrollController.hasClients) {
          scrollController.animateTo(scrollController.position.maxScrollExtent,
              duration: Duration(milliseconds: 100), curve: Curves.bounceIn);
        }
      });
    }
  }

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
        .verifyPhoneNumber(country.dialCode + phoneNumberController.text);
  }

  void setAppUser() {
    Provider.of<AuthController>(context, listen: false).setAppUser(
        fullNameController: fullNameController.text,
        emailController: emailController.text,
        phoneNumberController: phoneNumberController.text);
  }

//  Future<String> getTimeZone() async{
// return await FlutterNativeTimezone.getLocal();
//   }

  Future<void> verifyNumber() async {
    setAppUser();
    await verifyPhoneNumber();
  }

  // Future<void> goToCheckSmsPge() async {
  //   loading = false;
  //   navigateToCheckSmsPage = true;
  //   await Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //       builder: (context) => CheckSmsPage(
  //         appUser: appUser,
  //       ),
  //     ),
  //   );
  // }

  @override
  void dispose() {
    super.dispose();
  }

  String getCountryDescription(String country) {
    const int maxLength = 24;
    if (country.length > maxLength) {
      return country.substring(0, maxLength);
    }
    return country;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (didPop) {
        if (mounted) {
          Provider.of<AuthController>(context, listen: false)
              .clearVerificationError();
        }
      },
      child: Scaffold(
        backgroundColor: LiviThemes.colors.baseWhite,
        resizeToAvoidBottomInset: true,
        bottomNavigationBar: Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Consumer<AuthController>(
                builder: (context, authController, child) {
              return LiviFilledButton(
                showArrow: true,
                enabled: fullNameController.text.isNotEmpty &&
                    agreedToTOS &&
                    phoneNumberController.text.isNotEmpty,
                text: Strings.continueText,
                isLoading: authController.loading,
                isCloseToNotch: true,
                onTap: verifyNumber,
              );
            }),
          ),
        ),
        body: Form(
          key: formKey,
          child: SingleChildScrollView(
            controller: scrollController,
            child: Column(
              children: [
                BackBar(),
                LiviThemes.icons.logo,
                LiviThemes.spacing.heightSpacer16(),
                Align(
                  child:
                      LiviTextStyles.interSemiBold24(Strings.createAnAccount),
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
                  focusNode: fullNameFocus,
                  padding: const EdgeInsets.symmetric(
                      horizontal: kSpacer_16, vertical: kSpacer_8),
                  title: Strings.fullName,
                  textCapitalization: TextCapitalization.words,
                  hint: Strings.steveJobsFullName,
                  controller: fullNameController,
                ),
                LiviInputField(
                  focusNode: emailFocus,
                  padding: const EdgeInsets.symmetric(
                      horizontal: kSpacer_16, vertical: kSpacer_8),
                  title: Strings.email,
                  subTitle: Strings.optional,
                  hint: Strings.steveJobsEmail,
                  controller: emailController,
                ),
                Consumer<AuthController>(
                    builder: (context, authController, child) {
                  return LiviInputField(
                    padding: const EdgeInsets.symmetric(
                        horizontal: kSpacer_16, vertical: kSpacer_8),
                    title: Strings.phoneNumber,
                    controller: phoneNumberController,
                    focusNode: phoneFocus,
                    errorText: authController.verificationError.isEmpty
                        ? null
                        : authController.verificationError,
                    prefix: CountryDropdownButton(
                      country: country,
                      onChanged: (Country? value) {
                        setState(() {
                          country = value!;
                        });
                      },
                    ),
                    hint: Strings.steveJobsNumber,
                  );
                }),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Checkbox(
                          activeColor: LiviThemes.colors.brand600,
                          value: agreedToTOS,
                          onChanged: (e) => _setAgreedToTOS(!agreedToTOS)),
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
      ),
    );
  }
}
