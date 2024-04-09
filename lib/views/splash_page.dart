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
  bool _initialized = false;

  @override
  void initState() {
    _handleAuth();
    super.initState();
  }

  Future<void> _connectReader() async {
    // await controller.initialize();
    // await controller.connect();
  }

  void _handleAuth() {
    Timer(const Duration(milliseconds: 5000), () async {
      await _connectReader();
      // var power = await _readPower();
      // await _setPower(power - 5);
      // power = await _readPower();
      setState(() {
        _initialized = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_initialized) {
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
    } else {
      // return const NavigationBarPage();
      return SizedBox();
    }
  }
}
