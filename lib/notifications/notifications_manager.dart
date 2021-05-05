import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';

/// Manages push notifications of logged-in user within the app.
class NotificationsManager {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  NotificationsManager();

  setupPushNotifications() async {
    if (Platform.isIOS) {
      final _ = await requestPermissions();

      final apnsToken = await _firebaseMessaging.getAPNSToken();
      _onAPNSTokenReceived(apnsToken);
    }

    final fcmToken = await _firebaseMessaging.getToken();
    _onFCMTokenReceived(fcmToken);

    _firebaseMessaging.onTokenRefresh.listen((token) {
      print('FCM Token refresh');
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

  /// Requests permissions for push notifications on iOS
  /// There is no need to call this method on Android
  /// if called on Android it will always return authorization status authorized
  Future<NotificationSettings> requestPermissions({alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true}) async {
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: alert,
      announcement: announcement,
      badge: badge,
      carPlay: carPlay,
      criticalAlert: criticalAlert,
      provisional: provisional,
      sound: sound,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }

    return settings;
  }

  /// Returns bool that indicates if push notifications are authorized
  /// On Android it is always true
  Future<bool> isPushAuthorized() async {
    // return true;

    final notificationSettings =
    await _firebaseMessaging.getNotificationSettings();
    return notificationSettings.authorizationStatus ==
        AuthorizationStatus.authorized;
  }

  /// Returns the current authorization status for push notifications
  /// On Android it is always authorized
  Future<AuthorizationStatus> getAuthorizationStatus() async {
    final notificationSettings =
    await _firebaseMessaging.getNotificationSettings();
    return notificationSettings.authorizationStatus;
  }

  /// Returns ANPS token for iOS
  /// Return null for Android/web
  Future<String?> getAPNSToken() async {
    final token = await _firebaseMessaging.getAPNSToken();
    return token;
  }

  _onAPNSTokenReceived(String? token) {
    print('APNS Token $token');
  }

  _onFCMTokenReceived(String? token) {
    print('FCM Token $token');
  }

  _onMessage(RemoteMessage message) {
    print('New remote message}');
  }

  _onAppOpenedFromMessage(RemoteMessage message) {
    print('Opened from remote message');
  }
}
