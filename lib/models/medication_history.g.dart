// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'medication_history.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MedicationHistory _$MedicationHistoryFromJson(Map<String, dynamic> json) =>
    MedicationHistory(
      dateTime: DateTime.parse(json['dateTime'] as String),
    )
      ..id = json['id'] as String?
      ..accountId = json['accountId'] as String
      ..name = json['name'] as String
      ..dosageForm =
          $enumDecodeNullable(_$DosageFormEnumMap, json['dosageForm'])
      ..medicationId = json['medicationId'] as String
      ..strength = json['strength'] as String?
      ..isOverride = json['isOverride'] as bool?
      ..medicationName = json['medicationName'] as String
      ..inventoryQuantity = json['inventoryQuantity'] as int?
      ..scheduleType =
          $enumDecodeNullable(_$ScheduleTypeEnumMap, json['scheduleType'])
      ..schedules = json['schedules'] as String?
      ..outcome = $enumDecodeNullable(_$DosingOutcomeEnumMap, json['outcome'])
      ..qtyDispensed = (json['qtyDispensed'] as num).toDouble()
      ..qtyMissed = (json['qtyMissed'] as num).toDouble()
      ..qtyRemaining = (json['qtyRemaining'] as num).toDouble()
      ..qtyRequested = (json['qtyRequested'] as num).toDouble()
      ..qtySkipped = (json['qtySkipped'] as num).toDouble()
      ..scheduledDosingTime = json['scheduledDosingTime'] == null
          ? null
          : DateTime.parse(json['scheduledDosingTime'] as String)
      ..appUserId = json['appUserId'] as String;

Map<String, dynamic> _$MedicationHistoryToJson(MedicationHistory instance) =>
    <String, dynamic>{
      'id': instance.id,
      'accountId': instance.accountId,
      'dateTime': instance.dateTime.toIso8601String(),
      'name': instance.name,
      'dosageForm': _$DosageFormEnumMap[instance.dosageForm],
      'medicationId': instance.medicationId,
      'strength': instance.strength,
      'isOverride': instance.isOverride,
      'medicationName': instance.medicationName,
      'inventoryQuantity': instance.inventoryQuantity,
      'scheduleType': _$ScheduleTypeEnumMap[instance.scheduleType],
      'schedules': instance.schedules,
      'outcome': _$DosingOutcomeEnumMap[instance.outcome],
      'qtyDispensed': instance.qtyDispensed,
      'qtyMissed': instance.qtyMissed,
      'qtyRemaining': instance.qtyRemaining,
      'qtyRequested': instance.qtyRequested,
      'qtySkipped': instance.qtySkipped,
      'scheduledDosingTime': instance.scheduledDosingTime?.toIso8601String(),
      'appUserId': instance.appUserId,
    };

