import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_template/log/abstract_logger.dart';

/// Logger that outputs messages to firebase console to be added to a crash report.
class FirebaseLogger implements AbstractLogger {
  final FirebaseCrashlytics _crashlytics;

  FirebaseLogger.instance() : _crashlytics = FirebaseCrashlytics.instance;

  FirebaseLogger(this._crashlytics);

  @override
  void d(String message) => _crashlytics.log('(D) $message');

  @override
  void w(String message) => _crashlytics.log('(W) $message');

  @override
  void e(Object error) =>
      _crashlytics.recordFlutterError(FlutterErrorDetails(exception: error));
}
