import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/auth_controller.dart';
import 'views.dart';

class SmsFlowPage extends StatefulWidget {
  static const String routeName = '/sms-flow-page';
  final bool isLoginPage;
  final bool showIdentifyPersonaPage;
  const SmsFlowPage({
    super.key,
    this.isLoginPage = false,
    this.showIdentifyPersonaPage = false,
  });

  @override
  State<SmsFlowPage> createState() => _SmsFlowPageState();
}

class _SmsFlowPageState extends State<SmsFlowPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
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
      return CheckSmsPage(
        appUser: controller.appUser!,
        isAccountCreation: !widget.isLoginPage,
      );
    } else if (controller.firebaseAuthUser != null &&
        (controller.appUser != null &&
            controller.appUser!.accountId.isNotEmpty)) {
      return NavigationBarPage(
        showIdentifyPersonaPage: widget.showIdentifyPersonaPage,
      );
    } else {
      if (widget.isLoginPage) {
        return LoginPage();
      }
      return CreateAccountPage();
    }
  }
}
