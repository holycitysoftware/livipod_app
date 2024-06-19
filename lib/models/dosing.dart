import 'package:json_annotation/json_annotation.dart';

part 'dosing.g.dart';

enum DosingOutcome {
  @JsonValue('missed')
  missed,
  @JsonValue('skipped')
  skipped,
  @JsonValue('taken')
  taken,
  @JsonValue('jam')
  jam
}

@JsonSerializable(explicitToJson: true)
class Dosing {
  int dosingId = 0;
  DateTime? scheduledDosingTime;
  DateTime? lastDosingTime;
  double qtyRequested = 0;
  double qtyRemaining = 0;
  @JsonKey(defaultValue: 0)
  double qtySkipped = 0;
  @JsonKey(defaultValue: 0)
  double qtyMissed = 0;
  @JsonKey(defaultValue: 0)
  double qtyDispensed = 0;
  DosingOutcome? outcome;

  Dosing();

  factory Dosing.fromJson(Map<String, dynamic> json) => _$DosingFromJson(json);

  DateTime? get scheduledDosingTimeLocal {
    if (scheduledDosingTime == null) {
      return scheduledDosingTime;
    }
    return scheduledDosingTime!.toLocal();
  }

  Map<String, dynamic> toJson() => _$DosingToJson(this);
}
