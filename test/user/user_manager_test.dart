import 'package:flutter_template/model/user/credentials.dart';
import 'package:flutter_template/model/user/refresh_token.dart';
import 'package:flutter_template/model/user/user.dart';
import 'package:flutter_template/model/user/user_credentials.dart';
import 'package:flutter_template/network/user_api_service.dart';
import 'package:flutter_template/user/unauthorized_user_exception.dart';
import 'package:flutter_template/user/user_hooks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:single_item_storage/cached_storage.dart';
import 'package:single_item_storage/observed_storage.dart';
import 'package:single_item_storage/storage.dart';

import 'test_user_manager.dart';
import 'user_manager_test.mocks.dart';

final String validToken = 'token-1';
final RefreshToken validRefreshToken = RefreshToken('refreshToken-1', 1);
final Credentials validCredentials = Credentials('token-1', validRefreshToken);
final UserCredentials validUserCredentials =
    UserCredentials(User(id: 'username', email: 'email'), validCredentials);

final UserCredentials validUserCredentialsSecond =
    UserCredentials(User(id: 'username2', email: 'email2'), validCredentials);

bool Function(UserCredentials?) userCredentialsToBool() {
  return (userCredentials) {
    return userCredentials?.credentials != null ? true : false;
  };
}

/// Tests for [UserManager]
@GenerateMocks([UserApiService, LoginHook, LogoutHook, Storage])
void main() {
  late TestUserManager userManager;
  late UserApiService apiService;
  late ObservedStorage storage;
  late Storage<UserCredentials?> innerStorage;
  late LoginHook<UserCredentials> loginHook;
  late LogoutHook logoutHook;

  setUp(() {
    apiService = MockUserApiService();
    innerStorage = MockStorage();
    storage = ObservedStorage(CachedStorage(innerStorage));
    loginHook = MockLoginHook();
    logoutHook = MockLogoutHook();
    userManager = TestUserManager(
      apiService,
      storage,
      loginHooks: [loginHook],
      logoutHooks: [logoutHook],
    );

    when(innerStorage.save(validUserCredentials)).thenAnswer(
        (realInvocation) async => Future.value(validUserCredentials));
    when(storage.get()).thenAnswer(
        (realInvocation) async => Future.value(validUserCredentials));
    when(apiService.getUserProfile(authHeader: 'Bearer $validToken').toType())
        .thenAnswer((_) async => Future.value(validUserCredentials.user));
  });

  tearDown(() async {
    await userManager.teardown();
  });

  test('IsLoggedIn', () async {
    bool isLoggedIn = await userManager.isLoggedIn();

    expect(isLoggedIn, isFalse);
  });

  test('Login Success', () async {
    when(apiService.login("username", "password").toType())
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
    when(apiService.login("username", "pass").toType())
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

  test('Login Failure', () async {
    when(apiService.login("username", "pass"))
        .thenThrow(Exception("Can't log-in, sorry."));

    expect(userManager.login("username", "pass"),
        throwsA(isInstanceOf<Exception>()));
    expect(userManager.updates, emits(isNull));
    expect(userManager.isLoggedIn(), completion(isFalse));
    expect(userManager.getLoggedInUser(), completion(isNull));
  });

  test('Logout Success', () async {
    when(apiService.login("username", "pass").toType())
        .thenAnswer((_) => Future.value(validCredentials));
    when(apiService.logout().toType()).thenAnswer(
        (_) => Future.value(http.Response('{"loggedOut": true}', 200)));

    expect(
      userManager.updates,
      emitsInOrder([null, validUserCredentials, null]),
    );

    await userManager.login("username", "pass");
    await userManager.logout();

    expect(userManager.isLoggedIn(), completion(isFalse));
    expect(userManager.getLoggedInUser(), completion(isNull));
  });

  test('Logout Error', () async {
    when(apiService.login("username", "password").toType())
        .thenAnswer((_) => Future.value(validCredentials));
    when(apiService.logout()).thenThrow(Exception("Can't log-out!"));

    // expect(userManager.updates, emitsInOrder([null, validUserCredentials, null]));

    await userManager.login("username", "password");
    expect(userManager.logout(), throwsA(isInstanceOf<Exception>()));

    // expect(userManager.isLoggedIn(), completion(isFalse));
    // expect(userManager.getLoggedInUser(), completion(isNull));
  });

  test('Double logout', () async {
    // arrange
    when(apiService.logout().toType()).thenAnswer(
        (_) => Future.value(http.Response('{"loggedOut": true}', 200)));
    when(apiService.login("username", "pass").toType())
        .thenAnswer((_) => Future.value(validCredentials));

    // assert later
    expect(
        userManager.updates, emitsInOrder([null, validUserCredentials, null]));

    // act
    await userManager.login("username", "pass");
    await userManager.logout();
    await userManager.logout();

    // assert
    verify(apiService.logout()).called(1);
    expect(storage.get(), completion(isNull));
  });

  test('Logout not logged in', () async {
    expect(userManager.logout(), completes);
  });

  test('User updates stream', () async {
    when(apiService.login("jojo", "123").toType())
        .thenAnswer((_) => Future.value(validCredentials));
    when(apiService.logout().toType()).thenAnswer(
        (_) => Future.value(http.Response('{"loggedOut": true}', 200)));

    Stream<bool> userUpdates = userManager.updates.map(userCredentialsToBool());

    expect(userUpdates, emitsInOrder([false, true, false]));

    userManager
        .login("jojo", "123")
        .then((_) => userManager.login("jojo", "123"))
        .then((_) => userManager.logout());
  });

  test('User updates multiple stream subscription', () async {
    when(apiService.login("jojo", "123").toType())
        .thenAnswer((_) => Future.value(validCredentials));
    when(apiService.logout().toType()).thenAnswer(
        (_) => Future.value(http.Response('{"loggedOut": true}', 200)));

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

  test('Update credentials success', () async {
    // arrange
    when(apiService.getUserProfile(authHeader: 'Bearer $validToken').toType())
        .thenAnswer(
            (realInvocation) => Future.value(validUserCredentials.user));
    when(apiService.login("username", "pass").toType())
        .thenAnswer((_) => Future.value(validCredentials));

    // act
    await userManager.login('username', 'pass');
    final actualUserCredentials =
        await userManager.updateCredentials(validCredentials);

    // assert
    expect(actualUserCredentials.credentials, validCredentials);
    verify(innerStorage.get()).called(1);
    verify(innerStorage.save(actualUserCredentials)).called(2);
  });

  test('Update credentials when user logged out', () async {
    // arrange
    when(innerStorage.get())
        .thenAnswer((realInvocation) => Future.value(validUserCredentials));
    when(apiService.logout().toType()).thenAnswer(
        (_) => Future.value(http.Response('{"loggedOut": true}', 200)));
    when(apiService.login("username", "pass").toType())
        .thenAnswer((_) => Future.value(validCredentials));

    // act
    await userManager.login('username', 'pass');
    await userManager.logout();

    // assert
    expect(userManager.updateCredentials(validCredentials),
        throwsA(isInstanceOf<UnauthorizedUserException>()));
  });

  test('Update user success', () async {
    // arrange
    when(apiService.getUserProfile().toType()).thenAnswer(
        (realInvocation) => Future.value(validUserCredentialsSecond.user));
    when(apiService.updateUserProfile(validUserCredentialsSecond.user).toType())
        .thenAnswer((_) => Future.value(validUserCredentialsSecond.user));
    when(innerStorage.save(validUserCredentialsSecond)).thenAnswer(
        (realInvocation) async => Future.value(validUserCredentialsSecond));
    when(apiService.login("username", "pass").toType())
        .thenAnswer((_) => Future.value(validCredentials));

    // act
    await userManager.login('username', 'pass');
    final User actualUser =
        await userManager.updateUser(validUserCredentialsSecond.user);

    // assert
    verify(apiService.updateUserProfile(validUserCredentialsSecond.user))
        .called(1);
    expect(actualUser, validUserCredentialsSecond.user);
  });

  test('Update user when logged out', () async {
    // arrange
    when(apiService.logout().toType()).thenAnswer(
        (_) => Future.value(http.Response('{"loggedOut": true}', 200)));
    when(apiService.login("username", "pass").toType())
        .thenAnswer((_) => Future.value(validCredentials));

    // act
    await userManager.login('username', 'pass');
    await userManager.logout();

    // assert
    verify(storage.delete()).called(1);
    expect(userManager.updateUser(validUserCredentials.user),
        throwsA(isInstanceOf<UnauthorizedUserException>()));
  });

  test('Refresh user success', () async {
    // arrange
    when(apiService.getUserProfile().toType()).thenAnswer(
        (realInvocation) => Future.value(validUserCredentialsSecond.user));
    when(innerStorage.save(validUserCredentialsSecond)).thenAnswer(
        (realInvocation) async => Future.value(validUserCredentialsSecond));
    when(apiService.login("username", "pass").toType())
        .thenAnswer((_) => Future.value(validCredentials));

    // act
    await userManager.login('username', 'pass');
    final User actualUser = await userManager.refreshUser();

    // assert
    verify(apiService.getUserProfile()).called(1);
    expect(actualUser, validUserCredentialsSecond.user);
  });

  test('Double refresh user', () async {
    when(apiService.getUserProfile().toType()).thenAnswer(
        (realInvocation) => Future.value(validUserCredentials.user));
    when(apiService.login("username", "pass").toType())
        .thenAnswer((_) => Future.value(validCredentials));
    await userManager.login("username", "pass");

    // expect(userManager.updates, emitsInOrder([validUserCredentials, validUserCredentials]));

    await userManager.refreshUser();
    await userManager.refreshUser();

    verify(apiService.getUserProfile(authHeader: 'Bearer $validToken'))
        .called(1);
    verify(apiService.getUserProfile()).called(2);
  });

  test('Refresh user when logged out', () async {
    // arrange
    when(apiService.logout().toType()).thenAnswer(
        (_) => Future.value(http.Response('{"loggedOut": true}', 200)));
    when(apiService.login("username", "pass").toType())
        .thenAnswer((_) => Future.value(validCredentials));

    // act
    await userManager.login('username', 'pass');
    await userManager.logout();

    // assert
    verify(storage.delete()).called(1);
    expect(userManager.refreshUser(),
        throwsA(isInstanceOf<UnauthorizedUserException>()));
  });

  test('Deactivate User', () async {
    // arrange
    when(apiService.login("username", "pass").toType())
        .thenAnswer((_) => Future.value(validCredentials));

    // act
    await userManager.login('username', 'pass');
    userManager.deactivateUser();

    // assert
    verify(apiService.deactivate()).called(1);
    verifyNever(storage.delete());
    expect(userManager.updates, emitsInOrder([null]));
  });
}
