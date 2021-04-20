import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

Future<void> configureCrashlytics() async {
  await Firebase.initializeApp();
  await FirebaseCrashlytics.instance
      .setCrashlyticsCollectionEnabled(kDebugMode ? false : true);
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
}

