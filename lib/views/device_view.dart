import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import '../controllers/devices_controller.dart';
import 'package:provider/provider.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';

class DeviceView extends StatefulWidget {
  final BluetoothDevice device;
  const DeviceView({super.key, required this.device});

  @override
  State<DeviceView> createState() => _DeviceViewState();
}

class _DeviceViewState extends State<DeviceView> {
  late final DevicesController _devicesController;
  final info = NetworkInfo();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController ssidController = TextEditingController();
  final TextEditingController pwdController = TextEditingController();

  @override
  void initState() {
    _devicesController = Provider.of<DevicesController>(context, listen: false);
    getNetworkInfo();
    super.initState();
  }

  @override
  void dispose() {
    ssidController.dispose();
    pwdController.dispose();
    super.dispose();
  }

  Future getNetworkInfo() async {
    await _devicesController.connect(widget.device);
    if (await Permission.locationWhenInUse.request().isGranted) {
      final wifiName = await info.getWifiName();
      ssidController.text = wifiName ?? '';
      pwdController.text = 'FDUS218!';
      // 'Adherence12345!';
      // 'FDUS218!'; // FOR TESTING
    } else {
      print('restricted');
    }
  }

  void pop() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Device Setup'),
        ),
        body: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(children: [
              TextFormField(
                controller: ssidController,
                decoration: const InputDecoration(label: Text('ssid')),
                // The validator receives the text that the user has entered.
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter ssid';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: pwdController,
                decoration: const InputDecoration(label: Text('password')),
                obscureText: true,
                // The validator receives the text that the user has entered.
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter password';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () async {
                  // Validate returns true if the form is valid, or false otherwise.
                  if (_formKey.currentState!.validate()) {
                    // If the form is valid, display a snackbar. In the real world,
                    // you'd often call a server or save the information in a database.
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Processing Data')),
                    );

                    await _devicesController.sendCredentials(
                        widget.device, ssidController.text, pwdController.text);
                    pop();
                  }
                },
                child: const Text('Continue'),
              ),
            ]),
          ),
        ));
  }
}
