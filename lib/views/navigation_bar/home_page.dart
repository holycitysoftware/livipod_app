import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/auth_controller.dart';
import '../../themes/livi_themes.dart';
import '../views.dart';

///Route: home-page
class HomePage extends StatelessWidget {
  static const String routeName = '/home-page';
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: LiviThemes.colors.baseWhite,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text('Home'),
        ),
        body:
            Consumer<AuthController>(builder: (context, authController, child) {
          return Center(
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
          );
        }),
      ),
    );
  }
}
