import 'dart:io';

import 'package:flutter_template/model/user/credentials.dart';
import 'package:flutter_template/model/user/refresh_token.dart';
import 'package:flutter_template/model/user/user.dart';
import 'package:flutter_template/model/user/user_credentials.dart';
import 'package:flutter_template/network/api_service.dart';
import 'package:flutter_template/user/user_hooks.dart';
import 'package:flutter_template/user/user_manager.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:single_item_storage/cached_storage.dart';
import 'package:single_item_storage/storage.dart';

class MockApiService extends Mock implements ApiService {}

class MockStorage extends Mock implements Storage<UserCredentials> {}

class MockLoginHook extends Mock implements LoginHook<UserCredentials> {}

class MockLogoutHook extends Mock implements LogoutHook {}

final String validToken = 'token-1';
final RefreshToken validRefreshToken = RefreshToken('refreshToken-1', 1);
final Credentials validCredentials = Credentials('token-1', validRefreshToken);
final UserCredentials validUserCredentials =
    UserCredentials(User(id: 'username', email: 'email'), validCredentials);

void main() {
  late UserManager userManager;
  late ApiService apiService;
  late Storage<UserCredentials> storage;
  late LoginHook<UserCredentials> loginHook;
  late LogoutHook logoutHook;

  setUp(() {
    apiService = MockApiService();
    storage = CachedStorage(MockStorage());
    loginHook = MockLoginHook();
    logoutHook = MockLogoutHook();
    userManager = UserManager(
      apiService,
      storage,
      loginHooks: [loginHook],
      logoutHooks: [logoutHook],
    );

    when(apiService.getUserProfile())
        .thenAnswer((_) => Future.value(validUserCredentials.user));
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

    expect(userManager.updates, emitsInOrder([null, validUserCredentials]));

    UserCredentials actualLoggedInUser =
        await userManager.login("username", "password");

    expect(actualLoggedInUser, equals(validUserCredentials));
    expect(await storage.get(), equals(validUserCredentials));
    expect(await userManager.isLoggedIn(), isTrue);
    expect(await userManager.getLoggedInUser(), equals(validUserCredentials));

    verify(loginHook.postLogin(validUserCredentials)).called(1);
  });

  test('Double login', () async {
    when(apiService.login("username", "pass"))
        .thenAnswer((_) => Future.value(validCredentials));

    expect(userManager.updates, emitsInOrder([null, validUserCredentials]));

    await userManager.login("username", "pass");
    UserCredentials actualLoggedInUser =
        await userManager.login("username", "pass");

    expect(actualLoggedInUser, equals(validUserCredentials));
    expect(await userManager.isLoggedIn(), isTrue);
    expect(await storage.get(), equals(validUserCredentials));
    expect(await userManager.getLoggedInUser(), equals(validUserCredentials));

    verify(apiService.login("username", "pass")).called(1);
    verify(loginHook.postLogin(validUserCredentials)).called(1);
  });

  test('Double user refresh', () async {
    when(apiService.login("username", "pass"))
        .thenAnswer((_) => Future.value(validCredentials));
    await userManager.login("username", "pass");

    expect(userManager.updates,
        emitsInOrder([validUserCredentials, validUserCredentials]));

    await userManager.refreshUser();
    await userManager.refreshUser();

    verify(apiService.getUserProfile()).called(3);
  });

  test('Login Failure', () async {
    when(apiService.login("username", "pass"))
        .thenAnswer((_) => Future.error(Exception("Can't log-in, sorry.")));

    expect(userManager.login("username", "pass"),
        throwsA(isInstanceOf<Exception>()));
    expect(userManager.updates, emits(isNull));
    expect(storage.get(), emits(isNull));
    expect(userManager.isLoggedIn(), completion(isFalse));
    expect(userManager.getLoggedInUser(), completion(isNull));

    userManager.teardown();
  });

  test('Logout Success', () async {
    when(apiService.login("username", "pass"))
        .thenAnswer((_) => Future.value(validCredentials));
    when(apiService.logout()).thenAnswer((_) => Future.value());
    expect(
        userManager.updates, emitsInOrder([null, validUserCredentials, null]));

    await userManager.login("username", "pass");
    await userManager.logout();

    expect(storage.get(), emits(isNull));
    expect(userManager.isLoggedIn(), completion(isFalse));
    expect(userManager.getLoggedInUser(), completion(isNull));

    userManager.teardown();
  });

  test('Logout Error', () async {
    when(apiService.login("username", "password"))
        .thenAnswer((_) => Future.value(validCredentials));
    when(apiService.logout())
        .thenAnswer((_) => Future.error(Exception("Can't log-out!")));
    expect(
        userManager.updates, emitsInOrder([null, validUserCredentials, null]));

    await userManager.login("username", "password");
    await userManager.logout();

    expect(storage.get(), emits(isNull));
    expect(userManager.isLoggedIn(), completion(isFalse));
    expect(userManager.getLoggedInUser(), completion(isNull));

    userManager.teardown();
  });

  test('Logout not logged in', () async {
    expect(userManager.logout(), completes);
  });

  test('User updates stream', () async {
    when(apiService.login("jojo", "123"))
        .thenAnswer((_) => Future.value(validCredentials));
    when(apiService.logout()).thenAnswer((_) => Future.value());

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
    when(apiService.login("jojo", "123"))
        .thenAnswer((_) => Future.value(validCredentials));
    when(apiService.logout()).thenAnswer((_) => Future.value());

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
}
