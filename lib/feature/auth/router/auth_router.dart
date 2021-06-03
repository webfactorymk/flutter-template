import 'package:flutter/material.dart';
import 'package:flutter_template/feature/auth/router/auth_router_delegate.dart';
import 'package:provider/provider.dart';

/// Nested router that hosts all auth screens and manages navigation among them.
class AuthRouter extends StatelessWidget {
  const AuthRouter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final childBackButtonDispatcher =
        ChildBackButtonDispatcher(Router.of(context).backButtonDispatcher!)
          ..takePriority();

    return ChangeNotifierProvider<AuthRouterDelegate>(
        create: (_) => AuthRouterDelegate(),
        child: Consumer<AuthRouterDelegate>(
            builder: (context, authRouterDelegate, child) => Router(
                  routerDelegate: authRouterDelegate,
                  backButtonDispatcher: childBackButtonDispatcher,
                )));
  }
}
