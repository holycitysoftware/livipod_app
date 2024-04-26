import 'models.dart';

class PersonaPageInfo {
  const PersonaPageInfo({
    required this.index,
    required this.question,
    required this.options,
  });

  ///Index goes from 1 - 8
  final int index;
  final List<PersonaOption> options;
  final String question;
}

class PersonaOption {
  final int index;
  final AppUserType appUserType;
  final String option;

  const PersonaOption({
    required this.index,
    required this.appUserType,
    required this.option,
  });
}
