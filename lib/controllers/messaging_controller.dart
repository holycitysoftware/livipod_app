import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../constants.dart' as constants;

class MessagingController extends ChangeNotifier {
  String _fcmToken = '';
  String _apnsToken = '';

  late AndroidNotificationChannel _channel;
  bool _isFlutterLocalNotificationsInitialized = false;
  late FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;

  String get fcmToken => _fcmToken;

  MessagingController() {
    getPermissions();
    if (!kIsWeb) {
      initialize();
    }

    FirebaseMessaging.instance.onTokenRefresh.listen((fcmToken) {
      _fcmToken = fcmToken;
      notifyListeners();
    }, onError: (err) {
      if (kDebugMode) {
        print(err);
      }
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      final RemoteNotification? notification = message.notification;
      final AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null && !kIsWeb) {
        _flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              _channel.id,
              _channel.name,
              channelDescription: _channel.description,
              icon: 'launch_background',
            ),
          ),
        );
      }
    });
  }

  Future<void> initialize() async {
    if (_isFlutterLocalNotificationsInitialized) {
      return;
    }
    _channel = const AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      description:
          'This channel is used for important notifications.', // description
      importance: Importance.high,
    );

    _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    /// Create an Android Notification Channel.
    ///
    /// We use this channel in the `AndroidManifest.xml` file to override the
    /// default FCM channel to enable heads up notifications.
    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_channel);

    /// Update the iOS foreground notification presentation options to allow
    /// heads up notifications.
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    _isFlutterLocalNotificationsInitialized = true;
  }

  Future<void> getPermissions() async {
    await FirebaseMessaging.instance.requestPermission(
        alert: true,
        announcement: true,
        badge: true,
        carPlay: true,
        criticalAlert: true);
  }

  Future<void> getFcmToken() async {
    if (kIsWeb) {
      _fcmToken = await FirebaseMessaging.instance
              .getToken(vapidKey: constants.vapidPublicKey) ??
          '';
    } else {
      _apnsToken = await FirebaseMessaging.instance.getAPNSToken() ?? '';
      _fcmToken = await FirebaseMessaging.instance.getToken() ?? '';
    }
    notifyListeners();
  }
}
