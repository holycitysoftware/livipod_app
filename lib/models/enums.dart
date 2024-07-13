import 'package:flutter/material.dart';

import '../utils/strings.dart';

enum DosageForm implements Comparable<DosageForm> {
  none(description: Strings.none, isAlsoCustomDosageForm: true),
  aerosol(description: Strings.aerosol),
  aerosol_foam(description: Strings.aerosol_foam),
  aerosol_metered(description: Strings.aerosol_metered),
  aerosol_powder(description: Strings.aerosol_powder),
  aerosol_spray(description: Strings.aerosol_spray),
  bar_chewable(description: Strings.bar_chewable),
  bead(description: Strings.bead),
  capsule(description: Strings.capsule),
  capsule_coated(description: Strings.capsule_coated),
  capsule_coated_pellets(description: Strings.capsule_coated_pellets),
  capsule_coated_extended_release(
      description: Strings.capsule_coated_extended_release),
  capsule_delayed_release(description: Strings.capsule_delayed_release),
  capsule_delayed_release_pellets(
      description: Strings.capsule_delayed_release_pellets),
  capsule_extended_release(description: Strings.capsule_extended_release),
  capsule_film_coated_extended_release(
      description: Strings.capsule_film_coated_extended_release),
  capsule_gelatin_coated(description: Strings.capsule_gelatin_coated),
  capsule_liquid_filled(description: Strings.capsule_liquid_filled),
  cellular_sheet(description: Strings.cellular_sheet),
  chewable_gel(description: Strings.chewable_gel),
  cloth(description: Strings.cloth),
  concentrate(description: Strings.concentrate),
  cream(description: Strings.cream),
  cream_augmented(description: Strings.cream_augmented),
  crystal(description: Strings.crystal),
  disc(description: Strings.disc),
  douche(description: Strings.douche),
  dressing(description: Strings.dressing),
  drug_eluting_contact_lens(description: Strings.drug_eluting_contact_lens),
  elixir(description: Strings.elixir),
  emulsion(description: Strings.emulsion),
  enema(description: Strings.enema),
  extract(description: Strings.extract),
  fiber_extended_release(description: Strings.fiber_extended_release),
  film(description: Strings.film),
  film_extended_release(description: Strings.film_extended_release),
  film_soluble(description: Strings.film_soluble),
  for_solution(description: Strings.for_solution),
  for_suspension(description: Strings.for_suspension),
  for_suspension_extended_release(
      description: Strings.for_suspension_extended_release),
  gas(description: Strings.gas),
  gel(description: Strings.gel),
  gel_dentifrice(description: Strings.gel_dentifrice),
  gel_metered(description: Strings.gel_metered),
  globule(description: Strings.globule),
  granule(description: Strings.granule),
  granule_delayed_release(description: Strings.granule_delayed_release),
  granule_effervescent(description: Strings.granule_effervescent),
  granule_for_solution(description: Strings.granule_for_solution),
  granule_for_suspension(description: Strings.granule_for_suspension),
  granule_for_suspension_extended_release(
      description: Strings.granule_for_suspension_extended_release),
  gum_chewing(description: Strings.gum_chewing),
  implant(description: Strings.implant),
  inhalant(description: Strings.inhalant),
  injectable_foam(description: Strings.injectable_foam),
  injectable_liposomal(description: Strings.injectable_liposomal),
  injection(description: Strings.injection),
  injection_emulsion(description: Strings.injection_emulsion),
  injection_lipid_complex(description: Strings.injection_lipid_complex),
  injection_powder_for_solution(
      description: Strings.injection_powder_for_solution),
  injection_powder_for_suspension(
      description: Strings.injection_powder_for_suspension),
  injection_powder_for_suspension_extended_release(
      description: Strings.injection_powder_for_suspension_extended_release),
  injection_powder_lyophilized_for_liposomal_suspension(
      description:
          Strings.injection_powder_lyophilized_for_liposomal_suspension),
  injection_powder_lyophilized_for_solution(
      description: Strings.injection_powder_lyophilized_for_solution),
  injection_powder_lyophilized_for_suspension(
      description: Strings.injection_powder_lyophilized_for_suspension),
  injection_powder_lyophilized_for_suspension_extended_release(
      description:
          Strings.injection_powder_lyophilized_for_suspension_extended_release),
  injection_solution(description: Strings.injection_solution),
  injection_solution_concentrate(
      description: Strings.injection_solution_concentrate),
  injection_suspension(description: Strings.injection_suspension),
  injection_suspension_extended_release(
      description: Strings.injection_suspension_extended_release),
  injection_suspension_liposomal(
      description: Strings.injection_suspension_liposomal),
  injection_suspension_sonicated(
      description: Strings.injection_suspension_sonicated),
  insert(description: Strings.insert),
  insert_extended_release(description: Strings.insert_extended_release),
  intrauterine_device(description: Strings.intrauterine_device),
  irrigant(description: Strings.irrigant),
  jelly(description: Strings.jelly),
  kit(description: Strings.kit),
  liniment(description: Strings.liniment),
  lipstick(description: Strings.lipstick),
  liquid(description: Strings.liquid),
  liquid_extended_release(description: Strings.liquid_extended_release),
  lotion(description: Strings.lotion),
  lotion_augmented(description: Strings.lotion_augmented),
  lotion_shampoo(description: Strings.lotion_shampoo),
  lozenge(description: Strings.lozenge),
  mouthwash(description: Strings.mouthwash),
  not_applicable(description: Strings.not_applicable),
  oil(description: Strings.oil),
  ointment(description: Strings.ointment),
  ointment_augmented(description: Strings.ointment_augmented),
  paste(description: Strings.paste),
  paste_dentifrice(description: Strings.paste_dentifrice),
  pastille(description: Strings.pastille),
  patch(description: Strings.patch),
  patch_extended_release(description: Strings.patch_extended_release),
  patch_extended_release_electrically_controlled(
      description: Strings.patch_extended_release_electrically_controlled),
  pellet(description: Strings.pellet),
  pellet_implantable(description: Strings.pellet_implantable),
  pellets_coated_extended_release(
      description: Strings.pellets_coated_extended_release),
  pill(description: Strings.pill),
  plaster(description: Strings.plaster),
  poultice(description: Strings.poultice),
  powder(description: Strings.powder),
  powder_dentifrice(description: Strings.powder_dentifrice),
  powder_for_solution(description: Strings.powder_for_solution),
  powder_for_suspension(description: Strings.powder_for_suspension),
  powder_metered(description: Strings.powder_metered),
  ring(description: Strings.ring),
  rinse(description: Strings.rinse),
  salve(description: Strings.salve),
  shampoo(description: Strings.shampoo),
  shampoo_suspension(description: Strings.shampoo_suspension),
  soap(description: Strings.soap),
  solution(description: Strings.solution),
  solution_concentrate(description: Strings.solution_concentrate),
  solution_for_slush(description: Strings.solution_for_slush),
  solution_gel_forming_drops(description: Strings.solution_gel_forming_drops),
  solution_gel_forming_extended_release(
      description: Strings.solution_gel_forming_extended_release),
  solution_drops(description: Strings.solution_drops),
  sponge(description: Strings.sponge),
  spray(description: Strings.spray),
  spray_metered(description: Strings.spray_metered),
  spray_suspension(description: Strings.spray_suspension),
  stick(description: Strings.stick),
  strip(description: Strings.strip),
  suppository(description: Strings.suppository),
  suppository_extended_release(
      description: Strings.suppository_extended_release),
  suspension(description: Strings.suspension),
  suspension_extended_release(description: Strings.suspension_extended_release),
  suspension_drops(description: Strings.suspension_drops),
  swab(description: Strings.swab),
  syrup(description: Strings.syrup),
  system(description: Strings.system),
  tablet(description: Strings.tablet),
  tablet_chewable(description: Strings.tablet_chewable),
  tablet_chewable_extended_release(
      description: Strings.tablet_chewable_extended_release),
  tablet_coated(description: Strings.tablet_coated),
  tablet_coated_particles(description: Strings.tablet_coated_particles),
  tablet_delayed_release(description: Strings.tablet_delayed_release),
  tablet_delayed_release_particles(
      description: Strings.tablet_delayed_release_particles),
  tablet_effervescent(description: Strings.tablet_effervescent),
  tablet_extended_release(description: Strings.tablet_extended_release),
  tablet_film_coated(description: Strings.tablet_film_coated),
  tablet_film_coated_extended_release(
      description: Strings.tablet_film_coated_extended_release),
  tablet_for_solution(description: Strings.tablet_for_solution),
  tablet_for_suspension(description: Strings.tablet_for_suspension),
  tablet_multilayer(description: Strings.tablet_multilayer),
  tablet_multilayer_extended_release(
      description: Strings.tablet_multilayer_extended_release),
  tablet_orally_disintegrating(
      description: Strings.tablet_orally_disintegrating),
  tablet_orally_disintegrating_delayed_release(
      description: Strings.tablet_orally_disintegrating_delayed_release),
  tablet_soluble(description: Strings.tablet_soluble),
  tablet_sugar_coated(description: Strings.tablet_sugar_coated),
  tablet_with_sensor(description: Strings.tablet_with_sensor),
  tampon(description: Strings.tampon),
  tape(description: Strings.tape),
  tincture(description: Strings.tincture),
  troche(description: Strings.troche),
  other(description: Strings.other, isAlsoCustomDosageForm: true),
  wafer(description: Strings.wafer);

