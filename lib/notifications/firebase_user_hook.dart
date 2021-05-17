import 'dart:async';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter_template/model/user/user_credentials.dart';
import 'package:flutter_template/notifications/notifications_manager.dart';
import 'package:flutter_template/user/user_event_hook.dart';

/// Listens for user updates events and configures firebase accordingly.
///
/// - Sets user identifier
/// - Enables/Disables [NotificationsManager]
/// - Cleans up user data on logout
class FirebaseUserHook extends UserEventHook<UserCredentials> {
  final FirebaseCrashlytics _crashlytics;
  final NotificationsManager _notificationsManager;

  StreamSubscription<UserCredentials?>? _streamSubscription;

  FirebaseUserHook(this._crashlytics, this._notificationsManager);

  @override
  void onUserUpdatesProvided(Stream<UserCredentials?> userUpdates) {
    _streamSubscription = userUpdates
        .distinct((prev, next) => prev.isLoggedIn() == next.isLoggedIn())
        .listen((userCredentials) async {
      if (userCredentials.isLoggedIn()) {
        await _onUserAuthorized(userCredentials!);
      } else {
        await _onUserUnauthorized();
      }
    });
  }

  Future<void> _onUserAuthorized(UserCredentials userCredentials) async {
    _crashlytics.setUserIdentifier(userCredentials.user.id);

    if (!_notificationsManager.setupStarted) {
      await _notificationsManager.setupPushNotifications();
    }
    _notificationsManager.userAuthorized = true;
  }

  Future<void> _onUserUnauthorized() async {
    final timeNow = DateTime.now().millisecondsSinceEpoch;
    _crashlytics.setUserIdentifier('n/a: $timeNow');

    _notificationsManager.userAuthorized = false;
  }

  @override
  Future<void> postLogout() => _notificationsManager.disablePushNotifications();

  Future<void> tearDown() async {
    await _streamSubscription?.cancel();
    _streamSubscription = null;
  }
}
