import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/communication_controller.dart';
import '../models/command_response.dart';

class LiviPodDispensingView extends StatefulWidget {
  final LiviPodCommManager liviPodCommManager;
  const LiviPodDispensingView({super.key, required this.liviPodCommManager});

  @override
  State<LiviPodDispensingView> createState() => _LiviPodDispensingViewState();
}

class _LiviPodDispensingViewState extends State<LiviPodDispensingView> {
  DispenseStatus _status = DispenseStatus.idle;
  int _dispensed = 0;
  int _requested = 0;
  bool _done = false;

  @override
  void initState() {
    widget.liviPodCommManager.stream.listen(handleEvent);
    super.initState();
  }

  @override
  void dispose() {
    widget.liviPodCommManager.stream.listen(handleEvent).cancel();
    super.dispose();
  }

  void handleEvent(event) {
    final commandResponse = CommandResponse.fromJson(json.decode(event));
    handleResponse(commandResponse);
  }

  Future handleResponse(CommandResponse commandResponse) async {
    if (mounted && commandResponse.event == ResponseEvent.dispensing) {
      setState(() {
        _status = commandResponse.status;
        _dispensed = commandResponse.dispensed;
        _requested = commandResponse.requested;
      });
    } else if (mounted &&
        commandResponse.event == ResponseEvent.commandReceived) {
      Navigator.pop(context);
    }
  }

  void confirm() {
    widget.liviPodCommManager.sink.add("{\"command\": \"CONFIRM\"}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('LiviPod Dispensing')),
        body: Consumer<CommunicationController>(
          builder: (context, value, child) {
            return WillPopScope(
              onWillPop: () {
                return Future.value(_done);
              },
              child: Container(
                width: double.infinity,
                height: double.infinity,
                color: widget.liviPodCommManager.liviPod.online
                    ? Colors.green[200]
                    : Colors.red[200],
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Center(
                    child: Column(children: [
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Dispensing',
                            textAlign: TextAlign.center,
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '$_dispensed of $_requested',
                            textAlign: TextAlign.center,
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _status.name,
                            textAlign: TextAlign.center,
                          )
                        ],
                      ),
                      if (_status == DispenseStatus.complete) ...[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                                onPressed: () {
                                  confirm();
                                },
                                child: const Text('Confirm'))
                          ],
                        )
                      ]
                    ]),
                  ),
                ),
              ),
            );
          },
        ));
  }
}
