import 'package:flutter_template/log/abstract_logger.dart';

/// Static logger. Use this to log events across the app.
///
/// __Before use you must set logger implementation.__
/// __See the setter for [logger].__
abstract class Log {
  static AbstractLogger? _logger;

  static set logger(AbstractLogger value) => _logger = value;

  static void d(String message) => _logger?.d(message);

  static void w(String message) => _logger?.w(message);

  static void e(Object error) => _logger?.e(error);
}

/// Convenience error function to use w/ [Future]s.
void onErrorLog(error) => Log.e(error);
