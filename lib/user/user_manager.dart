import 'dart:async';

import 'package:flutter_template/log/logger.dart';
import 'package:flutter_template/model/user/credentials.dart';
import 'package:flutter_template/model/user/user.dart';
import 'package:flutter_template/model/user/user_credentials.dart';
import 'package:flutter_template/network/api_service.dart';
import 'package:flutter_template/network/errors/unauthorized_user_exception.dart';
import 'package:flutter_template/user/user_hooks.dart';
import 'package:flutter_template/util/nullable_util.dart';
import 'package:flutter_template/util/updates_stream.dart';
import 'package:single_item_storage/storage.dart';

/// Manages a single logged-in user within the app.
///
/// Subscribe to `updates` and `updatesSticky` to listen for changes.
///
/// Or use the [hooks] to register for specific events:
/// - Provide login and logout hooks to perform external actions after
/// these events. For example update cleanup DB.
/// - Provide update hooks to more easily register to [updatesSticky].
///
/// To obtain an instance use `serviceLocator.get<UserManager>()`
class UserManager with UpdatesStream<UserCredentials> {
  final ApiService _apiService;
  final Storage<UserCredentials?> _userStore;
  final Set<LoginHook<UserCredentials>> loginHooks;
  final Set<LogoutHook> logoutHooks;

  UserManager(
    this._apiService,
    this._userStore, {
    Iterable<LoginHook<UserCredentials>> loginHooks = const [],
    Iterable<LogoutHook> logoutHooks = const [],
    Iterable<UserUpdatesHook<UserCredentials>> updateHooks = const [],
  })  : this.loginHooks = Set.unmodifiable(loginHooks),
        this.logoutHooks = Set.unmodifiable(logoutHooks) {
    updateHooks.forEach((hook) => hook.onUserUpdatesProvided(updatesSticky));

    _userStore.get().onError((error, stackTrace) async {
      Logger.e(error ?? 'Error loading user from disk');
      return null;
    }).then((user) => addUpdate(user));
  }

  /// Emits a user update event to listeners
  /// to [updates] and [updatesSticky].
  @override
  void addUpdate(UserCredentials? event) {
    Logger.d('UserManager - User update event: $event');
    super.addUpdate(event);
  }

  /// Gets the user or null if there is no logged in user.
  Future<UserCredentials?> getLoggedInUser() => _userStore.get();

  /// Checks if the user is logged in.
  ///
  /// todo You may want to add custom logic here
  Future<bool> isLoggedIn() =>
      _userStore.get().then((userCredentials) => userCredentials.isLoggedIn());

  /// Logs-in the user and triggers an update to the user [updates] stream.
  /// If the user is already logged in, the user is returned with no additional action.
  Future<UserCredentials> login(String username, String password) async {
    Logger.d('UserManager - Login in progress...');

    if (await isLoggedIn()) {
      Logger.w('UserManager - Abort login: Already logged in!');
      return _userStore.get().asNonNullable();
    }

    final credentials = await _apiService.login(username, password);
    final user = await _apiService.getUserProfile(token: credentials.token);
    final userCredentials = UserCredentials(user, credentials);

    Logger.d('UserManager - Login success: $userCredentials');
    await _userStore.save(userCredentials);

    for (var loginHook in loginHooks) {
      await loginHook
          .postLogin(userCredentials)
          .catchError((err) => Logger.e('UserManager - LoginHook error: $err'));
    }

    addUpdate(userCredentials);
    return userCredentials;
  }

  /// Logs-out the user and triggers an update to the user [updates] stream.
  /// If the user is already logged out, the [Future] completes without doing anything.
  /// Todo: Mind to handle the error response.
  Future<void> logout() async {
    Logger.d('UserManager - Logout in progress...');

    if (!(await isLoggedIn())) {
      Logger.w('UserManager - Abort logout: Already logged out!');
      return;
    }

    await _apiService.logout();
    await _userStore.delete();
    Logger.d('UserManager - Logout success');

    for (var logoutHook in logoutHooks) {
      await logoutHook
          .postLogout()
          .catchError((e) => Logger.e('UserManager - LogoutHook error: $e'));
    }

    addUpdate(null);
  }

  /// Updates current user's credentials and triggers an update to [updates] stream.
  Future<UserCredentials> updateCredentials(Credentials? credentials) async {
    Logger.d('UserManager - Updating credentials w/ new $credentials');

    if (!(await isLoggedIn())) {
      Logger.e('UserManager - Updating credentials error: User logged out!');
      final UserCredentials? oldUser = await _userStore.get();

      if (oldUser?.credentials == null) {
        throw UnauthorizedUserException('Updating credentials on logged out usr');
      }
    }

    final UserCredentials oldUser = await _userStore.get().asNonNullable();
    final UserCredentials newUser = UserCredentials(oldUser.user, credentials);

    await _userStore.save(newUser);
    Logger.d('UserManager - Updating credentials success');

    addUpdate(newUser);
    return newUser;
  }

  /// Updates current user's credentials and triggers an update to [updates] stream.
  Future<User> updateUser(User user) async {
    Logger.d('UserManager - Updating user w/ new $user');

    if (!(await isLoggedIn())) {
      Logger.e('UserManager - Updating user error: User logged out!');
      await _userStore.delete();
      throw UnauthorizedUserException('Updating user on logged out usr');
    }

    await _apiService.updateUserProfile(user);
    Logger.d('UserManager - Updating user success');

    return refreshUser();
  }

  /// Fetches a fresh copy of [User] and triggers an update to [updates] stream
  /// if there is a change.
  Future<User> refreshUser() async {
    Logger.d('UserManager - Refreshing user profile...');

    if (!(await isLoggedIn())) {
      Logger.e('UserManager - Refreshing user error: User logged out!');
      await _userStore.delete();
      throw UnauthorizedUserException('Refreshing a logged out user');
    }

    final User newUser = await _apiService.getUserProfile();

    final UserCredentials? oldUserCredentials = await _userStore.get();
    final UserCredentials newUserCredentials = UserCredentials(
      newUser,
      oldUserCredentials?.credentials,
    );

    if (oldUserCredentials?.user != newUser) {
      await _userStore.save(newUserCredentials);
      addUpdate(newUserCredentials);
    } else {
      Logger.d('UserManager - Getting profile. No changes.');
    }

    return newUser;
  }

  /// Deactivates the user's profile and triggers an update to [updates] stream.
  Future<void> deactivateUser() async {
    Logger.d('UserManager - Deactivating user');
    await _apiService.deactivate();
    await _userStore.delete();
    Logger.d('UserManager - Deactivating user success');
    addUpdate(null);
  }

  /// Releases resources held by this component making it unusable.
  /// Call when the app is closing.
  /// This method does not delete saved data.
  Future<void> teardown() async {
    await closeUpdatesStream();
  }
}
