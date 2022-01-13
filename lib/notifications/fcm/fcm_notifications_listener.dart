import 'dart:io';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_template/config/firebase_config.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_template/log/log.dart';
import 'package:flutter_template/notifications/data/data_notification_manager.dart';
import 'package:flutter_template/notifications/fcm/fcm_remote_message.dart';
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
/// Advanced usage:
/// https://firebase.flutter.dev/docs/messaging/notifications/
///
/// <br />
/// To obtain an instance use `serviceLocator.get<FcmNotificationsListener>()`
class FcmNotificationsListener {
  final NotificationConsumer dataPayloadConsumer;

  /// If true creates a local notification for Android only
  /// On iOS the system shows the remote push notification by default
  /// To change the iOS behavior see
  /// setForegroundNotificationPresentationOptions in setupPushNotifications
  final bool showInForeground;

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
    InitializationSettings initializationSettings, {
    this.showInForeground = true,
    required Storage<String> fcm,
    required Storage<String> apns,
    required this.dataPayloadConsumer,
  })  : _fcmTokenStorage = fcm,
        _apnsTokenStorage = apns {
    if (shouldConfigureFirebase()) {
      _fcm = FirebaseMessaging.instance;
    }
    flNotification = FlutterLocalNotificationsPlugin();
    flNotification.initialize(initializationSettings);
  }

  bool get setupStarted => _setupStarted;

  setupPushNotifications() async {
    if (_setupStarted) {
      Log.d('FCM - Setup: Aborting, already completed.');
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
      Log.d('FCM - Token refresh');
      _onFCMTokenReceived(token);
    });

    // Foreground message
    FirebaseMessaging.onMessage.listen((message) {
      ifUserAuthorized(() {
        Log.d('FCM - Foreground message: ${message.print()}');
        if (showInForeground) {
          _showNotificationOnAndroid(message);
        }
        if (message.messageType != null) {
          dataPayloadConsumer.onNotificationMessage(message);
        }
      });
    });

    // Background message
    FirebaseMessaging.onBackgroundMessage(backgroundMessageHandler);

    // App opened from message
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      ifUserAuthorized(() {
        Log.d('FCM - App opened from remote message: ${message.print()}');
        if (message.messageType != null) {
          dataPayloadConsumer.onAppOpenedFromMessage(message);
        }
      });
    });

    FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: showInForeground,
      badge: showInForeground,
      sound: showInForeground,
    );
  }

  Future<void> disablePushNotifications() async {
    await _fcm.deleteToken();
    await _fcmTokenStorage.delete();
    await _apnsTokenStorage.delete();

    _setupStarted = false;
  }

  void _showNotificationOnAndroid(RemoteMessage message) async {
    if (!Platform.isAndroid) {
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

  R? ifUserAuthorized<R>(R? Function() action) {
    if (userAuthorized) {
      return action();
    } else {
      Log.w('FCM - Message missed. User unauthorized.');
    }
  }

  /// Requests permissions for push notifications on iOS
  /// There is no need to call this method on Android
  /// if called on Android it will always return authorization status authorized
  Future<NotificationSettings> requestPermissions({
    bool? alert,
    bool? badge,
    bool? sound,
    bool announcement = false,
    bool carPlay = false,
    bool criticalAlert = false,
    bool provisional = false,
  }) async {
    NotificationSettings settings = await _fcm.requestPermission(
      alert: alert ?? showInForeground,
      badge: badge ?? showInForeground,
      sound: sound ?? showInForeground,
      announcement: announcement,
      carPlay: carPlay,
      criticalAlert: criticalAlert,
      provisional: provisional,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      Log.d('FCM - User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      Log.d('FCM - User granted provisional permission');
    } else {
      Log.w('FCM - User declined or not accepted permission');
    }

    return settings;
  }

  /// Returns bool that indicates if push notifications are authorized
  /// On Android it is always true
  Future<bool> isPushAuthorized() async {
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
    Log.d('FCM - Token: $token');

    final storedToken = await _fcmTokenStorage.get();

    if (storedToken == null || storedToken != token) {
      if (token != null) {
        await _fcmTokenStorage.save(token);
      }
    }
  }
}

Future<void> backgroundMessageHandler(message) async {
  Log.w('FCM - Background message: ${message.print()}. '
      'Waiting for user to tap and open app before handling.');

  //todo change this behavior if you wish but read this first
  //https://firebase.flutter.dev/docs/messaging/usage/#background-messages
}
