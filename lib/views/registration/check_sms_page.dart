import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sms_autofill/sms_autofill.dart';

import '../../components/components.dart';
import '../../controllers/controllers.dart';
import '../../models/app_user.dart';
import '../../themes/livi_themes.dart';
import '../../utils/strings.dart';
import '../views.dart';

class CheckSmsPage extends StatefulWidget {
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
  final FocusNode pinFocusNode = FocusNode();
  String code = '';
  @override
  void initState() {
    autoFill();
    super.initState();
  }

  Future<void> autoFill() async {
    if (Platform.isAndroid) {
      await SmsAutoFill().listenForCode();
    }
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
              isAccountCreation: true);
    }
  }

  @override
  void dispose() {
    if (Platform.isAndroid) {
      SmsAutoFill().unregisterListener();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          BackBar(title: Strings.verification),
          LiviThemes.spacing.heightSpacer8(),
          Align(child: LiviTextStyles.interSemiBold24(Strings.checkYourSms)),
          LiviThemes.spacing.heightSpacer8(),
          Align(
              child: LiviTextStyles.interRegular16(
                  Strings.weSentAVerificationCodeTo)),
          Align(
              child: LiviTextStyles.interRegular16(widget.appUser.phoneNumber)),
          LiviThemes.spacing.heightSpacer24(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: PinFieldAutoFill(
                    controller: pinController,
                    autoFocus: true,
                    currentCode: code,
                    onCodeSubmitted: goToIdentifyPersonPage,
                    onCodeChanged: (code) {
                      if (code!.length == 6) {
                        goToIdentifyPersonPage(code);
                      }
                    },
                    focusNode: pinFocusNode,
                    decoration: BoxLooseDecoration(
                        radius: Radius.circular(6.47),
                        strokeWidth: 1.08,
                        textStyle: LiviThemes.typography.interRegular_30
                            .copyWith(color: LiviThemes.colors.baseBlack),
                        strokeColorBuilder: FixedColorListBuilder([
                          LiviThemes.colors.gray200,
                          LiviThemes.colors.gray200,
                          LiviThemes.colors.gray200,
                          LiviThemes.colors.gray200,
                          LiviThemes.colors.gray200,
                          LiviThemes.colors.gray200
                        ])),
                    // decoration: // UnderlineDecoration, BoxLooseDecoration or BoxTightDecoration see https://github.com/TinoGuo/pin_input_text_field for more info,
                    // onCodeSubmitted: //code submitted callback
                    // onCodeChanged: //code changed callback
                  ),
                ),
              ],
            ),
          ),
          Spacer(),
          Row(
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
        ],
      ),
    );
  }
}
