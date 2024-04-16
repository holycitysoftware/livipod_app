import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../components/components.dart';
import '../controllers/controllers.dart';
import '../themes/livi_themes.dart';
import '../utils/strings.dart';

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
      // Provider.of<AuthController>(context,listen: false);
    });
  }

  @override
  Widget build(BuildContext context) {
    // if (!_initialized) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: LiviThemes.icons.splashBackgroundImage,
            // fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            LiviThemes.icons.logoWhite,
            LiviTextStyles.interMedium24(Strings.welcomeToLiviPod),
            LiviThemes.icons.livipodText,
          ],
        ),
      ),
    );
  }
}