  const DosageForm({
    required this.description,
    this.isAlsoCustomDosageForm = false,
  });

  final String description;
  final bool? isAlsoCustomDosageForm;

  @override
  String toString() => description;

  @override
  int compareTo(DosageForm other) => description.compareTo(other.description);
}

enum DayTime implements Comparable<DayTime> {
  am(description: Strings.AM),
  pm(description: Strings.PM);

  const DayTime({
    required this.description,
  });

  final String description;

  @override
  String toString() => description;

  @override
  int compareTo(DayTime other) => description.compareTo(other.description);
}

enum TimeReminderBefore implements Comparable<TimeReminderBefore> {
  oneMinute(
    description: Strings.oneMinuteBefore,
    duration: Duration(minutes: 1),
  ),
  twoMinute(
    description: Strings.twoMinutesBefore,
    duration: Duration(minutes: 2),
  ),
  fiveMinutes(
    description: Strings.fiveMinutesBefore,
    duration: Duration(minutes: 5),
  ),
  tenMinutes(
    description: Strings.tenMinutesBefore,
    duration: Duration(minutes: 10),
  ),
  thirthyMinutes(
    description: Strings.thirthyMinutesBefore,
    duration: Duration(minutes: 30),
  ),
  oneHour(
    description: Strings.oneHourBefore,
    duration: Duration(hours: 1),
  ),
  twoHours(
    description: Strings.twoHoursBefore,
    duration: Duration(hours: 2),
  ),
  threeHours(
    description: Strings.threeHoursBefore,
    duration: Duration(hours: 3),
  );

