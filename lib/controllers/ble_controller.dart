import 'dart:async';

import 'package:async/async.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

import '../models/livi_pod.dart';
import '../services/livi_pod_service.dart';
import 'ble_device_controller.dart';

class BleController extends ChangeNotifier {
  final LiviPodService liviPodService;
  List<ScanResult> _scanResults = [];
  BluetoothAdapterState _adapterState = BluetoothAdapterState.off;
  final List<BleDeviceController> _connectedDevices = [];
  final StreamGroup<Map<String, BluetoothConnectionState>>
      _connectionStateStreamGroup =
      StreamGroup<Map<String, BluetoothConnectionState>>();
  final StreamGroup<BleDeviceInfo> _deviceInfoStreamGroup =
      StreamGroup<BleDeviceInfo>();
  final StreamGroup<DispenseRequest> _dispenseResponseStreamGroup =
      StreamGroup<DispenseRequest>();
  bool _isScanning = false;
  List<LiviPod> _liviPodDevices = [];

  // For public consumption
  BluetoothAdapterState get adapterState => _adapterState;
  bool get isScanning => _isScanning;
  List<ScanResult> get scanResults => _scanResults;
  List<BleDeviceController> get connectedDevices => _connectedDevices;
  List<LiviPod> get liviPodDevices => _liviPodDevices;

  BleController({required this.liviPodService}) {
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
      final liviPod = _liviPodDevices.firstWhere((element) =>
          element.bleDeviceController == event.bleDeviceController);

      // update mac and ip address
      liviPod.macAddress = event.macAddress;
      liviPod.ipAddress = event.ipAddress;

      // update database
      liviPodService.updateLiviPod(liviPod);

      notifyListeners();
    });

    _dispenseResponseStreamGroup.stream.listen((event) {
      // get the livipod
      final liviPod = _liviPodDevices.firstWhere((element) =>
          element.bleDeviceController == event.bleDeviceController);
      liviPod.dispenseRequest = event;
      notifyListeners();
    });

    liviPodService.listenToLiviPodsRealTime().listen(_handleLiviPods);

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

      if (!_liviPodDevices.any((element) => element.id == liviPod.id) &&
          !_connectedDevices.any((element) =>
              element.bluetoothDevice.remoteId == device.remoteId)) {
        liviPod.bleDeviceController = _addBleDeviceController(device);
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

  BleDeviceController? connectToUnclaimedDevice(BluetoothDevice device) {
    final bleDevice = _addBleDeviceController(device);
    bleDevice.connect();
    return bleDevice;
  }

  BleDeviceController _addBleDeviceController(BluetoothDevice device) {
    final bleDevice = BleDeviceController(bluetoothDevice: device);
    _connectionStateStreamGroup
        .add(bleDevice.connectionStateStreamController.stream);
    _deviceInfoStreamGroup.add(bleDevice.deviceInfoStreamController.stream);
    _dispenseResponseStreamGroup
        .add(bleDevice.dispenseResponseStreamController.stream);
    _connectedDevices.add(bleDevice);
    return bleDevice;
  }

  void disconnectFromUnclaimedDevice(BluetoothDevice device) {
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

  void startBlinkOnUnclaimedDevice(BluetoothDevice device) {
    if (_connectedDevices.any(
        (element) => element.bluetoothDevice.remoteId == device.remoteId)) {
      final bleDevice = _connectedDevices.firstWhere(
          (element) => element.bluetoothDevice.remoteId == device.remoteId);
      bleDevice.startBlink();
    }
  }

  void stopBlinkOnUnclaimedDevice(BluetoothDevice device) {
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
