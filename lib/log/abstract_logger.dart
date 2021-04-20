/// Base class for all logger implementations.
abstract class AbstractLogger {
  /// Debug
  void d(String message);

  /// Warning
  void w(String message);

  /// Error
  void e(Object error);
}
