import 'dart:io';
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
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  final Storage<String> _fcmTokenStorage;
  final Storage<String> _apnsTokenStorage;

  NotificationsManager({
    Storage<String>? fcmTokenStorage,
    Storage<String>? apnsTokenStorage,
  })  : _fcmTokenStorage = fcmTokenStorage ??
            SharedPrefsStorage<String>.primitive(itemKey: fcmDeviceTokenKey),
        _apnsTokenStorage = apnsTokenStorage ??
            SharedPrefsStorage<String>.primitive(itemKey: apnsDeviceTokenKey);

  setupPushNotifications() async {
    if (Platform.isIOS) {
      await requestPermissions();

      final apnsToken = await _fcm.getAPNSToken();
      _onAPNSTokenReceived(apnsToken);
    }

    final fcmToken = await _fcm.getToken();
    _onFCMTokenReceived(fcmToken);

    _fcm.onTokenRefresh.listen((token) {
      Logger.d('FCM Token refresh');
      _onFCMTokenReceived(token);
    });

    FirebaseMessaging.onMessage.listen((message) {
      _onMessage(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      _onAppOpenedFromMessage(message);
    });

    FirebaseMessaging.onBackgroundMessage((message) => _onMessage(message));
  }

  disablePushNotifications() async {
    await _fcm.deleteToken();
    await _fcmTokenStorage.delete();
    await _apnsTokenStorage.delete();
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
      Logger.d('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      Logger.d('User granted provisional permission');
    } else {
      Logger.w('User declined or has not accepted permission');
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
    Logger.d('FCM Token $token');

    final storedToken = await _fcmTokenStorage.get();

    if (storedToken == null || storedToken != token) {
      await _fcmTokenStorage.save(token!);
    }
  }

  _onMessage(RemoteMessage message) {
    Logger.d('New remote message}');
  }

  _onAppOpenedFromMessage(RemoteMessage message) {
    Logger.d('Opened from remote message');
  }
}
