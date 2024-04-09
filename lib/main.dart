import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'controllers/controllers.dart';
import 'firebase_options.dart';
import 'views/splash_page.dart';
import 'views/views.dart';

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
          home: SplashPage()),
    );
  }
}
