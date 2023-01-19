import 'dart:async';

import 'package:flutter_template/di/service_locator.dart';
import 'package:flutter_template/di/user_scope.dart';
import 'package:flutter_template/log/log.dart';
import 'package:flutter_template/model/user/user_credentials.dart';
import 'package:flutter_template/user/user_event_hook.dart';

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
  String? _lastUserScopeUserId;

  @override
  Future<void> onUserAuthorized(
      UserCredentials userCredentials,
      bool isExplicitUserLogin,
      ) async {
    final userId = userCredentials.user.id;
    if (await _pushUserScope(userId, _lastUserScopeUserId)) {
      await setupUserScope(userId);
    }
    _lastUserScopeUserId = userId;
  }

  @override
  Future<void> onUserUnauthorized(bool isExplicitUserLogout) async {
    if (serviceLocator.currentScopeName == 'baseScope' ||
        isExplicitUserLogout == false) {
      return;
    }
    await teardownUserScope().catchError(onErrorLog);
    await _popUserScope();
    _lastUserScopeUserId = null;
  }
}

/// Ensures the user scope is the top-most scope in the stack.
/// Returns true if setup needs to proceed, or false if already setup.
Future<bool> _pushUserScope(String userId, String? prevUserId) async {
  if (serviceLocator.currentScopeName == 'baseScope') {
    Log.d('Push userScope on top of baseScope');
    serviceLocator.pushNewScope(scopeName: userScopeName);
  } else if (serviceLocator.currentScopeName == userScopeName) {
    if (prevUserId == userId) {
      Log.d('Push userScope - The same user logins after '
          'session expired or duplicate event. Do nothing.');
      return false;
    } else {
      Log.d('Push userScope - NEW user logins after session expired');
      await serviceLocator.popScopesTill(userScopeName);
    }
  } else {
    Log.w('Push userScope - Un-popped scopes. Popping till $userScopeName]');
    await serviceLocator.popScopesTill(userScopeName);
  }
  return true;
}

/// Pops the user scope leaving baseScope as the top-most scope in the stack.
Future<void> _popUserScope() => serviceLocator
    .popScopesTill(userScopeName)
    .whenComplete(() => Log.d('Pop userScope'));
