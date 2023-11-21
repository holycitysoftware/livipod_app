import 'package:flutter/material.dart';
import 'package:livipod_app/controllers/livi_pod_controller.dart';
import 'package:provider/provider.dart';

import '../models/livi_pod.dart';
import 'livi_pod_test_view.dart';

class LiviPodsView extends StatefulWidget {
  const LiviPodsView({super.key});

  @override
  State<LiviPodsView> createState() => _LiviPodsViewState();
}

class _LiviPodsViewState extends State<LiviPodsView> {
  late final LiviPodController _liviPodController;
  final List<LiviPod> _pods = [];

  @override
  void initState() {
    _liviPodController = Provider.of<LiviPodController>(context, listen: false);
    _liviPodController.listenToLiviPodsRealTime().listen(handleLiviPods);
    super.initState();
  }

  @override
  void dispose() {
    _liviPodController
        .listenToLiviPodsRealTime()
        .listen(handleLiviPods)
        .cancel();
    super.dispose();
  }

  void handleLiviPods(List<LiviPod> pods) {
    if (mounted) {
      setState(() {
        _pods.addAll(pods);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: ListView.builder(
        itemCount: _pods.length,
        itemBuilder: (context, index) {
          final pod = _pods[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (context) {
                  return LiviPodTestView(
                    liviPod: pod,
                  );
                },
              ));
            },
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Text(pod.macAddress),
              ),
            ),
          );
        },
      ),
    );
  }
}
