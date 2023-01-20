import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_template/feature/auth/router/auth_router.dart';
import 'package:flutter_template/feature/force_update/ui/force_update_page.dart';
import 'package:flutter_template/feature/home/router/home_router.dart';
import 'package:flutter_template/log/log.dart';
import 'package:flutter_template/model/user/user_credentials.dart';
import 'package:flutter_template/routing/no_animation_transition_delegate.dart';
import 'package:flutter_template/user/user_manager.dart';

import 'app_nav_state.dart';

/// Root rooter of this application
class AppRouterDelegate extends RouterDelegate
    with ChangeNotifier, PopNavigatorRouterDelegateMixin {
  final GlobalKey<NavigatorState> navigatorKey;
  final GlobalKey<NavigatorState> authNavigatorKey;
  final GlobalKey<NavigatorState> homeNavigatorKey;

  StreamSubscription<UserCredentials?>? _userUpdatesSubscription;

  AppNavState _navState;
  bool _isUserLoggedIn = false;

  AppRouterDelegate(
    this.navigatorKey,
    this.authNavigatorKey,
    this.homeNavigatorKey,
    UserManager userManager, [
    this._navState = const AppNavState.auth(),
  ]) {
    Log.d('AppRouterDelegate - Subscribe to user updates');
    _userUpdatesSubscription = userManager.updatesSticky
        .distinct((prev, next) => _isUserLoggedIn == next?.isLoggedIn())
        .listen((usrCredentials) => onUserAuthenticationUpdate(usrCredentials));
  }

  @visibleForTesting
  void onUserAuthenticationUpdate(UserCredentials? usrCredentials) {
    Log.d('AppRouterDelegate - Credentials update: '
        '${usrCredentials.isLoggedIn() ? 'authorized' : 'unauthorized'}');
    _isUserLoggedIn = usrCredentials.isLoggedIn();
    _isUserLoggedIn ? setHomeNavState() : setAuthNavState();
    notifyListeners();
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      transitionDelegate: NoAnimationTransitionDelegate(),
      key: navigatorKey,
      pages: _getPages(),
      onPopPage: (route, result) => route.didPop(result),
    );
  }

  List<Page> _getPages() {
    if (_navState is AuthNavState) {
      return [
        MaterialPage(
          key: ValueKey('AuthRouterPage'),
          child: AuthRouter(authNavigatorKey),
        )
      ];
    }

    if (_navState is HomeNavState) {
      return [
        MaterialPage(
          key: ValueKey('HomeRouterPage'),
          child: HomeRouter(
            homeNavigatorKey,
          ),
        )
      ];
    }

    if (_navState is ForceUpdateNavState) {
      return [ForceUpdatePage()];
    }

    return [];
  }

  @override
  Future<void> setNewRoutePath(configuration) async {
    /* no-op */
  }

  @override
  void dispose() async {
    super.dispose();
    Log.d('AppRouterDelegate - Unsubscribe from user updates');
    await _userUpdatesSubscription?.cancel();
  }

  void setForceUpdateNavState() {
    _navState = AppNavState.forceUpdate();
    notifyListeners();
  }

  void setAuthNavState() {
    _navState = AppNavState.auth();
    notifyListeners();
  }

  void setHomeNavState() {
    _navState = AppNavState.home();
    notifyListeners();
  }
}
