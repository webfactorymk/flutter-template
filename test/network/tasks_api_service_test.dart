import 'dart:convert';
import 'package:chopper/chopper.dart';
import 'package:flutter_template/model/task/task.dart';
import 'package:flutter_template/model/task/task_status.dart';
import 'package:flutter_template/model/user/credentials.dart';
import 'package:flutter_template/model/user/user_credentials.dart';
import 'package:flutter_template/network/chopper/authenticator/authenticator_helper_jwt.dart';
import 'package:flutter_template/network/chopper/converters/json_type_converter_provider.dart';
import 'package:flutter_template/network/chopper/interceptors/auth_interceptor.dart';
import 'package:flutter_template/network/tasks_api_service.dart';
import 'package:flutter_template/network/user_auth_api_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:single_item_storage/cached_storage.dart';
import 'package:single_item_storage/memory_storage.dart';
import 'package:single_item_storage/storage.dart';

import 'mock_client_handler.dart';
import 'network_test_helper.dart';
import 'tasks_api_service_test.mocks.dart';

final Map<int, Task> taskMap = Map.unmodifiable({
  1: Task(
      id: '1',
      title: "Post 1",
      description: "This is post one (1).",
      taskStatus: TaskStatus.done),
  2: Task(
      id: '2',
      title: "Post 2",
      description: "This is post two (2).",
      taskStatus: TaskStatus.done),
  3: Task(
      id: '3',
      title: "Post 3",
      description: "This is post tree (3).",
      taskStatus: TaskStatus.done),
});

@GenerateMocks([UserAuthApiService])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late TasksApiService apiService;
  late Storage<UserCredentials> userCredentialsStorage;
  late http.Client mockClient;
  late ChopperClient chopperClient;
  late MockUserAuthApiService mockUserAuthApiService;

  setUp(() {
    mockUserAuthApiService = MockUserAuthApiService();
    userCredentialsStorage = CachedStorage<UserCredentials>(MemoryStorage());
    mockClient = MockClient(withMockClientHandler());
    chopperClient = ChopperClient(
      baseUrl: 'http://example.com',
      client: mockClient,
      converter: JsonTypeConverterProvider.getDefault(),
      interceptors: [
        AuthInterceptor(
            userCredentialsStorage,
            AuthenticatorHelperJwt(
                mockUserAuthApiService, userCredentialsStorage)),
      ],
    );
    apiService = TasksApiService.create(chopperClient);
  });

  group('Test tasks api service - chopper implementation', () {
    test('valid token, 200 response, no refresh', () async {
      userCredentialsStorage.save(NetworkTestHelper.validUserCredentials);

      final postsResponse = await apiService.getTask('2');
      print(postsResponse.body);

      expect(postsResponse.statusCode, equals(200));
      expect(json.decode(postsResponse.bodyString)['refreshToken'], null);
    });

    test('invalid token, 401 response', () async {
      final postsResponse = await apiService.getTask('2');

      expect(postsResponse.statusCode, equals(401));
    });

    test('invalid token, 401 response, refresh', () async {
      Response<Credentials> response = Response(
          http.Response('test', 200), NetworkTestHelper.validCredentials);
      when(mockUserAuthApiService.refreshToken(any))
          .thenAnswer((_) async => Future.value(response));
      await userCredentialsStorage
          .save(NetworkTestHelper.expiredUserCredentials);

      final Response<Task> actual = await apiService.getTask('2');

      // expect(actual.statusCode, equals(401));
      expect(actual.body, equals(taskMap[2]));
    });

    test('invalid token, 401 response, refresh failed', () async {
      when(mockUserAuthApiService.refreshToken(any))
          .thenAnswer((_) => Future.error(Exception('refresh token failed')));

      final Response<Task> actual = await apiService.getTask('2');

      expect(actual.statusCode, equals(401));
      expect(actual.body, equals(null));
    });

    test('multiple 401 responses, refresh token once, retry all', () async {
      Response<Credentials> response = Response(
          http.Response('test', 200), NetworkTestHelper.validCredentials);
      when(mockUserAuthApiService.refreshToken(any))
          .thenAnswer((_) async => Future.value(response));
      await userCredentialsStorage
          .save(NetworkTestHelper.expiredUserCredentials);

      final List<Response<Task>> responseList =
          List.unmodifiable(await Future.wait([
        apiService.getTask('1'),
        apiService.getTask('2'),
        apiService.getTask('3'),
      ]));

      expect(responseList[0].statusCode, equals(200));
      expect(responseList[0].body, equals(taskMap[1]));
      expect(responseList[1].statusCode, equals(200));
      expect(responseList[1].body, equals(taskMap[2]));
      expect(responseList[2].statusCode, equals(200));
      expect(responseList[2].body, equals(taskMap[3]));

      verify(mockUserAuthApiService.refreshToken(NetworkTestHelper.validToken))
          .called(1);
    });
  });
}
