/// Exception thrown when we're trying to perform an action on an
/// older version that must be updated.
class ForceUpdateException implements Exception {
  final String? message;

  ForceUpdateException([this.message]);

  @override
  String toString() {
    return 'ForceUpdateException{message: $message}';
  }
}
