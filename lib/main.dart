import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:livipod_app/controllers/communication_controller.dart';
import 'package:provider/provider.dart';
import 'controllers/controllers.dart';
import 'controllers/messaging_controller.dart';
import 'firebase_options.dart';
import 'services/livi_pod_service.dart';
import 'themes/livi_themes.dart';
import 'views/views.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseAppCheck.instance.activate(
    webProvider: ReCaptchaV3Provider('recaptcha-v3-site-key'),
  );
  // Set the background messaging handler early on, as a named top-level function
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  if (!kIsWeb) {
    await setupFlutterNotifications();
  }

  // AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
  //   if (!isAllowed) {
  //     // This is just a basic example. For real apps, you must show some
  //     // friendly dialog box before call the request method.
  //     // This is very important to not harm the user experience
  //     AwesomeNotifications().requestPermissionToSendNotifications();
  //   }
  // });

  // FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  //     FlutterLocalNotificationsPlugin();
  // flutterLocalNotificationsPlugin
  //     .resolvePlatformSpecificImplementation<
  //         AndroidFlutterLocalNotificationsPlugin>()
  //     ?.requestNotificationsPermission();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  runApp(const MyApp());
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await setupFlutterNotifications();
  showFlutterNotification(message);
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  if (kDebugMode) {
    print('Handling a background message ${message.messageId}');
  }
}

late AndroidNotificationChannel channel;

bool isFlutterLocalNotificationsInitialized = false;

Future<void> setupFlutterNotifications() async {
  if (isFlutterLocalNotificationsInitialized) {
    return;
  }
  channel = const AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    description:
        'This channel is used for important notifications.', // description
    importance: Importance.high,
  );

  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  /// Create an Android Notification Channel.
  ///
  /// We use this channel in the `AndroidManifest.xml` file to override the
  /// default FCM channel to enable heads up notifications.
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  /// Update the iOS foreground notification presentation options to allow
  /// heads up notifications.
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  isFlutterLocalNotificationsInitialized = true;
}

void showFlutterNotification(RemoteMessage message) {
  final RemoteNotification? notification = message.notification;
  final AndroidNotification? android = message.notification?.android;
  if (notification != null && android != null && !kIsWeb) {
    flutterLocalNotificationsPlugin.show(
      notification.hashCode,
      notification.title,
      notification.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
          channelDescription: channel.description,
          icon: 'launch_background',
        ),
      ),
    );
  }
}

/// Initialize the [FlutterLocalNotificationsPlugin] package.
late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final BleController _devicesController;
  //late final ScheduleController _scheduleController;
  final LiviPodService _liviPodController = LiviPodService();
  final AuthController _authController = AuthController();
  final MessagingController _messagingController = MessagingController();

  // FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  //     FlutterLocalNotificationsPlugin();
  // var initializationSettingsAndroid = AndroidInitializationSettings(
  //     'res_app_icon'); // <- default icon name is @mipmap/ic_launcher
  // //  var initializationSettingsIOS = IOSInitializationSettings(onDidReceiveLocalNotification: onDidReceiveLocalNotification);
  // AndroidNotificationDetails androidNotificationDetails =
  //     AndroidNotificationDetails(
  //   'your channel id',
  //   'your channel name',
  //   channelDescription: 'your channel description',
  //   importance: Importance.max,
  //   priority: Priority.high,
  //   colorized: true,
  //   color: LiviThemes.colors.brand500,
  //   ticker: 'ticker',
  // );
  // late final DarwinInitializationSettings initializationSettingsDarwin;

  // Future<void> onDidReceiveLocalNotification(
  //     int id, String? title, String? body, String? payload) async {
  //   // display a dialog with the notification details, tap ok to go to another page
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) => CupertinoAlertDialog(
  //       title: Text(title ?? ''),
  //       content: Text(body ?? ''),
  //       actions: [
  //         CupertinoDialogAction(
  //           isDefaultAction: true,
  //           child: Text('Ok'),
  //           onPressed: () async {
  //             Navigator.of(context, rootNavigator: true).pop();
  //             await Navigator.push(
  //               context,
  //               MaterialPageRoute(
  //                 builder: (context) => SmsFlowPage(),
  //               ),
  //             );
  //           },
  //         )
  //       ],
  //     ),
  //   );
  // }

  // late NotificationDetails notificationDetails;

  @override
  void initState() {
    _devicesController = BleController(liviPodController: _liviPodController);
    // _scheduleController =
    //     ScheduleController(liviPodController: _liviPodController);
    // notificationDetails =
    //     NotificationDetails(android: androidNotificationDetails);
    // initializationSettingsDarwin = DarwinInitializationSettings(
    //     onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    // doAsyncStuff();
    super.initState();
  }

  // Future<void> doAsyncStuff() async {
  //   var initializationSettings = InitializationSettings(
  //       android: initializationSettingsAndroid,
  //       iOS: initializationSettingsDarwin);

  //   flutterLocalNotificationsPlugin.initialize(
  //     initializationSettings,
  //   );

  //   await flutterLocalNotificationsPlugin.show(2, 'Baclofen 10 mg Tablet',
  //       'Time to take your 9:40 AM medications', notificationDetails,
  //       payload: 'item x');
  // }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => _authController,
        ),
        // ChangeNotifierProvider(
        //   create: (context) => _scheduleController,
        // ),
        ChangeNotifierProvider(
          create: (context) => _devicesController,
        ),
        ChangeNotifierProvider(
          create: (context) => _messagingController,
        ),
        // ChangeNotifierProvider(
        //   create: (context) => _webSocketController,
        // ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: LiviThemes.theme.getAppTheme(),
        home: SplashPage(), // const FdaSearchTest() // const TestCreateUser()
      ),
    );
  }
}
