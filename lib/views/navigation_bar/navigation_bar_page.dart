import 'package:flutter/material.dart';
import '../../themes/livi_themes.dart';
import '../../utils/strings.dart';
import '../views.dart';

class NavigationBarPage extends StatefulWidget {
  const NavigationBarPage({super.key});

  @override
  State<NavigationBarPage> createState() => _NavigationBarPageState();
}

class _NavigationBarPageState extends State<NavigationBarPage> {
  int currentPageIndex = 0;
  NavigationDestinationLabelBehavior labelBehavior =
      NavigationDestinationLabelBehavior.alwaysShow;

  List<Widget> navigationBarPages = const [
    HomePage(),
    MedicationsPage(),
    HistoryPage(),
    SettingsPage(),
  ];

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
      child: Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          items: navigationBarItems,
          backgroundColor: LiviThemes.colors.baseWhite94,
          currentIndex: currentPageIndex,
          showUnselectedLabels: true,
          unselectedItemColor: LiviThemes.colors.randomGray,
          selectedItemColor: LiviThemes.colors.brand600,
          onTap: selectItem,
          selectedLabelStyle: LiviThemes.typography.interSemiBold_11.copyWith(
            color: LiviThemes.colors.brand600,
          ),
          unselectedLabelStyle: LiviThemes.typography.interMedium_11.copyWith(
            color: LiviThemes.colors.randomGray,
          ),
        ),
        body: navigationBarPages[currentPageIndex],
      ),
    );
  }
}
