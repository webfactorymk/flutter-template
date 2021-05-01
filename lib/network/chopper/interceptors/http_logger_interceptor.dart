import 'dart:async';

import 'package:chopper/chopper.dart';
import 'package:flutter_template/log/logger.dart';
import 'package:http/http.dart' as http;

/// [HttpLoggingInterceptor] that uses [Logger] instead of chopper logger.
class HttpLoggerInterceptor implements RequestInterceptor, ResponseInterceptor {
  @override
  FutureOr<Request> onRequest(Request request) async {
    final base = await request.toBaseRequest();
    Logger.d('--> ${base.method} ${base.url}');
    base.headers.forEach((k, v) => Logger.d('$k: $v'));

    var bytes = '';
    if (base is http.Request) {
      final body = base.body;
      if (body.isNotEmpty) {
        Logger.d(body);
        bytes = ' (${base.bodyBytes.length}-byte body)';
      }
    }

    Logger.d('--> END ${base.method}$bytes');
    return request;
  }

  @override
  FutureOr<Response> onResponse(Response response) {
    final base = response.base.request;
    Logger.d('<-- ${response.statusCode} ${base!.url}');

    response.base.headers.forEach((k, v) => Logger.d('$k: $v'));

    var bytes;
    if (response.base is http.Response) {
      final resp = response.base as http.Response;
      if (resp.body.isNotEmpty) {
        Logger.d(resp.body);
        bytes = ' (${response.bodyBytes.length}-byte body)';
      }
    }

    Logger.d('--> END ${base.method}$bytes');
    return response;
  }
}
