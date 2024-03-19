import 'package:json_annotation/json_annotation.dart';

enum AppUserType {
  @JsonValue('selfGuidedUser')
  selfGuidedUser,
  @JsonValue('assistedUser')
  assistedUser,
  @JsonValue('caredForUser')
  caredForUser,
  @JsonValue('caregiver')
  caregiver
}

extension ParseToString on AppUserType {
  String toUppercaseString() {
    return toString().split('.').last.toUpperCase();
  }
}
