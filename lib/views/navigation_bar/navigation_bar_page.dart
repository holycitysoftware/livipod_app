import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/messaging_controller.dart';
import '../../services/app_user_service.dart';
import '../../themes/livi_themes.dart';
import '../../utils/strings.dart';
import '../views.dart';

class NavigationBarPage extends StatefulWidget {
  static const String routeName = '/navigation-bar-page';

  final bool showIdentifyPersonaPage;
  const NavigationBarPage({
    super.key,
    this.showIdentifyPersonaPage = false,
  });

  @override
  State<NavigationBarPage> createState() => _NavigationBarPageState();
}

class _NavigationBarPageState extends State<NavigationBarPage> {
  int currentPageIndex = 0;
  NavigationDestinationLabelBehavior labelBehavior =
      NavigationDestinationLabelBehavior.alwaysShow;

  late MessagingController _messagingController;
  late AuthController _authController;
  final AppUserService _appUserService = AppUserService();

  List<Widget> navigationBarPages = const [
    HomePage(),
    MedicationsPage(),
    HistoryPage(),
    SettingsPage(),
  ];

  @override
  void initState() {
    if (widget.showIdentifyPersonaPage) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        goToTellUsAboutYourselfPage();
      });
    }
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

  Future<void> goToTellUsAboutYourselfPage() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TellUsAboutYourselfPage(),
      ),
    );
  }

  List<BottomNavigationBarItem> navigationBarItems = <BottomNavigationBarItem>[
    BottomNavigationBarItem(
      icon: LiviThemes.icons.homeIcon(),
      activeIcon: LiviThemes.icons.homeIcon(color: LiviThemes.colors.brand600),
      label: Strings.home,
    ),
    BottomNavigationBarItem(
      icon: LiviThemes.icons.alarmAddIcon(),
      activeIcon:
          LiviThemes.icons.alarmAddIcon(color: LiviThemes.colors.brand600),
      label: Strings.medications,
    ),
    BottomNavigationBarItem(
      icon: LiviThemes.icons.leaderboardIcon(),
      activeIcon:
          LiviThemes.icons.leaderboardIcon(color: LiviThemes.colors.brand600),
      label: Strings.history,
    ),
    BottomNavigationBarItem(
      icon: LiviThemes.icons.settingsIcon(),
      activeIcon:
          LiviThemes.icons.settingsIcon(color: LiviThemes.colors.brand600),
      label: Strings.settings,
    ),
  ];

  void selectItem(int index) {
    setState(() {
      currentPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: false,
        child: Consumer<MessagingController>(
            builder: (context, messagingController, child) {
          if (messagingController.fcmToken.isNotEmpty) {
            updateUserFcmToken(messagingController.fcmToken);
          }

          return Scaffold(
            backgroundColor: LiviThemes.colors.baseWhite,
            bottomNavigationBar: BottomNavigationBar(
              items: navigationBarItems,
              backgroundColor: LiviThemes.colors.baseWhite94,
              currentIndex: currentPageIndex,
              showUnselectedLabels: true,
              unselectedItemColor: LiviThemes.colors.randomGray,
              selectedItemColor: LiviThemes.colors.brand600,
              onTap: selectItem,
              selectedLabelStyle:
                  LiviThemes.typography.interSemiBold_11.copyWith(
                color: LiviThemes.colors.brand600,
              ),
              unselectedLabelStyle:
                  LiviThemes.typography.interMedium_11.copyWith(
                color: LiviThemes.colors.randomGray,
              ),
            ),
            body: navigationBarPages[currentPageIndex],
          );
        }));
  }
}
