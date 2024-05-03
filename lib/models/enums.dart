import '../utils/strings.dart';

enum DosageForm implements Comparable<DosageForm> {
  none(description: Strings.none),
  capsule(description: Strings.capsule),
  tablet(description: Strings.tablet),
  drops(description: Strings.drops),
  injection(description: Strings.injection),
  ointment(description: Strings.ointment),
  liquid(description: Strings.liquid),
  patch(description: Strings.patch),
  other(description: Strings.other);

  const DosageForm({
    required this.description,
  });

  final String description;

  @override
  String toString() => description;

  @override
  int compareTo(DosageForm other) => description.compareTo(other.description);
}
