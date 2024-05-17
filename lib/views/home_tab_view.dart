import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/controllers.dart';
import '../controllers/messaging_controller.dart';
import '../services/app_user_service.dart';
import '../themes/livi_themes.dart';
import 'devices_view.dart';
import 'profile_view.dart';

class HomeTabView extends StatefulWidget {
  const HomeTabView({super.key});

  @override
  State<HomeTabView> createState() => _HomeTabViewState();
}

class _HomeTabViewState extends State<HomeTabView> {
  late MessagingController _messagingController;
  late AuthController _authController;
  final AppUserService _appUserService = AppUserService();
  int _index = 0;

  @override
  void initState() {
    _authController = Provider.of<AuthController>(context, listen: false);
    setupMessaging();
    super.initState();
  }

  Future setupMessaging() async {
    _messagingController =
        Provider.of<MessagingController>(context, listen: false);
    await _messagingController.getFcmToken();
  }

  Future updateUserFcmToken(String fcmToken) async {
    if (_authController.appUser?.fcmToken != fcmToken) {
      _authController.appUser?.fcmToken = fcmToken;
      await _appUserService.updateUser(_authController.appUser!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MessagingController>(
      builder: (context, messagingController, child) {
        if (messagingController.fcmToken.isNotEmpty) {
          updateUserFcmToken(messagingController.fcmToken);
        }

        return Scaffold(
          backgroundColor: LiviThemes.colors.baseWhite,
          appBar: AppBar(title: const Text('LiviPod')),
          body: _getPage(),
          bottomNavigationBar: BottomNavigationBar(
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
              BottomNavigationBarItem(icon: Icon(Icons.circle), label: 'Pods'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.people), label: 'Profile'),
            ],
            currentIndex: _index,
            onTap: (value) {
              setState(() {
                _index = value;
              });
            },
          ),
        );
      },
    );
  }

  Widget _getPage() {
    switch (_index) {
      case 0:
        return Placeholder();
      case 1:
        return DevicesView();
      default:
        return ProfileView();
    }
  }
}
