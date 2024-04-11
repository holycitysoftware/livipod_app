import 'dart:async';

import 'package:flutter/foundation.dart';

import '../models/dosing.dart';
import '../models/livi_pod.dart';
import '../models/schedule_type.dart';
import 'livi_pod_controller.dart';

class ScheduleController extends ChangeNotifier {
  final LiviPodController liviPodController;

  ScheduleController({required this.liviPodController}) {
    Timer.periodic(const Duration(minutes: 1), (timer) async {
      // get the livipods for this user
      final liviPods = await liviPodController.getLiviPods(/* account */);
      for (var liviPod in liviPods) {
        // get dosing history for this pod
        // var dosings = ........
        schedule(liviPod /* dosings */);
      }
      // schedule
    });
  }

  void schedule(LiviPod liviPod) {
    if (liviPod.schedule != null) {
      switch (liviPod.schedule!.type) {
        case ScheduleType.asNeeded:
          _scheduleAsNeeded(liviPod);
          break;
        case ScheduleType.daily:
          _scheduleDaily(liviPod);
          break;
        case ScheduleType.weekly:
        // TODO: Handle this case.
        case ScheduleType.monthly:
        // TODO: Handle this case
      }
    }
  }

  void _scheduleAsNeeded(LiviPod liviPod) {
    final schedule = liviPod.schedule!;
    if (liviPod.nextDosing == null) {
      liviPod.nextDosing = Dosing();
      liviPod.nextDosing!.scheduledDosingTime = DateTime.now();
      liviPod.nextDosing!.qtyRequested = schedule.prnDosing!.maxQty;
    } else {}
  }

  void _scheduleDaily(LiviPod liviPod) {}
}
