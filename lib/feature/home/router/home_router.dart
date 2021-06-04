import 'package:flutter/material.dart';
import 'package:flutter_template/feature/home/router/home_router_delegate.dart';
import 'package:provider/provider.dart';

/// Nested router that hosts all task screens and manages navigation among them.
class HomeRouter extends StatelessWidget {
  final GlobalKey<NavigatorState> navigatorKey;

  const HomeRouter(this.navigatorKey, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final childBackButtonDispatcher =
        ChildBackButtonDispatcher(Router.of(context).backButtonDispatcher!)
          ..takePriority();

    return ChangeNotifierProvider<HomeRouterDelegate>(
        create: (_) => HomeRouterDelegate(navigatorKey),
        child: Consumer<HomeRouterDelegate>(
            builder: (context, homeRouterDelegate, child) => Router(
                  routerDelegate: homeRouterDelegate,
                  backButtonDispatcher: childBackButtonDispatcher,
                )));
  }
}