  const TimeReminderBefore({
    required this.description,
    required this.duration,
  });

  final String description;
  final Duration duration;

  @override
  String toString() => description;

  @override
  int compareTo(TimeReminderBefore other) => duration.compareTo(other.duration);
}

enum TimeReminderLater implements Comparable<TimeReminderLater> {
  oneMinute(
    description: Strings.oneMinuteLater,
    duration: Duration(minutes: 1),
  ),
  twoMinute(
    description: Strings.twoMinutesLater,
    duration: Duration(minutes: 2),
  ),
  fiveMinutes(
    description: Strings.fiveMinutesLater,
    duration: Duration(minutes: 5),
  ),
  tenMinutes(
    description: Strings.tenMinutesLater,
    duration: Duration(minutes: 10),
  ),
  thirthyMinutes(
    description: Strings.thirthyMinutesLater,
    duration: Duration(minutes: 30),
  ),
  oneHour(
    description: Strings.oneHourLater,
    duration: Duration(hours: 1),
  ),
  twoHours(
    description: Strings.twoHoursLater,
    duration: Duration(hours: 2),
  ),
  threeHours(
    description: Strings.threeHoursLater,
    duration: Duration(hours: 3),
  );

  const TimeReminderLater({
    required this.description,
    required this.duration,
  });

  final String description;
  final Duration duration;

  @override
  String toString() => description;

  @override
  int compareTo(TimeReminderLater other) => duration.compareTo(other.duration);
}

