import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sunrise_sunset_calc/sunrise_sunset_calc.dart';

import '../models/enums.dart';

import '../themes/livi_themes.dart';

int daysBetween(DateTime end, DateTime start) {
  return (end.difference(start).inHours / 24).round();
}

String getFormattedDate(DateTime? date) {
  if (date != null) {
    return DateFormat('MM/dd/yy').format(date);
  }
  return 'Never';
}

Widget dosageFormIcon({required DosageForm dosageForm, Color? color}) {
  switch (dosageForm) {
    case DosageForm.none:
      return LiviThemes.icons.tabletIcon(color: color);
    case DosageForm.capsule:
      return LiviThemes.icons.capsuleIcon(color: color);
    case DosageForm.tablet:
      return LiviThemes.icons.tabletIcon(color: color);
    // case DosageForm.drops:
    //   return LiviThemes.icons.dropsIcon(color: color);
    case DosageForm.injection:
      return LiviThemes.icons.injectionIcon(color: color);
    case DosageForm.ointment:
      return LiviThemes.icons.ointmentIcon(color: color);
    case DosageForm.liquid:
      return LiviThemes.icons.liquidIcon(color: color);
    case DosageForm.patch:
      return LiviThemes.icons.patchIcon(color: color);
    case DosageForm.other:
      return LiviThemes.icons.otherDotsHorizontalIcon(color: color);

    case DosageForm.aerosol:
      return LiviThemes.icons.liquidIcon(color: color);
    case DosageForm.aerosol_foam:
      return LiviThemes.icons.liquidIcon(color: color);
    case DosageForm.aerosol_metered:
      return LiviThemes.icons.liquidIcon(color: color);
    case DosageForm.aerosol_powder:
      return LiviThemes.icons.liquidIcon(color: color);
    case DosageForm.aerosol_spray:
      return LiviThemes.icons.liquidIcon(color: color);
    case DosageForm.bar_chewable:
      return LiviThemes.icons.otherDotsHorizontalIcon(color: color);
    case DosageForm.bead:
      return LiviThemes.icons.capsuleIcon(color: color);
    case DosageForm.capsule_coated:
      return LiviThemes.icons.capsuleIcon(color: color);
    case DosageForm.capsule_coated_pellets:
      return LiviThemes.icons.capsuleIcon(color: color);
    case DosageForm.capsule_coated_extended_release:
      return LiviThemes.icons.capsuleIcon(color: color);
    case DosageForm.capsule_delayed_release:
      return LiviThemes.icons.capsuleIcon(color: color);
    case DosageForm.capsule_delayed_release_pellets:
      return LiviThemes.icons.capsuleIcon(color: color);
    case DosageForm.capsule_extended_release:
      return LiviThemes.icons.capsuleIcon(color: color);
    case DosageForm.capsule_film_coated_extended_release:
      return LiviThemes.icons.capsuleIcon(color: color);
    case DosageForm.capsule_gelatin_coated:
      return LiviThemes.icons.capsuleIcon(color: color);
    case DosageForm.capsule_liquid_filled:
      return LiviThemes.icons.capsuleIcon(color: color);
    case DosageForm.cellular_sheet:
      return LiviThemes.icons.otherDotsHorizontalIcon(color: color);
    case DosageForm.chewable_gel:
      return LiviThemes.icons.otherDotsHorizontalIcon(color: color);
    case DosageForm.cloth:
      return LiviThemes.icons.otherDotsHorizontalIcon(color: color);
    case DosageForm.concentrate:
      return LiviThemes.icons.liquidIcon(color: color);
    case DosageForm.cream:
      return LiviThemes.icons.ointmentIcon(color: color);
    case DosageForm.cream_augmented:
      return LiviThemes.icons.liquidIcon(color: color);
    case DosageForm.crystal:
      return LiviThemes.icons.otherDotsHorizontalIcon(color: color);
    case DosageForm.disc:
      return LiviThemes.icons.otherDotsHorizontalIcon(color: color);
    case DosageForm.douche:
      return LiviThemes.icons.otherDotsHorizontalIcon(color: color);
    case DosageForm.dressing:
      return LiviThemes.icons.otherDotsHorizontalIcon(color: color);
    case DosageForm.drug_eluting_contact_lens:
      return LiviThemes.icons.otherDotsHorizontalIcon(color: color);
    case DosageForm.elixir:
      return LiviThemes.icons.liquidIcon(color: color);
    case DosageForm.emulsion:
      return LiviThemes.icons.liquidIcon(color: color);
    case DosageForm.enema:
      return LiviThemes.icons.otherDotsHorizontalIcon(color: color);
    case DosageForm.extract:
      return LiviThemes.icons.otherDotsHorizontalIcon(color: color);
    case DosageForm.fiber_extended_release:
      return LiviThemes.icons.otherDotsHorizontalIcon(color: color);
    case DosageForm.film:
      return LiviThemes.icons.otherDotsHorizontalIcon(color: color);
    case DosageForm.film_extended_release:
      return LiviThemes.icons.otherDotsHorizontalIcon(color: color);
    case DosageForm.film_soluble:
      return LiviThemes.icons.otherDotsHorizontalIcon(color: color);
    case DosageForm.for_solution:
      return LiviThemes.icons.otherDotsHorizontalIcon(color: color);
    case DosageForm.for_suspension:
      return LiviThemes.icons.otherDotsHorizontalIcon(color: color);
    case DosageForm.for_suspension_extended_release:
      return LiviThemes.icons.otherDotsHorizontalIcon(color: color);
    case DosageForm.gas:
      return LiviThemes.icons.otherDotsHorizontalIcon(color: color);
    case DosageForm.gel:
      return LiviThemes.icons.ointmentIcon(color: color);
    case DosageForm.gel_dentifrice:
      return LiviThemes.icons.ointmentIcon(color: color);
    case DosageForm.gel_metered:
      return LiviThemes.icons.ointmentIcon(color: color);
    case DosageForm.globule:
      return LiviThemes.icons.otherDotsHorizontalIcon(color: color);
    case DosageForm.granule:
      return LiviThemes.icons.otherDotsHorizontalIcon(color: color);
    case DosageForm.granule_delayed_release:
      return LiviThemes.icons.otherDotsHorizontalIcon(color: color);
    case DosageForm.granule_effervescent:
      return LiviThemes.icons.otherDotsHorizontalIcon(color: color);
    case DosageForm.granule_for_solution:
      return LiviThemes.icons.otherDotsHorizontalIcon(color: color);
    case DosageForm.granule_for_suspension:
      return LiviThemes.icons.otherDotsHorizontalIcon(color: color);
    case DosageForm.granule_for_suspension_extended_release:
      return LiviThemes.icons.otherDotsHorizontalIcon(color: color);
    case DosageForm.gum_chewing:
      return LiviThemes.icons.otherDotsHorizontalIcon(color: color);
    case DosageForm.implant:
      return LiviThemes.icons.otherDotsHorizontalIcon(color: color);
    case DosageForm.inhalant:
      return LiviThemes.icons.otherDotsHorizontalIcon(color: color);
    case DosageForm.injectable_foam:
      return LiviThemes.icons.injectionIcon(color: color);
    case DosageForm.injectable_liposomal:
      return LiviThemes.icons.injectionIcon(color: color);
    case DosageForm.injection_emulsion:
      return LiviThemes.icons.injectionIcon(color: color);
    case DosageForm.injection_lipid_complex:
      return LiviThemes.icons.injectionIcon(color: color);
    case DosageForm.injection_powder_for_solution:
      return LiviThemes.icons.injectionIcon(color: color);
    case DosageForm.injection_powder_for_suspension:
      return LiviThemes.icons.injectionIcon(color: color);
    case DosageForm.injection_powder_for_suspension_extended_release:
      return LiviThemes.icons.injectionIcon(color: color);
    case DosageForm.injection_powder_lyophilized_for_liposomal_suspension:
      return LiviThemes.icons.injectionIcon(color: color);
    case DosageForm.injection_powder_lyophilized_for_solution:
      return LiviThemes.icons.injectionIcon(color: color);
    case DosageForm.injection_powder_lyophilized_for_suspension:
      return LiviThemes.icons.injectionIcon(color: color);
    case DosageForm
          .injection_powder_lyophilized_for_suspension_extended_release:
    case DosageForm.injection_solution:
      return LiviThemes.icons.injectionIcon(color: color);
    case DosageForm.injection_solution_concentrate:
      return LiviThemes.icons.injectionIcon(color: color);
    case DosageForm.injection_suspension:
      return LiviThemes.icons.injectionIcon(color: color);
    case DosageForm.injection_suspension_extended_release:
      return LiviThemes.icons.injectionIcon(color: color);
    case DosageForm.injection_suspension_liposomal:
      return LiviThemes.icons.injectionIcon(color: color);
    case DosageForm.injection_suspension_sonicated:
      return LiviThemes.icons.injectionIcon(color: color);
    case DosageForm.insert:
      return LiviThemes.icons.otherDotsHorizontalIcon(color: color);
    case DosageForm.insert_extended_release:
      return LiviThemes.icons.otherDotsHorizontalIcon(color: color);
    case DosageForm.intrauterine_device:
      return LiviThemes.icons.otherDotsHorizontalIcon(color: color);
    case DosageForm.irrigant:
      return LiviThemes.icons.otherDotsHorizontalIcon(color: color);
    case DosageForm.jelly:
      return LiviThemes.icons.otherDotsHorizontalIcon(color: color);
    case DosageForm.kit:
      return LiviThemes.icons.otherDotsHorizontalIcon(color: color);
    case DosageForm.liniment:
      return LiviThemes.icons.ointmentIcon(color: color);
    case DosageForm.lipstick:
      return LiviThemes.icons.otherDotsHorizontalIcon(color: color);
    case DosageForm.liquid_extended_release:
      return LiviThemes.icons.liquidIcon(color: color);
    case DosageForm.lotion:
      return LiviThemes.icons.liquidIcon(color: color);
    case DosageForm.lotion_augmented:
      return LiviThemes.icons.liquidIcon(color: color);
    case DosageForm.lotion_shampoo:
      return LiviThemes.icons.liquidIcon(color: color);
    case DosageForm.lozenge:
      return LiviThemes.icons.tabletIcon(color: color);
    case DosageForm.mouthwash:
      return LiviThemes.icons.liquidIcon(color: color);
    case DosageForm.not_applicable:
      return LiviThemes.icons.otherDotsHorizontalIcon(color: color);
    case DosageForm.oil:
      return LiviThemes.icons.liquidIcon(color: color);
    case DosageForm.ointment_augmented:
      return LiviThemes.icons.ointmentIcon(color: color);
    case DosageForm.paste:
      return LiviThemes.icons.otherDotsHorizontalIcon(color: color);
    case DosageForm.paste_dentifrice:
      return LiviThemes.icons.otherDotsHorizontalIcon(color: color);
    case DosageForm.pastille:
      return LiviThemes.icons.tabletIcon(color: color);
    case DosageForm.patch_extended_release:
      return LiviThemes.icons.patchIcon(color: color);
    case DosageForm.patch_extended_release_electrically_controlled:
      return LiviThemes.icons.patchIcon(color: color);
    case DosageForm.pellet:
      return LiviThemes.icons.otherDotsHorizontalIcon(color: color);
    case DosageForm.pellet_implantable:
      return LiviThemes.icons.otherDotsHorizontalIcon(color: color);
    case DosageForm.pellets_coated_extended_release:
      return LiviThemes.icons.otherDotsHorizontalIcon(color: color);
    case DosageForm.pill:
      return LiviThemes.icons.capsuleIcon(color: color);
    case DosageForm.plaster:
      return LiviThemes.icons.patchIcon(color: color);
    case DosageForm.poultice:
      return LiviThemes.icons.otherDotsHorizontalIcon(color: color);
    case DosageForm.powder:
      return LiviThemes.icons.otherDotsHorizontalIcon(color: color);
    case DosageForm.powder_dentifrice:
      return LiviThemes.icons.otherDotsHorizontalIcon(color: color);
    case DosageForm.powder_for_solution:
      return LiviThemes.icons.otherDotsHorizontalIcon(color: color);
    case DosageForm.powder_for_suspension:
      return LiviThemes.icons.otherDotsHorizontalIcon(color: color);
    case DosageForm.powder_metered:
      return LiviThemes.icons.otherDotsHorizontalIcon(color: color);
    case DosageForm.ring:
      return LiviThemes.icons.otherDotsHorizontalIcon(color: color);
    case DosageForm.rinse:
      return LiviThemes.icons.liquidIcon(color: color);
    case DosageForm.salve:
      return LiviThemes.icons.otherDotsHorizontalIcon(color: color);
    case DosageForm.shampoo:
      return LiviThemes.icons.liquidIcon(color: color);
    case DosageForm.shampoo_suspension:
      return LiviThemes.icons.liquidIcon(color: color);
    case DosageForm.soap:
      return LiviThemes.icons.otherDotsHorizontalIcon(color: color);
    case DosageForm.solution:
      return LiviThemes.icons.liquidIcon(color: color);
    case DosageForm.solution_concentrate:
      return LiviThemes.icons.liquidIcon(color: color);
    case DosageForm.solution_for_slush:
      return LiviThemes.icons.liquidIcon(color: color);
    case DosageForm.solution_gel_forming_drops:
      return LiviThemes.icons.liquidIcon(color: color);
    case DosageForm.solution_gel_forming_extended_release:
      return LiviThemes.icons.liquidIcon(color: color);
    case DosageForm.solution_drops:
      return LiviThemes.icons.liquidIcon(color: color);
    case DosageForm.sponge:
      return LiviThemes.icons.otherDotsHorizontalIcon(color: color);
    case DosageForm.spray:
      return LiviThemes.icons.otherDotsHorizontalIcon(color: color);
    case DosageForm.spray_metered:
      return LiviThemes.icons.otherDotsHorizontalIcon(color: color);
    case DosageForm.spray_suspension:
      return LiviThemes.icons.otherDotsHorizontalIcon(color: color);
    case DosageForm.stick:
      return LiviThemes.icons.otherDotsHorizontalIcon(color: color);
    case DosageForm.strip:
      return LiviThemes.icons.otherDotsHorizontalIcon(color: color);
    case DosageForm.suppository:
      return LiviThemes.icons.otherDotsHorizontalIcon(color: color);
    case DosageForm.suppository_extended_release:
      return LiviThemes.icons.otherDotsHorizontalIcon(color: color);
    case DosageForm.suspension:
      return LiviThemes.icons.otherDotsHorizontalIcon(color: color);
    case DosageForm.suspension_extended_release:
      return LiviThemes.icons.otherDotsHorizontalIcon(color: color);
    case DosageForm.suspension_drops:
      return LiviThemes.icons.liquidIcon(color: color);
    case DosageForm.swab:
      return LiviThemes.icons.otherDotsHorizontalIcon(color: color);
    case DosageForm.syrup:
      return LiviThemes.icons.liquidIcon(color: color);
    case DosageForm.system:
      return LiviThemes.icons.otherDotsHorizontalIcon(color: color);
    case DosageForm.tablet_chewable:
      return LiviThemes.icons.tabletIcon(color: color);
    case DosageForm.tablet_chewable_extended_release:
      return LiviThemes.icons.tabletIcon(color: color);
    case DosageForm.tablet_coated:
      return LiviThemes.icons.tabletIcon(color: color);
    case DosageForm.tablet_coated_particles:
      return LiviThemes.icons.tabletIcon(color: color);
    case DosageForm.tablet_delayed_release:
      return LiviThemes.icons.tabletIcon(color: color);
    case DosageForm.tablet_delayed_release_particles:
      return LiviThemes.icons.tabletIcon(color: color);
    case DosageForm.tablet_effervescent:
      return LiviThemes.icons.tabletIcon(color: color);
    case DosageForm.tablet_extended_release:
      return LiviThemes.icons.tabletIcon(color: color);
    case DosageForm.tablet_film_coated:
      return LiviThemes.icons.tabletIcon(color: color);
    case DosageForm.tablet_film_coated_extended_release:
      return LiviThemes.icons.tabletIcon(color: color);
    case DosageForm.tablet_for_solution:
      return LiviThemes.icons.tabletIcon(color: color);
    case DosageForm.tablet_for_suspension:
      return LiviThemes.icons.tabletIcon(color: color);
    case DosageForm.tablet_multilayer:
      return LiviThemes.icons.tabletIcon(color: color);
    case DosageForm.tablet_multilayer_extended_release:
      return LiviThemes.icons.tabletIcon(color: color);
    case DosageForm.tablet_orally_disintegrating:
      return LiviThemes.icons.tabletIcon(color: color);
    case DosageForm.tablet_orally_disintegrating_delayed_release:
      return LiviThemes.icons.tabletIcon(color: color);
    case DosageForm.tablet_soluble:
      return LiviThemes.icons.tabletIcon(color: color);
    case DosageForm.tablet_sugar_coated:
      return LiviThemes.icons.tabletIcon(color: color);
    case DosageForm.tablet_with_sensor:
      return LiviThemes.icons.tabletIcon(color: color);
    case DosageForm.tampon:
      return LiviThemes.icons.otherDotsHorizontalIcon(color: color);
    case DosageForm.tape:
      return LiviThemes.icons.otherDotsHorizontalIcon(color: color);
    case DosageForm.tincture:
      return LiviThemes.icons.liquidIcon(color: color);
    case DosageForm.troche:
      return LiviThemes.icons.otherDotsHorizontalIcon(color: color);
    case DosageForm.wafer:
      return LiviThemes.icons.otherDotsHorizontalIcon(color: color);
  }
}

