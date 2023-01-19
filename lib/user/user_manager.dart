import 'dart:async';

import 'package:flutter_template/log/log.dart';
import 'package:flutter_template/model/user/credentials.dart';
import 'package:flutter_template/model/user/user.dart';
import 'package:flutter_template/model/user/user_credentials.dart';
import 'package:flutter_template/network/user_api_service.dart';
import 'package:flutter_template/network/util/http_util.dart';
import 'package:flutter_template/user/unauthorized_user_exception.dart';
import 'package:flutter_template/user/user_event_hook.dart';
import 'package:flutter_template/util/nullable_util.dart';
import 'package:flutter_template/util/updates_stream.dart';
import 'package:single_item_storage/observed_storage.dart';
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
///
/// To obtain an instance of the user storage (for breaking circular dependencies
/// for example) use `serviceLocator.get<Storage<UserCredentials>>()`. This will
/// notify the user manager of any changes you make.
class UserManager with UpdatesStream<UserCredentials> {
  final UserApiService _apiService;
  final Storage<UserCredentials> _userStore;
  final Set<UserEventHook<UserCredentials>> userEventHooks;
  late final StreamSubscription _userStoreExternalUpdatesSubscription;
  UserCredentials? _currentUser;

  UserManager(
    this._apiService,
    ObservedStorage<UserCredentials> observedStorage, {
    Iterable<UserEventHook<UserCredentials>> userEventHooks = const [],
  })  : this._userStore = observedStorage.silent,
        this.userEventHooks = Set.unmodifiable(userEventHooks) {
    userEventHooks.forEach((hook) => hook.onUserUpdatesProvided(updatesSticky));

    _userStoreExternalUpdatesSubscription = observedStorage.updatesSticky
        .distinct((_, next) => next == _currentUser)
        .listen((userCredentials) async {
      Log.d('UserManager - User storage modified outside UserManager');
      addUpdate(userCredentials);

      if (userCredentials == null) {
        for (var userEventHook in userEventHooks) {
          await userEventHook
              .onUserUnauthorized(false)
              .catchError((e) => Log.e('UserManager - LogoutHook error: $e'));
        }
      }
    });
  }

  /// Called to ensure the user is loaded from disk and awaits all
  /// [UserEventHook.onUserLoaded] hooks.
  Future<void> init() async {
    final UserCredentials? loggedInUser = await _userStore.get();
    for (var userEventHook in userEventHooks) {
      if (loggedInUser != null) {
        await userEventHook.onUserAuthorized(loggedInUser, false);
      } else {
        await userEventHook.onUserUnauthorized(false);
      }
    }
    addUpdate(loggedInUser);
  }

  /// Emits a user update event to listeners
  /// to [updates] and [updatesSticky].
  @override
  void addUpdate(UserCredentials? event) {
    Log.d('UserManager - User update event: $event');
    _currentUser = event;
    super.addUpdate(event);
  }

  /// Gets the user or null if there is no logged in user.
  UserCredentials? getLoggedInUserSync() => _currentUser;

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
    Log.d('UserManager - Login in progress...');

    if (await isLoggedIn()) {
      Log.w('UserManager - Abort login: Already logged in!');
      return _userStore.get().asNonNullable();
    }

    final credentials = await _apiService.login(username, password);
    final user = await _apiService.getUserProfile(
        authHeader: authHeaderValue(credentials.token));
    final userCredentials = UserCredentials(user, credentials);

    Log.d('UserManager - Login success: $userCredentials');
    await _userStore.save(userCredentials);

    for (var userEventHook in userEventHooks) {
      await userEventHook
          .onUserAuthorized(userCredentials, true)
          .catchError((err) => Log.e('UserManager - LoginHook error: $err'));
    }

    addUpdate(userCredentials);
    return userCredentials;
  }

  /// Logs-out the user and triggers an update to the user [updates] stream.
  /// If the user is already logged out, the [Future] completes without doing anything.
  Future<void> logout() async {
    Log.d('UserManager - Logout in progress...');

    if (!(await isLoggedIn())) {
      Log.w('UserManager - Abort logout: Already logged out!');
      return;
    }

    await _apiService
        .logout()
        .catchError((e) => Log.e('UserManager - Logout error: $e'));

    await _userStore.delete();
    Log.d('UserManager - Logout success');

    for (var userEventHook in userEventHooks) {
      await userEventHook
          .onUserUnauthorized(true)
          .catchError((e) => Log.e('UserManager - LogoutHook error: $e'));
    }

    addUpdate(null);
  }

  /// Updates current user's credentials and triggers an update to [updates] stream.
  Future<UserCredentials> updateCredentials(Credentials? credentials) async {
    Log.d('UserManager - Updating credentials w/ new $credentials');

    if ((await _userStore.get())?.user == null) {
      Log.e('UserManager - Updating credentials error: User logged out!');
      throw UnauthorizedUserException('Updating credentials on logged out usr');
    }

    final UserCredentials oldUser = await _userStore.get().asNonNullable();
    final UserCredentials newUser = UserCredentials(oldUser.user, credentials);

    await _userStore.save(newUser);
    Log.d('UserManager - Updating credentials success');

    addUpdate(newUser);
    return newUser;
  }

  /// Updates current user's credentials and triggers an update to [updates] stream.
  Future<User> updateUser(User user) async {
    Log.d('UserManager - Updating user w/ new $user');

    if (!(await isLoggedIn())) {
      Log.e('UserManager - Updating user error: User logged out!');
      await _userStore.delete();
      throw UnauthorizedUserException('Updating user on logged out usr');
    }

    await _apiService.updateUserProfile(user);
    Log.d('UserManager - Updating user success');

    return refreshUser();
  }

  /// Fetches a fresh copy of [User] and triggers an update to [updates] stream
  /// if there is a change.
  Future<User> refreshUser() async {
    Log.d('UserManager - Refreshing user profile...');

    if (!(await isLoggedIn())) {
      Log.e('UserManager - Refreshing user error: User logged out!');
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
      Log.d('UserManager - Getting profile. No changes.');
    }

    return newUser;
  }

  /// Deactivates the user's profile and triggers an update to [updates] stream.
  Future<void> deactivateUser() async {
    Log.d('UserManager - Deactivating user');
    await _apiService.deactivate();
    await _userStore.delete();
    Log.d('UserManager - Deactivating user success');
    addUpdate(null);
  }

  /// Releases resources held by this component making it unusable.
  /// Call when the app is closing.
  /// This method does not delete saved data.
  Future<void> teardown() async {
    await _userStoreExternalUpdatesSubscription.cancel();
    await closeUpdatesStream();
  }
}
