import 'package:flutter_template/log/abstract_logger.dart';

/// Stub implementation of [AbstractLogger].
class StubLogger implements AbstractLogger {
  @override
  void d(String message) {}

  @override
  void e(Object error) {}

  @override
  void w(String message) {}
}
