import 'dart:async';
import 'dart:io';
import 'package:flutter_template/config/firebase_config.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_template/log/log.dart';
import 'package:flutter_template/notifications/data/data_notification_manager.dart';
import 'package:flutter_template/notifications/fcm/fcm_remote_message.dart';
import 'package:flutter_template/notifications/local/local_notification_manager.dart';
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
  final LocalNotificationsManager localNotificationsManager;

  /// If true creates a local notification for Android only
  /// On iOS the system shows the remote push notification by default
  /// To change the iOS behavior see
  /// setForegroundNotificationPresentationOptions in setupPushNotifications
  final bool showInForeground;

  late final FirebaseMessaging _fcm;

  final Storage<String> _fcmTokenStorage;
  final Storage<String> _apnsTokenStorage;

  bool _setupStarted = false;
  bool userAuthorized = false;

  late StreamSubscription _tokenSubscription;
  late StreamSubscription _foregroundSubscription;
  late StreamSubscription _foregroundClickSubscription;

  FcmNotificationsListener({
    this.showInForeground = true,
    required Storage<String> fcm,
    required Storage<String> apns,
    required this.dataPayloadConsumer,
    required this.localNotificationsManager,
  })  : _fcmTokenStorage = fcm,
        _apnsTokenStorage = apns {
    if (shouldConfigureFirebase()) {
      _fcm = FirebaseMessaging.instance;
    }
  }

  bool get setupStarted => _setupStarted;

  Future<void> setupPushNotifications() async {
    if (_setupStarted) {
      Log.d('FCM - Setup: Aborting, already completed.');
      return;
    }

    _setupStarted = true;
    await requestPermissions();

    if (Platform.isIOS) {
      final apnsToken = await _fcm.getAPNSToken();
      await _onAPNSTokenReceived(apnsToken);
    }

    final fcmToken = await _fcm.getToken();
    await _onFCMTokenReceived(fcmToken);

    _tokenSubscription = _fcm.onTokenRefresh.listen((token) async {
      Log.d('FCM - Token refresh');
      await _onFCMTokenReceived(token);
    });

    FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: showInForeground,
      badge: showInForeground,
      sound: showInForeground,
    );

    // Register click on notification handler when app is terminated.
    FirebaseMessaging.instance
        .getInitialMessage()
        .then(_onBackgroundMessageOpenedHandler);

    // Register background notification handler.
    // This will be called when the app is terminated and in background(not terminated)
    FirebaseMessaging.onBackgroundMessage(backgroundMessageHandler);

    // Register foreground message listener
    _foregroundSubscription = FirebaseMessaging.onMessage.listen(_onForegroundMessageHandler);

    // Register click on notification listener when app is in background and not terminated.
    _foregroundClickSubscription = FirebaseMessaging.onMessageOpenedApp
        .listen(_onForegroundMessageOpenedHandler);
  }

  Future<void> disablePushNotifications() async {
    await _tokenSubscription.cancel();
    await _foregroundSubscription.cancel();
    await _foregroundClickSubscription.cancel();
    await _fcm.deleteToken();
    await _fcmTokenStorage.delete();
    await _apnsTokenStorage.delete();

    _setupStarted = false;
  }

  void _showNotificationOnAndroid(RemoteMessage message) async {
    if (!Platform.isAndroid) {
      return;
    }
    if (message.notification != null &&
        message.notification!.title != null &&
        message.notification!.body != null) {

      //TODO change the payload as needed..
      localNotificationsManager.displayAndroidNotification(
        message.notification!.title!,
        message.notification!.body!,
        payload: message.notification!.body,
      );
    } else {
      Log.d('FcmNotificationsListener - Android notification missed');
    }
  }

  R? ifUserAuthorized<R>(R? Function() action) {
    if (userAuthorized) {
      return action();
    } else {
      print('FCM - Message missed. User unauthorized.');
    }
  }

  /// Requests permissions for push notifications.
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
  Future<bool> isPushAuthorized() async {
    final notificationSettings = await _fcm.getNotificationSettings();
    return notificationSettings.authorizationStatus ==
        AuthorizationStatus.authorized;
  }

  /// Returns the current authorization status for push notifications
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

  /// Handle the click event on notification when app is in background and terminated.
  Future<void> _onBackgroundMessageOpenedHandler(RemoteMessage? message) async {
    if (message != null) {
      print('FCM - Terminated app, notification tap handler with message: ' +
          message.print());
      if (message.messageType != null) {
        await dataPayloadConsumer.onAppOpenedFromMessage(message);
      }
    }
  }

  /// Handle the click event on notification when app is in background and not terminated.
  Future<void> _onForegroundMessageOpenedHandler(RemoteMessage message) async {
    Log.d('FCM - Notification tap while app in background and not terminated');
    ifUserAuthorized(() async {
      if (message.messageType != null) {
        await dataPayloadConsumer.onAppOpenedFromMessage(message);
      }
    });
  }

  /// Handle receiving message when app is in foreground.
  Future<void> _onForegroundMessageHandler(RemoteMessage message) async {
    ifUserAuthorized(() async {
      Log.d('FCM - Foreground message: ${message.print()}');
      if (showInForeground) {
        _showNotificationOnAndroid(message);
      }
      if (message.messageType != null) {
        await dataPayloadConsumer.onNotificationMessage(message);
      }
    });
  }
}

/// Receives message when the app is in background and terminated.
///
/// On Android this code will run on separate isolate.
///
/// Please note: Before using any method here, make sure that you have all dependencies initialized,
/// because you can encounter a case on android where this code will run on separate isolate.
Future<void> backgroundMessageHandler(RemoteMessage message) async {
  print('FCM - Background message: ${message.print()}. '
      'Waiting for user to tap and open app before handling.');

  //todo change this behavior if you wish but read this first
  //https://firebase.flutter.dev/docs/messaging/usage/#background-messages

  //TODO before using dataPayloadConsumer make sure all components are initialized..
}
