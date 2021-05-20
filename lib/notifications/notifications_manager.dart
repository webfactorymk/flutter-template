import 'dart:io';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_template/config/firebase_config.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_template/log/logger.dart';
import 'package:single_item_shared_prefs/single_item_shared_prefs.dart';
import 'package:single_item_storage/storage.dart';

const String apnsDeviceTokenKey = 'apns-device-token';
const String fcmDeviceTokenKey = 'firebase-device-token';

/// Manages push notifications of logged-in user within the app.
///
/// To obtain an instance use `serviceLocator.get<NotificationsManager>()`
class NotificationsManager {
  late final FirebaseMessaging _fcm;
  late final FlutterLocalNotificationsPlugin flNotification;

  final Storage<String> _fcmTokenStorage;
  final Storage<String> _apnsTokenStorage;

  bool _setupStarted = false;
  bool userAuthorized = false;

  //TODO change this values before using them
  static const String CHANNEL_ID = '12345';
  static const String CHANNEL_NAME = 'channel name';
  static const String CHANNEL_DESCRIPTION = 'channel description';

  NotificationsManager(
    InitializationSettings initializationSettings, {
    Storage<String>? fcmTokenStorage,
    Storage<String>? apnsTokenStorage,
  })  : _fcmTokenStorage = fcmTokenStorage ??
            SharedPrefsStorage<String>.primitive(itemKey: fcmDeviceTokenKey),
        _apnsTokenStorage = apnsTokenStorage ??
            SharedPrefsStorage<String>.primitive(itemKey: apnsDeviceTokenKey) {
    if (shouldConfigureFirebase()) {
      _fcm = FirebaseMessaging.instance;
    }
    flNotification = FlutterLocalNotificationsPlugin();
    flNotification.initialize(initializationSettings);
  }

  bool get setupStarted => _setupStarted;

  setupPushNotifications() async {
    if (_setupStarted) {
      Logger.d('NotificationsManager - Setup: Aborting, already completed.');
    }
    _setupStarted = true;

    if (Platform.isIOS) {
      await requestPermissions();

      final apnsToken = await _fcm.getAPNSToken();
      _onAPNSTokenReceived(apnsToken);
    }

    final fcmToken = await _fcm.getToken();
    _onFCMTokenReceived(fcmToken);

    _fcm.onTokenRefresh.listen((token) {
      Logger.d('NotificationsManager - FCM Token refresh');
      _onFCMTokenReceived(token);
    });

    FirebaseMessaging.onMessage.listen((message) {
      if (userAuthorized) {
        _onMessage(message);
      } else {
        Logger.w('NotificationsManager - Message missed. User unauthorized');
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      if (userAuthorized) {
        _onAppOpenedFromMessage(message);
      } else {
        Logger.w('NotificationsManager - App not opened. User unauthorized');
      }
    });

    FirebaseMessaging.onBackgroundMessage(backgroundMessageHandler);
  }

  Future<void> disablePushNotifications() async {
    await _fcm.deleteToken();
    await _fcmTokenStorage.delete();
    await _apnsTokenStorage.delete();

    _setupStarted = false;
  }

  /// Requests permissions for push notifications on iOS
  /// There is no need to call this method on Android
  /// if called on Android it will always return authorization status authorized
  Future<NotificationSettings> requestPermissions({
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  }) async {
    NotificationSettings settings = await _fcm.requestPermission(
      alert: alert,
      announcement: announcement,
      badge: badge,
      carPlay: carPlay,
      criticalAlert: criticalAlert,
      provisional: provisional,
      sound: sound,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      Logger.d('NotificationsManager - User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      Logger.d('NotificationsManager - User granted provisional permission');
    } else {
      Logger.w(
          'NotificationsManager - User declined or not accepted permission');
    }

    return settings;
  }

  /// Returns bool that indicates if push notifications are authorized
  /// On Android it is always true
  Future<bool> isPushAuthorized() async {
    // return true;

    final notificationSettings = await _fcm.getNotificationSettings();
    return notificationSettings.authorizationStatus ==
        AuthorizationStatus.authorized;
  }

  /// Returns the current authorization status for push notifications
  /// On Android it is always authorized
  Future<AuthorizationStatus> getAuthorizationStatus() async {
    final notificationSettings = await _fcm.getNotificationSettings();
    return notificationSettings.authorizationStatus;
  }

  /// Returns ANPS token for iOS
  /// Return null for Android/web
  Future<String?> getAPNSToken() async {
    final token = await _fcm.getAPNSToken();
    return token;
  }

  Future<void> _onAPNSTokenReceived(String? token) async {
    Logger.d('APNS Token $token');

    final storedToken = await _apnsTokenStorage.get();

    if (storedToken == null || storedToken != token) {
      await _apnsTokenStorage.save(token!);
    }
  }

  Future<void> _onFCMTokenReceived(String? token) async {
    Logger.d('NotificationsManager - FCM Token $token');

    final storedToken = await _fcmTokenStorage.get();

    if (storedToken == null || storedToken != token) {
      await _fcmTokenStorage.save(token!);
    }
  }

  _onMessage(RemoteMessage message) async {
      String notificationTitle = message.notification!.title!;
      String notificationBody = message.notification!.body!;
      const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
        CHANNEL_ID,
        CHANNEL_NAME,
        CHANNEL_DESCRIPTION,
        importance: Importance.max,
        priority: Priority.high,
      );
      const NotificationDetails platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);
      await flNotification.show(
          0, notificationTitle, notificationBody, platformChannelSpecifics);
  }

  _onAppOpenedFromMessage(RemoteMessage message) {
    Logger.d('NotificationsManager - Opened from remote message');
  }
}

Future<void> backgroundMessageHandler(message) async {
  Logger.w('NotificationsManager - Bg message missed. User unauthorized');
}
