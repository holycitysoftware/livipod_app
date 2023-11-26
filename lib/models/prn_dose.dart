import 'package:json_annotation/json_annotation.dart';

part 'prn_dose.g.dart';

@JsonSerializable()
class PrnDose {
  double minQty = 1;
  double maxQty = 1;
  double nteQty = 1;
  int hourInterval = 4;

  PrnDose();

  factory PrnDose.fromJson(Map<String, dynamic> json) =>
      _$PrnDoseFromJson(json);

  Map<String, dynamic> toJson() => _$PrnDoseToJson(this);
}
