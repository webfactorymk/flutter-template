import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_template/config/flavor_config.dart';
import 'package:flutter_template/feature/auth/global_handler/global_auth_cubit.dart';
import 'package:flutter_template/feature/auth/global_handler/global_auth_state.dart';
import 'package:flutter_template/routing/auth_state.dart';
import 'package:package_info/package_info.dart';

import 'app_route_path.dart';
import 'pages/pages.dart';

class AppRouterDelegate extends RouterDelegate<AppRoutePath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<AppRoutePath> {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  late AuthState authState;
  GlobalAuthState globalAuthState;

  String _buildVersion = '';

  AppRouterDelegate() : globalAuthState = AuthenticationFailure() {
    if (!FlavorConfig.isProduction()) {
      _getBuildVersion();
    }
  }

  Future<void> _getBuildVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    _buildVersion =
        'Build version ${packageInfo.version} (${packageInfo.buildNumber})';
  }

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
    return BlocConsumer(
      bloc: authCubit,
      listener: (_, GlobalAuthState state) {
        globalAuthState = state;
        notifyListeners();
      },
      builder: (BuildContext context, GlobalAuthState state) {
        if (!FlavorConfig.isProduction()) {
          WidgetsBinding.instance?.addPostFrameCallback(
              (_) => _insertOverlay(context, _buildVersion));
        }

        return Navigator(
          key: navigatorKey,
          pages: _getPages(globalAuthState),
          onPopPage: (route, result) {
            if (!route.didPop(result)) {
              return false;
            }

            notifyListeners();
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

  void _insertOverlay(BuildContext context, buildVersion) {
    Overlay.of(context)?.insert(
      OverlayEntry(builder: (context) {
        var safePadding = MediaQuery.of(context).padding.bottom;
        final size = MediaQuery.of(context).size;
        final textSize = (TextPainter(
                text: TextSpan(
                    text: buildVersion,
                    style: Theme.of(context).textTheme.caption),
                maxLines: 1,
                textScaleFactor: MediaQuery.of(context).textScaleFactor,
                textDirection: TextDirection.ltr)
              ..layout())
            .size;

        return Positioned(
          height: 56,
          top: size.height - max(safePadding, 20),
          left: (size.width - textSize.width) / 2,
          child: IgnorePointer(
            child: Text(
              buildVersion,
              style: Theme.of(context).textTheme.caption,
            ),
          ),
        );
      }),
    );
  }
}
