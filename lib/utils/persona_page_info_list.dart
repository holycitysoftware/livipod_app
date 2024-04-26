import '../models/models.dart';
import 'strings.dart';

List<PersonaPageInfo> personaPageInfoList = const [
  PersonaPageInfo(
    index: 1,
    question: Strings.howComfortableAreYou,
    options: [
      PersonaOption(
          index: 1,
          appUserType: AppUserType.selfGuidedUser,
          option: Strings.veryComfortable),
      PersonaOption(
          index: 1,
          appUserType: AppUserType.assistedUser,
          option: Strings.somewhatComfortable),
      PersonaOption(
          index: 1,
          appUserType: AppUserType.caredForUser,
          option: Strings.notVeryComfortable),
    ],
  ),
  PersonaPageInfo(
    index: 2,
    question: Strings.doYouUsuallyRememberToTake,
    options: [
      PersonaOption(
          index: 2,
          appUserType: AppUserType.selfGuidedUser,
          option: Strings.always),
      PersonaOption(
          index: 2,
          appUserType: AppUserType.assistedUser,
          option: Strings.mostOfTheTime),
      PersonaOption(
          index: 2,
          appUserType: AppUserType.caredForUser,
          option: Strings.rarelyOrNever),
    ],
  ),
  PersonaPageInfo(
    index: 3,
    question: Strings.howOftenDoYouNeedAssistance,
    options: [
      PersonaOption(
          index: 3,
          appUserType: AppUserType.caredForUser,
          option: Strings.frequently),
      PersonaOption(
          index: 3,
          appUserType: AppUserType.assistedUser,
          option: Strings.occasionally),
      PersonaOption(
          index: 3,
          appUserType: AppUserType.selfGuidedUser,
          option: Strings.never),
    ],
  ),
  PersonaPageInfo(
    index: 4,
    question: Strings.haveYouEverMissedADose,
    options: [
      PersonaOption(
          index: 4,
          appUserType: AppUserType.caredForUser,
          option: Strings.frequently),
      PersonaOption(
          index: 4,
          appUserType: AppUserType.assistedUser,
          option: Strings.occasionally),
      PersonaOption(
          index: 4,
          appUserType: AppUserType.selfGuidedUser,
          option: Strings.never),
    ],
  ),
  PersonaPageInfo(
    index: 5,
    question: Strings.doYouHaveAnyDifficulties,
    options: [
      PersonaOption(
          index: 5,
          appUserType: AppUserType.selfGuidedUser,
          option: Strings.noDifficulties),
      PersonaOption(
          index: 5,
          appUserType: AppUserType.assistedUser,
          option: Strings.someDifficulties),
      PersonaOption(
          index: 5,
          appUserType: AppUserType.caredForUser,
          option: Strings.significantDifficulties),
    ],
  ),
  PersonaPageInfo(
    index: 6,
    question: Strings.areYouCurrentlyManagingYourOwn,
    options: [
      PersonaOption(
          index: 6,
          appUserType: AppUserType.selfGuidedUser,
          option: Strings.yesIndependently),
      PersonaOption(
          index: 6,
          appUserType: AppUserType.assistedUser,
          option: Strings.withSomeAssistance),
      PersonaOption(
          index: 6,
          appUserType: AppUserType.caredForUser,
          option: Strings.noSomeoneElseManages),
    ],
  ),
  PersonaPageInfo(
    index: 7,
    question: Strings.howWouldYouRateYourAbilityTo,
    options: [
      PersonaOption(
          index: 7,
          appUserType: AppUserType.selfGuidedUser,
          option: Strings.excellent),
      PersonaOption(
          index: 7,
          appUserType: AppUserType.assistedUser,
          option: Strings.fair),
      PersonaOption(
          index: 7,
          appUserType: AppUserType.caredForUser,
          option: Strings.poor),
    ],
  ),
  PersonaPageInfo(
    index: 8,
    question: Strings.doYouHaveAnyMedicalConditionsThat,
    options: [
      PersonaOption(
          index: 8,
          appUserType: AppUserType.selfGuidedUser,
          option: Strings.no),
      PersonaOption(
          index: 8,
          appUserType: AppUserType.assistedUser,
          option: Strings.yesMildConditions),
      PersonaOption(
          index: 8,
          appUserType: AppUserType.caredForUser,
          option: Strings.yesSevereConditions),
    ],
  ),
];
