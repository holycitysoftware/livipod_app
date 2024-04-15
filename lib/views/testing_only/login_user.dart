import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/auth_controller.dart';
import '../views.dart';

class LoginCreateUser extends StatefulWidget {
  const LoginCreateUser({super.key});

  @override
  State<LoginCreateUser> createState() => _LoginCreateUserState();
}

class _LoginCreateUserState extends State<LoginCreateUser> {
  @override
  void dispose() {
    super.dispose();
  }

  Future<void> goToWelcomePage() async {
    await Navigator.push(
        context, MaterialPageRoute(builder: (context) => WelcomePage()));
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthController>(builder: (context, controller, child) {
      return getView(controller);
    });
  }

  Widget getView(AuthController controller) {
    if (!controller.promptForUserCode && controller.firebaseAuthUser == null) {
      return LoginPage();
    } else if (controller.promptForUserCode &&
        controller.firebaseAuthUser == null &&
        controller.appUser != null) {
      return CheckSmsPage(appUser: controller.appUser!);
    } else if (controller.firebaseAuthUser != null) {
      return SafeArea(
        child: PopScope(
          canPop: false,
          child: Scaffold(
            body: Center(
              child: Column(
                children: [
                  const Text('You are authenticated'),
                  const SizedBox(height: 16.0),
                  Text(controller.firebaseAuthUser!.uid),
                  const SizedBox(height: 16.0),
                  Text(controller.firebaseAuthUser!.refreshToken ?? ''),
                  const SizedBox(height: 16.0),
                  Text(controller.firebaseAuthUser!.phoneNumber ?? ''),
                  const SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () async {
                      await controller.signOut();
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
    } else {
      return LoginPage();
    }
  }
}
