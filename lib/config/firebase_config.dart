import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_template/config/flavor_config.dart';
import 'package:flutter_template/log/log.dart';

const String apnsTokenKey = 'apns-device-token';
const String fcmTokenKey = 'firebase-device-token';
const String voipTokenKey = 'voip-device-token';

//todo decide when you need firebase in your project
bool shouldConfigureFirebase() =>
    FlavorConfig.isInitialized() &&
    (FlavorConfig.isStaging() || FlavorConfig.isProduction());

Future<void> configureFirebase() async {
  if (!shouldConfigureFirebase()) {
    return;
  }
  await Firebase.initializeApp();
  await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(
      kDebugMode ? false : true); //todo crashlytics in debug mode?
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
}

Future<void> logFirebaseToken() async {
  final token = await FirebaseMessaging.instance.getToken();
  Log.d('FirebaseMessaging - Token: $token');
}

R? runZonedGuardedWithErrorHandler<R>(R Function() body) =>
    runZonedGuarded(body, (error, stack) {
      if (shouldConfigureFirebase()) {
        FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      }
    });
