import 'package:flutter_template/config/flavor_config.dart';
import 'package:flutter_template/log/abstract_logger.dart';

enum LogLevel { debug, warning, error }

/// Logger that applies a filter to log messages.
class FilteredLogger implements AbstractLogger {
  final AbstractLogger _inner;
  final bool Function(LogLevel logLevel) shouldLog;

  FilteredLogger(this._inner, this.shouldLog);

  @override
  void d(String message) {
    if (shouldLog(LogLevel.debug)) {
      _inner.d(message);
    }
  }

  @override
  void w(String message) {
    if (shouldLog(LogLevel.warning)) {
      _inner.w(message);
    }
  }

  @override
  void e(Object error) {
    if (shouldLog(LogLevel.error)) {
      _inner.e(error);
    }
  }
}

/// This log filter always logs except in production and tests.
bool Function(LogLevel _) noLogsInProductionOrTests() =>
    (_) => FlavorConfig.isInitialized() && !FlavorConfig.isProduction();

/// This log filter always logs except in tests.
bool Function(LogLevel _) noLogsInTests() =>
    (_) => FlavorConfig.isInitialized();

extension Filter on AbstractLogger {
  FilteredLogger makeFiltered(bool Function(LogLevel logLevel) shouldLog) =>
      FilteredLogger(this, shouldLog);
}
