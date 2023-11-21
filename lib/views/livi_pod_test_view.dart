import 'package:flutter/material.dart';
import 'package:livipod_app/models/livi_pod.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;

class LiviPodTestView extends StatefulWidget {
  final LiviPod liviPod;
  const LiviPodTestView({super.key, required this.liviPod});

  @override
  State<LiviPodTestView> createState() => _LiviPodTestViewState();
}

class _LiviPodTestViewState extends State<LiviPodTestView> {
  late final WebSocketChannel _channel;

  @override
  void initState() {
    _channel = WebSocketChannel.connect(
        Uri.parse('ws://${widget.liviPod.ipAddress}/livipod'));
    _channel.stream.listen(_handleMessage);
    super.initState();
  }

  void _handleMessage(dynamic message) {
    print(message);
    _channel.sink.add('received!');
    _channel.sink.close(status.goingAway);
  }

  @override
  void dispose() {
    _channel.stream.listen(_handleMessage).cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('LiviPod Test')),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.grey[350],
      ),
    );
  }
}
