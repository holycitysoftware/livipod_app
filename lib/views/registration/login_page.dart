import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/components.dart';
import '../../controllers/controllers.dart';
import '../../models/models.dart';
import '../../themes/livi_spacing/livi_spacing.dart';
import '../../themes/livi_themes.dart';
import '../../utils/countries.dart';
import '../../utils/strings.dart';
import '../views.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final ScrollController scrollController = ScrollController();
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final FocusNode fullNameFocus = FocusNode();
  final FocusNode phoneFocus = FocusNode();
  bool loading = false;
  late AppUser appUser;
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
        context, MaterialPageRoute(builder: (context) => CreateAccountPage()));
  }

  Future<void> verifyPhoneNumber() async {
    await Provider.of<AuthController>(context, listen: false)
        .verifyPhoneNumber(country.dialCode + phoneNumberController.text);
  }

  void setAppUser() {
    Provider.of<AuthController>(context, listen: false).setAppUser(
        fullNameController: fullNameController.text,
        phoneNumberController: phoneNumberController.text);
  }

  Future<void> verifyNumber() async {
    setAppUser();
    await verifyPhoneNumber();
  }

  Future<void> goToCheckSmsPge() async {
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
  void dispose() {
    super.dispose();
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
                isCloseToNotch: true,
                enabled: fullNameController.text.isNotEmpty &&
                    phoneNumberController.text.isNotEmpty,
                isLoading: authController.loading,
                text: Strings.logIn,
                onTap: verifyNumber,
              );
            }),
          ),
        ),
        body: Form(
          key: _formKey,
          child: ListView(
            controller: scrollController,
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
                child:
                    LiviTextStyles.interSemiBold24(Strings.loginToYourAccount),
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
                textCapitalization: TextCapitalization.words,
                keyboardType: TextInputType.text,
                hint: Strings.steveJobsFullName,
                onFieldSubmitted: (value) {
                  phoneFocus.requestFocus();
                },
                focusNode: fullNameFocus,
                controller: fullNameController,
              ),
              Consumer<AuthController>(
                  builder: (context, authController, child) {
                return LiviInputField(
                  padding: const EdgeInsets.symmetric(
                      horizontal: kSpacer_16, vertical: kSpacer_8),
                  title: Strings.phoneNumber,
                  focusNode: phoneFocus,
                  onFieldSubmitted: (value) {
                    verifyNumber();
                  },
                  errorText: authController.verificationError.isEmpty
                      ? null
                      : authController.verificationError,
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
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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
    );
  }
}
