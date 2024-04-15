import 'package:flutter/material.dart';

import '../../models/models.dart';
import '../../themes/livi_themes.dart';
import '../../utils/countries.dart';

class CountryDropdownButton extends StatelessWidget {
  final Country country;
  final ValueChanged<Country?> onChanged;
  const CountryDropdownButton({
    super.key,
    required this.country,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButton<Country>(
      underline: SizedBox(),
      padding: EdgeInsets.only(left: 16, right: 8),
      value: country,
      onChanged: onChanged,
      style: LiviThemes.typography.interRegular_16
          .copyWith(color: LiviThemes.colors.baseBlack),
      menuMaxHeight: 220,
      borderRadius: BorderRadius.circular(8),
      icon: LiviThemes.icons.chevronDownGray,
      items: countriesList
          .map<DropdownMenuItem<Country>>(
            (Country country) => DropdownMenuItem<Country>(
              value: country,
              child: Text(
                country.code,
                style: LiviThemes.typography.interRegular_16
                    .copyWith(color: LiviThemes.colors.baseBlack),
              ),
            ),
          )
          .toList(),
    );
  }
}
