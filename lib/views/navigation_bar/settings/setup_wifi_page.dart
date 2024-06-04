import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../components/components.dart';
import '../../../controllers/ble_controller.dart';
import '../../../themes/livi_themes.dart';
import '../../../utils/strings.dart';

class SetupWifiPage extends StatefulWidget {
  const SetupWifiPage({super.key});

  @override
  State<SetupWifiPage> createState() => _SetupWifiPageState();
}

class _SetupWifiPageState extends State<SetupWifiPage> {
  final TextEditingController ssidTextController = TextEditingController();
  final TextEditingController passwordTextController = TextEditingController();
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  String? errorText;

  @override
  void initState() {
    ssidTextController.addListener(() {});
    passwordTextController.addListener(() {});
    super.initState();
  }

  bool enableButton() {
    return ssidTextController.text.isNotEmpty &&
        passwordTextController.text.isNotEmpty;
  }

  void saveWifi() {
    if (_formkey.currentState!.validate()) {
      Provider.of<BleController>(context, listen: false)
          .enableWifi(ssidTextController.text, passwordTextController.text);
      Navigator.pop(context);
    }
  }

  String? validatePassword(String? value) {
    if (value != null) {
      if (value.isEmpty) {
        errorText = Strings.passwordRequired;
      } else if (value.length < 8) {
        errorText = Strings.passwordLength;
      }
    }
    return null;
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
          child: LiviFilledButton(
            text: Strings.setWifi,
            onTap: () => saveWifi(),
          ),
        ),
      ),
      appBar: LiviAppBar(
        title: Strings.setupWifi,
      ),
      body: Form(
        key: _formkey,
        child: ListView(
          children: [
            LiviInputField(
              title: Strings.ssid,
              controller: ssidTextController,
              focusNode: FocusNode(),
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            ),
            LiviInputField(
              validator: validatePassword,
              title: Strings.password,
              focusNode: FocusNode(),
              errorText: errorText,
              controller: passwordTextController,
            ),
          ],
        ),
      ),
    );
  }
}
