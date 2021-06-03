import 'package:flutter/material.dart';
import 'package:flutter_template/feature/auth/router/auth_router_delegate.dart';
import 'package:provider/provider.dart';

/// Nested router that hosts all auth screens and manages navigation among them.
class AuthRouter extends StatefulWidget {
  const AuthRouter({Key? key}) : super(key: key);

  @override
  _AuthRouterState createState() => _AuthRouterState();
}

class _AuthRouterState extends State<AuthRouter> {
  late AuthRouterDelegate _authRouterDelegate;

  @override
  void initState() {
    super.initState();
    _authRouterDelegate = AuthRouterDelegate();
  }

  @override
  Widget build(BuildContext context) {
    final childBackButtonDispatcher =
        ChildBackButtonDispatcher(Router.of(context).backButtonDispatcher!)
          ..takePriority();

    return ChangeNotifierProvider<AuthRouterDelegate>.value(
        value: _authRouterDelegate,
        child: Router(
          routerDelegate: _authRouterDelegate,
          backButtonDispatcher: childBackButtonDispatcher,
        ));
  }
}