enum IntervalBetweenDoses implements Comparable<IntervalBetweenDoses> {
  oneHour(
    description: Strings.oneHour,
    duration: Duration(hours: 1),
  ),
  twoHours(
    description: Strings.twoHours,
    duration: Duration(hours: 2),
  ),
  threeHours(
    description: Strings.threeHours,
    duration: Duration(hours: 3),
  ),
  fourHours(
    description: Strings.fourHours,
    duration: Duration(hours: 4),
  ),
  fiveHours(
    description: Strings.fiveHours,
    duration: Duration(hours: 5),
  ),
  sixHours(
    description: Strings.sixHours,
    duration: Duration(hours: 6),
  ),
  sevenHours(
    description: Strings.sevenHours,
    duration: Duration(hours: 7),
  ),
  eightHours(
    description: Strings.eightHours,
    duration: Duration(hours: 8),
  ),
  nineHours(
    description: Strings.nineHours,
    duration: Duration(hours: 9),
  ),
  tenHours(
    description: Strings.tenHours,
    duration: Duration(hours: 10),
  ),
  elevenHours(
    description: Strings.elevenHours,
    duration: Duration(hours: 11),
  ),
  twelveHours(
    description: Strings.twelveHours,
    duration: Duration(hours: 12),
  ),
  thirteenHours(
    description: Strings.thirteenHours,
    duration: Duration(hours: 13),
  ),
  fourteenHours(
    description: Strings.fourteenHours,
    duration: Duration(hours: 14),
  ),
  fifteenHours(
    description: Strings.fifteenHours,
    duration: Duration(hours: 15),
  ),
  sixteenHours(
    description: Strings.sixteenHours,
    duration: Duration(hours: 16),
  ),
  seventeenHours(
    description: Strings.seventeenHours,
    duration: Duration(hours: 17),
  ),
  eighteenHours(
    description: Strings.eighteenHours,
    duration: Duration(hours: 18),
  ),
  nineteenHours(
    description: Strings.nineteenHours,
    duration: Duration(hours: 19),
  ),
  twentyHours(
    description: Strings.twentyHours,
    duration: Duration(hours: 20),
  ),
  twentyOneHours(
    description: Strings.twentyOneHours,
    duration: Duration(hours: 21),
  ),
  twentyTwoHours(
    description: Strings.twentyTwoHours,
    duration: Duration(hours: 22),
  ),
  twentyThreeHours(
    description: Strings.twentyThreeHours,
    duration: Duration(hours: 23),
  ),
  twentyFourHours(
    description: Strings.twentyFourHours,
    duration: Duration(hours: 24),
  );

  const IntervalBetweenDoses({
    required this.description,
    required this.duration,
  });

  final String description;
  final Duration duration;

  @override
  String toString() => description;

  @override
  int compareTo(IntervalBetweenDoses other) =>
      duration.compareTo(other.duration);
}

enum Days implements Comparable<Days> {
  sunday(description: Strings.sunday),
  monday(description: Strings.monday),
  tuesday(description: Strings.tuesday),
  wednesday(description: Strings.wednesday),
  thursday(description: Strings.thursday),
  friday(description: Strings.friday),
  saturday(description: Strings.saturday);

  const Days({
    required this.description,
  });

  final String description;

  @override
  String toString() => description;

  @override
  int compareTo(Days other) => description.compareTo(other.description);
}

enum PeriodOfDay {
  morning(
      description: Strings.morning,
      startTime: TimeOfDay(hour: 6, minute: 0),
      endTime: TimeOfDay(hour: 11, minute: 59),
      colors: [Color(0xffDEEDF6), Color(0xffEBEDE2)]),
  afternoon(
      description: Strings.afternoon,
      startTime: TimeOfDay(hour: 12, minute: 0),
      endTime: TimeOfDay(hour: 16, minute: 59),
      colors: [Color(0xffF9F7F0), Color(0xffEED3CB)]),
  night(
      description: Strings.night,
      startTime: TimeOfDay(hour: 17, minute: 0),
      endTime: TimeOfDay(hour: 5, minute: 59),
      colors: [Color(0xffE4E2DD), Color(0xffBFC2D7)]);

  const PeriodOfDay({
    required this.description,
    required this.startTime,
    required this.endTime,
    required this.colors,
  });

  static PeriodOfDay getPeriodOfDayColors() {
    final now = DateTime.now();
    final morningStartTime = DateTime(now.year, now.month, now.day,
        morning.startTime.hour, morning.startTime.minute);
    final morningEndTime = DateTime(now.year, now.month, now.day,
        morning.endTime.hour, morning.endTime.minute);
    final afternoonStartTime = DateTime(now.year, now.month, now.day,
        afternoon.startTime.hour, afternoon.startTime.minute);
    final afternoonEndTime = DateTime(now.year, now.month, now.day,
        afternoon.endTime.hour, afternoon.endTime.minute);
    final nightStartTime = DateTime(now.year, now.month, now.day,
        night.startTime.hour, night.startTime.minute);
    final nightEndTime = DateTime(now.year, now.month, now.day + 1,
        night.endTime.hour, night.endTime.minute);
    final midnight = DateTime(now.year, now.month, now.day, 23, 59);
    final midnightFollowingDay = DateTime(now.year, now.month, now.day);

    if (now.isAfter(morningStartTime) && now.isBefore(morningEndTime)) {
      return morning;
    }
    if (now.isAfter(afternoonStartTime) && now.isBefore(afternoonEndTime)) {
      return afternoon;
    }

    if (now.isAfter(nightStartTime) && now.isBefore(midnight)) {
      return night;
    }
    if (now.isAfter(midnightFollowingDay) && now.isBefore(nightEndTime)) {
      return night;
    }
    return morning;
  }

  final String description;
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final List<Color> colors;
}
