// ignore_for_file: avoid_classes_with_only_static_members

import 'package:flutter/material.dart';

import '../views/registration/welcome_page.dart';
import '../views/sms_flow_page.dart';
import '../views/views.dart';

class Pages {
  static Map<String, WidgetBuilder> get pages => {
        // HomePage.routeName: (context) => HomePage(),
        // SmsFlowPage.routeName: (context) => SmsFlowPage(),
        // SplashPage.routeName: (context) => SplashPage(),
        // WelcomePage.routeName: (context) => WelcomePage(),
        // CheckSmsPage.routeName: (context) => CheckSmsPage(),
        // SearchMedicationPage.routeName: (context) => SearchMedicationPage(),
        // SelectDosageFormPage.routeName: (context) => SelectDosageFormPage(),
        // NavigationBarPage.routeName: (context) => NavigationBarPage(),
        // LoginPage.routeName: (context) => LoginPage(),
        // CreateAccountPage.routeName: (context) => CreateAccountPage(),
        // PrivacyPolicyPage.routeName: (context) => PrivacyPolicyPage(),
        // TermsOfServicePage.routeName: (context) => TermsOfServicePage(),
        // IdentifyPersonaPage.routeName: (context) => IdentifyPersonaPage(),
        // TellUsAboutYourselfPage.routeName: (context) =>
        //     TellUsAboutYourselfPage(),
        // SelectMedicationStrength.routeName: (context) =>
        //     SelectMedicationStrength(),
      };

  static List<String> get pagesNameList => pages.keys.toList();
  static List<Route<dynamic>> initialRoutes(String initialRoute) {
    return [
      MaterialPageRoute(
        builder: (context) {
          return SplashPage();
        },
      ),
    ];
  }

  static Route? onGenerateRoute(RouteSettings settings) {
    print(settings.toString());
    if (settings.name != null) {
      switch (settings.name) {
        case SmsFlowPage.routeName:
          final args = settings.arguments as SmsFlowPageArguments;
          return MaterialPageRoute(
            builder: (context) {
              return SmsFlowPage(
                isLoginPage: args.isLoginPage,
                showIdentifyPersonaPage: args.showIdentifyPersonaPage,
              );
            },
          );
        case CheckSmsPage.routeName:
          if (settings.arguments == null) {
            final args = settings.arguments! as CheckSmsPageArguments;
            return MaterialPageRoute(
              builder: (context) {
                return CheckSmsPage(
                  appUser: args.appUser,
                  isAccountCreation: args.isAccountCreation,
                );
              },
            );
          }
        case SearchMedicationPage.routeName:
          if (settings.arguments == null) {
            final args = settings.arguments! as SearchMedicationPageArguments;
            return MaterialPageRoute(
              builder: (context) {
                return SearchMedicationPage(
                  medication: args.medication,
                );
              },
            );
          }
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
          if (settings.arguments == null) {
            final args = settings.arguments! as IdentifyPersonaPageArguments;
            return MaterialPageRoute(
              builder: (context) {
                return IdentifyPersonaPage(
                  personaPageInfo: args.personaPageInfo,
                );
              },
            );
          }
        case SelectDosageFormPage.routeName:
          if (settings.arguments == null) {
            final args = settings.arguments! as SelectDosageFormPageArguments;
            return MaterialPageRoute(
              builder: (context) {
                return SelectDosageFormPage(
                  medication: args.medication,
                );
              },
            );
          }
        case SelectMedicationStrength.routeName:
          // final args = settings.arguments! as SelectMedicationStrengthArguments;
          return MaterialPageRoute(
            builder: (context) {
              return SelectMedicationStrength(
                  // medication: args.medication,
                  );
            },
          );
        case LoginPage.routeName:
          return MaterialPageRoute(
            builder: (context) {
              return LoginPage();
            },
          );
        case CreateAccountPage.routeName:
          return MaterialPageRoute(
            builder: (context) {
              return CreateAccountPage();
            },
          );
        case PrivacyPolicyPage.routeName:
          return MaterialPageRoute(
            builder: (context) {
              return PrivacyPolicyPage();
            },
          );
        case TermsOfServicePage.routeName:
          return MaterialPageRoute(
            builder: (context) {
              return TermsOfServicePage();
            },
          );
        case TellUsAboutYourselfPage.routeName:
          return MaterialPageRoute(
            builder: (context) {
              return TellUsAboutYourselfPage();
            },
          );
        case WelcomePage.routeName:
          return MaterialPageRoute(
            builder: (context) {
              return WelcomePage();
            },
          );
        case SplashPage.routeName:
          return MaterialPageRoute(
            builder: (context) {
              return SplashPage();
            },
          );
        case HomePage.routeName:
          return MaterialPageRoute(
            builder: (context) {
              return HomePage();
            },
          );
      }
    }

    assert(false, 'Need to implement ${settings.name}');
    return null;
  }
}
