import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/auth_controller.dart';
import '../views.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
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
