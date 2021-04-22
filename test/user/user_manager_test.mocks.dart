// Mocks generated by Mockito 5.0.5 from annotations
// in flutter_template/test/user/user_manager_test.dart.
// Do not manually edit this file.

import 'dart:async' as _i6;

import 'package:flutter_template/model/user/credentials.dart' as _i2;
import 'package:flutter_template/model/user/user.dart' as _i4;
import 'package:flutter_template/network/api_service.dart' as _i5;
import 'package:flutter_template/user/user_hooks.dart' as _i7;
import 'package:http/src/response.dart' as _i3;
import 'package:mockito/mockito.dart' as _i1;
import 'package:single_item_storage/storage.dart' as _i8;

// ignore_for_file: comment_references
// ignore_for_file: unnecessary_parenthesis

class _FakeCredentials extends _i1.Fake implements _i2.Credentials {}

class _FakeResponse extends _i1.Fake implements _i3.Response {}

class _FakeUser extends _i1.Fake implements _i4.User {}

/// A class which mocks [ApiService].
///
/// See the documentation for Mockito's code generation for more information.
class MockApiService extends _i1.Mock implements _i5.ApiService {
  MockApiService() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i6.Future<void> signUp(_i4.User? user) =>
      (super.noSuchMethod(Invocation.method(#signUp, [user]),
          returnValue: Future<void>.value(null),
          returnValueForMissingStub: Future.value()) as _i6.Future<void>);
  @override
  _i6.Future<_i2.Credentials> login(String? username, String? password) =>
      (super.noSuchMethod(Invocation.method(#login, [username, password]),
              returnValue: Future<_i2.Credentials>.value(_FakeCredentials()))
          as _i6.Future<_i2.Credentials>);
  @override
  _i6.Future<_i3.Response> logout() =>
      (super.noSuchMethod(Invocation.method(#logout, []),
              returnValue: Future<_i3.Response>.value(_FakeResponse()))
          as _i6.Future<_i3.Response>);
  @override
  _i6.Future<void> deactivate() =>
      (super.noSuchMethod(Invocation.method(#deactivate, []),
          returnValue: Future<void>.value(null),
          returnValueForMissingStub: Future.value()) as _i6.Future<void>);
  @override
  _i6.Future<_i3.Response> resetPassword(String? email) =>
      (super.noSuchMethod(Invocation.method(#resetPassword, [email]),
              returnValue: Future<_i3.Response>.value(_FakeResponse()))
          as _i6.Future<_i3.Response>);
  @override
  _i6.Future<_i4.User> getUserProfile({String? token}) => (super.noSuchMethod(
          Invocation.method(#getUserProfile, [], {#token: token}),
          returnValue: Future<_i4.User>.value(_FakeUser()))
      as _i6.Future<_i4.User>);
  @override
  _i6.Future<_i3.Response> updateUserProfile(_i4.User? user) =>
      (super.noSuchMethod(Invocation.method(#updateUserProfile, [user]),
              returnValue: Future<_i3.Response>.value(_FakeResponse()))
          as _i6.Future<_i3.Response>);
  @override
  _i6.Future<void> addNotificationsToken(String? token) =>
      (super.noSuchMethod(Invocation.method(#addNotificationsToken, [token]),
          returnValue: Future<void>.value(null),
          returnValueForMissingStub: Future.value()) as _i6.Future<void>);
}

/// A class which mocks [LoginHook].
///
/// See the documentation for Mockito's code generation for more information.
class MockLoginHook<U> extends _i1.Mock implements _i7.LoginHook<U> {
  MockLoginHook() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i6.Future<void> postLogin(U? user) =>
      (super.noSuchMethod(Invocation.method(#postLogin, [user]),
          returnValue: Future<void>.value(null),
          returnValueForMissingStub: Future.value()) as _i6.Future<void>);
}

/// A class which mocks [LogoutHook].
///
/// See the documentation for Mockito's code generation for more information.
class MockLogoutHook extends _i1.Mock implements _i7.LogoutHook {
  MockLogoutHook() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i6.Future<void> postLogout() =>
      (super.noSuchMethod(Invocation.method(#postLogout, []),
          returnValue: Future<void>.value(null),
          returnValueForMissingStub: Future.value()) as _i6.Future<void>);
}

/// A class which mocks [Storage].
///
/// See the documentation for Mockito's code generation for more information.
class MockStorage<E> extends _i1.Mock implements _i8.Storage<E> {
  MockStorage() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i6.Future<E> save(E? item) =>
      (super.noSuchMethod(Invocation.method(#save, [item]),
          returnValue: Future<E>.value(null)) as _i6.Future<E>);
  @override
  _i6.Future<E?> get() => (super.noSuchMethod(Invocation.method(#get, []),
      returnValue: Future<E?>.value(null)) as _i6.Future<E?>);
  @override
  _i6.Future<void> delete() =>
      (super.noSuchMethod(Invocation.method(#delete, []),
          returnValue: Future<void>.value(null),
          returnValueForMissingStub: Future.value()) as _i6.Future<void>);
}