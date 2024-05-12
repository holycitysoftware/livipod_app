import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class BleDeviceController {
  final StreamController<BleDeviceInfo> deviceInfoStreamController =
      StreamController<BleDeviceInfo>.broadcast();
  final StreamController<DispenseRequest> dispenseResponseStreamController =
      StreamController<DispenseRequest>.broadcast();
  final StreamController<Map<String, BluetoothConnectionState>>
      connectionStateStreamController =
      StreamController<Map<String, BluetoothConnectionState>>.broadcast();
  final BluetoothDevice bluetoothDevice;
  final List<BluetoothService> _services = [];
  BluetoothConnectionState deviceState = BluetoothConnectionState.disconnected;
  bool _readyForCommands = false;

  //bool _userDisconnect = false;
  final List<BluetoothCharacteristic> _claimCharacteristics = [];
  final List<BluetoothCharacteristic> _unclaimCharacteristics = [];
  final List<BluetoothCharacteristic> _blinkCharacteristics = [];
  final List<BluetoothCharacteristic> _wifiCredentialsCharacteristics = [];
  final List<BluetoothCharacteristic> _resetCharacteristics = [];
  final List<BluetoothCharacteristic> _dispenseCharacteristics = [];

  bool get readyForCommands => _readyForCommands;

  BleDeviceController({required this.bluetoothDevice});

  void _setupStreams() {
    bluetoothDevice.connectionState.listen(_handleConnectionState);
  }

  void _cancelStreams() {
    bluetoothDevice.connectionState.listen(_handleConnectionState).cancel();
  }

  void _handleConnectionState(BluetoothConnectionState event) {
    deviceState = event;

    if (event == BluetoothConnectionState.connected) {
      if (kDebugMode) {
        print('The ${bluetoothDevice.advName} device is connected');
      }
      bluetoothDevice.discoverServices().then((services) {
        _services.addAll(services);
        _discoverServiceCharacteristics();
        _readyForCommands = true;
        // this will stream to all clients listening
        connectionStateStreamController.sink
            .add({bluetoothDevice.remoteId.str: event});
      });
    } else {
      if (kDebugMode) {
        print('The ${bluetoothDevice.advName} device is disconnected');
      }
      _readyForCommands = false;
      // this will stream to all clients listening
      connectionStateStreamController.sink
          .add({bluetoothDevice.remoteId.str: event});
      // // 1. typically, start a periodic timer that tries to
      // //    reconnect, or just call connect() again right now
      // // 2. you must always re-discover services after disconnection!
      // if (!_userDisconnect) {
      //   Timer.periodic(const Duration(seconds: 5), (timer) async {
      //     if (bluetoothDevice.isConnected) {
      //       timer.cancel();
      //       _userDisconnect = false;
      //     } else {
      //       try {
      //         await bluetoothDevice.connect();
      //       } on FlutterBluePlusException catch (ex) {
      //         if (kDebugMode) {
      //           print(ex);
      //         }
      //       } on PlatformException catch (pex) {
      //         if (kDebugMode) {
      //           print(pex);
      //         }
      //       } catch (e) {
      //         if (kDebugMode) {
      //           print(e);
      //         }
      //       }
      //     }
      //   });
      // }
    }
  }

  void _discoverServiceCharacteristics() {
    for (final service in _services) {
      for (final characteristic in service.characteristics) {
        if (characteristic.uuid
            .toString()
            .startsWith('7cd5e90e-6379-41a5-9ad8-5ad71bc6d144')) {
          _claimCharacteristics.add(characteristic);
        } else if (characteristic.uuid
            .toString()
            .startsWith('b9662ed7-3a33-4c4d-b0d6-4adb77ad4d28')) {
          _setupDeviceInfoListener(characteristic);
        } else if (characteristic.uuid
            .toString()
            .startsWith('7736aff1-758b-45ae-8349-95581a16f905')) {
          _unclaimCharacteristics.add(characteristic);
        } else if (characteristic.uuid
            .toString()
            .startsWith('7832d8b7-d7df-4501-894e-1ac87edc8c3d')) {
          _blinkCharacteristics.add(characteristic);
        } else if (characteristic.uuid
            .toString()
            .startsWith('8a336a00-8c6d-49f6-840b-ca88987c636b')) {
          _wifiCredentialsCharacteristics.add(characteristic);
        } else if (characteristic.uuid
            .toString()
            .startsWith('de0f7bcc-cdc7-4beb-b006-d182ad7ca6cb')) {
          _resetCharacteristics.add(characteristic);
        } else if (characteristic.uuid
            .toString()
            .startsWith('a4a1b894-db82-4c34-9cd2-681acd27b5f0')) {
          _dispenseCharacteristics.add(characteristic);
        } else if (characteristic.uuid
            .toString()
            .startsWith('f8d4cd48-6f60-49df-82f8-9e6316025aeb')) {
          _setupDispenseResponseListener(characteristic);
        }
      }
    }
  }

  Future<void> _setupDispenseResponseListener(
      BluetoothCharacteristic characteristic) async {
    if (bluetoothDevice.isConnected) {
      await characteristic.setNotifyValue(true);
      characteristic.onValueReceived.listen(
        (e) {
          // parse // event,requested,dispensed,status
          final temp = String.fromCharCodes(e);
          final list = temp.split(',');
          final event = list[0];
          final requested = int.parse(list[1]);
          final dispensed = int.parse(list[2]);
          final status = list[3];

          final dr = DispenseRequest(
              bleDeviceController: this,
              event: event,
              requested: requested,
              dispensed: dispensed,
              status: status);
          dispenseResponseStreamController.sink.add(dr);
        },
      );
    }
  }

  Future<void> _setupDeviceInfoListener(
      BluetoothCharacteristic characteristic) async {
    if (bluetoothDevice.isConnected) {
      await characteristic.setNotifyValue(true);
      characteristic.onValueReceived.listen(
        (event) {
          // parse the ip and mac address
          final temp = String.fromCharCodes(event);
          final list = temp.split(',');
          final mac = list[0];
          final ipAddress = list[1];
          final deviceInfo = BleDeviceInfo(
              bleDeviceController: this, macAddress: mac, ipAddress: ipAddress);
          deviceInfoStreamController.sink.add(deviceInfo);
        },
      );
    }
  }

  Future enableWifi(String ssid, String password) async {
    final index = _wifiCredentialsCharacteristics.indexWhere(
        (element) => element.device.remoteId == bluetoothDevice.remoteId);
    if (index != -1 &&
        _wifiCredentialsCharacteristics[index].device.isConnected) {
      var data = '$ssid,$password;';
      await _wifiCredentialsCharacteristics[index].write(data.codeUnits);
    }
  }

  Future disableWifi() async {}

  Future claim(String id) async {
    final index = _claimCharacteristics.indexWhere(
        (element) => element.device.remoteId == bluetoothDevice.remoteId);
    if (index != -1 && _claimCharacteristics[index].device.isConnected) {
      await _claimCharacteristics[index].write(id.codeUnits);
    }
  }

  Future unclaim() async {
    final index = _unclaimCharacteristics.indexWhere(
        (element) => element.device.remoteId == bluetoothDevice.remoteId);
    if (index != -1 && _unclaimCharacteristics[index].device.isConnected) {
      await _unclaimCharacteristics[index].write([0x01]);
    }
  }

  Future startBlink() async {
    final index = _blinkCharacteristics.indexWhere(
        (element) => element.device.remoteId == bluetoothDevice.remoteId);
    if (index != -1 && _blinkCharacteristics[index].device.isConnected) {
      await _blinkCharacteristics[index].write([0x01]);
    }
  }

  Future stopBlink() async {
    final index = _blinkCharacteristics.indexWhere(
        (element) => element.device.remoteId == bluetoothDevice.remoteId);
    if (index != -1 && _blinkCharacteristics[index].device.isConnected) {
      await _blinkCharacteristics[index].write([0x02]);
    }
  }

  void connect() {
    //_userDisconnect = false;
    _setupStreams();
    bluetoothDevice
        .connect()
        .then((value) => null)
        .onError((error, stackTrace) {
      if (kDebugMode) {
        print(error);
      }
    }).catchError((error) {
      if (kDebugMode) {
        print(error);
      }
    });
  }

  void disconnect() async {
    //_userDisconnect = true;
    bluetoothDevice.disconnect().then((value) {
      _cancelStreams();
    }).onError((error, stackTrace) {
      if (kDebugMode) {
        print(error);
      }
    }).catchError((error) {
      if (kDebugMode) {
        print(error);
      }
    });
  }

  Future<void> reset() async {
    final index = _resetCharacteristics.indexWhere(
        (element) => element.device.remoteId == bluetoothDevice.remoteId);
    if (index != -1 && _resetCharacteristics[index].device.isConnected) {
      await _resetCharacteristics[index].write([0x01]);
    }
  }

  Future<void> dispense(DispenseRequest dr) async {
    final index = _dispenseCharacteristics.indexWhere(
        (element) => element.device.remoteId == bluetoothDevice.remoteId);
    if (index != -1 && _dispenseCharacteristics[index].device.isConnected) {
      await _dispenseCharacteristics[index].write([dr.requested]);
    }
  }
}

class BleDeviceInfo {
  final BleDeviceController bleDeviceController;
  final String macAddress;
  final String ipAddress;

  BleDeviceInfo(
      {required this.bleDeviceController,
      required this.macAddress,
      required this.ipAddress});
}

class DispenseRequest {
  final BleDeviceController bleDeviceController;
  final String event;
  final int requested;
  final int dispensed;
  final String status;

  DispenseRequest(
      {required this.bleDeviceController,
      required this.event,
      required this.requested,
      required this.dispensed,
      required this.status});
}
