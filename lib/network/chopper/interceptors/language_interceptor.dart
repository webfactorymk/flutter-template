import 'dart:io';

import 'package:chopper/chopper.dart';
import 'package:single_item_storage/storage.dart';

/// [RequestInterceptor] that adds preferred language header on each request.
class LanguageInterceptor implements RequestInterceptor {
  final Storage<String> _localeStore;

  LanguageInterceptor(this._localeStore);

  @override
  Future<Request> onRequest(Request request) async {
    final String? locale = await _localeStore.get();
    if (locale != null) {
      return applyHeader(request, HttpHeaders.acceptLanguageHeader, locale);
    } else {
      return request;
    }
  }
}
