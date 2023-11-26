import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:livipod_app/controllers/livi_pod_controller.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../models/livi_pod.dart';

class LiviPodCommManager {
  LiviPod liviPod;
  late WebSocketChannel channel;
  Function onStateChange;

  final StreamController<String> _receiveCtrl =
      StreamController<String>.broadcast();
  final StreamController<dynamic> _sendCtrl = StreamController<dynamic>();

  Stream<String> get stream => _receiveCtrl.stream;
  get sink => _sendCtrl.sink;

  LiviPodCommManager({required this.liviPod, required this.onStateChange}) {
    _sendCtrl.stream.listen(_send);
    initWebSocketConnection();
  }

  initWebSocketConnection() async {
    liviPod.online = false;
    if (kDebugMode) {
      print("connecting...");
    }
    onStateChange();
    final success = await connectWs();
    if (success) {
      if (kDebugMode) {
        print("socket connection initialized");
      }

      liviPod.online = true;
      onStateChange();

      channel.stream.listen(
        (streamData) {
          _receiveCtrl.add(streamData);
        },
        onDone: () {
          debugPrint('ws channel closed');
          initWebSocketConnection();
        },
        onError: (error) {
          debugPrint('ws error $error');
          initWebSocketConnection();
        },
      );
    } else {
      initWebSocketConnection();
    }
  }

  void _send(event) {
    if (liviPod.online) {
      channel.sink.add(event);
    }
  }

  Future<bool> connectWs() async {
    try {
      channel = IOWebSocketChannel.connect(
          Uri.parse('ws://${liviPod.ipAddress}/livipod'),
          pingInterval: const Duration(seconds: 5));

      await channel.ready; // will await until we have a good connection
      return true;
    } catch (e) {
      if (kDebugMode) {
        print('Error! can not connect WS connectWs $e');
      }
      return false;
    }
  }
}

class CommunicationController extends ChangeNotifier {
  final List<LiviPodCommManager> _liviPodCommManagers = [];
  final LiviPodController liviPodController;

  List<LiviPodCommManager> get liviPodCommManagers => _liviPodCommManagers;

  CommunicationController({required this.liviPodController}) {
    liviPodController.listenToLiviPodsRealTime().listen(handleLiviPodStream);
  }

  void handleLiviPodStream(List<LiviPod> liviPods) {
    for (var liviPod in liviPods) {
      final index = _liviPodCommManagers.indexWhere(
          (element) => element.liviPod.macAddress == liviPod.macAddress);
      if (index == -1) {
        final liviPodCommManager = LiviPodCommManager(
            liviPod: liviPod,
            onStateChange: () {
              notifyListeners();
            });

        _liviPodCommManagers.add(liviPodCommManager);
      }
    }
  }
}
