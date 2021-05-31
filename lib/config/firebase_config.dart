import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_template/config/flavor_config.dart';

//todo decide when you need firebase in your project
bool shouldConfigureFirebase() =>
    FlavorConfig.isInitialized() &&
    (FlavorConfig.isStaging() || FlavorConfig.isProduction());

Future<void> configureFirebase() async {
  if (!shouldConfigureFirebase()) {
    return;
  }
  await Firebase.initializeApp();
  await FirebaseCrashlytics.instance
      .setCrashlyticsCollectionEnabled(kDebugMode ? false : true); //todo crashlytics in debug mode?
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
}
