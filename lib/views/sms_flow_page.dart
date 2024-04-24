import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/auth_controller.dart';
import 'views.dart';

class SmsFlowPage extends StatefulWidget {
  final bool isLoginPage;
  const SmsFlowPage({
    super.key,
    this.isLoginPage = false,
  });

  @override
  State<SmsFlowPage> createState() => _SmsFlowPageState();
}

class _SmsFlowPageState extends State<SmsFlowPage> {
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
      if (widget.isLoginPage) {
        return LoginPage();
      }
      return CreateAccountPage();
    } else if (controller.promptForUserCode &&
        controller.firebaseAuthUser == null &&
        controller.appUser != null) {
      return CheckSmsPage(appUser: controller.appUser!);
    } else if (controller.firebaseAuthUser != null) {
      return HomePage();
    } else {
      return LoginPage();
    }
  }
}
