import 'dart:async';

import 'package:flutter_template/di/service_locator.dart';
import 'package:flutter_template/di/user_scope.dart';
import 'package:flutter_template/log/log.dart';
import 'package:flutter_template/model/user/user_credentials.dart';
import 'package:flutter_template/user/user_event_hook.dart';
import 'package:flutter_template/user/user_manager.dart';

/// Creates and destroys the user scope on login/logout events.
///
/// <br /> __The user scope component lifecycle__
///
/// a. created on:
///     - app start if there is a logged in user
///
///     - user explicit login
///
/// b. destroyed on:
///     - user explicit logout
///
/// c. recreated on:
///     - new user login after session expiry
///
/// d. kept intact on:
///     - same user login after session expiry
class UserScopeHook extends UserEventHook<UserCredentials> {
  @override
  Future<void> postLogin(UserCredentials userCredentials) async {
    final userId = userCredentials.user.id;
    if (await _pushUserScope(userId)) {
      await setupUserScope(userId);
    }
  }

  @override
  Future<void> postLogout() async {
    if (serviceLocator.currentScopeName == 'baseScope') {
      return;
    }
    await teardownUserScope().catchError(onErrorLog);
    await _popUserScope();
  }

  @override
  Future<void> onUserLoaded(UserCredentials? userCred) async {
    if (userCred != null && await _pushUserScope(userCred.user.id)) {
      await setupUserScope(userCred.user.id);
    }
  }
}

/// Ensures the user scope is the top-most scope in the stack.
/// Returns true if setup needs to proceed, or false if already setup.
Future<bool> _pushUserScope(String userId) async {
  if (serviceLocator.currentScopeName == 'baseScope') {
    Log.d('Push userScope on top of baseScope');
    serviceLocator.pushNewScope(scopeName: userScopeName);
  } else if (serviceLocator.currentScopeName == userScopeName) {
    final prevUserId =
        (await serviceLocator.get<UserManager>().getLoggedInUser())?.user.id;
    if (prevUserId == userId) {
      Log.d('Push userScope - The same user logins after session expired');
      return false;
    } else {
      Log.d('Push userScope - NEW user logins after session expired');
      await serviceLocator.reset();
    }
  } else {
    Log.w('Push userScope - Un-popped scopes. Popping till $userScopeName]');
    await serviceLocator.popScopesTill(userScopeName);
    await serviceLocator.reset();
  }
  return true;
}

/// Pops the user scope leaving baseScope as the top-most scope in the stack.
Future<void> _popUserScope() => serviceLocator
    .popScopesTill(userScopeName)
    .whenComplete(() => Log.d('Pop userScope'));
