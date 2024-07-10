import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:regexed_validator/regexed_validator.dart';

import '../components/components.dart';
import '../models/enums.dart';

import '../themes/livi_spacing/livi_spacing.dart';
import '../themes/livi_themes.dart';
import 'strings.dart';

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

String getFirstLettersOfName(String name) {
  String firstLetter = '';
  String secondLetter = '';
  final splittedNames = name.split('');
  firstLetter = splittedNames.first[0];
  if (splittedNames.length > 1) {
    secondLetter = splittedNames.last[0];
  }
  return '$firstLetter$secondLetter'.toUpperCase();
}

Future<String?> updateImage(BuildContext context, String base64) async {
  String? imageValue;
  await showModalBottomSheet(
    context: context,
    builder: (context) => Container(
      padding: const EdgeInsets.all(kSpacer_16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Expanded(
                child: ListTile(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(60)),
                  leading: Icon(
                    Icons.camera_alt,
                    color: LiviThemes.colors.brand600,
                  ),
                  title: LiviTextStyles.interRegular16(Strings.takePicture),
                  onTap: () async {
                    imageValue = await takePicture(ImageSource.camera);
                    if (imageValue != null) {
                      Navigator.pop(context);
                    }
                  },
                ),
              ),
            ],
          ),
          LiviDivider(),
          Row(
            children: [
              Expanded(
                child: ListTile(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(60)),
                  leading: Icon(
                    Icons.image,
                    color: LiviThemes.colors.brand600,
                  ),
                  title: LiviTextStyles.interRegular16(Strings.pickImage),
                  onTap: () async {
                    imageValue = await takePicture(ImageSource.gallery);
                    if (imageValue != null) {
                      Navigator.pop(context);
                    }
                  },
                ),
              ),
            ],
          ),
          if (base64.isNotEmpty) LiviDivider(),
          if (base64.isNotEmpty)
            Row(
              children: [
                Expanded(
                  child: ListTile(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(60)),
                    leading: LiviThemes.icons
                        .trash1Icon(color: LiviThemes.colors.error500),
                    title: LiviTextStyles.interRegular16(Strings.deleteImage),
                    onTap: () async {
                      imageValue = '';
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            )
        ],
      ),
    ),
  );

  return imageValue;
}

final ImagePicker _picker = ImagePicker();

Future<String?> takePicture(
  ImageSource source,
) async {
  try {
    final xfile = _picker.pickImage(
      source: source,
      requestFullMetadata: false,
      imageQuality: 20,
    );
    final resultImage = await xfile;
    if (resultImage == null) {
      return null;
    }
    final croppedFile = await _cropImage(resultImage);
    if (croppedFile == null) {
      return null;
    }
    final xfileCropped = XFile.fromData(await croppedFile.readAsBytes());
    final imageList = await convertToListInt(xfileCropped);
    if (imageList != null) {
      return base64Encode(imageList);
    }
    return null;
  } catch (e, s) {
    print(e.toString());
    print(s.toString());
  }
}

String? validateEmail(String email) {
  var validEmail = true;

  if (email.isNotEmpty) {
    validEmail = validator.email(email);
  } else {
    return null;
  }
  if (!validEmail) {
    return 'Invalid email';
  } else {
    return null;
  }
}

String? validatePhone(String phone) {
  final validPhone = validator.phone(phone);

  if (!validPhone) {
    return 'Invalid phone number.';
  } else {
    return null;
  }
}

Future<CroppedFile?> _cropImage(XFile file) async {
  if (file != null) {
    return ImageCropper().cropImage(
      sourcePath: file.path,
      cropStyle: CropStyle.circle,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Edit image',
          toolbarWidgetColor: LiviThemes.colors.brand500,
          toolbarColor: LiviThemes.colors.baseWhite,
          cropGridColor: LiviThemes.colors.brand500,
          activeControlsWidgetColor: LiviThemes.colors.brand500,
          initAspectRatio: CropAspectRatioPreset.ratio4x3,
          cropGridColumnCount: 1,
          lockAspectRatio: true,
        ),
        IOSUiSettings(
          title: 'Edit image',
          aspectRatioLockEnabled: true,
          aspectRatioPickerButtonHidden: true,
        ),
      ],
    );
  }
  return null;
}

Future<List<int>?> convertToListInt(XFile? file) async {
  if (file != null) {
    return file.readAsBytes();
  }
  return null;
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
