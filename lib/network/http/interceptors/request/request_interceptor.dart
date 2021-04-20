import 'package:http/http.dart';

/// Interceptor that can read and modify a [BaseRequest] before it's sent.
abstract class RequestInterceptor {
  Future<void> intercept(BaseRequest baseRequest);
}