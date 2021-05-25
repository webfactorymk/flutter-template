import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_template/feature/auth/global_handler/global_auth_cubit.dart';
import 'package:flutter_template/feature/auth/global_handler/global_auth_state.dart';
import 'package:flutter_template/routing/auth_state.dart';

import 'app_route_path.dart';
import 'pages/pages.dart';

class AppRouterDelegate extends RouterDelegate<AppRoutePath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<AppRoutePath> {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  late AuthState authState;
  GlobalAuthState globalAuthState;

  AppRouterDelegate() : globalAuthState = AuthenticationFailure();

  List<Page> _getPages(GlobalAuthState state) {
    List<Page> pages = [];
    if (state is AuthenticationSuccess) {
      pages.add(HomePage());
    } else if (state is AuthenticationFailure) {
      pages.add(LoginPage());
    }
    if (authState.signUpPressed) {
      pages.add(SignUpPage());
    }
    return pages;
  }

  @override
  Widget build(BuildContext context) {
    final GlobalAuthCubit authCubit = BlocProvider.of<GlobalAuthCubit>(context);
    authState = context.watch<AuthState>();
    return BlocBuilder(
      bloc: authCubit,
      builder: (BuildContext context, GlobalAuthState state) {
        globalAuthState = state;
        return Navigator(
          key: navigatorKey,
          pages: _getPages(globalAuthState),
          onPopPage: (route, result) {
            if (!route.didPop(result)) {
              return false;
            }

            return true;
          },
        );
      },
    );
  }

  @override
  Future<void> setNewRoutePath(AppRoutePath configuration) async {
    notifyListeners();
  }
}
