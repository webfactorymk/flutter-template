import 'dart:convert';

import 'package:chopper/chopper.dart';
import 'package:flutter_template/model/task/api/create_task.dart';
import 'package:flutter_template/model/task/task.dart';
import 'package:flutter_template/model/task/task_status.dart';
import 'package:flutter_template/model/user/user_credentials.dart';
import 'package:flutter_template/network/chopper/authenticator/authenticator_helper_jwt.dart';
import 'package:flutter_template/network/chopper/converters/json_type_converter_provider.dart';
import 'package:flutter_template/network/chopper/generated/chopper_tasks_api_service.dart';
import 'package:flutter_template/network/chopper/interceptors/auth_interceptor.dart';
import 'package:flutter_template/network/user_auth_api_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:single_item_storage/cached_storage.dart';
import 'package:single_item_storage/memory_storage.dart';
import 'package:single_item_storage/storage.dart';
import 'package:flutter_template/network/chopper/converters/response_to_type_converter.dart';

import 'mock_client_handler.dart';
import 'network_test_helper.dart';
import 'tasks_api_service_test.mocks.dart';

final Map<int, Task> taskMap = Map.unmodifiable({
  1: Task(
      id: '1',
      title: "Post 1",
      description: "This is post one (1).",
      status: TaskStatus.done),
  2: Task(
      id: '2',
      title: "Post 2",
      description: "This is post two (2).",
      status: TaskStatus.done),
  3: Task(
      id: '3',
      title: "Post 3",
      description: "This is post tree (3).",
      status: TaskStatus.done),
});

@GenerateMocks([UserAuthApiService])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late ChopperTasksApiService apiService;
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
        AuthInterceptor(AuthenticatorHelperJwt(
            mockUserAuthApiService, userCredentialsStorage)),
      ],
    );
    apiService = ChopperTasksApiService.create(chopperClient);
  });

  group('Test tasks api service - chopper implementation', () {
    test('valid token, 200 response, no refresh', () async {
      // arrange
      userCredentialsStorage.save(NetworkTestHelper.validUserCredentials);

      // act
      final postsResponse = await apiService.getTask('2');
      print(postsResponse.body);

      // assert
      expect(postsResponse.statusCode, equals(200));
      expect(json.decode(postsResponse.bodyString)['refreshToken'], null);
    });

    test('invalid token, 401 response', () async {
      // act
      final postsResponse = await apiService.getTask('2');

      // assert
      expect(postsResponse.statusCode, equals(401));
    });

    test('invalid token, 401 response, refresh', () async {
      // arrange
      when(mockUserAuthApiService.refreshToken(any)).thenAnswer(
          (_) async => Future.value(NetworkTestHelper.validCredentials));
      await userCredentialsStorage
          .save(NetworkTestHelper.expiredUserCredentials);

      // act
      final Response<Task> actual = await apiService.getTask('2');

      // assert
      expect(actual.body, equals(taskMap[2]));
    });

    test('invalid token, 401 response, refresh failed', () async {
      // arrange
      when(mockUserAuthApiService.refreshToken(any))
          .thenAnswer((_) => Future.error(Exception('refresh token failed')));

      // act
      final Response<Task> actual = await apiService.getTask('2');

      // assert
      expect(actual.statusCode, equals(401));
      expect(actual.body, equals(null));
    });

    test('multiple 401 responses, refresh token once, retry all', () async {
      // arrange
      when(mockUserAuthApiService.refreshToken(any)).thenAnswer(
          (_) async => Future.value(NetworkTestHelper.validCredentials));
      await userCredentialsStorage
          .save(NetworkTestHelper.expiredUserCredentials);

      // act
      final List<Response<Task>> responseList =
          List.unmodifiable(await Future.wait([
        apiService.getTask('1'),
        apiService.getTask('2'),
        apiService.getTask('3'),
      ]));

      // assert
      expect(responseList[0].statusCode, equals(200));
      expect(responseList[0].body, equals(taskMap[1]));
      expect(responseList[1].statusCode, equals(200));
      expect(responseList[1].body, equals(taskMap[2]));
      expect(responseList[2].statusCode, equals(200));
      expect(responseList[2].body, equals(taskMap[3]));

      verify(mockUserAuthApiService.refreshToken(NetworkTestHelper.validToken))
          .called(1);
    });

    test('task list, 200 response, converted', () async {
      // arrange
      userCredentialsStorage.save(NetworkTestHelper.validUserCredentials);

      // act
      List<Task> convertedResponse = await apiService.getTasks('id').toType();

      // assert
      expect(convertedResponse, equals(taskMap.values.toList()));
    });

    test('task post request, 200 response, converted', () async {
      // arrange
      userCredentialsStorage.save(NetworkTestHelper.validUserCredentials);

      // act
      Task convertedResponse = await apiService
          .createTask(CreateTask.fromTask(taskMap[1]!))
          .toType();

      // assert
      expect(convertedResponse, equals(taskMap[1]));
    });
  });
}
