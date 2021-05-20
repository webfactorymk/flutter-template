import 'package:flutter/cupertino.dart';

class AppBackButtonDispatcher extends RootBackButtonDispatcher {
  final RouterDelegate _routerDelegate;

  AppBackButtonDispatcher(this._routerDelegate);

  @override
  Future<bool> didPopRoute() {
    return _routerDelegate.popRoute();
  }
}