String getStringFromDateTimeInteger(int day) {
  switch (day) {
    case 0:
      return 'Sunday';
    case 1:
      return 'Monday';
    case 2:
      return 'Tuesday';
    case 3:
      return 'Wednesday';
    case 4:
      return 'Thursday';
    case 5:
      return 'Friday';
    case 6:
      return 'Saturday';
    default:
      return '';
  }
}

String getFormattedTime(DateTime? date) {
  if (date != null) {
    return DateFormat('h:mm a').format(date);
  } else {
    return '-';
  }
}

String getFormattedLocalDateAndTime(DateTime? date) {
  if (date != null) {
    date = date.toLocal();
    return DateFormat('MM/dd/yy h:mm a').format(date);
  }
  return 'Never';
}

String getFormattedDateAndTime(DateTime? date) {
  if (date != null) {
    return DateFormat('MM/dd/yy h:mm a').format(date);
  }
  return 'Never';
}

String removeDecimalZeroFormat(double n) {
  return n.toStringAsFixed(n.truncateToDouble() == n ? 0 : 1);
}

String getDay(int index) {
  switch (index) {
    case 0:
      return 'Sunday';
    case 1:
      return 'Monday';
    case 2:
      return 'Tuesday';
    case 3:
      return 'Wednesday';
    case 4:
      return 'Thursday';
    case 5:
      return 'Friday';
    case 6:
      return 'Saturday';
    default:
      return 'Unknown';
  }
}

String formartDay(int day) {
  switch (day) {
    case 1:
      return '1st';
    case 2:
      return '2nd';
    case 3:
      return '3rd';
    default:
      return '${day}th';
  }
}

String formartTimeOfDay(TimeOfDay timeOfDat) {
  //ap pm hour
  String ap = timeOfDat.period == DayPeriod.am ? 'AM' : 'PM';
  String hour = timeOfDat.hourOfPeriod.toString();
  String minute = timeOfDat.minute.toString();
  hour = hour;
  if (timeOfDat.minute < 10) {
    minute = '0$minute';
  }
  return '$hour:$minute $ap';
}
