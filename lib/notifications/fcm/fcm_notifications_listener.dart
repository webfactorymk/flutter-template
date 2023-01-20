import 'dart:async';
import 'dart:io';

import 'package:flutter_template/config/firebase_config.dart';
import 'package:flutter_template/log/log.dart';
import 'package:flutter_template/network/user_api_service.dart';
import 'package:flutter_template/notifications/data/data_notification_consumer.dart';
import 'package:flutter_template/notifications/data/model/message.dart' as model;
import 'package:flutter_template/notifications/data/model/remote_message_extension.dart';
import 'package:flutter_template/notifications/data/parser/base_message_type_parser.dart';
import 'package:flutter_template/notifications/local/android_notification_details.dart';
import 'package:flutter_template/notifications/local/android_notification_ids.dart';
import 'package:flutter_template/notifications/local/local_notification_manager.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
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
/// On message types:
/// Data-only messages are considered low priority by devices when
/// your application is in the background or terminated, and will be ignored.
/// You can however explicitly increase the priority by sending additional
/// properties on the FCM payload:
/// On Android, set the priority field to high.
/// On Apple (iOS & macOS), set the content-available field to true.
///
/// <br />
/// To obtain an instance use `serviceLocator.get<FcmNotificationsListener>()`
class FcmNotificationsListener {
  final DataNotificationConsumer dataNotificationConsumer;
  final LocalNotificationsManager localNotificationsManager;
  final UserApiService userApiService;
  final Storage<String> _fcmTokenStorage;

  /// If true creates a local notification for Android only.
  ///
  /// Notification messages which arrive whilst the application is in the
  /// foreground will not display a visible notification by default,
  /// on both Android & iOS. It is, however, possible to override this behavior:
  /// - On Android, you must create a "High Priority" notification channel. BUT,
  ///   this doesn't seem to work...
  /// - On iOS, you can update the presentation options for the application.
  ///
  /// On iOS the system shows the remote push notification by default
  /// To change the iOS behavior see
  /// setForegroundNotificationPresentationOptions in setupPushNotifications
  final bool showInForeground;

  late final FirebaseMessaging _fcm;

  StreamSubscription? _tokenSubscription;
  StreamSubscription? _foregroundSubscription;
  StreamSubscription? _foregroundClickSubscription;

  bool _setupInitialized = false;
  bool _userAuthorized = false;

  FcmNotificationsListener({
    this.showInForeground = true,
    required Storage<String> fcm,
    required this.dataNotificationConsumer,
    required this.localNotificationsManager,
    required this.userApiService,
  }) : _fcmTokenStorage = fcm {
    if (shouldConfigureFirebase()) {
      _fcm = FirebaseMessaging.instance;
    }
  }

  bool get setupInitialized => _setupInitialized;

  Future<void> setupPushNotifications() async {
    if (_setupInitialized) {
      Log.d('FCM - Setup: Aborting, already completed.');
      return;
    }
    Log.d("FCM - Setup push notifications");

    _setupInitialized = true;

    await requestPermissions();

    final fcmToken = await _fcm.getToken();
    await _onFCMTokenReceived(fcmToken);

    _tokenSubscription = _fcm.onTokenRefresh.listen((token) async {
      Log.d('FCM - Token refresh');
      await _onFCMTokenReceived(token);
    });

    FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: showInForeground,
      badge: false,
      sound: showInForeground,
    );

    // Register foreground message handler
    _foregroundSubscription =
        FirebaseMessaging.onMessage.listen(_onForegroundMessage);

    // Register background notification handler.
    // This will be called when the app is in the background or terminated
    FirebaseMessaging.onBackgroundMessage(backgroundMessageHandler);

    // Notification click listener when app is in background (or foreground), but not terminated
    _foregroundClickSubscription = FirebaseMessaging.onMessageOpenedApp
        .listen((message) => _onAppOpenedFromMessage(message, false));

    // Notification click listener when app is terminated and eventually opened
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((message) => _onAppOpenedFromMessage(message, true));

