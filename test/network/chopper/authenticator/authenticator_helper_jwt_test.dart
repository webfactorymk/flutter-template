import 'package:chopper/chopper.dart';
import 'package:flutter_template/model/task/task.dart';
import 'package:flutter_template/model/task/task_status.dart';
import 'package:flutter_template/model/user/credentials.dart';
import 'package:flutter_template/model/user/user_credentials.dart';
import 'package:flutter_template/network/chopper/authenticator/authenticator_helper_jwt.dart';
import 'package:flutter_template/network/user_auth_api_service.dart';
import 'package:flutter_template/network/util/http_util.dart';
import 'package:flutter_template/user/unauthorized_user_exception.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:single_item_storage/cached_storage.dart';
import 'package:single_item_storage/memory_storage.dart';
import 'package:single_item_storage/storage.dart';
import 'package:http/http.dart' as http;

import '../../network_test_helper.dart';
import 'authenticator_helper_jwt_test.mocks.dart';

@GenerateMocks([UserAuthApiService])
void main() {
  late Storage<UserCredentials> storage;
  late MockUserAuthApiService mockUserAuthApiService;
  late AuthenticatorHelperJwt authenticatorHelperJwt;

  setUp(() {
    storage = CachedStorage<UserCredentials>(MemoryStorage());
    mockUserAuthApiService = MockUserAuthApiService();
    authenticatorHelperJwt =
        AuthenticatorHelperJwt(mockUserAuthApiService, storage);
  });

  group('refreshUserCredentials', () {
    test('refreshUserCredentials, inValidCredentials', () async {
      // arrange
      await storage.save(NetworkTestHelper.inValidUserCredentials);

      // assert
      expect(
          authenticatorHelperJwt.refreshIfTokenExpired(
              credentials: null, onError: (e) => throw e),
          throwsA(isInstanceOf<Exception>()));
    });

    test('refreshUserCredentials, token not expired', () async {
      // arrange
      storage.save(NetworkTestHelper.validUserCredentials);

      // act
      String? actual = await authenticatorHelperJwt.refreshIfTokenExpired(
          onError: (_) => null);

      // assert
      expect(actual, NetworkTestHelper.validToken);
    });

    test('refreshUserCredentials, token expired', () async {
      // arrange
      when(mockUserAuthApiService.refreshToken(any)).thenAnswer(
          (_) async => Future.value(NetworkTestHelper.validCredentials));
      await storage.save(NetworkTestHelper.expiredUserCredentials);

      // act
      String? actual = await authenticatorHelperJwt.refreshIfTokenExpired(
          onError: (e) => throw e);

      // assert
      expect(actual, equals(NetworkTestHelper.validToken));
    });
  });

  group('interceptResponse', () {
    Task task = Task(
        id: '1',
        title: "Post 1",
        description: "This is post one (1).",
        status: TaskStatus.done);
    Response<Task> validResponse = Response(http.Response('test', 401), task);

    test('interceptResponse, no token', () async {
      // assert
      expect(
          authenticatorHelperJwt.interceptResponse(
              Request('GET', 'task/2', 'http://example.com',
                  headers: {authHeaderKey: 'Bearer '}),
              validResponse),
          throwsA(isInstanceOf<UnauthorizedUserException>()));
    });

    test('interceptResponse, expired token', () async {
      // assert
      expect(
          authenticatorHelperJwt.interceptResponse(
              Request('GET', 'task/2', 'http://example.com', headers: {
                authHeaderKey: 'Bearer ' + NetworkTestHelper.expiredToken
              }),
              validResponse),
          throwsA(isInstanceOf<UnauthorizedUserException>()));
    });

    test('interceptResponse, expired token, valid token stored', () async {
      // arrange
      storage.save(NetworkTestHelper.validUserCredentials);

      // act
      Request? actualRequest = await authenticatorHelperJwt.interceptResponse(
          Request('GET', 'task/2', 'http://example.com', headers: {
            authHeaderKey: 'Bearer ' + NetworkTestHelper.expiredToken
          }),
          validResponse);

      // assert
      expect(
          actualRequest?.headers[authHeaderKey], NetworkTestHelper.validToken);
    });
  });

  group('interceptRequest', () {
    test('interceptRequest, no token', () async {
      // arrange
      Request expected = Request('GET', 'task/2', 'http://example.com',
          headers: {authHeaderKey: 'Bearer ' + NetworkTestHelper.expiredToken});

      // act
      Request actual = await authenticatorHelperJwt.interceptRequest(expected);

      // assert
      expect(actual, expected);
    });

    test('interceptRequest, expired token', () async {
      // arrange
      when(mockUserAuthApiService.refreshToken(any)).thenAnswer(
          (_) async => Future.value(NetworkTestHelper.validCredentials));
      storage.save(NetworkTestHelper.expiredUserCredentials);
      Request expected = Request('GET', 'task/2', 'http://example.com',
          headers: {authHeaderKey: 'Bearer ' + NetworkTestHelper.expiredToken});

      // act
      Request actual = await authenticatorHelperJwt.interceptRequest(expected);

      // assert
      expect(
          await storage.get(), equals(NetworkTestHelper.validUserCredentials));
      expect(actual, isNot(equals(expected)));
    });

    test('interceptRequest, expired token, valid token stored', () async {
      // arrange
      storage.save(NetworkTestHelper.validUserCredentials);
      Request expected = Request('GET', 'task/2', 'http://example.com',
          headers: {authHeaderKey: 'Bearer ' + NetworkTestHelper.expiredToken});

      // act
      Request actual = await authenticatorHelperJwt.interceptRequest(expected);

      // assert
      expect(actual, isNot(equals(expected)));
      expect(actual.headers[authHeaderKey],
          equals('Bearer ' + NetworkTestHelper.validToken));
    });
  });
}
