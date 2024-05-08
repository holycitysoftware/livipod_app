import 'package:json_annotation/json_annotation.dart';

part 'prn_dose.g.dart';

@JsonSerializable()

///As the thing is needed
class PrnDose {
  double minQty = 1;
  double maxQty = 1;

  ///Not to exceed quantity
  double nteQty = 1;
  int hourInterval = 4;

  PrnDose();

  factory PrnDose.fromJson(Map<String, dynamic> json) =>
      _$PrnDoseFromJson(json);

  Map<String, dynamic> toJson() => _$PrnDoseToJson(this);
}
