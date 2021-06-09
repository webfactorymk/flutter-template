import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_template/di/service_locator.dart';
import 'package:flutter_template/feature/settings/preferences_helper.dart';
import 'package:flutter_template/resources/localization/localization_notifier.dart';
import 'package:flutter_template/root.dart';
import 'package:flutter_template/routing/app_router_delegate.dart';
import 'package:flutter_template/user/user_manager.dart';

final navigatorKey = GlobalKey<NavigatorState>();
final authNavigatorKey = GlobalKey<NavigatorState>();
final homeNavigatorKey = GlobalKey<NavigatorState>();

class App extends StatelessWidget {
  App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return Root(
      AppRouterDelegate(
        navigatorKey,
        authNavigatorKey,
        homeNavigatorKey,
        serviceLocator.get<UserManager>(),
      ),
      LocalizationNotifier(
          serviceLocator.get<PreferencesHelper>().languagePreferred),
    );
  }
}
