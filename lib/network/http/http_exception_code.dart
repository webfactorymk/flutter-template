import 'dart:io';

class HttpExceptionCode extends HttpException {
  final int? statusCode;
  final String stringKey;

  HttpExceptionCode(
    String message, {
    Uri? uri,
    required this.statusCode,
    this.stringKey = 'default_error',
  }) : super(message, uri: uri);

  @override
  String toString() {
    return 'HttpExceptionCode{'
        'message: $message, '
        'uri: $uri, '
        'statusCode: $statusCode, '
        'stringKey: $stringKey}';
  }
}
