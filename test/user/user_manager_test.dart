import 'package:chopper/chopper.dart';
import 'package:flutter_template/model/user/credentials.dart';
import 'package:flutter_template/model/user/refresh_token.dart';
import 'package:flutter_template/model/user/user.dart';
import 'package:flutter_template/model/user/user_credentials.dart';
import 'package:flutter_template/network/api_service.dart';
import 'package:flutter_template/network/errors/unauthorized_user_exception.dart';
import 'package:flutter_template/user/user_hooks.dart';
import 'package:flutter_template/user/user_manager.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:single_item_storage/cached_storage.dart';
import 'package:single_item_storage/storage.dart';
import 'package:http/http.dart' as http;

import 'test_user_manager.dart';
import 'user_manager_test.mocks.dart';

final String validToken = 'token-1';
final RefreshToken validRefreshToken = RefreshToken('refreshToken-1', 1);
final Credentials validCredentials = Credentials('token-1', validRefreshToken);
final UserCredentials validUserCredentials =
    UserCredentials(User(id: 'username', email: 'email'), validCredentials);

@GenerateMocks([ApiService, LoginHook, LogoutHook, Storage])
void main() {
  late TestUserManager userManager;
  late ApiService apiService;
  late Storage<UserCredentials?> storage;
  late Storage<UserCredentials?> innerStorage;
  late LoginHook<UserCredentials> loginHook;
  late LogoutHook logoutHook;

  setUp(() {
    apiService = MockApiService();
    innerStorage = MockStorage();
    storage = CachedStorage(innerStorage);
    loginHook = MockLoginHook();
    logoutHook = MockLogoutHook();
    userManager = TestUserManager(
      apiService,
      storage,
      loginHooks: [loginHook],
      logoutHooks: [logoutHook],
    );

    when(innerStorage.save(validUserCredentials))
        .thenAnswer((realInvocation) async => Future.value(validUserCredentials));
    when(storage.get()).thenAnswer((realInvocation) async => Future.value(validUserCredentials));
    when(apiService.getUserProfile(token: validToken))
        .thenAnswer((_) async => Future.value(validUserCredentials.user));
  });

  tearDown(() {
    userManager.teardown();
  });

  test('IsLoggedIn', () async {
    bool isLoggedIn = await userManager.isLoggedIn();

    expect(isLoggedIn, isFalse);
  });

  test('Login Success', () async {
    when(apiService.login("username", "password"))
        .thenAnswer((_) => Future.value(validCredentials));

    expectLater(userManager.updates, emitsInOrder([null, validUserCredentials]));

    UserCredentials actualLoggedInUser = await userManager.login("username", "password");

    expect(actualLoggedInUser, equals(validUserCredentials));
    expect(await storage.get(), equals(validUserCredentials));
    expect(await userManager.isLoggedIn(), isTrue);
    expect(await userManager.getLoggedInUser(), equals(validUserCredentials));

    verify(loginHook.postLogin(validUserCredentials)).called(1);
  });

  test('Double login', () async {
    when(apiService.login("username", "pass")).thenAnswer((_) => Future.value(validCredentials));

    expectLater(userManager.updates, emitsInOrder([null, validUserCredentials]));

    await userManager.login("username", "pass");
    UserCredentials actualLoggedInUser = await userManager.login("username", "pass");

    expect(actualLoggedInUser, equals(validUserCredentials));
    expect(await userManager.isLoggedIn(), isTrue);
    expect(await storage.get(), equals(validUserCredentials));
    expect(await userManager.getLoggedInUser(), equals(validUserCredentials));

    verify(apiService.login("username", "pass")).called(1);
    verify(loginHook.postLogin(validUserCredentials)).called(1);
  });

  test('Double user refresh', () async {
    when(apiService.getUserProfile())
        .thenAnswer((realInvocation) => Future.value(validUserCredentials.user));
    when(apiService.login("username", "pass")).thenAnswer((_) => Future.value(validCredentials));
    await userManager.login("username", "pass");

    // expectLater(userManager.updates, emitsInOrder([validUserCredentials, validUserCredentials]));

    await userManager.refreshUser();
    await userManager.refreshUser();

    verify(apiService.getUserProfile(token: validToken)).called(1);
    verify(apiService.getUserProfile()).called(2);
  });

  test('Login Failure', () async {
    when(apiService.login("username", "pass")).thenThrow(Exception("Can't log-in, sorry."));

    expect(userManager.login("username", "pass"), throwsA(isInstanceOf<Exception>()));
    expect(userManager.updates, emits(isNull));
    // I commented this because we expect something on mocked instance
    // expect(storage.get(), emits(isEmpty));
    expect(userManager.isLoggedIn(), completion(isFalse));
    expect(userManager.getLoggedInUser(), completion(isNull));

    // userManager.teardown();
  });

  test('Logout Success', () async {
    when(apiService.login("username", "pass")).thenAnswer((_) => Future.value(validCredentials));
    when(apiService.logout())
        .thenAnswer((_) => Future.value(http.Response('{"loggedOut": true}', 200)));
    expect(userManager.updates, emitsInOrder([null, validUserCredentials, null]));

    await userManager.login("username", "pass");
    await userManager.logout();

    // expect(storage.get(), emits(isNull));
    expect(userManager.isLoggedIn(), completion(isFalse));
    expect(userManager.getLoggedInUser(), completion(isNull));

    userManager.teardown();
  });

  test('Logout Error', () async {
    when(apiService.login("username", "password"))
        .thenAnswer((_) => Future.value(validCredentials));
    when(apiService.logout()).thenThrow(Exception("Can't log-out!"));

    // await expectLater(userManager.updates, emitsInOrder([null, validUserCredentials, null]));

    await userManager.login("username", "password");
    expect(userManager.logout(), throwsA(isInstanceOf<Exception>()));

    // expect(userManager.isLoggedIn(), completion(isFalse));
    // expect(userManager.getLoggedInUser(), completion(isNull));
  });

  test('Logout not logged in', () async {
    expect(userManager.logout(), completes);
  });

  test('User updates stream', () async {
    when(apiService.login("jojo", "123")).thenAnswer((_) => Future.value(validCredentials));
    when(apiService.logout())
        .thenAnswer((_) => Future.value(http.Response('{"loggedOut": true}', 200)));

    Stream<bool> userUpdates = userManager.updates.map((userCredentials) {
      return userCredentials?.credentials != null ? true : false;
    });

    expect(userUpdates, emitsInOrder([false, true, false]));

    userManager
        .login("jojo", "123")
        .then((_) => userManager.login("jojo", "123"))
        .then((_) => userManager.logout());
  });

  bool Function(UserCredentials?) userCredentialsToBool() {
    return (userCredentials) {
      return userCredentials?.credentials != null ? true : false;
    };
  }

  test('User updates multiple stream subscription', () async {
    when(apiService.login("jojo", "123")).thenAnswer((_) => Future.value(validCredentials));
    when(apiService.logout())
        .thenAnswer((_) => Future.value(http.Response('{"loggedOut": true}', 200)));

    Stream<bool> usrUpdates1 = userManager.updates.map(userCredentialsToBool());
    Stream<bool> usrUpdates2 = userManager.updates.map(userCredentialsToBool());
    Stream<bool> usrUpdates3 = userManager.updates.map(userCredentialsToBool());

    expect(usrUpdates1, emitsInOrder([false, true, false]));
    expect(usrUpdates2, emitsInOrder([false, true, false]));

    userManager
        .login("jojo", "123")
        .then((_) => userManager.login("jojo", "123"))
        .then((_) => userManager.logout());

    expect(usrUpdates3, emits(isFalse));
  });

  test('Double logout', () async {
    // arrange
    when(apiService.logout())
        .thenAnswer((_) => Future.value(http.Response('{"loggedOut": true}', 200)));
    when(apiService.login("username", "pass")).thenAnswer((_) => Future.value(validCredentials));

    // assert later
    expectLater(userManager.updates, emitsInOrder([null, validUserCredentials, null]));

    // act
    await userManager.login("username", "pass");
    await userManager.logout();
    await userManager.logout();

    // assert
    verify(apiService.logout()).called(1);
    expect(storage.get(), completion(isNull));
  });
}
