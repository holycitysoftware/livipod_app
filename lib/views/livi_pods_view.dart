import 'package:flutter/material.dart';
import 'package:livipod_app/controllers/communication_controller.dart';
import 'package:livipod_app/views/medication_view.dart';
import 'package:provider/provider.dart';

import 'livi_pod_test_view.dart';

class LiviPodsView extends StatefulWidget {
  const LiviPodsView({super.key});

  @override
  State<LiviPodsView> createState() => _LiviPodsViewState();
}

class _LiviPodsViewState extends State<LiviPodsView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(20.0),
        child: Consumer<CommunicationController>(
          builder: (context, value, child) {
            return ListView.builder(
              itemCount: value.liviPodCommManagers.length,
              itemBuilder: (context, index) {
                final liviPodCommManager = value.liviPodCommManagers[index];
                return ListTile(
                  onLongPress: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return LiviPodTestView(
                          liviPodCommManager: liviPodCommManager,
                        );
                      },
                    ));
                  },
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return MedicationView(
                          liviPod: liviPodCommManager.liviPod,
                        );
                      },
                    ));
                  },
                  title: const Text('unassigned'),
                  subtitle: Text(liviPodCommManager.liviPod.macAddress),
                  trailing: liviPodCommManager.liviPod.online
                      ? Icon(
                          Icons.link,
                          color: Colors.green[200],
                        )
                      : Icon(Icons.link_off, color: Colors.red[200]),
                  // tileColor: liviPodCommManager.liviPod.online
                  //     ? Colors.green[200]
                  //     : Colors.red[200],
                );
              },
            );
          },
        ));
  }
}
