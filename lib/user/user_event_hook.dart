import 'package:flutter_template/user/user_manager.dart';

/// User Event Hooks
///
/// These hooks provide a mechanism for components listen and react
/// when certain user events happen. For example cleanup user files on logout,
/// enable/disable push notifications, etc.
///
/// Implement [UserEventHooks], override needed methods
/// and register your implementation when creating [UserManager].
abstract class UserEventHook<U> {
  /// Performs an action after authorised user is established.
  ///
  /// This action happens when the user:
  ///
  /// - explicitly logs in
  ///   <br><i>where [isExplicitUserLogin] = `true`</i>,
  ///
  /// - the app is launched with authorized user
  ///   <br><i>where [isExplicitUserLogin] = `false`</i>.
  ///
  /// Note: Mind that duplicate events shouldn't, but might happen.
  /// Do not use this method for user model updates!
  Future<void> onUserAuthorized(U user, bool isExplicitUserLogin) =>
      Future.value();

  /// Performs an action after the user is no longer authorized.
  ///
  /// This action happens when the user:
  ///
  /// - explicitly logs out
  ///   <br><i>where [isExplicitUserLogout] = `true`</i>,
  ///
  /// - the app is launched without logged in user
  ///   <br><i>where [isExplicitUserLogout] = `false`</i>,
  ///
  /// - the session expires
  ///   <br><i>where [isExplicitUserLogout] = `false`</i>.
  ///
  /// _Note: Mind that duplicate events shouldn't, but might happen._
  Future<void> onUserUnauthorized(bool isExplicitUserLogout) => Future.value();

  /// Convenience hook for providing [UserManager.updates] to registered clients.
  ///
  /// The [userUpdates] stream will provide real-time user updates
  /// and will be active throughout the app's lifecycle capturing
  /// login, logout, and update events, even if different users log in.
  ///
  /// You can subscribe to this stream at any point and will receive the
  /// latest user state and subsequent updates.
  /// __Mind to unsubscribe when done using it__.
  void onUserUpdatesProvided(Stream<U?> userUpdates) {}
}

/// Stub [UserEventHook] that will do nothing.
class StubUserEventHook<U> extends UserEventHook<U> {}
