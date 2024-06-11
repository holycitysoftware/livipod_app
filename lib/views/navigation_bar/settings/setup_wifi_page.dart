import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wifi_scan/wifi_scan.dart';

import '../../../components/components.dart';
import '../../../controllers/ble_controller.dart';
import '../../../themes/livi_themes.dart';
import '../../../utils/strings.dart';

class SetupWifiPage extends StatefulWidget {
  final WiFiAccessPoint? wiFiAccessPoint;
  const SetupWifiPage({super.key, this.wiFiAccessPoint});

  @override
  State<SetupWifiPage> createState() => _SetupWifiPageState();
}

class _SetupWifiPageState extends State<SetupWifiPage> {
  final TextEditingController ssidTextController = TextEditingController();
  final TextEditingController passwordTextController = TextEditingController();
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final ssidFocusNode = FocusNode();
  final passwordFocusNode = FocusNode();
  String? errorText;

  @override
  void initState() {
    ssidTextController.addListener(() {});
    passwordTextController.addListener(() {});
    if (widget.wiFiAccessPoint != null) {
      ssidTextController.text = widget.wiFiAccessPoint!.ssid;
    }
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
      Navigator.popUntil(context, (route) => route.isFirst);
    }
  }

  String? validatePassword(String? value) {
    if (value != null) {
      if (value.isEmpty) {
        errorText = Strings.passwordRequired;
        return errorText;
      } else if (value.length < 8) {
        errorText = Strings.passwordLength;
        return errorText;
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
              focusNode: ssidFocusNode,
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            ),
            LiviInputField(
              validator: validatePassword,
              title: Strings.password,
              focusNode: passwordFocusNode,
              errorText: errorText,
              controller: passwordTextController,
            ),
          ],
        ),
      ),
    );
  }
}
