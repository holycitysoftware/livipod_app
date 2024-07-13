import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';

import '../../components/components.dart';
import '../../controllers/controllers.dart';
import '../../models/app_user.dart';
import '../../themes/livi_themes.dart';
import '../../utils/strings.dart';

class CheckSmsPageArguments {
  final AppUser appUser;
  final bool isAccountCreation;

  CheckSmsPageArguments({
    required this.appUser,
    this.isAccountCreation = false,
  });
}

class CheckSmsPage extends StatefulWidget {
  static const String routeName = '/check-sms-page';
  final AppUser appUser;
  final bool isAccountCreation;
  const CheckSmsPage({
    super.key,
    required this.appUser,
    this.isAccountCreation = false,
  });

  @override
  State<CheckSmsPage> createState() => _CheckSmsPageState();
}

class _CheckSmsPageState extends State<CheckSmsPage> {
  final TextEditingController pinController = TextEditingController();
  String code = '';
  final defaultPinTheme = PinTheme(
    width: 56,
    height: 56,
    textStyle: TextStyle(
      fontSize: 20,
      color: LiviThemes.colors.baseBlack,
      fontWeight: FontWeight.w600,
    ),
    decoration: BoxDecoration(
      border: Border.all(color: Color.fromRGBO(234, 239, 243, 1)),
      borderRadius: BorderRadius.circular(6.47),
    ),
  );
  @override
  void initState() {
    autoFill();
    super.initState();
  }

  Future<void> autoFill() async {
    // if (Platform.isAndroid) {
    // await SmsAutoFill().listenForCode();
    // }
  }

  Future<void> validateSmsCode() async {
    await Provider.of<AuthController>(context, listen: false).validate(
        pinController.text,
        isAccountCreation: widget.isAccountCreation);
  }

  Future<void> goToIdentifyPersonPage(String code) async {
    await validateSmsCode();
  }

  Future<void> verifyPhoneNumber() async {
    final appUser = Provider.of<AuthController>(context, listen: false).appUser;
    if (appUser != null) {
      await Provider.of<AuthController>(context, listen: false)
          .verifyPhoneNumber(appUser.phoneNumber.trim(),
              isAccountCreation: widget.isAccountCreation);
    }
  }

  @override
  void dispose() {
    // if (Platform.isAndroid) {
    // SmsAutoFill().unregisterListener();
    // }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LiviThemes.colors.baseWhite,
      resizeToAvoidBottomInset: true,
      bottomNavigationBar: Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Builder(builder: (context) {
            return Consumer<AuthController>(
                builder: (context, authController, child) {
              return LiviFilledButton(
                isCloseToNotch: true,
                showArrow: true,
                isLoading: authController.loading,
                text: Strings.continueText,
                onTap: () => goToIdentifyPersonPage(''),
              );
            });
          }),
        ),
      ),
      body: Column(
        children: [
          BackBar(
            title: Strings.verification,
            onTap: () => Provider.of<AuthController>(context, listen: false)
                .goBackBySettingPromptForUserCode(),
          ),
          LiviThemes.spacing.heightSpacer8(),
          Align(child: LiviTextStyles.interSemiBold24(Strings.checkYourSms)),
          LiviThemes.spacing.heightSpacer8(),
          Align(
              child: LiviTextStyles.interRegular16(
                  Strings.weSentAVerificationCodeTo)),
          if (widget.appUser != null)
            Align(
                child:
                    LiviTextStyles.interRegular16(widget.appUser.phoneNumber)),
          LiviThemes.spacing.heightSpacer24(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                    child: Pinput(
                  defaultPinTheme: defaultPinTheme,
                  // focusedPinTheme: focusedPinTheme,
                  // submittedPinTheme: submittedPinTheme,
                  length: 6, controller: pinController,
                )),
              ],
            ),
          ),
          Spacer(),
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: verifyPhoneNumber,
                  child: LiviTextStyles.interRegular16(
                    Strings.didntReceiveTheSMS,
                    textAlign: TextAlign.start,
                    maxLines: 3,
                  ),
                ),
                LiviThemes.spacing.widthSpacer4(),
                GestureDetector(
                  onTap: verifyPhoneNumber,
                  child: LiviTextStyles.interSemiBold16(
                    Strings.clickToResend,
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
    );
  }
}
