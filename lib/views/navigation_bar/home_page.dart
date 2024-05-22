import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../components/components.dart';
import '../../controllers/auth_controller.dart';
import '../../models/enums.dart';
import '../../themes/livi_themes.dart';
import '../../utils/strings.dart';

///Route: home-page
class HomePage extends StatefulWidget {
  static const String routeName = '/home-page';
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final now = DateTime.now();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        body:
            Consumer<AuthController>(builder: (context, authController, child) {
          return Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  PeriodOfDay.morning.colors.first,
                  PeriodOfDay.morning.colors.last
                ],
              ),
            ),
            child: ListView(
              padding: const EdgeInsets.all(24.0),
              children: [
                LiviTextStyles.interRegular12(
                    '${DateFormat('EEEE').format(now)}, ${now.day} ${DateFormat('MMMM').format(now)}',
                    color: LiviThemes.colors.gray600),
                Row(
                  children: [
                    LiviThemes.icons.sunIcon(
                      color: LiviThemes.colors.baseWhite,
                    ),
                    LiviTextStyles.interSemiBold36('Morning, Bill')
                  ],
                ),
                LiviTextStyles.interRegular14(
                    '${Strings.nextMedsDueAt} ${DateFormat.jm().format(now)}',
                    color: LiviThemes.colors.baseBlack),
              ],
            ),
          );
        }),
      ),
    );
  }
}
