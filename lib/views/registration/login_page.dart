import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
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
import '../views.dart';

class LoginPage extends StatefulWidget {
  static const String routeName = '/login-page';
  final AppUser? appUser;
  const LoginPage({super.key, this.appUser});
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final ScrollController scrollController = ScrollController();
  final TextEditingController phoneNumberController = TextEditingController();
  final FocusNode fullNameFocus = FocusNode();
  final FocusNode phoneFocus = FocusNode();
  bool loading = false;
  late AppUser appUser;
  Country country = getUS();

  @override
  void initState() {
    setFocusListeners();
    phoneNumberController.addListener(() {
      setState(() {});
    });
    getCountry();
    super.initState();
  }

  Future<void> getCountry() async {
    if (widget.appUser == null ||
        (widget.appUser != null && widget.appUser!.phoneNumber.isEmpty)) {
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
      Provider.of<AuthController>(context, listen: false).clearAppUser();
      setState(() {});
    }
  }

  void setFocusListeners() {
    fullNameFocus.addListener(animateFieldsToCenter);
    phoneFocus.addListener(animateFieldsToCenter);
  }

  void animateFieldsToCenter() {
    if (fullNameFocus.hasFocus || phoneFocus.hasFocus) {
      Future.delayed(Duration(milliseconds: 350), () {
        if (scrollController.hasClients) {
          scrollController.animateTo(scrollController.position.maxScrollExtent,
              duration: Duration(milliseconds: 100), curve: Curves.bounceIn);
        }
      });
    }
  }

  Future<void> goToCreateAccountPage(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SmsFlowPage(
          showIdentifyPersonaPage: true,
        ),
      ),
    );
  }

  Future<void> verifyPhoneNumber() async {
    await Provider.of<AuthController>(context, listen: false)
        .verifyPhoneNumber(country.dialCode + phoneNumberController.text);
  }

  Future<void> setAppUser() async {
    await Provider.of<AuthController>(context, listen: false).setAppUser(
        fullNameController: '',
        phoneNumberController: country.dialCode + phoneNumberController.text);
  }

  Future<void> verifyNumber() async {
    await setAppUser();
    await verifyPhoneNumber();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: PopScope(
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
                  isCloseToNotch: true,
                  enabled: phoneNumberController.text.isNotEmpty,
                  isLoading: authController.loading,
                  text: Strings.logIn,
                  onTap: verifyNumber,
                );
              }),
            ),
          ),
          body: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: kSpacer_16),
              child: Column(
                // controller: scrollController,
                // keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                children: [
                  BackBar(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => WelcomePage(),
                          ),
                        );
                      },
                      title: Strings.logIn),
                  Align(
                    child: LiviTextStyles.interSemiBold24(Strings.welcomeBack),
                  ),
                  LiviThemes.spacing.heightSpacer4(),
                  Align(
                    child: LiviTextStyles.interRegular16(
                        Strings.enterYourDetailsToLogIn),
                  ),
                  LiviThemes.spacing.heightSpacer8(),
                  const SizedBox(height: kSpacer_16),
                  Consumer<AuthController>(
                      builder: (context, authController, child) {
                    return LiviInputField(
                      key: Key('phone-number-field'),
                      padding: const EdgeInsets.symmetric(
                          horizontal: kSpacer_16, vertical: kSpacer_8),
                      title: Strings.phoneNumber.requiredSymbol(),
                      focusNode: phoneFocus,
                      staticHint: country.dialCode,
                      onFieldSubmitted: (value) {
                        verifyNumber();
                      },
                      errorText: authController.verificationError.isEmpty
                          ? null
                          : authController.verificationError,
                      keyboardType: TextInputType.number,
                      hint: Strings.steveJobsNumber,
                      prefix: CountryDropdownButton(
                        country: country,
                        onChanged: (Country? value) {
                          setState(() {
                            country = value!;
                          });
                        },
                      ),
                      controller: phoneNumberController,
                    );
                  }),
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 16),
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
          ),
        ),
      ),
    );
  }
}
