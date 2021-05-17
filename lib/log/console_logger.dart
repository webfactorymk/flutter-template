import 'package:flutter_template/log/abstract_logger.dart';
import 'package:logger/logger.dart' as console;

/// Logger that outputs messages to the console.
class ConsoleLogger implements AbstractLogger {
  final console.Logger logger;

  factory ConsoleLogger.create() {
    return ConsoleLogger(console.Logger(
      printer: console.SimplePrinter(colors: true, printTime: false),
    ));
  }

  ConsoleLogger(this.logger);

  @override
  void d(String message) => logger.d(message);

  @override
  void w(String message) => logger.w(message);

  @override
  void e(Object error) => logger.e(error.toString(), error);
}
