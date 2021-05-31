import 'package:flutter/material.dart';
import 'package:flutter_template/feature/auth/router/auth_router_delegate.dart';

/// Nested router that hosts all auth screens and manages navigation among them.
class AuthRouter extends StatelessWidget {
  const AuthRouter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final childBackButtonDispatcher =
        ChildBackButtonDispatcher(Router.of(context).backButtonDispatcher!)
          ..takePriority();

    return Router(
      routerDelegate: AuthRouterDelegate(),
      backButtonDispatcher: childBackButtonDispatcher,
    );
  }
}
