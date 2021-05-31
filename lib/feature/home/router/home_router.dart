import 'package:flutter/material.dart';
import 'package:flutter_template/feature/home/router/home_router_delegate.dart';

/// Nested router that hosts all task screens and manages navigation among them.
class HomeRouter extends StatelessWidget {
  const HomeRouter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final childBackButtonDispatcher =
        ChildBackButtonDispatcher(Router.of(context).backButtonDispatcher!)
          ..takePriority();

    return Router(
      routerDelegate: HomeRouterDelegate(),
      backButtonDispatcher: childBackButtonDispatcher,
    );
  }
}
