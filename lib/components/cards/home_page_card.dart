import 'package:flutter/material.dart';

import '../../models/enums.dart';
import '../../models/models.dart';
import '../../themes/livi_themes.dart';
import '../../utils/utils.dart';
import '../components.dart';

class HomePageCard extends StatelessWidget {
  final EdgeInsets margin;
  final double cardHeight;
  final Function() onTap;
  final double opacity;
  final Widget pillIcon;
  final Widget buttons;
  final bool showDosageForm;
  final DosageForm dosageForm;
  final String name;
  final String medInfo;
  final Schedule schedule;
  const HomePageCard({
    super.key,
    required this.margin,
    required this.cardHeight,
    required this.onTap,
    required this.opacity,
    required this.pillIcon,
    required this.buttons,
    required this.showDosageForm,
    required this.dosageForm,
    required this.name,
    required this.medInfo,
    required this.schedule,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: cardHeight,
      margin: margin,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedOpacity(
          opacity: opacity,
          duration: const Duration(milliseconds: 150),
          child: Container(
            decoration: BoxDecoration(
              color: LiviThemes.colors.baseWhite,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: LiviThemes.colors.gray200,
              ),
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                pillIcon,
                Spacer(),
                Expanded(
                  flex: 6,
                  child: Row(
                    children: [
                      if (showDosageForm)
                        Container(
                          height: 40,
                          width: 40,
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: LiviThemes.colors.brand50,
                            borderRadius: BorderRadius.circular(64),
                          ),
                          child: dosageFormIcon(dosageForm: dosageForm),
                        ),
                      LiviThemes.spacing.widthSpacer16(),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            LiviTextStyles.interSemiBold16(
                              name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            LiviTextStyles.interRegular14(
                              medInfo,
                              color: LiviThemes.colors.gray700,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                            LiviTextStyles.interRegular14(
                              schedule.getScheduleDescription(),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              color: LiviThemes.colors.brand600,
                            ),
                            Spacer(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Spacer(),
                buttons,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
