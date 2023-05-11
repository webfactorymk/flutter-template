import 'package:flutter/widgets.dart';
import 'package:flutter_template/config/firebase_config.dart';
import 'package:flutter_template/config/logger_config.dart';
import 'package:flutter_template/di/service_locator.dart';
import 'package:flutter_template/di/service_locator.dart' as serviceLocatorConf;
import 'package:flutter_template/feature/settings/preferences_helper.dart';
import 'package:flutter_template/user/user_manager.dart';

/// Configuration that needs to be done before the Flutter app starts goes here.
///
/// To minimize the app loading time keep this setup fast and simple.
Future<void> preAppConfig() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureFirebase();
  initLogger();
  await serviceLocatorConf.setupGlobalDependencies();
  // await serviceLocator.get<LocalNotificationsManager>().init(); //todo uncomment for local notifications
  await serviceLocator.get<UserManager>().init();
  await serviceLocator.get<PreferencesHelper>().init();
}
