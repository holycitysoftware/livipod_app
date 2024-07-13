import 'package:dropdown_button2/dropdown_button2.dart';
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
    return DropdownButton2<Country>(
      underline: Text(''),
      value: country,
      buttonStyleData: ButtonStyleData(
        padding: EdgeInsets.fromLTRB(16, 0, 8, 0),
      ),
      dropdownStyleData: DropdownStyleData(width: 85, maxHeight: 300),
      iconStyleData: IconStyleData(
        icon: LiviThemes.icons.chevronDownGray,
      ),
      onChanged: onChanged,
      style: LiviThemes.typography.interRegular_16
          .copyWith(color: LiviThemes.colors.baseBlack),
      items: countriesList
          .map<DropdownMenuItem<Country>>(
            (Country country) => DropdownMenuItem<Country>(
              value: country,
              alignment: Alignment.center,
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
