import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_template/feature/auth/login/ui/login_page.dart';
import 'package:flutter_template/feature/auth/router/auth_nav_state.dart';
import 'package:flutter_template/feature/auth/signup/ui/password/password_page.dart';
import 'package:flutter_template/feature/auth/signup/ui/username/username_page.dart';

class AuthRouterDelegate extends RouterDelegate
    with ChangeNotifier, PopNavigatorRouterDelegateMixin {
  final GlobalKey<NavigatorState> navigatorKey;

  AuthNavState _authNavState;

  AuthRouterDelegate(this.navigatorKey,
      [this._authNavState = const AuthNavState.login()]);

  void setLoginNavState() {
    _authNavState = AuthNavState.login();
    notifyListeners();
  }

  void setSignupUsernameNavState() {
    _authNavState = AuthNavState.signupUsername(_authNavState);
    notifyListeners();
  }

  void setSignupPasswordNavState() {
    _authNavState = AuthNavState.signupPassword(_authNavState);
    notifyListeners();
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
        key: navigatorKey,
        pages: [
          LoginPage(),
          if (_authNavState is SignupUsernameNavState) UsernamePage(),
          if (_authNavState is SignupPasswordNavState) ...[
            UsernamePage(),
            PasswordPage()
          ],
        ],
        onPopPage: (route, result) {
          _authNavState = _authNavState.prevState ?? AuthNavState.login();
          return route.didPop(result);
        });
  }

  @override
  Future<void> setNewRoutePath(configuration) async {
    /* no-op */
  }
}
