// ignore_for_file: avoid_classes_with_only_static_members

import 'package:flutter/material.dart';

import 'livi_themes.dart';

class LiviTheme {
  ThemeData getAppTheme() {
    return ThemeData(
        dialogTheme: DialogTheme(
          backgroundColor: LiviThemes.colors.baseWhite,
          surfaceTintColor: LiviThemes.colors.baseWhite,
        ),
        appBarTheme: AppBarTheme(
          // titleTextStyle: GoogleFonts.getFont('Outfit',
          //     fontSize: 18, fontWeight: FontWeight.bold, color: AppColor.BLACK),
          actionsIconTheme: IconThemeData(color: LiviThemes.colors.brand600),
          iconTheme: IconThemeData(color: LiviThemes.colors.brand600),
          backgroundColor: LiviThemes.colors.baseWhite,
        ),
        cardTheme: CardTheme(color: LiviThemes.colors.baseWhite),
        primaryColor: LiviThemes.colors.brand600,
        highlightColor: LiviThemes.colors.brand600.withOpacity(.1),
        scaffoldBackgroundColor: LiviThemes.colors.baseWhite,
        colorScheme: ColorScheme.light(
          primary: LiviThemes.colors.brand600,
        ),
        timePickerTheme: TimePickerThemeData(
            dialBackgroundColor: LiviThemes.colors.gray300,
            // hourMinuteColor: LiviThemes.colors.gray300,
            dayPeriodTextColor: LiviThemes.colors.brand600,
            backgroundColor: LiviThemes.colors.baseWhite,
            dialHandColor: LiviThemes.colors.brand600,
            dayPeriodColor: LiviThemes.colors.brand300,
            dayPeriodBorderSide: BorderSide(color: LiviThemes.colors.brand300),
            dayPeriodTextStyle: LiviThemes.typography.interSemiBold_16
                .copyWith(color: LiviThemes.colors.brand600),
            hourMinuteTextStyle: LiviThemes.typography.interRegular_48
                .copyWith(color: LiviThemes.colors.brand600),
            hourMinuteTextColor: LiviThemes.colors.baseBlack),
        datePickerTheme: DatePickerThemeData(
          // dayOverlayColor: MaterialStatePropertyAll(LiviThemes.colors.brand600),
          // dayForegroundColor:
          //     MaterialStatePropertyAll(LiviThemes.colors.gray700),color
          cancelButtonStyle: ButtonStyle(
            shape: MaterialStatePropertyAll(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(color: LiviThemes.colors.gray300),
              ),
            ),
            padding:
                MaterialStatePropertyAll(EdgeInsets.symmetric(horizontal: 48)),
            // backgroundColor:
            //     MaterialStateProperty.all<Color>(LiviThemes.colors.brand600),
            foregroundColor:
                MaterialStateProperty.all<Color>(LiviThemes.colors.baseBlack),
          ),
          confirmButtonStyle: ButtonStyle(
            shape: MaterialStatePropertyAll(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(color: LiviThemes.colors.gray300),
              ),
            ),
            backgroundColor:
                MaterialStateProperty.all<Color>(LiviThemes.colors.brand600),
            foregroundColor:
                MaterialStateProperty.all<Color>(LiviThemes.colors.baseWhite),
          ),
        )
        // textTheme: TextTheme(
        //   displayLarge: GoogleFonts.getFont('Outfit',
        //       fontSize: 20, fontWeight: FontWeight.bold, color: AppColor.BLACK),
        //   displayMedium: GoogleFonts.getFont('Outfit',
        //       fontSize: 18, fontWeight: FontWeight.bold, color: AppColor.BLACK),
        //   displaySmall: GoogleFonts.getFont('Outfit',
        //       fontSize: 16, fontWeight: FontWeight.bold, color: AppColor.BLACK),
        //   titleLarge: GoogleFonts.getFont('Outfit',
        //       fontSize: 18, fontWeight: FontWeight.bold, color: AppColor.BLACK),
        //   titleMedium: GoogleFonts.getFont('Outfit',
        //       fontSize: 14, fontWeight: FontWeight.bold, color: AppColor.BLACK),
        //   titleSmall: GoogleFonts.getFont('Outfit',
        //       fontSize: 12, fontWeight: FontWeight.bold, color: AppColor.BLACK),
        //   bodyLarge:
        //       GoogleFonts.getFont('Outfit', fontSize: 16, color: AppColor.BLACK),
        //   bodyMedium:
        //       GoogleFonts.getFont('Outfit', fontSize: 14, color: AppColor.BLACK),
        //   bodySmall: GoogleFonts.getFont('Outfit',
        //       fontSize: 12, color: AppColor.BLACK.withOpacity(0.4)),
        // ),
        // iconTheme: const IconThemeData(color: AppColor.PRIMARY),
        // textButtonTheme: TextButtonThemeData(
        //     style: ButtonStyle(
        //         backgroundColor:
        //             MaterialStateProperty.all<Color>(AppColor.BODY_COLOR),
        //         foregroundColor: MaterialStateProperty.all<Color>(AppColor.WHITE),
        //         shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        //             const RoundedRectangleBorder(
        //                 borderRadius: BorderRadius.all(Radius.circular(5)))))),
        // toggleButtonsTheme: ToggleButtonsThemeData(
        //   selectedColor: AppColor.BODY_COLOR,
        //   fillColor: AppColor.BODY_COLOR.withOpacity(0.1),
        //   textStyle: const TextStyle(color: AppColor.WHITE),
        //   selectedBorderColor: AppColor.BODY_COLOR,
        //   borderRadius: BorderRadius.circular(8.0),
        // ),
        // colorScheme: ColorScheme.fromSwatch().copyWith(
        //   primary: AppColor.PRIMARY,
        //   onPrimary: AppColor.PRIMARY,
        //   secondary: AppColor.SECONDARY,
        //   onSecondary: AppColor.SECONDARY,
        //   surface: AppColor.BG_COLOR,
        //   onSurface: AppColor.BG_COLOR,
        //   error: Colors.red,
        //   onError: Colors.red,
        //   background: AppColor.BG_COLOR,
        //   onBackground: AppColor.BG_COLOR,
        //   brightness: Brightness.light,
        // ),
        );
  }
}
