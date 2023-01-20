import 'package:flutter_template/feature/force_update/force_update_alert.dart';
import 'package:flutter_template/log/log.dart';
import 'package:flutter_template/widgets/alert_dialog.dart';
import 'package:flutter/material.dart';

/// An observer that tracks the current route displayed.
/// Does not take modal routes into consideration.
class NavigationRoutesObserver extends RouteObserver<PageRoute<dynamic>> {
  List<String> _dialogQueue = [];

  bool get isErrorDialogDisplayed =>
      _dialogQueue.contains(errorDialogRouteName);

  bool get isForceUpdateDialogDisplayed =>
      _dialogQueue.contains(forceUpdateDialogRouteName);

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);

    if (_isDialogRoute(route)) {
      _dialogQueue.add(route.settings.name!);
      Log.d('NavigationRoutesObserver - Error dialog shown');
    }
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);

    if (_isDialogRoute(newRoute)) {
      _dialogQueue.add(newRoute!.settings.name!);
      Log.d('NavigationRoutesObserver - Error dialog shown');
    } else if (_isDialogRoute(oldRoute)) {
      _dialogQueue.remove(oldRoute!.settings.name);
      Log.d('NavigationRoutesObserver - Error dialog dismissed');
    }
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);

    if (_isDialogRoute(route)) {
      _dialogQueue.remove(route.settings.name);
      Log.d('NavigationRoutesObserver - Error dialog dismissed');
    }
  }

  bool _isDialogRoute(Route? route) => [
        errorDialogRouteName,
        forceUpdateDialogRouteName,
      ].contains(route?.settings.name);
}
