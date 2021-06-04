import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_template/feature/auth/login/ui/login_page.dart';
import 'package:flutter_template/feature/auth/router/auth_nav_state.dart';
import 'package:flutter_template/feature/auth/signup/ui/signup_page.dart';

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

  void setSignupNavState() {
    authNavState = AuthNavState.signup();
    notifyListeners();
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
        key: navigatorKey,
        pages: [LoginPage(), if (authNavState is SignupNavState) SignupPage()],
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
