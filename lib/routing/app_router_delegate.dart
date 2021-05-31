import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_template/feature/auth/router/auth_router.dart';
import 'package:flutter_template/feature/home/router/home_router.dart';
import 'package:flutter_template/feature/loading/ui/loading_page.dart';
import 'package:flutter_template/log/logger.dart';
import 'package:flutter_template/model/user/user_credentials.dart';
import 'package:flutter_template/user/user_manager.dart';

/// Root rooter of this application
class AppRouterDelegate extends RouterDelegate
    with ChangeNotifier, PopNavigatorRouterDelegateMixin {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  bool? isUserLoggedIn;
  StreamSubscription<UserCredentials?>? _userUpdatesSubscription;

  AppRouterDelegate(UserManager userManager) {
    Logger.d('AppRouterDelegate - Subscribe to user updates');
    _userUpdatesSubscription = userManager.updatesSticky
        .distinct((prev, next) => isUserLoggedIn == next?.isLoggedIn())
        .listen((usrCredentials) => onUserAuthenticationUpdate(usrCredentials));
  }

  @visibleForTesting
  void onUserAuthenticationUpdate(UserCredentials? usrCredentials) {
    Logger.d('AppRouterDelegate - Credentials update: $usrCredentials');
    isUserLoggedIn = usrCredentials.isLoggedIn();
    notifyListeners();
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      pages: _getPages(),
      onPopPage: (route, result) => route.didPop(result),
    );
  }

  List<Page> _getPages() {
    if (isUserLoggedIn == null) {
      return [LoadingPage()];
    } else if (isUserLoggedIn!) {
      return [
        MaterialPage(
          key: ValueKey('HomeRouterPage'),
          child: HomeRouter(),
        )
      ];
    } else {
      return [
        MaterialPage(
          key: ValueKey('AuthRouterPage'),
          child: AuthRouter(),
        )
      ];
    }
  }

  @override
  Future<void> setNewRoutePath(configuration) async {
    /* no-op */
  }

  Future<void> teardown() async {
    Logger.d('AppRouterDelegate - Unsubscribe from user updates');
    await _userUpdatesSubscription?.cancel();
  }
}
