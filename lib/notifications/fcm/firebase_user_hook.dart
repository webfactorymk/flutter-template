import 'dart:async';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter_template/model/user/user_credentials.dart';
import 'package:flutter_template/notifications/fcm/fcm_notifications_listener.dart';
import 'package:flutter_template/user/user_event_hook.dart';
import 'package:flutter_template/util/date_time_util.dart';

/// Listens for user updates events and configures firebase accordingly.
///
/// - Sets user identifier
/// - Enables/Disables [FcmNotificationsListener]
/// - Cleans up user data on logout
class FirebaseUserHook extends UserEventHook<UserCredentials> {
  final FirebaseCrashlytics _crashlytics;
  final FcmNotificationsListener _notificationListener;

  FirebaseUserHook(this._crashlytics, this._notificationListener);

  @override
  Future<void> onUserAuthorized(UserCredentials userCredentials, bool _) async {
    await _crashlytics.setUserIdentifier(userCredentials.user.id);

    if (!_notificationListener.setupInitialized) {
      await _notificationListener.setupPushNotifications();
    }
  }

  @override
  Future<void> onUserUnauthorized(bool _) async {
    await _notificationListener.disablePushNotifications();
    await _crashlytics.setUserIdentifier('n/a: ${DateUtils.timestamp}');
  }
}