const _$DosageFormEnumMap = {
  DosageForm.none: 'none',
  DosageForm.aerosol: 'aerosol',
  DosageForm.aerosol_foam: 'aerosol_foam',
  DosageForm.aerosol_metered: 'aerosol_metered',
  DosageForm.aerosol_powder: 'aerosol_powder',
  DosageForm.aerosol_spray: 'aerosol_spray',
  DosageForm.bar_chewable: 'bar_chewable',
  DosageForm.bead: 'bead',
  DosageForm.capsule: 'capsule',
  DosageForm.capsule_coated: 'capsule_coated',
  DosageForm.capsule_coated_pellets: 'capsule_coated_pellets',
  DosageForm.capsule_coated_extended_release: 'capsule_coated_extended_release',
  DosageForm.capsule_delayed_release: 'capsule_delayed_release',
  DosageForm.capsule_delayed_release_pellets: 'capsule_delayed_release_pellets',
  DosageForm.capsule_extended_release: 'capsule_extended_release',
  DosageForm.capsule_film_coated_extended_release:
      'capsule_film_coated_extended_release',
  DosageForm.capsule_gelatin_coated: 'capsule_gelatin_coated',
  DosageForm.capsule_liquid_filled: 'capsule_liquid_filled',
  DosageForm.cellular_sheet: 'cellular_sheet',
  DosageForm.chewable_gel: 'chewable_gel',
  DosageForm.cloth: 'cloth',
  DosageForm.concentrate: 'concentrate',
  DosageForm.cream: 'cream',
  DosageForm.cream_augmented: 'cream_augmented',
  DosageForm.crystal: 'crystal',
  DosageForm.disc: 'disc',
  DosageForm.douche: 'douche',
  DosageForm.dressing: 'dressing',
  DosageForm.drug_eluting_contact_lens: 'drug_eluting_contact_lens',
  DosageForm.elixir: 'elixir',
  DosageForm.emulsion: 'emulsion',
  DosageForm.enema: 'enema',
  DosageForm.extract: 'extract',
  DosageForm.fiber_extended_release: 'fiber_extended_release',
  DosageForm.film: 'film',
  DosageForm.film_extended_release: 'film_extended_release',
  DosageForm.film_soluble: 'film_soluble',
  DosageForm.for_solution: 'for_solution',
  DosageForm.for_suspension: 'for_suspension',
  DosageForm.for_suspension_extended_release: 'for_suspension_extended_release',
  DosageForm.gas: 'gas',
  DosageForm.gel: 'gel',
  DosageForm.gel_dentifrice: 'gel_dentifrice',
  DosageForm.gel_metered: 'gel_metered',
  DosageForm.globule: 'globule',
  DosageForm.granule: 'granule',
  DosageForm.granule_delayed_release: 'granule_delayed_release',
  DosageForm.granule_effervescent: 'granule_effervescent',
  DosageForm.granule_for_solution: 'granule_for_solution',
  DosageForm.granule_for_suspension: 'granule_for_suspension',
  DosageForm.granule_for_suspension_extended_release:
      'granule_for_suspension_extended_release',
  DosageForm.gum_chewing: 'gum_chewing',
  DosageForm.implant: 'implant',
  DosageForm.inhalant: 'inhalant',
  DosageForm.injectable_foam: 'injectable_foam',
  DosageForm.injectable_liposomal: 'injectable_liposomal',
  DosageForm.injection: 'injection',
  DosageForm.injection_emulsion: 'injection_emulsion',
  DosageForm.injection_lipid_complex: 'injection_lipid_complex',
  DosageForm.injection_powder_for_solution: 'injection_powder_for_solution',
  DosageForm.injection_powder_for_suspension: 'injection_powder_for_suspension',
  DosageForm.injection_powder_for_suspension_extended_release:
      'injection_powder_for_suspension_extended_release',
  DosageForm.injection_powder_lyophilized_for_liposomal_suspension:
      'injection_powder_lyophilized_for_liposomal_suspension',
  DosageForm.injection_powder_lyophilized_for_solution:
      'injection_powder_lyophilized_for_solution',
  DosageForm.injection_powder_lyophilized_for_suspension:
      'injection_powder_lyophilized_for_suspension',
  DosageForm.injection_powder_lyophilized_for_suspension_extended_release:
      'injection_powder_lyophilized_for_suspension_extended_release',
  DosageForm.injection_solution: 'injection_solution',
  DosageForm.injection_solution_concentrate: 'injection_solution_concentrate',
  DosageForm.injection_suspension: 'injection_suspension',
  DosageForm.injection_suspension_extended_release:
      'injection_suspension_extended_release',
  DosageForm.injection_suspension_liposomal: 'injection_suspension_liposomal',
  DosageForm.injection_suspension_sonicated: 'injection_suspension_sonicated',
  DosageForm.insert: 'insert',
  DosageForm.insert_extended_release: 'insert_extended_release',
  DosageForm.intrauterine_device: 'intrauterine_device',
  DosageForm.irrigant: 'irrigant',
  DosageForm.jelly: 'jelly',
  DosageForm.kit: 'kit',
  DosageForm.liniment: 'liniment',
  DosageForm.lipstick: 'lipstick',
  DosageForm.liquid: 'liquid',
  DosageForm.liquid_extended_release: 'liquid_extended_release',
  DosageForm.lotion: 'lotion',
  DosageForm.lotion_augmented: 'lotion_augmented',
  DosageForm.lotion_shampoo: 'lotion_shampoo',
  DosageForm.lozenge: 'lozenge',
  DosageForm.mouthwash: 'mouthwash',
  DosageForm.not_applicable: 'not_applicable',
  DosageForm.oil: 'oil',
  DosageForm.ointment: 'ointment',
  DosageForm.ointment_augmented: 'ointment_augmented',
  DosageForm.paste: 'paste',
  DosageForm.paste_dentifrice: 'paste_dentifrice',
  DosageForm.pastille: 'pastille',
  DosageForm.patch: 'patch',
  DosageForm.patch_extended_release: 'patch_extended_release',
  DosageForm.patch_extended_release_electrically_controlled:
      'patch_extended_release_electrically_controlled',
  DosageForm.pellet: 'pellet',
  DosageForm.pellet_implantable: 'pellet_implantable',
  DosageForm.pellets_coated_extended_release: 'pellets_coated_extended_release',
  DosageForm.pill: 'pill',
  DosageForm.plaster: 'plaster',
  DosageForm.poultice: 'poultice',
  DosageForm.powder: 'powder',
  DosageForm.powder_dentifrice: 'powder_dentifrice',
  DosageForm.powder_for_solution: 'powder_for_solution',
  DosageForm.powder_for_suspension: 'powder_for_suspension',
  DosageForm.powder_metered: 'powder_metered',
  DosageForm.ring: 'ring',
  DosageForm.rinse: 'rinse',
  DosageForm.salve: 'salve',
  DosageForm.shampoo: 'shampoo',
  DosageForm.shampoo_suspension: 'shampoo_suspension',
  DosageForm.soap: 'soap',
  DosageForm.solution: 'solution',
  DosageForm.solution_concentrate: 'solution_concentrate',
  DosageForm.solution_for_slush: 'solution_for_slush',
  DosageForm.solution_gel_forming_drops: 'solution_gel_forming_drops',
  DosageForm.solution_gel_forming_extended_release:
      'solution_gel_forming_extended_release',
  DosageForm.solution_drops: 'solution_drops',
  DosageForm.sponge: 'sponge',
  DosageForm.spray: 'spray',
  DosageForm.spray_metered: 'spray_metered',
  DosageForm.spray_suspension: 'spray_suspension',
  DosageForm.stick: 'stick',
  DosageForm.strip: 'strip',
  DosageForm.suppository: 'suppository',
  DosageForm.suppository_extended_release: 'suppository_extended_release',
  DosageForm.suspension: 'suspension',
  DosageForm.suspension_extended_release: 'suspension_extended_release',
  DosageForm.suspension_drops: 'suspension_drops',
  DosageForm.swab: 'swab',
  DosageForm.syrup: 'syrup',
  DosageForm.system: 'system',
  DosageForm.tablet: 'tablet',
  DosageForm.tablet_chewable: 'tablet_chewable',
  DosageForm.tablet_chewable_extended_release:
      'tablet_chewable_extended_release',
  DosageForm.tablet_coated: 'tablet_coated',
  DosageForm.tablet_coated_particles: 'tablet_coated_particles',
  DosageForm.tablet_delayed_release: 'tablet_delayed_release',
  DosageForm.tablet_delayed_release_particles:
      'tablet_delayed_release_particles',
  DosageForm.tablet_effervescent: 'tablet_effervescent',
  DosageForm.tablet_extended_release: 'tablet_extended_release',
  DosageForm.tablet_film_coated: 'tablet_film_coated',
  DosageForm.tablet_film_coated_extended_release:
      'tablet_film_coated_extended_release',
  DosageForm.tablet_for_solution: 'tablet_for_solution',
  DosageForm.tablet_for_suspension: 'tablet_for_suspension',
  DosageForm.tablet_multilayer: 'tablet_multilayer',
  DosageForm.tablet_multilayer_extended_release:
      'tablet_multilayer_extended_release',
  DosageForm.tablet_orally_disintegrating: 'tablet_orally_disintegrating',
  DosageForm.tablet_orally_disintegrating_delayed_release:
      'tablet_orally_disintegrating_delayed_release',
  DosageForm.tablet_soluble: 'tablet_soluble',
  DosageForm.tablet_sugar_coated: 'tablet_sugar_coated',
  DosageForm.tablet_with_sensor: 'tablet_with_sensor',
  DosageForm.tampon: 'tampon',
  DosageForm.tape: 'tape',
  DosageForm.tincture: 'tincture',
  DosageForm.troche: 'troche',
  DosageForm.other: 'other',
  DosageForm.wafer: 'wafer',
};

const _$ScheduleTypeEnumMap = {
  ScheduleType.asNeeded: 'asNeeded',
  ScheduleType.daily: 'daily',
  ScheduleType.weekly: 'weekly',
  ScheduleType.monthly: 'monthly',
};

const _$DosingOutcomeEnumMap = {
  DosingOutcome.missed: 'missed',
  DosingOutcome.skipped: 'skipped',
  DosingOutcome.taken: 'taken',
  DosingOutcome.jam: 'jam',
};
