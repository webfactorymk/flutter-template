import 'dart:io';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_template/config/firebase_config.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_template/log/log.dart';
import 'package:flutter_template/notifications/notifications_manager.dart';
import 'package:single_item_storage/storage.dart';

/// Listens for remote messages using Firebase Cloud Messaging (FCM)
///
/// <br />
/// For integration instructions visit:
/// https://firebase.flutter.dev/docs/messaging/overview
///
/// Message types:
/// https://firebase.flutter.dev/docs/messaging/usage/#message-types
///
/// <br />
/// To obtain an instance use `serviceLocator.get<FcmNotificationsListener>()`
class FcmNotificationsListener {
  final NotificationConsumer _notificationConsumer;

  late final FirebaseMessaging _fcm;
  late final FlutterLocalNotificationsPlugin flNotification;

  final Storage<String> _fcmTokenStorage;
  final Storage<String> _apnsTokenStorage;

  bool _setupStarted = false;
  bool userAuthorized = false;

  //TODO change this values before using them
  static const String CHANNEL_ID = 'foreground';
  static const String CHANNEL_NAME = 'channel name';
  static const String CHANNEL_DESCRIPTION = 'channel description';

  FcmNotificationsListener(
    InitializationSettings initializationSettings,
    NotificationConsumer notificationConsumer, {
    required Storage<String> fcm,
    required Storage<String> apns,
  })  : _fcmTokenStorage = fcm,
        _apnsTokenStorage = apns,
        _notificationConsumer = notificationConsumer {
    if (shouldConfigureFirebase()) {
      _fcm = FirebaseMessaging.instance;
    }
    flNotification = FlutterLocalNotificationsPlugin();
    flNotification.initialize(initializationSettings);
  }

  bool get setupStarted => _setupStarted;

  setupPushNotifications() async {
    if (_setupStarted) {
      Log.d('NotificationsManager - Setup: Aborting, already completed.');
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
      Log.d('NotificationsManager - FCM Token refresh');
      _onFCMTokenReceived(token);
    });

    FirebaseMessaging.onMessage.listen((message) {
      if (userAuthorized) {
        _onMessage(message);
      } else {
        Log.w('NotificationsManager - Message missed. User unauthorized');
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      if (userAuthorized) {
        _onAppOpenedFromMessage(message);
      } else {
        Log.w('NotificationsManager - App not opened. User unauthorized');
      }
    });

    FirebaseMessaging.onBackgroundMessage(backgroundMessageHandler);

    //TODO change this behavior depending on your app requirements
    FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
        alert: true, badge: true, sound: true);
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
      Log.d('NotificationsManager - User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      Log.d('NotificationsManager - User granted provisional permission');
    } else {
      Log.w('NotificationsManager - User declined or not accepted permission');
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
    Log.d('APNS Token $token');

    final storedToken = await _apnsTokenStorage.get();

    if (storedToken == null || storedToken != token) {
      if (token != null) {
        await _apnsTokenStorage.save(token);
      }
    }
  }

  Future<void> _onFCMTokenReceived(String? token) async {
    Log.d('NotificationsManager - FCM Token $token');

    final storedToken = await _fcmTokenStorage.get();

    if (storedToken == null || storedToken != token) {
      if (token != null) {
        await _fcmTokenStorage.save(token);
      }
    }
  }

  /// Creates a local notification for Android only
  /// On iOS the system shows the remote push notification by default
  /// To change the iOS behavior see setForegroundNotificationPresentationOptions in setupPushNotifications
  _onMessage(RemoteMessage message) async {
    if (Platform.isIOS) {
      return;
    }

    String? notificationTitle = message.notification?.title;
    String? notificationBody = message.notification?.body;
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      CHANNEL_ID,
      CHANNEL_NAME,
      channelDescription: CHANNEL_DESCRIPTION,
      importance: Importance.max,
      priority: Priority.high,
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flNotification.show(
        0, notificationTitle, notificationBody, platformChannelSpecifics);
  }

  _onAppOpenedFromMessage(RemoteMessage message) {
    Log.d('NotificationsManager - Opened from remote message');
  }
}

Future<void> backgroundMessageHandler(message) async {
  Log.w('NotificationsManager - Bg message missed. User unauthorized');
}
