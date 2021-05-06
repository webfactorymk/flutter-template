class UnauthorizedUserException implements Exception {
  final String? message;

  UnauthorizedUserException([this.message]);

  @override
  String toString() {
    return 'UnauthorizedUserException{message: $message}';
  }
}
