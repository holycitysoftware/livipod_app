import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class DevicesController extends ChangeNotifier {
  final List<BluetoothDevice> _scannedDevices = [];
  BluetoothAdapterState _state = BluetoothAdapterState.off;
  final List<BluetoothDevice> _connectedDevices = [];
  final List<BluetoothCharacteristic> _claimCharacteristics = [];
  final List<BluetoothCharacteristic> _unclaimCharacteristics = [];

  BluetoothAdapterState get state => _state;
  List<BluetoothDevice> get scannedDevices => _scannedDevices;
  List<BluetoothDevice> get connectedDevices => _connectedDevices;

  DevicesController() {
    FlutterBluePlus.adapterState.listen((event) {
      _state = event;
      notifyListeners();
    });
  }

  void startBle() {
    _scannedDevices.clear();
    FlutterBluePlus.onScanResults.listen(handleScanResults);

    if (_state == BluetoothAdapterState.on) {
      if (kDebugMode) {
        print('Starting BLE scanning');
      }
      FlutterBluePlus.startScan(
        withNames: ['LiviPod'],
        continuousUpdates: true, /*removeIfGone: const Duration(seconds: 15)*/
      );
    } else {
      if (kDebugMode) {
        print('Cannot scan when bluetooth adapter is off');
      }
    }
  }

  void handleScanResults(event) {
    for (var r in event) {
      final scannedDeviceExists = _scannedDevices
          .any((element) => element.remoteId == r.device.remoteId);
      if (!scannedDeviceExists) {
        _scannedDevices.add(r.device);
        notifyListeners();
      }
    }
  }

  void stopBle() {
    FlutterBluePlus.onScanResults.listen(handleScanResults).cancel();
    if (_state == BluetoothAdapterState.on) {
      if (kDebugMode) {
        print('Stopping BLE scanning');
      }
      FlutterBluePlus.stopScan();
    } else {
      if (kDebugMode) {
        print('Cannot scan when bluetooth adapter is off');
      }
    }
  }

  Future connect(BluetoothDevice device) async {
    if (!device.isConnected) {
      device.connectionState.listen((event) {
        if (event == BluetoothConnectionState.disconnected) {
          if (kDebugMode) {
            print(
                "${device.disconnectReason?.code}: ${device.disconnectReason?.description}");
          }
          _connectedDevices
              .removeWhere((element) => element.remoteId == device.remoteId);
          // 1. typically, start a periodic timer that tries to
          //    reconnect, or just call connect() again right now
          // 2. you must always re-discover services after disconnection!
          Timer.periodic(const Duration(seconds: 5), (timer) async {
            if (device.isConnected) {
              timer.cancel();
            } else {
              await device.connect();
              notifyListeners();
            }
          });
        } else if (event == BluetoothConnectionState.connected) {
          _connectedDevices.add(device);
          discoverServices(device);
        }
        notifyListeners();
      });

      try {
        await device.connect();
      } catch (e) {
        if (kDebugMode) {
          print(e);
        }
      }
    }
  }

  Future<void> disconnect(BluetoothDevice device) async {
    final remoteId = device.remoteId;
    await device.disconnect();
    _connectedDevices.removeWhere((element) => element.remoteId == remoteId);
    notifyListeners();
  }

  Future<void> discoverServices(BluetoothDevice device) async {
    if (device.isConnected) {
      List<BluetoothService> services = await device.discoverServices();
      for (var service in services) {
        if (kDebugMode) {
          print(service);
        }
        discoverServiceCharacteristics(device, service);
      }
    }
  }

  void discoverServiceCharacteristics(
      BluetoothDevice device, BluetoothService service) {
    for (var characteristic in service.characteristics) {
      if (characteristic.uuid
          .toString()
          .startsWith("7cd5e90e-6379-41a5-9ad8-5ad71bc6d144")) {
        _claimCharacteristics.add(characteristic);
      } else if (characteristic.uuid
          .toString()
          .startsWith("b9662ed7-3a33-4c4d-b0d6-4adb77ad4d28")) {
        setupDeviceInfoListener(device, characteristic);
      } else if (characteristic.uuid
          .toString()
          .startsWith("7736aff1-758b-45ae-8349-95581a16f905")) {
        _unclaimCharacteristics.add(characteristic);
      }
    }
  }

  Future<void> setupDeviceInfoListener(
      BluetoothDevice device, BluetoothCharacteristic characteristic) async {
    if (device.isConnected) {
      await characteristic.setNotifyValue(true);
      characteristic.onValueReceived.listen(
        (event) async {
//           // parse the ip and mac address
//           final remoteId = device.remoteId;
//           var temp = String.fromCharCodes(event);
//           var list = temp.split(',');
//           var mac = list[0];
//           var ipAddress = list[1];
//           var online = list[1] != '0';

//           if (_liviPods.any(
//               (element) => element.remoteId == device.remoteId.toString())) {
//             // find the matching macAddress of existing livipod
//             var liviPod = _liviPods.firstWhere(
//                 (element) => element.remoteId == device.remoteId.toString());
//             if (liviPod.ipAddress != ipAddress) {
//               liviPod.ipAddress = ipAddress;
// // update the database
//               await liviPodController.updateLiviPod(liviPod);
//             }
//           } else {
//             // if no livipod exists with that mac address add it to the database
//             final liviPod = LiviPod(
//                 macAddress: mac,
//                 ipAddress: ipAddress,
//                 online: online,
//                 remoteId: remoteId.toString());
//             if (!await liviPodController.liviPodExists(liviPod)) {
//               await liviPodController.addLiviPod(liviPod);
//             }
//           }
          notifyListeners();
        },
      );
    }
  }

  Future claim(BluetoothDevice device, String id) async {
    final index = _claimCharacteristics
        .indexWhere((element) => element.device.remoteId == device.remoteId);
    if (index != -1 && _claimCharacteristics[index].device.isConnected) {
      await _claimCharacteristics[index].write(id.codeUnits);
    }
    notifyListeners();
  }

  Future unclaim(BluetoothDevice device) async {
    final index = _unclaimCharacteristics
        .indexWhere((element) => element.device.remoteId == device.remoteId);
    if (index != -1 && _unclaimCharacteristics[index].device.isConnected) {
      await _unclaimCharacteristics[index].write([0x01]);
    }
    notifyListeners();
  }
}
