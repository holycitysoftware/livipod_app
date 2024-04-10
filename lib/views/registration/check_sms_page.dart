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
  const CheckSmsPage({
    super.key,
    required this.appUser,
  });

  @override
  State<CheckSmsPage> createState() => _CheckSmsPageState();
}

class _CheckSmsPageState extends State<CheckSmsPage> {
  final TextEditingController pinController = TextEditingController();
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
    await Provider.of<AuthController>(context, listen: false)
        .validate(pinController.text);
  }

  Future<void> goToIdentifyPersonPage(String code) async {
    await validateSmsCode();
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TestCreateUser(),
      ),
    );
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
      bottomNavigationBar: LiviFilledButton(
        isCloseToNotch: true,
        margin: const EdgeInsets.all(16),
        showArrow: true,
        text: Strings.continueText,
        onTap: () => goToIdentifyPersonPage(''),
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
          Align(child: LiviTextStyles.interRegular16(Strings.steveJobsNumber)),
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
                        FocusScope.of(context).requestFocus(FocusNode());
                        setState(() {
                          this.code = code;
                        });
                      }
                    },
                    decoration: BoxLooseDecoration(
                        radius: Radius.circular(6.47),
                        strokeWidth: 1.08,
                        textStyle: LiviThemes.typography.interRegular_30,
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
              LiviTextStyles.interRegular16(Strings.didntReceiveTheSMS),
              LiviThemes.spacing.widthSpacer8(),
              LiviTextStyles.interSemiBold16(Strings.clickToResend,
                  color: LiviThemes.colors.brand600),
            ],
          ),
        ],
      ),
    );
  }
}
