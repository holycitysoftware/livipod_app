import 'package:flutter/material.dart';
import '../controllers/devices_controller.dart';
import 'package:provider/provider.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';

class DeviceView extends StatefulWidget {
  const DeviceView({super.key});

  @override
  State<DeviceView> createState() => _DeviceViewState();
}

class _DeviceViewState extends State<DeviceView> {
  late final DevicesController _devicesController;
  final info = NetworkInfo();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController ssidController = TextEditingController();

  @override
  void initState() {
    _devicesController = Provider.of<DevicesController>(context, listen: false);
    getNetworkInfo();
    super.initState();
  }

  @override
  void dispose() {
    ssidController.dispose();
    super.dispose();
  }

  Future getNetworkInfo() async {
    if (await Permission.locationWhenInUse.request().isGranted) {
      final wifiName = await info.getWifiName();
      ssidController.text = wifiName ?? '';
    } else {
      print('restricted');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('WiFi Setup')),
      body: Form(
        key: _formKey,
        onWillPop: () async {
          await _devicesController.disconnect();
          return Future.value(true);
        },
        child: Column(children: [
          TextFormField(
            controller: ssidController,
            // The validator receives the text that the user has entered.
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
          ),
          ElevatedButton(
            onPressed: () {
              // Validate returns true if the form is valid, or false otherwise.
              if (_formKey.currentState!.validate()) {
                // If the form is valid, display a snackbar. In the real world,
                // you'd often call a server or save the information in a database.
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Processing Data')),
                );
              }
            },
            child: const Text('Continue'),
          ),
        ]),
      ),
    );
  }
}
