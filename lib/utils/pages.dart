// ignore_for_file: avoid_classes_with_only_static_members

import 'package:flutter/material.dart';

import '../views/registration/terms_of_service_page.dart';
import '../views/views.dart';

class Pages {
  static Map<String, WidgetBuilder> get pages => {
        HomePage.routeName: (context) => HomePage(),
        SmsFlowPage.routeName: (context) => SmsFlowPage(),
        SplashPage.routeName: (context) => SplashPage(),
        WelcomePage.routeName: (context) => WelcomePage(),
        CheckSmsPage.routeName: (context) => CheckSmsPage(),
        SearchMedicationPage.routeName: (context) => SearchMedicationPage(),
        SelectDosageFormPage.routeName: (context) => SelectDosageFormPage(),
        NavigationBarPage.routeName: (context) => NavigationBarPage(),
        LoginPage.routeName: (context) => LoginPage(),
        CreateAccountPage.routeName: (context) => CreateAccountPage(),
        PrivacyPolicyPage.routeName: (context) => PrivacyPolicyPage(),
        TermsOfServicePage.routeName: (context) => TermsOfServicePage(),
        IdentifyPersonaPage.routeName: (context) => IdentifyPersonaPage(),
        TellUsAboutYourselfPage.routeName: (context) =>
            TellUsAboutYourselfPage(),
        SelectMedicationStrength.routeName: (context) =>
            SelectMedicationStrength(),
      };

  static List<String> get pagesNameList => pages.keys.toList();

  static Route? onGenerateRoute(RouteSettings settings) {
    if (settings.arguments != null) {
      switch (settings.name) {
        case CheckSmsPage.routeName:
          final args = settings.arguments! as CheckSmsPageArguments;
          return MaterialPageRoute(
            builder: (context) {
              return CheckSmsPage(
                appUser: args.appUser,
                isAccountCreation: args.isAccountCreation,
              );
            },
          );
        case SearchMedicationPage.routeName:
          final args = settings.arguments! as SearchMedicationPageArguments;
          return MaterialPageRoute(
            builder: (context) {
              return SearchMedicationPage(
                medication: args.medication,
              );
            },
          );
        case NavigationBarPage.routeName:
          final args = settings.arguments! as NavigationBarPageArguments;
          return MaterialPageRoute(
            builder: (context) {
              return NavigationBarPage(
                showIdentifyPersonaPage: args.showIdentifyPersonaPage,
              );
            },
          );
        case IdentifyPersonaPage.routeName:
          final args = settings.arguments! as IdentifyPersonaPageArguments;
          return MaterialPageRoute(
            builder: (context) {
              return IdentifyPersonaPage(
                personaPageInfo: args.personaPageInfo,
              );
            },
          );
        default:
      }
    }

    assert(false, 'Need to implement ${settings.name}');
    return null;
  }
}
