import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_template/feature/auth/login/ui/login_page.dart';
import 'package:flutter_template/feature/auth/router/auth_nav_state.dart';
import 'package:flutter_template/feature/auth/signup/ui/password/password_page.dart';
import 'package:flutter_template/feature/auth/signup/ui/username/username_page.dart';

class AuthRouterDelegate extends RouterDelegate
    with ChangeNotifier, PopNavigatorRouterDelegateMixin {
  final GlobalKey<NavigatorState> navigatorKey;

  AuthNavState authNavState;

  AuthRouterDelegate(this.navigatorKey,
      [this.authNavState = const AuthNavState.login()]);

  void setLoginNavState() {
    authNavState = AuthNavState.login();
    notifyListeners();
  }

  void setSignupUsernameNavState() {
    authNavState = AuthNavState.signupUsername();
    notifyListeners();
  }

  void setSignupPasswordNavState() {
    authNavState = AuthNavState.signupPassword();
    notifyListeners();
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
        key: navigatorKey,
        pages: [
          LoginPage(),
          if (authNavState is SignupUsernameNavState) UsernamePage(),
          if (authNavState is SignupPasswordNavState) PasswordPage(),
        ],
        onPopPage: (route, result) {
          authNavState = AuthNavState.login();
          return route.didPop(result);
        });
  }

  @override
  Future<void> setNewRoutePath(configuration) async {
    /* no-op */
  }
}
