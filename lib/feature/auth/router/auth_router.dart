import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_template/di/service_locator.dart';
import 'package:flutter_template/feature/auth/router/auth_router_delegate.dart';
import 'package:flutter_template/feature/auth/signup/bloc/signup_cubit.dart';
import 'package:flutter_template/network/user_api_service.dart';
import 'package:flutter_template/user/user_manager.dart';
import 'package:provider/provider.dart';

/// Nested router that hosts all auth screens and manages navigation among them.
class AuthRouter extends StatelessWidget {
  final GlobalKey<NavigatorState> navigatorKey;

  const AuthRouter(this.navigatorKey, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final childBackButtonDispatcher =
        ChildBackButtonDispatcher(Router.of(context).backButtonDispatcher!)
          ..takePriority();

    return BlocProvider<SignupCubit>(
      create: (BuildContext context) => SignupCubit(
        serviceLocator.get<UserApiService>(),
        serviceLocator.get<UserManager>(),
      ),
      child: ChangeNotifierProvider<AuthRouterDelegate>(
          create: (_) => AuthRouterDelegate(navigatorKey),
          child: Consumer<AuthRouterDelegate>(
              builder: (context, authRouterDelegate, child) => Router(
                    routerDelegate: authRouterDelegate,
                    backButtonDispatcher: childBackButtonDispatcher,
                  ))),
    );
  }
}
