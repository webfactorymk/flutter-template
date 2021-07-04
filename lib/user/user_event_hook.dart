import 'package:flutter_template/user/user_manager.dart';

/// User Event Hooks
///
/// These hooks provide a mechanism for components to be configured
/// to perform actions automatically when certain user events happen.
/// For example cleanup user files on logout, enable/disable push
/// notifications, etc.
///
/// Implement [UserEventHooks], override needed methods
/// and register your implementation when creating [UserManager].
abstract class UserEventHook<U> {
  /// Performs an action after the user login event.
  ///
  /// Note that this action happens only when the user explicitly logs in,
  /// not when the app is restarted and the logged in user is loaded.
  /// For every user update event see [UserManager.updates] or [onUserLoaded].
  Future<void> postLogin(U user) => Future.value();

  /// Performs an action after the user logout event.
  ///
  /// Note that this action happens only when the user explicitly logs out,
  /// not when the session expires or the app is restarted without logged in user.
  /// For every user update event see [UserManager.updates] or [onUserLoaded].
  Future<void> postLogout() => Future.value();

  /// Convenience hook for providing [UserManager.updates] to registered clients.
  ///
  /// The [userUpdates] stream will provide real-time user updates
  /// and will be active throughout the app's lifecycle capturing
  /// login, logout, and update events, even if different users log in.
  ///
  /// You can subscribe to this stream at any point and will receive the
  /// latest user state and subsequent updates.
  /// __Just mind to unsubscribe when done using it__.
  void onUserUpdatesProvided(Stream<U?> userUpdates) {}

  /// Called when the user is first loaded at app start.
  /// Might be `null` if the user is not logged in.
  ///
  /// <i>This action is awaited in the [UserManager]'s init method so
  /// you can put any initialization that needs happen before the app
  /// UI is loaded (for example setup user scoped components).</i>
  Future<void> onUserLoaded(U? user) => Future.value();
}

/// Stub [UserEventHook] that will do nothing.
class StubUserEventHook<U> extends UserEventHook<U> {}
