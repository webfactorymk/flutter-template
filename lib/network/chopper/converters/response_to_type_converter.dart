import 'package:chopper/chopper.dart';
import 'package:flutter_template/network/util/http_exception_code.dart';
import 'package:http/http.dart' as http;

Type _typeOf<T>() => T;

extension ResponseToTypeConverter<T> on Future<Response<T>> {
  Future<T> toType() => this.then((response) {
        if (response.isSuccessful) {
          if (T == _typeOf<void>()) {
            return Future.value();
          } else if (T == http.BaseResponse || T == http.Response) {
            return response.base as T;
          } else {
            return response.body!;
          }
        } else {
          return _httpError(response);
        }
      });

  Future<T> _httpError(Response<T> response) {
    return Future.error(HttpExceptionCode(
      'Http error -> status code: ${response.statusCode}, response: ${response.body}',
      statusCode: response.statusCode,
      uri: response.base.request?.url,
      errorResponse: response.error,
    ));
  }
}
