import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wifi_scan/wifi_scan.dart';

import '../../../components/components.dart';
import '../../../controllers/ble_controller.dart';
import '../../../themes/livi_themes.dart';
import '../../../utils/strings.dart';
import 'setup_wifi_page.dart';

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
    _startScan();
    startListeningToScanResults();
    super.initState();
  }

  /// Show snackbar.
  void kShowSnackBar(BuildContext context, String message) {
    if (kDebugMode) print(message);
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  Future<bool> _canGetScannedResults(BuildContext context) async {
    // check if can-getScannedResults
    final can = await WiFiScan.instance.canGetScannedResults();
    // if can-not, then show error
    if (can != CanGetScannedResults.yes) {
      if (mounted) {
        kShowSnackBar(context, 'Cannot get scanned results: $can');
      }
      accessPoints = <WiFiAccessPoint>[];
      return false;
    }
    return true;
  }

  Future<void> _startScan() async {
    final can = await WiFiScan.instance.canStartScan();
    // if can-not, then show error
    if (can != CanStartScan.yes) {
      if (mounted) {
        kShowSnackBar(context, 'Cannot start scan: $can');
      }
      return;
    }
  }

  Future<void> startListeningToScanResults() async {
    if (await _canGetScannedResults(context)) {
      subscription = WiFiScan.instance.onScannedResultsAvailable
          .listen((result) => setState(() => accessPoints = result));
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

  Future<void> goToWifiList(WiFiAccessPoint wiFiAccessPoint) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SetupWifiPage(
          wiFiAccessPoint: wiFiAccessPoint,
        ),
      ),
    );
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
            final item = accessPoints[index];
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
              child: Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: BorderSide(color: LiviThemes.colors.gray200),
                ),
                color: LiviThemes.colors.gray50,
                child: InkWell(
                  borderRadius: BorderRadius.circular(8),
                  onTap: () => goToWifiList(item),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Icon(
                          Icons.wifi,
                          color: LiviThemes.colors.brand600,
                        ),
                        LiviThemes.spacing.widthSpacer24(),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            LiviThemes.spacing.widthSpacer8(),
                            LiviTextStyles.interMedium16(item.ssid,
                                overflow: TextOverflow.ellipsis),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
