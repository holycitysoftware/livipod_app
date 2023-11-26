import 'package:flutter/material.dart';
import 'package:flutter_spinbox/material.dart';
import 'package:livipod_app/controllers/communication_controller.dart';
import 'package:livipod_app/models/command_response.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:visibility_detector/visibility_detector.dart';

import 'livi_pod_dispensing_view.dart';

class LiviPodTestView extends StatefulWidget {
  final LiviPodCommManager liviPodCommManager;
  const LiviPodTestView({super.key, required this.liviPodCommManager});

  @override
  State<LiviPodTestView> createState() => _LiviPodTestViewState();
}

class _LiviPodTestViewState extends State<LiviPodTestView> {
  double _requestQty = 1;
  double _visibleFraction = 0.0;

  @override
  void initState() {
    //widget.liviPodCommManager.stream.listen(handleEvent);
    super.initState();
  }

  @override
  void dispose() {
    //widget.liviPodCommManager.stream.listen(handleEvent).cancel();
    super.dispose();
  }

  void handleEvent(event) {
    print(event);
    final commandResponse = CommandResponse.fromJson(json.decode(event));
    handleResponse(commandResponse);
  }

  void dispense() {
    widget.liviPodCommManager.sink
        .add("{\"command\": \"DISPENSE\", \"param1\": $_requestQty}");
  }

  void setDispenseQty(value) {
    if (mounted) {
      setState(() {
        _requestQty = value;
      });
    }
  }

  Future handleResponse(CommandResponse commandResponse) async {
    if (mounted &&
        commandResponse.event == ResponseEvent.commandReceived &&
        commandResponse.result == 0) {
      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: commandResponse.result == 0
                ? const Text('failure!')
                : const Text('success!'),
            actions: [
              ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Close'))
            ],
          );
        },
      );
    } else if (_visibleFraction == 1.0 &&
        commandResponse.event != ResponseEvent.dispensing) {
      // since we will continue receiveing event updates make sure to only
      // push if we are visible and triggered
      Navigator.push(context, MaterialPageRoute(
        builder: (context) {
          return LiviPodDispensingView(
            liviPodCommManager: widget.liviPodCommManager,
          );
        },
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('LiviPod Test')),
        body: Consumer<CommunicationController>(
          builder: (context, value, child) {
            return VisibilityDetector(
              key: const Key('livi-pod-test-key'),
              onVisibilityChanged: (info) {
                if (info.visibleFraction == 1.0) {
                  widget.liviPodCommManager.stream.listen(handleEvent);
                } else {
                  widget.liviPodCommManager.stream.listen(handleEvent).cancel();
                }
                _visibleFraction = info.visibleFraction;
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
                      SpinBox(
                        min: 1,
                        max: 10,
                        value: _requestQty,
                        onChanged: (value) {
                          setDispenseQty(value);
                        },
                        spacing: 8,
                        direction: Axis.vertical,
                        textStyle: const TextStyle(fontSize: 30),
                        incrementIcon: const Icon(
                          Icons.keyboard_arrow_up,
                          size: 64,
                        ),
                        decrementIcon:
                            const Icon(Icons.keyboard_arrow_down, size: 64),
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.all(24)),
                      ),
                      ElevatedButton(
                          onPressed: () {
                            dispense();
                          },
                          child: const Text('Dispense'))
                    ]),
                  ),
                ),
              ),
            );
          },
        ));
  }
}
