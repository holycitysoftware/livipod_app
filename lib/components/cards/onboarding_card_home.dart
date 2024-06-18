import 'package:flutter/material.dart';

import '../../themes/livi_themes.dart';
import '../components.dart';

class OnboardingCardHome extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget icon;
  final Function() onTap;
  const OnboardingCardHome({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Card(
        elevation: .5,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: LiviThemes.colors.gray200,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: icon,
                ),
              ),
              LiviThemes.spacing.widthSpacer12(),
              Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        Expanded(
                          child: LiviTextStyles.interSemiBold14(
                            title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ]),
                      Row(children: [
                        Expanded(
                          child: LiviTextStyles.interRegular14(
                            subtitle,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ]),
                    ]),
              ),
              LiviThemes.icons.chevronRight(),
            ],
          ),
        ),
      ),
    );
  }
}
