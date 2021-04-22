import 'dart:async';

import 'package:flutter_template/model/user/credentials.dart';
import 'package:flutter_template/model/user/user.dart';
import 'package:flutter_template/network/api_service.dart';
import 'package:http/http.dart' as http;

/// A stub implementation of [ApiService].
class HttpApiServiceStub implements ApiService {
  @override
  Future<void> addNotificationsToken(String token) {
    // TODO: implement addNotificationsToken
    throw UnimplementedError();
  }

  @override
  Future<void> deactivate() {
    // TODO: implement deactivate
    throw UnimplementedError();
  }

  @override
  Future<User> getUserProfile({String? token}) {
    // TODO: implement getUserProfile
    throw UnimplementedError();
  }

  @override
  Future<Credentials> login(String username, String password) {
    // TODO: implement login
    throw UnimplementedError();
  }

  @override
  Future<http.Response> logout() {
    // TODO: implement logout
    throw UnimplementedError();
  }

  @override
  Future<http.Response> resetPassword(String email) {
    // TODO: implement resetPassword
    throw UnimplementedError();
  }

  @override
  Future<void> signUp(User user) {
    // TODO: implement signUp
    throw UnimplementedError();
  }

  @override
  Future<http.Response> updateUserProfile(User user) {
    // TODO: implement updateUserProfile
    throw UnimplementedError();
  }
}
