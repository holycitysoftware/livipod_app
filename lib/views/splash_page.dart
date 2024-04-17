import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../components/components.dart';
import '../controllers/controllers.dart';
import '../themes/livi_themes.dart';
import '../utils/strings.dart';
import 'registration/welcome_page.dart';

class SplashPage extends StatefulWidget {
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
      //TODO. validate userauth
      // Provider.of<AuthController>(context,listen: false);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => WelcomePage()));
    });
  }

  @override
  Widget build(BuildContext context) {
    // if (!_initialized) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        body: Container(
          width: double.maxFinite,
          height: double.maxFinite,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: LiviThemes.icons.splashBackgroundImage,
              fit: BoxFit.fill,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              LiviThemes.icons.logoWhite,
              LiviTextStyles.interMedium24(Strings.welcomeToLiviPod,
                  color: LiviThemes.colors.baseWhite),
              LiviThemes.icons.livipodText,
            ],
          ),
        ),
      ),
    );
  }
}
