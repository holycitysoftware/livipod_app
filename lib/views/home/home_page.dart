import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/components.dart';
import '../../controllers/controllers.dart';
import '../../themes/livi_themes.dart';
import '../../utils/strings.dart';
import '../views.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<AuthController>(builder: (context, authController, child) {
      return SafeArea(
        child: PopScope(
          canPop: false,
          child: Scaffold(
            appBar: AppBar(
              title: LiviTextIcon(),
            ),
            body: Center(
              child: Column(
                children: [
                  const Text('You are authenticated'),
                  const SizedBox(height: 16.0),
                  Text(authController.firebaseAuthUser!.uid),
                  const SizedBox(height: 16.0),
                  Text(authController.firebaseAuthUser!.refreshToken ?? ''),
                  const SizedBox(height: 16.0),
                  Text(authController.firebaseAuthUser!.phoneNumber ?? ''),
                  const SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () async {
                      await authController.signOut();
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => WelcomePage(),
                          ));
                    },
                    child: const Text('Sign Out'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
    ;
  }
}
