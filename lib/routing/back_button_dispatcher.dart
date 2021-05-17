import 'package:flutter/cupertino.dart';
import 'package:flutter_template/routing/global_router_delegate.dart';

class AppBackButtonDispatcher extends RootBackButtonDispatcher {
  final AppRouterDelegate _routerDelegate;

  AppBackButtonDispatcher(this._routerDelegate);

  @override
  Future<bool> didPopRoute() {
    return _routerDelegate.popRoute();
  }
}
