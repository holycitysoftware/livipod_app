import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../components/components.dart';
import '../themes/livi_themes.dart';
import '../utils/strings.dart';
import 'registration/welcome_page.dart';
import 'sms_flow_page.dart';

class SplashPage extends StatefulWidget {
  static const String routeName = '/';
  const SplashPage({
    super.key,
  });

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    _handleAuth();
    super.initState();
  }

  void _handleAuth() {
    Timer(const Duration(milliseconds: 4000), () async {
      final User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => SmsFlowPage(),
                settings: RouteSettings(name: SmsFlowPage.routeName)));
      } else {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => WelcomePage(),
                settings: RouteSettings(name: SmsFlowPage.routeName)));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // if (!_initialized) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Spacer(flex: 4),
            Align(child: LiviThemes.icons.logoRoundedBackground()),
            // LiviTextStyles.interMedium24(Strings.welcomeToLiviPod,
            //     color: LiviThemes.colors.baseWhite),
            Spacer(flex: 3),
            LiviThemes.icons.livipodTextWhite,
            Spacer(),
          ],
        ),
      ),
    );
  }
}
