import 'package:flutter/material.dart';
import 'package:flutter_template/feature/home/router/home_router_delegate.dart';

/// Nested router that hosts all task screens and manages navigation among them.
class HomeRouter extends StatefulWidget {
  const HomeRouter({Key? key}) : super(key: key);

  @override
  _HomeRouterState createState() => _HomeRouterState();
}

class _HomeRouterState extends State<HomeRouter> {
  late HomeRouterDelegate _homeRouterDelegate;

  @override
  void initState() {
    super.initState();
    _homeRouterDelegate = HomeRouterDelegate();
  }

  @override
  Widget build(BuildContext context) {
    final childBackButtonDispatcher =
        ChildBackButtonDispatcher(Router.of(context).backButtonDispatcher!)
          ..takePriority();

    return Router(
      routerDelegate: _homeRouterDelegate,
      backButtonDispatcher: childBackButtonDispatcher,
    );
  }
}
