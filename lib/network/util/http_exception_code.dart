import 'dart:io';

class HttpExceptionCode extends HttpException {
  final int? statusCode;
  final dynamic errorResponse;

  HttpExceptionCode(
    String message, {
    Uri? uri,
    required this.statusCode,
    this.errorResponse = 'no error response',
  }) : super(message, uri: uri);

  @override
  String toString() {
    return 'HttpExceptionCode{'
        'message: $message, '
        'uri: $uri, '
        'statusCode: $statusCode, '
        'errorResponse: $errorResponse}';
  }
}
