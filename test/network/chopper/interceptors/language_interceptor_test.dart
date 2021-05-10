import 'dart:io';

import 'package:chopper/chopper.dart';
import 'package:flutter_template/network/chopper/interceptors/language_interceptor.dart';
import 'package:flutter_template/network/util/http_util.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:single_item_storage/cached_storage.dart';
import 'package:single_item_storage/memory_storage.dart';
import 'package:single_item_storage/storage.dart';

import '../../network_test_helper.dart';

void main() {
  late Storage<String> storage;
  late LanguageInterceptor languageInterceptor;

  setUp(() {
    storage = CachedStorage<String>(MemoryStorage());
    languageInterceptor = LanguageInterceptor(storage);
  });

  group('onRequest', () {
    test('onRequest, no locale stored', () async {
      // assert
      Request expected = Request('GET', 'task/2', 'http://example.com',
          headers: {authHeaderKey: 'Bearer ' + NetworkTestHelper.validToken});

      // act
      Request actual = await languageInterceptor.onRequest(expected);

      // assert
      expect(actual, equals(expected));
      expect(actual.headers[HttpHeaders.acceptLanguageHeader], null);
    });

    test('onRequest, no locale stored', () async {
      // assert
      String expectedLocale = 'en-expected';
      storage.save(expectedLocale);
      Request expected = Request('GET', 'task/2', 'http://example.com',
          headers: {authHeaderKey: 'Bearer ' + NetworkTestHelper.validToken});

      // act
      Request actual = await languageInterceptor.onRequest(expected);

      // assert
      expect(actual, isNot(equals(expected)));
      expect(actual.headers[HttpHeaders.acceptLanguageHeader], expectedLocale);
    });
  });
}
