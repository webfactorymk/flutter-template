class DataNotFoundException implements Exception {
  final String? message;

  DataNotFoundException([this.message]);

  @override
  String toString() {
    return 'DataNotFoundException{message: $message}';
  }
}
