import 'package:flutter/material.dart';
import 'package:livipod_app/controllers/auth_controller.dart';
import 'package:livipod_app/controllers/livi_pod_controller.dart';
import 'package:livipod_app/controllers/schedule_controller.dart';
// import 'package:livipod_app/controllers/communication_controller.dart';
import 'package:livipod_app/views/home_tab_view.dart';
import 'package:livipod_app/views/testing_only/create_user.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'controllers/ble_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final BleController _devicesController;
  late final ScheduleController _scheduleController;
  final LiviPodController _liviPodController = LiviPodController();
  final AuthController _authController = AuthController();

  @override
  void initState() {
    _devicesController = BleController(liviPodController: _liviPodController);
    _scheduleController =
        ScheduleController(liviPodController: _liviPodController);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => _authController,
          ),
          ChangeNotifierProvider(
            create: (context) => _scheduleController,
          ),
          ChangeNotifierProvider(
            create: (context) => _devicesController,
          ),
          ChangeNotifierProvider(
            create: (context) => _liviPodController,
          ),
          // ChangeNotifierProvider(
          //   create: (context) => _webSocketController,
          // ),
        ],
        child: MaterialApp(
          title: 'Flutter Demo',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          home: const HomeTabView(), //const TestCreateUser()
        ));
  }
}
