import 'package:flutter/material.dart';
import 'package:livipod_app/views/device_view.dart';
import 'package:provider/provider.dart';

import '../controllers/devices_controller.dart';

class DevicesView extends StatefulWidget {
  const DevicesView({super.key});

  @override
  State<DevicesView> createState() => _DevicesViewState();
}

class _DevicesViewState extends State<DevicesView> {
  late final DevicesController _deviceController;

  @override
  void initState() {
    _deviceController = Provider.of<DevicesController>(context, listen: false);
    _deviceController.disconnect();
    super.initState();
  }

  @override
  void dispose() {
    _deviceController.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Consumer<DevicesController>(
            builder: (context, deviceController, child) {
              var devices = deviceController.liviPodDevices;
              return ListView.builder(
                shrinkWrap: true,
                itemCount: devices.length,
                itemBuilder: (context, index) {
                  var device = devices[index];
                  return GestureDetector(
                    onTap: () {
                      _deviceController.connect(device);
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return const DeviceView();
                        },
                      ));
                    },
                    child: Card(
                      elevation: 6,
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(device.platformName),
                            Text(
                              device.remoteId.toString(),
                              style: Theme.of(context).textTheme.bodySmall,
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
