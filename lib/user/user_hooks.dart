/*
  User Hooks

  These hooks provide a mechanism for components to be configured
  to perform actions automatically when certain user events happen.
  For example cleanup user files on logout, enable/disable push
  notifications, etc.

  In UserManager we can register login, logout, and update hooks and
  define actions to be performed when these events happen.

  This decouples the components by avoiding the need to:
  - components be manually called anywhere in the app on event (logout for example)
  - components to directly depend on user manager
  - user manager to directly depend on components that need to do an action on event
*/

import 'package:flutter_template/user/user_manager.dart';

/// Performs an action after the user login event.
///
/// Note that this action happens only when the user logs in,
/// not when the app is restarted and the logged in user is loaded.
/// For every user update event see [UserManager.updates] or [UserUpdateHook].
///
/// Register when creating [UserManager].
abstract class LoginHook<U> {
  Future<void> postLogin(U user);
}

/// Performs an action after the user logout event.
///
/// Note that this action happens only when the user logs out,
/// not when the session expires or the app is restarted without logged in user.
/// For every user update event see [UserManager.updates] or [UserUpdateHook].
///
/// Register when creating [UserManager].
abstract class LogoutHook {
  Future<void> postLogout();
}

/// Convenience hook for providing [UserManager.updates] to registered clients.
///
/// Register when creating [UserManager].
abstract class UserUpdatesHook<U> {
  /// The [userUpdates] stream will provide real-time user updates
  /// and will be active throughout the app's lifecycle capturing
  /// login, logout, and update events, even if different users log in.
  ///
  /// You can subscribe to this stream at any point and will receive the
  /// latest user state and subsequent updates.
  /// __Just mind to unsubscribe when done using it__.
  void onUserUpdatesProvided(Stream<U?> userUpdates);
}
