import 'package:json_annotation/json_annotation.dart';

enum NotificationType {
  @JsonValue('medicationTaken')
  medicationTaken,
  @JsonValue('medicationAvailable')
  medicationAvailable,
  @JsonValue('medicationDue')
  medicationDue,
  @JsonValue('medicationLate')
  medicationLate,
  @JsonValue('medicationMissed')
  medicationMissed,
  @JsonValue('inventoryLow')
  inventoryLow,
  @JsonValue('inventoryEmpty')
  inventoryEmpty,
  @JsonValue('wifiUnavailable')
  wifiUnavailable,
  @JsonValue('none')
  none
}
