import 'package:flutter/foundation.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:livipod_app/models/livi_pod.dart';

class DevicesController extends ChangeNotifier {
  final List<BluetoothDevice> _liviPodDevices = [];
  BluetoothAdapterState _state = BluetoothAdapterState.off;
  BluetoothDevice? _connectedDevice;
  BluetoothCharacteristic? _wifiCredentialsCharacteristic;
  LiviPod? _liviPod;

  BluetoothAdapterState get state => _state;
  List<BluetoothDevice> get liviPodDevices => _liviPodDevices;
  BluetoothDevice? get connectedDevice => _connectedDevice;
  LiviPod? get liviPod => _liviPod;

  DevicesController() {
    FlutterBluePlus.adapterState.listen((event) {
      _state = event;
      notifyListeners();
    });

    FlutterBluePlus.scanResults.listen((event) {
      List<BluetoothDevice> devicesToRemove = [];
      for (var c in _liviPodDevices) {
        if (!event.any((element) => element.device.remoteId == c.remoteId)) {
          devicesToRemove.add(c);
        }
      }
      for (var c in devicesToRemove) {
        _liviPodDevices
            .removeWhere((element) => element.remoteId == c.remoteId);
      }

      for (var r in event) {
        if (!_liviPodDevices
            .any((element) => element.remoteId == r.device.remoteId)) {
          _liviPodDevices.add(r.device);
        }
      }
      notifyListeners();
    });
  }

  void startBle() {
    _liviPodDevices.clear();
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

  void stopBle() {
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

  Future<void> connect(BluetoothDevice device) async {
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
        _connectedDevice = device;
        discoverServices();
      }
      notifyListeners();
    });

    await device.connect();
  }

  Future<void> disconnect() async {
    final remoteId = _connectedDevice?.remoteId;
    await _connectedDevice?.disconnect();
    _liviPodDevices.removeWhere((element) => element.remoteId == remoteId);
    notifyListeners();
  }

  Future<void> discoverServices() async {
    List<BluetoothService> services =
        await _connectedDevice!.discoverServices();
    for (var service in services) {
      if (kDebugMode) {
        print(service);
      }
      discoverServiceCharacteristics(service);
    }
  }

  void discoverServiceCharacteristics(BluetoothService service) {
    for (var characteristic in service.characteristics) {
      if (characteristic.uuid
          .toString()
          .startsWith("7cd5e90e-6379-41a5-9ad8-5ad71bc6d144")) {
        _wifiCredentialsCharacteristic = characteristic;
      } else if (characteristic.uuid
          .toString()
          .startsWith("b9662ed7-3a33-4c4d-b0d6-4adb77ad4d28")) {
        setupDeviceInfoListener(characteristic);
      }
    }
  }

  Future handleNotification(List<int> event) async {
    final remoteId = _connectedDevice!.remoteId;
    var temp = String.fromCharCodes(event);
    var list = temp.split(',');
    var mac = list[0];
    var ipAddress = list[1];
    var online = list[1] != '0';

    _liviPod = LiviPod(
        macAddress: mac,
        ipAddress: ipAddress,
        online: online,
        remoteId: remoteId.toString());

    await disconnect();
    notifyListeners();
  }

  Future<void> setupDeviceInfoListener(
      BluetoothCharacteristic characteristic) async {
    if (_connectedDevice?.isConnected ?? false) {
      await characteristic.setNotifyValue(true);
      characteristic.onValueReceived.listen(handleNotification);
    }
  }

  Future<void> sendCredentials(String ssid, String pwd) async {
    if (_connectedDevice != null && _wifiCredentialsCharacteristic != null) {
      var temp = '$ssid,$pwd;';
      await _wifiCredentialsCharacteristic!.write(temp.codeUnits);
      notifyListeners();
    }
  }
}
