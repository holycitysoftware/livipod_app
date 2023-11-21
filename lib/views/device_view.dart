import 'package:flutter/material.dart';
import 'package:livipod_app/controllers/livi_pod_controller.dart';
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
  late final LiviPodController _liviPodController;
  final info = NetworkInfo();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController ssidController = TextEditingController();
  final TextEditingController pwdController = TextEditingController();

  @override
  void initState() {
    _devicesController = Provider.of<DevicesController>(context, listen: false);
    _liviPodController = Provider.of<LiviPodController>(context, listen: false);
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

  Future addLiviPod(DevicesController controller) async {
    if (mounted) {
      if (!await _liviPodController.liviPodExists(controller.liviPod!)) {
        await _liviPodController.addLiviPod(controller.liviPod!);
      } else {
        await _liviPodController.updateLiviPod(controller.liviPod!);
      }
      await _devicesController.disconnect();
      pop();
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
        body: Consumer<DevicesController>(builder: (context, value, child) {
          if (value.liviPod != null) {
            addLiviPod(value);
            return const Center(
              child: Text('Processing...'),
            );
          } else {
            return Form(
              key: _formKey,
              onWillPop: () async {
                await _devicesController.disconnect();
                return Future.value(true);
              },
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
                            ssidController.text, pwdController.text);
                        pop();
                      }
                    },
                    child: const Text('Continue'),
                  ),
                ]),
              ),
            );
          }
        }));
  }
}
