import 'package:flutter/foundation.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:livipod_app/models/livi_pod.dart';

import 'livi_pod_controller.dart';

class DevicesController extends ChangeNotifier {
  final List<BluetoothDevice> _liviPodDevices = [];
  BluetoothAdapterState _state = BluetoothAdapterState.off;
  final List<BluetoothDevice> _connectedDevices = [];
  final List<BluetoothCharacteristic> _wifiCredentialsCharacteristics = [];
  final List<LiviPod> _liviPods = [];
  final LiviPodController liviPodController;

  BluetoothAdapterState get state => _state;
  List<BluetoothDevice> get liviPodDevices => _liviPodDevices;
  List<BluetoothDevice> get connectedDevices => _connectedDevices;
  List<LiviPod> get liviPods => _liviPods;

  DevicesController({required this.liviPodController}) {
    liviPodController.listenToLiviPodsRealTime().listen(handleLiviPodStream);

    FlutterBluePlus.adapterState.listen((event) {
      _state = event;
      if (_state == BluetoothAdapterState.on &&
          !FlutterBluePlus.isScanningNow) {
        _startBle();
      }
      notifyListeners();
    });

    FlutterBluePlus.scanResults.listen((event) {
      // List<BluetoothDevice> devicesToRemove = [];
      // for (var c in _liviPodDevices) {
      //   if (!event.any((element) => element.device.remoteId == c.remoteId)) {
      //     devicesToRemove.add(c);
      //   }
      // }
      // for (var c in devicesToRemove) {
      //   _liviPodDevices
      //       .removeWhere((element) => element.remoteId == c.remoteId);
      // }

      for (var r in event) {
        if (!_liviPodDevices
            .any((element) => element.remoteId == r.device.remoteId)) {
          _liviPodDevices.add(r.device);
          connect(r.device);
        }
      }
      notifyListeners();
    });
  }

  void _startBle() {
    // _liviPodDevices.clear();
    if (_state == BluetoothAdapterState.on) {
      if (kDebugMode) {
        print('Starting BLE scanning');
      }
      FlutterBluePlus.startScan(
          withNames: ['LiviPod'],
          continuousUpdates: true,
          removeIfGone: const Duration(seconds: 15));
    } else {
      if (kDebugMode) {
        print('Cannot scan when bluetooth adapter is off');
      }
    }
  }

  // void stopBle() {
  //   if (_state == BluetoothAdapterState.on) {
  //     if (kDebugMode) {
  //       print('Stopping BLE scanning');
  //     }
  //     FlutterBluePlus.stopScan();
  //   } else {
  //     if (kDebugMode) {
  //       print('Cannot scan when bluetooth adapter is off');
  //     }
  //   }
  // }

  Future connect(BluetoothDevice device) async {
    if (!device.isConnected) {
      device.connectionState.listen((event) {
        if (event == BluetoothConnectionState.disconnected) {
          // 1. typically, start a periodic timer that tries to
          //    reconnect, or just call connect() again right now
          // 2. you must always re-discover services after disconnection!
          if (kDebugMode) {
            print(
                "${device.disconnectReason?.code}: ${device.disconnectReason?.description}");
          }
        } else if (event == BluetoothConnectionState.connected) {
          _connectedDevices.add(device);
          discoverServices(device);
        }
        notifyListeners();
      });

      await device.connect();
    }
  }

  // Future<void> disconnect(BluetoothDevice device) async {
  //   final remoteId = device.remoteId;
  //   await device.disconnect();
  //   _connectedDevices.removeWhere((element) => element.remoteId == remoteId);
  //   _liviPodDevices.removeWhere((element) => element.remoteId == remoteId);
  //   notifyListeners();
  // }

  Future<void> discoverServices(BluetoothDevice device) async {
    List<BluetoothService> services = await device.discoverServices();
    for (var service in services) {
      if (kDebugMode) {
        print(service);
      }
      discoverServiceCharacteristics(device, service);
    }
  }

  void discoverServiceCharacteristics(
      BluetoothDevice device, BluetoothService service) {
    for (var characteristic in service.characteristics) {
      if (characteristic.uuid
          .toString()
          .startsWith("7cd5e90e-6379-41a5-9ad8-5ad71bc6d144")) {
        _wifiCredentialsCharacteristics.add(characteristic);
      } else if (characteristic.uuid
          .toString()
          .startsWith("b9662ed7-3a33-4c4d-b0d6-4adb77ad4d28")) {
        setupDeviceInfoListener(device, characteristic);
      }
    }
  }

  // Future handleNotification(List<int> event) async {
  //   final remoteId = _connectedDevice!.remoteId;
  //   var temp = String.fromCharCodes(event);
  //   var list = temp.split(',');
  //   var mac = list[0];
  //   var ipAddress = list[1];
  //   var online = list[1] != '0';

  //   final liviPod = LiviPod(
  //       macAddress: mac,
  //       ipAddress: ipAddress,
  //       online: online,
  //       remoteId: remoteId.toString());

  //   //await disconnect();
  //   notifyListeners();
  // }

  Future<void> setupDeviceInfoListener(
      BluetoothDevice device, BluetoothCharacteristic characteristic) async {
    if (device.isConnected) {
      await characteristic.setNotifyValue(true);
      characteristic.onValueReceived.listen(
        (event) async {
          // parse the ip and mac address
          final remoteId = device.remoteId;
          var temp = String.fromCharCodes(event);
          var list = temp.split(',');
          var mac = list[0];
          var ipAddress = list[1];
          var online = list[1] != '0';

          if (_liviPods.any(
              (element) => element.remoteId == device.remoteId.toString())) {
            // find the matching macAddress of existing livipod
            var liviPod = _liviPods.firstWhere(
                (element) => element.remoteId == device.remoteId.toString());
            if (liviPod.ipAddress != ipAddress) {
              liviPod.ipAddress = ipAddress;
// update the database
              await liviPodController.updateLiviPod(liviPod);
            }
          } else {
            // if no livipod exists with that mac address add it to the database
            final liviPod = LiviPod(
                macAddress: mac,
                ipAddress: ipAddress,
                online: online,
                remoteId: remoteId.toString());
            if (!await liviPodController.liviPodExists(liviPod)) {
              await liviPodController.addLiviPod(liviPod);
            }
          }
          notifyListeners();
        },
      );
    }
  }

  Future<void> sendCredentials(
      BluetoothDevice device, String ssid, String pwd) async {
    final index = _wifiCredentialsCharacteristics
        .indexWhere((element) => element.device.remoteId == device.remoteId);
    if (index != -1 &&
        _wifiCredentialsCharacteristics[index].device.isConnected) {
      var temp = '$ssid,$pwd;';
      await _wifiCredentialsCharacteristics[index].write(temp.codeUnits);
      notifyListeners();
    }
  }

  void handleLiviPodStream(List<LiviPod> liviPods) {
    _liviPods.clear();
    _liviPods.addAll(liviPods);
  }
}
