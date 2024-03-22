import 'package:flutter/painting.dart';

///LiviAi Pallet
class LiviColors {
  Color get black => const Color(0xff000000);
  Color get white => const Color(0xffFFFFFF);
  Color get transparent => const Color.fromARGB(0, 255, 255, 255);

  Color get white85 => const Color(0xffFFFFFF).withOpacity(0.85);
  Color get black15 => black.withOpacity(0.15);

  Color get primaryDarkest => const Color(0xff005A94);
  Color get primaryDarker => const Color(0xff0079C7);
  Color get primaryBrand => const Color(0xff444CE7);
  Color get primaryLighter_1 => const Color(0xff33ADFA);
  Color get primaryLighter_2 => const Color(0xff66C1FB);
  Color get primaryLighter_3 => const Color(0xff99D6FD);
  Color get primaryLightest => const Color(0xffCCEAFE);

  Color get blackLighter_1 => const Color(0xffD3D3D3); //Usado no Picker

  Color get grayScale_6 => const Color(0xffEBEBEB);
  Color get grayScale_5 => const Color(0xff4F4F4F);
  Color get grayScale_4 => const Color(0xff6F6F6F);
  Color get grayScale_3 => const Color(0xff9C9C9C);

  Color get grayScale_2 => const Color(0xffD8D8D8);
  Color get grayScale_1 => const Color(0xffF2F2F2);

  Color get secondaryRed => const Color(0xffFFE2E2);
  Color get secondaryOrange => const Color(0xffFFEAD1);
  Color get secondaryYellow => const Color(0xffF7F7B0);
  Color get secondaryGreen => const Color(0xffCCFFD2);
  Color get secondaryCyan => const Color(0xffD8FFFC);
  Color get secondaryBlue => const Color(0xffE0ECFF);
  Color get secondaryPurple => const Color(0xffE7E3FF);
  Color get secondaryPink => const Color(0xffFFE6FF);
  Color get secondaryGray => const Color(0xffD8D8D8);

  Color get notificationGreen => const Color(0xff37B34A);
  Color get notificationYellow => const Color(0xffFFBB56);
  Color get notificationRed => const Color(0xffFF334C);

  List<Map<String, Color>> get namedColors => [
        {'black': black},
        {'white': white},
        {'primaryDarkest': primaryDarkest},
        {'primaryDarker': primaryDarker},
        {'primaryBrand': primaryBrand},
        {'primaryLighter_1': primaryLighter_1},
        {'primaryLighter_2': primaryLighter_2},
        {'primaryLighter_3': primaryLighter_3},
        {'primaryLightest': primaryLightest},
        {'secondaryRed': secondaryRed},
        {'secondaryOrange': secondaryOrange},
        {'secondaryYellow': secondaryYellow},
        {'secondaryGreen': secondaryGreen},
        {'secondaryCyan': secondaryCyan},
        {'secondaryBlue': secondaryBlue},
        {'secondaryPurple': secondaryPurple},
        {'secondaryPink': secondaryPink},
        {'secondaryGray': secondaryGray},
        {'notificationGreen': notificationGreen},
        {'notificationYellow': notificationYellow},
        {'notificationRed': notificationRed},
        {'transparent': transparent}
      ];
}
