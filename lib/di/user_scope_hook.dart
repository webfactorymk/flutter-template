import 'package:flutter_template/di/service_locator.dart';
import 'package:flutter_template/di/user_scope.dart';
import 'package:flutter_template/log/logger.dart';
import 'package:flutter_template/model/user/user_credentials.dart';
import 'package:flutter_template/user/user_hooks.dart';
import 'package:flutter_template/user/user_manager.dart';

/// Creates and destroys the user scope on login/logout events.
class UserScopeHook implements LoginHook<UserCredentials>, LogoutHook {
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
}

/// Ensures the user scope is the top-most scope in the stack.
/// Returns true if setup needs to proceed, or false if already setup.
Future<bool> _pushUserScope(String userId) async {
  if (serviceLocator.currentScopeName == 'baseScope') {
    Logger.d('Push userScope on top of baseScope');
    serviceLocator.pushNewScope(scopeName: userScopeName);
  } else if (serviceLocator.currentScopeName == userScopeName) {
    final prevUserId =
        (await serviceLocator.get<UserManager>().getLoggedInUser())?.user.id;
    if (prevUserId == userId) {
      Logger.d('Push userScope - The same user logins after session expired');
      return false;
    } else {
      Logger.d('Push userScope - NEW user logins after session expired');
      await serviceLocator.reset();
    }
  } else {
    Logger.w('Push userScope - Un-popped scopes. Popping till $userScopeName]');
    await serviceLocator.popScopesTill(userScopeName);
    await serviceLocator.reset();
  }
  return true;
}

/// Pops the user scope leaving baseScope as the top-most scope in the stack.
Future<void> _popUserScope() => serviceLocator.popScopesTill('baseScope');
