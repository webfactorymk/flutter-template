import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_template/feature/auth/login/ui/login_page.dart';
import 'package:flutter_template/feature/auth/router/auth_nav_state.dart';
import 'package:flutter_template/feature/auth/signup/ui/password/password_page.dart';
import 'package:flutter_template/feature/auth/signup/ui/username/username_page.dart';
import 'package:flutter_template/util/collections_util.dart';

class AuthRouterDelegate extends RouterDelegate
    with ChangeNotifier, PopNavigatorRouterDelegateMixin {
  final GlobalKey<NavigatorState> navigatorKey;

  ListQueue<AuthNavState> authNavStates = ListQueue();

  AuthRouterDelegate(this.navigatorKey) {
    authNavStates.addUniqueElement(AuthNavState.login());
  }

  void setLoginNavState() {
    authNavStates.addUniqueElement(AuthNavState.login());
    notifyListeners();
  }

  void setSignupUsernameNavState() {
    authNavStates.addUniqueElement(AuthNavState.signupUsername());
    notifyListeners();
  }

  void setSignupPasswordNavState() {
    authNavStates.addUniqueElement(AuthNavState.signupPassword());
    notifyListeners();
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
        key: navigatorKey,
        pages: [
          LoginPage(),
          if (authNavStates.contains(AuthNavState.signupUsername()))
            UsernamePage(),
          if (authNavStates.contains(AuthNavState.signupPassword()))
            PasswordPage(),
        ],
        onPopPage: (route, result) {
          authNavStates.removeLast();
          return route.didPop(result);
        });
  }

  @override
  Future<void> setNewRoutePath(configuration) async {
    /* no-op */
  }
}