    _userAuthorized = true;
  }

  Future<void> disablePushNotifications() async {
    if (!_setupInitialized) {
      Log.w('FCM - Aborting push notification disable, already disabled.');
      return;
    }
    Log.d('FcmNotificationsListener - Disable push notifications');

    await _tokenSubscription?.cancel();
    await _foregroundSubscription?.cancel();
    await _foregroundClickSubscription?.cancel();

    await _fcm.deleteToken();
    await _fcmTokenStorage.delete();

    _userAuthorized = false;
    _setupInitialized = false;
  }

  R? ifUserAuthorized<R>(R? Function() action) {
    if (_userAuthorized) {
      return action();
    } else {
      print('FCM - Message missed. User unauthorized.');
      return null;
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
      badge: badge ?? false,
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

  Future<void> _onFCMTokenReceived(String? token) async {
    Log.d('FCM - Token: ${token == null ? 'false' : 'true'}');
    if (kDebugMode) print('FCM - Token: $token');

    final storedToken = await _fcmTokenStorage.get();

    if (storedToken == null || storedToken != token) {
      if (token != null) {
        final deviceType = Platform.isIOS ? 'iOS' : 'ANDROID';
        //DeviceType.ios.name : DeviceType.android.name;

        try {
          await userApiService.addNotificationsToken(token);
          await _fcmTokenStorage.save(token);
        } catch (error) {
          Log.e('_onAPNSTokenReceived error ${error.toString()}');
        }
      }
    }
  }

  /// Handle receiving message when app is in foreground.
  Future<void> _onForegroundMessage(RemoteMessage message) async {
    if (!message.hasType()) {
      Log.w('FCM - Message without a type: ${message.print()}');
    }

    ifUserAuthorized(() async {
      Log.d('FCM - Foreground message: ${message.print()}');

      if (showInForeground &&
          Platform.isAndroid &&
          message.notification != null) {
        final type = getTypeFromRawData(message);
        final id = message.messageId != null && message.messageId!.isNotEmpty
            ? message.messageId.hashCode
            : getMessageIdForType(type);
        final title = message.notification!.title;
        final body = message.notification!.body;
        final notificationDetails = getNotifDetailsForMessageType(type);
        final payload = model.Message(
            type: type, messageId: message.messageId, title: title, body: body);
        localNotificationsManager.displayAndroidNotification(
            id, title, body, notificationDetails,
            payload: payload);
      }

      await dataNotificationConsumer.onNotificationMessageForeground(message);
    });
  }

  /// Handle the click event on notification when app is in any state
  Future<void> _onAppOpenedFromMessage(RemoteMessage? message,
      bool fromTerminatedState,) async {
    if (message != null) {
      print('FCM - OnAppOpenedFromNotification - '
          'fromTerminatedState: $fromTerminatedState, '
          'message: ${message.print()}');
      ifUserAuthorized(() async {
        await dataNotificationConsumer.onAppOpenedFromMessage(message, null);
      });
    }
  }
}

/// Receives message when the app is in background and terminated.
///
/// On Android this code will run on separate isolate.
///
/// Please note: Before using any method here, make sure that you have all dependencies initialized,
/// because you can encounter a case on android where this code will run on separate isolate.
@pragma('vm:entry-point')
Future<void> backgroundMessageHandler(RemoteMessage message) async {
  print('FCM - Background message: ${message.print()}. '
      'Waiting for user to tap and open app before handling.');

  //todo change this behavior if you wish but read this first
  //https://firebase.flutter.dev/docs/messaging/usage/#background-messages

  //TODO before using dataPayloadConsumer make sure all components are initialized..
  //see code below
}

/* Background message handler that will handle messages on separate isolate */

// /// Receives message when the app is in background or terminated.
// ///
// /// On Android this code will run on separate isolate.
// ///
// /// Please note: Before using any method here, make sure that you have all dependencies initialized,
// /// because you can encounter a case on android where this code will run on separate isolate.
// ///
// /// Change this behavior if you wish, but read this first
// /// https://firebase.flutter.dev/docs/messaging/usage/#background-messages
// @pragma('vm:entry-point')
// Future<void> backgroundMessageHandler(RemoteMessage message) async {
//   print('FCM - Background message: ${message.print()}. '
//       'Waiting for user to tap and open app before handling.');
//   if (!message.hasType()) {
//     print('FCM - Message without a type: ${message.print()}');
//   }
//
//   DataNotificationConsumer notificationConsumer;
//   bool userAuthorized;
//   if (Platform.isAndroid) {
//     userAuthorized = await userCredentialsSecureStorage().get() != null;
//     notificationConsumer = DataNotificationConsumerFactory.create();
//     DataNotificationConsumerFactory.registerNewMessageHandlers(
//       notificationConsumer,
//       LocalNotificationsManager.create(),
//       PlatformComm.generalAppChannel(JsonDataConverter()),
//     );
//   } else {
//     userAuthorized = await serviceLocator.get<UserManager>().isLoggedIn();
//     notificationConsumer = serviceLocator.get<DataNotificationConsumer>();
//   }
//
//   if (userAuthorized) {
//     await notificationConsumer.onNotificationMessageBackground(message);
//   } else {
//     print('FCM - Message missed. User unauthorized.');
//   }
// }
