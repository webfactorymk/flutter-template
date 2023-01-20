import 'package:flutter/foundation.dart';
import 'package:flutter_template/config/firebase_config.dart';
import 'package:flutter_template/log/console_logger.dart';
import 'package:flutter_template/log/file_logger.dart';
import 'package:flutter_template/log/filtered_logger.dart';
import 'package:flutter_template/log/firebase_logger.dart';
import 'package:flutter_template/log/log.dart';
import 'package:flutter_template/log/multi_logger.dart';

/// App specific logging setup.
///
/// This setup configuration will:
/// - use console logger except in production
/// - use file logger for bug reports except in production
/// - use firebase logs, always, in production too
///
/// todo tailor this setup to your needs
///
void initLogger() {
  Log.logger = MultiLogger([
    ConsoleLogger.create().makeFiltered(noLogsInProductionOrTests()),
    FileLogger.instance().makeFiltered(noLogsInProductionOrTests()),
    if (shouldConfigureFirebase())
      FirebaseLogger.instance().makeFiltered(noLogsInTests()),
  ]);

  if (kDebugMode && shouldConfigureFirebase()) {
    logFirebaseToken();
  }
}
