import 'dart:async';

import 'package:async/async.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:livipod_app/controllers/ble_device_controller.dart';
import 'package:livipod_app/controllers/livi_pod_controller.dart';

import '../models/livi_pod.dart';

class BleController extends ChangeNotifier {
  final LiviPodController liviPodController;
  List<ScanResult> _scanResults = [];
  BluetoothAdapterState _adapterState = BluetoothAdapterState.off;
  final List<BleDeviceController> _connectedDevices = [];
  final StreamGroup<Map<String, BluetoothConnectionState>>
      _connectionStateStreamGroup =
      StreamGroup<Map<String, BluetoothConnectionState>>();
  final StreamGroup<BleDeviceInfo> _deviceInfoStreamGroup =
      StreamGroup<BleDeviceInfo>();
  bool _isScanning = false;
  List<LiviPod> _liviPodDevices = [];

  // For public consumption
  BluetoothAdapterState get adapterState => _adapterState;
  bool get isScanning => _isScanning;
  List<ScanResult> get scanResults => _scanResults;
  List<BleDeviceController> get connectedDevices => _connectedDevices;
  List<LiviPod> get liviPodDevices => _liviPodDevices;

  BleController({required this.liviPodController}) {
    FlutterBluePlus.setLogLevel(LogLevel.verbose, color: true);

    FlutterBluePlus.adapterState.listen((event) {
      _adapterState = event;
      notifyListeners();
    });

    // this is fired when any child streams
    _connectionStateStreamGroup.stream.listen((event) {
      if (kDebugMode) {
        print(event);
      }
      notifyListeners();
    });

    _deviceInfoStreamGroup.stream.listen((event) {
      // get the livipod
      var liviPod = _liviPodDevices.firstWhere((element) =>
          element.bleDeviceController == event.bleDeviceController);

      // update mac and ip address
      liviPod.macAddress = event.macAddress;
      liviPod.ipAddress = event.ipAddress;

      // update database
      liviPodController.updateLiviPod(liviPod);

      notifyListeners();
    });

    liviPodController.listenToLiviPodsRealTime().listen(_handleLiviPods);

    FlutterBluePlus.scanResults.listen((results) {
      _scanResults = results;
      notifyListeners();
    }, onError: (e) {
      if (kDebugMode) {
        print(e);
      }
    });

    FlutterBluePlus.isScanning.listen((state) {
      _isScanning = state;
      notifyListeners();
    });
  }

  void _handleLiviPods(List<LiviPod> liviPods) {
    for (var liviPod in liviPods) {
      final device =
          BluetoothDevice(remoteId: DeviceIdentifier(liviPod.remoteId));

      if (kDebugMode) {
        print('The livi pod remoteId is ${device.remoteId}');
      }

      if (!_liviPodDevices.any((element) => element.id == liviPod.id) &&
          !_connectedDevices.any((element) =>
              element.bluetoothDevice.remoteId == device.remoteId)) {
        liviPod.bleDeviceController = connect(device);
        _liviPodDevices.add(liviPod);
      } else if (!_liviPodDevices.any((element) => element.id == liviPod.id)) {
        // the bluetooth device is already connected
        liviPod.bleDeviceController = _connectedDevices.firstWhere(
            (element) => element.bluetoothDevice.remoteId == device.remoteId);
        _liviPodDevices.add(liviPod);
      }
    }
    notifyListeners();
  }

  void startScan() {
    _scanResults.clear();

    FlutterBluePlus.startScan(
        withNames: ['LiviPod'],
        timeout: const Duration(seconds: 15),
        continuousUpdates: true,
        removeIfGone: const Duration(seconds: 15));
  }

  void stopScan() {
    if (_adapterState == BluetoothAdapterState.on) {
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

  BleDeviceController? connect(BluetoothDevice device) {
    final bleDevice = BleDeviceController(bluetoothDevice: device);
    _connectionStateStreamGroup
        .add(bleDevice.connectionStateStreamController.stream);
    _deviceInfoStreamGroup.add(bleDevice.deviceInfoStreamController.stream);
    _connectedDevices.add(bleDevice);
    bleDevice.connect();
    return bleDevice;
  }

  void disconnect(BluetoothDevice device) {
    if (_connectedDevices.any(
        (element) => element.bluetoothDevice.remoteId == device.remoteId)) {
      final bleDevice = _connectedDevices.firstWhere(
          (element) => element.bluetoothDevice.remoteId == device.remoteId);
      bleDevice.disconnect();
      _connectedDevices.remove(bleDevice);
      _liviPodDevices
          .removeWhere((element) => element.bleDeviceController == bleDevice);
    }
  }

  void startBlink(BluetoothDevice device) {
    if (_connectedDevices.any(
        (element) => element.bluetoothDevice.remoteId == device.remoteId)) {
      final bleDevice = _connectedDevices.firstWhere(
          (element) => element.bluetoothDevice.remoteId == device.remoteId);
      bleDevice.startBlink();
    }
  }

  void stopBlink(BluetoothDevice device) {
    if (_connectedDevices.any(
        (element) => element.bluetoothDevice.remoteId == device.remoteId)) {
      final bleDevice = _connectedDevices.firstWhere(
          (element) => element.bluetoothDevice.remoteId == device.remoteId);
      bleDevice.stopBlink();
    }
  }

  Future<void> enableWifi(String ssid, String pwd) async {
    for (var liviPodDevice in _liviPodDevices) {
      await liviPodDevice.bleDeviceController?.enableWifi(ssid, pwd);
    }
  }

  Future<void> disableWifi() async {
    for (var liviPodDevice in _liviPodDevices) {
      await liviPodDevice.bleDeviceController?.disableWifi();
    }
  }
}
