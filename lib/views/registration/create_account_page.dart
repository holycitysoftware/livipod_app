import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';

import '../../components/components.dart';
import '../../controllers/controllers.dart';
import '../../models/models.dart';
import '../../themes/livi_spacing/livi_spacing.dart';
import '../../themes/livi_themes.dart';
import '../../utils/countries.dart';
import '../../utils/string_ext.dart';
import '../../utils/strings.dart';
import '../../utils/utils.dart';
import 'login_page.dart';
import 'privacy_policy_page.dart';
import 'terms_of_service_page.dart';
import 'welcome_page.dart';

class CreateAccountPage extends StatefulWidget {
  static const String routeName = '/create-account-page';
  final AppUser? appUser;
  const CreateAccountPage({
    super.key,
    this.appUser,
  });
  @override
  _CreateAccountPageState createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final FocusNode fullNameFocus = FocusNode();
  final FocusNode emailFocus = FocusNode();
  final FocusNode phoneFocus = FocusNode();
  bool navigateToCheckSmsPage = false;
  bool agreedToTOS = false;
  Country country = getUS();
  String buildNumber = '';

  @override
  void initState() {
    fullNameController.addListener(() {
      setState(() {});
    });
    phoneNumberController.addListener(() {
      setState(() {});
    });
    getBuildNumber();
    fillForms();
    super.initState();
  }

  Future<void> getCountry() async {
    if (widget.appUser!.phoneNumber.isEmpty) {
      return;
    }
    final number = await PhoneNumber.getRegionInfoFromPhoneNumber(
        widget.appUser!.phoneNumber);
    if (number != null) {
      final String parsableNumber = number.dialCode ?? '';
      country = getCountryByCode('+$parsableNumber');

      if (number != null && number.phoneNumber != null) {
        phoneNumberController.text = parseNumber(number.phoneNumber!, country);
      }
      setState(() {});
    }
  }

  void fillForms() {
    if (widget.appUser != null) {
      getCountry();
      fullNameController.text = widget.appUser!.name;
      emailController.text = widget.appUser!.email ?? '';
    }
  }

  Future<void> getBuildNumber() async {
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();
    buildNumber = '${packageInfo.version}+${packageInfo.buildNumber}';
    setState(() {});
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

  Future<void> verifyPhoneNumber(AuthController controller) async {
    await controller.verifyPhoneNumber(
        country.dialCode + phoneNumberController.text,
        isAccountCreation: true);
  }

  Future<void> setAppUser(AuthController controller) async {
    await controller.setAppUser(
        fullNameController: fullNameController.text,
        emailController: emailController.text,
        phoneNumberController: country.dialCode + phoneNumberController.text);
  }

//  Future<String> getTimeZone() async{
// return await FlutterNativeTimezone.getLocal();
//   }

  Future<void> verifyNumber(AuthController controller) async {
    await setAppUser(controller);
    await verifyPhoneNumber(controller);
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

  Future<void> goToPrivacyPolicyPage() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PrivacyPolicyPage(),
      ),
    );
  }

  Future<void> goToTermsOfServicePage() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TermsOfServicePage(),
      ),
    );
  }

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
          Provider.of<AuthController>(context, listen: false).clearAppUser();
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
                onTap: () {
                  verifyNumber(
                    authController,
                  );
                },
              );
            }),
          ),
        ),
        body: SafeArea(
          bottom: false,
          child: Form(
            key: formKey,
            child: ListView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              children: [
                BackBar(
                  padding: EdgeInsets.zero,
                  trailing: LiviTextStyles.interRegular14(buildNumber,
                      color: LiviThemes.colors.gray700),
                ),
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
                  title: Strings.fullName.requiredSymbol(),
                  textCapitalization: TextCapitalization.words,
                  hint: Strings.steveJobsFullName,
                  controller: fullNameController,
                  topScrollPadding: 40,
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
                    title: Strings.phoneNumber.requiredSymbol(),
                    controller: phoneNumberController,
                    focusNode: phoneFocus,
                    keyboardType: TextInputType.phone,
                    staticHint: country.dialCode,
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
                        child: RichText(
                            text: TextSpan(children: [
                          TextSpan(
                            text: '${Strings.iHaveReadAndAgreeToThe} ',
                            style: LiviThemes.typography.interRegular_16
                                .copyWith(color: LiviThemes.colors.baseBlack),
                          ),
                          TextSpan(
                            text: Strings.termsOfService,
                            recognizer: TapGestureRecognizer()
                              ..onTap = goToTermsOfServicePage,
                            style: LiviThemes.typography.interRegular_16
                                .copyWith(color: LiviThemes.colors.brand600),
                          ),
                          TextSpan(
                            text: ' ${Strings.and} ',
                            style: LiviThemes.typography.interRegular_16
                                .copyWith(color: LiviThemes.colors.baseBlack),
                          ),
                          TextSpan(
                            text: Strings.privacyPolicy,
                            style: LiviThemes.typography.interRegular_16
                                .copyWith(color: LiviThemes.colors.brand600),
                            recognizer: TapGestureRecognizer()
                              ..onTap = goToPrivacyPolicyPage,
                          ),
                        ])),
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
