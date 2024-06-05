import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wifi_scan/wifi_scan.dart';

import '../../../components/components.dart';
import '../../../controllers/ble_controller.dart';
import '../../../themes/livi_themes.dart';
import '../../../utils/strings.dart';

class SetupWifiListPage extends StatefulWidget {
  const SetupWifiListPage({super.key});

  @override
  State<SetupWifiListPage> createState() => _SetupWifiListPageState();
}

class _SetupWifiListPageState extends State<SetupWifiListPage> {
  final TextEditingController ssidTextController = TextEditingController();
  final TextEditingController passwordTextController = TextEditingController();
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  List<WiFiAccessPoint> accessPoints = [];
  String? errorText;
  StreamSubscription<List<WiFiAccessPoint>>? subscription;

  @override
  void initState() {
    startScan();
    super.initState();
  }

  Future<void> startScan() async {
    // check platform support and necessary requirements
    final can = await WiFiScan.instance.canStartScan(askPermissions: true);
    switch (can) {
      case CanStartScan.yes:
        // start full scan async-ly
        final isScanning = await WiFiScan.instance.startScan();
        //...
        break;
      // ... handle other cases of CanStartScan values
      case CanStartScan.notSupported:
      // TODO: Handle this case.
      case CanStartScan.noLocationPermissionRequired:
      // TODO: Handle this case.
      case CanStartScan.noLocationPermissionDenied:
      // TODO: Handle this case.
      case CanStartScan.noLocationPermissionUpgradeAccuracy:
      // TODO: Handle this case.
      case CanStartScan.noLocationServiceDisabled:
      // TODO: Handle this case.
      case CanStartScan.failed:
      // TODO: Handle this case.
    }
  }

  Future<void> startListeningToScannedResults() async {
    // check platform support and necessary requirements
    final can =
        await WiFiScan.instance.canGetScannedResults(askPermissions: true);
    switch (can) {
      case CanGetScannedResults.yes:
        // listen to onScannedResultsAvailable stream
        subscription =
            WiFiScan.instance.onScannedResultsAvailable.listen((results) {
          // update accessPoints
          setState(() => accessPoints = results);
        });
        // ...
        break;
      // ... handle other cases of CanGetScannedResults values
      case CanGetScannedResults.notSupported:
      // TODO: Handle this case.
      case CanGetScannedResults.noLocationPermissionRequired:
      // TODO: Handle this case.
      case CanGetScannedResults.noLocationPermissionDenied:
      // TODO: Handle this case.
      case CanGetScannedResults.noLocationPermissionUpgradeAccuracy:
      // TODO: Handle this case.
      case CanGetScannedResults.noLocationServiceDisabled:
      // TODO: Handle this case.
    }
  }

// make sure to cancel subscription after you are done
  @override
  void dispose() {
    super.dispose();
    subscription?.cancel();
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
      appBar: LiviAppBar(
        title: Strings.wifiList,
      ),
      body: Form(
          key: _formkey,
          child: ListView.builder(
              itemCount: accessPoints.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SetupWifiListPage()));
                  },
                  title: Text(accessPoints[index].ssid),
                  subtitle: Text(accessPoints[index].bssid),
                  trailing: Text(accessPoints[index].level.toString()),
                );
              })),
    );
  }
}
