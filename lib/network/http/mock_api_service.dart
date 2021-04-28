import 'dart:async';

import 'package:flutter_template/model/user/credentials.dart';
import 'package:flutter_template/model/user/refresh_token.dart';
import 'package:flutter_template/model/user/user.dart';
import 'package:flutter_template/network/api_service.dart';
import 'package:http/http.dart' as http;

const String mockToken =
    "eyJhbGciOiJIUzI1NiJ9.eyJJc3N1ZXIiOiJJc3N1ZXIiLCJVc2VybmFtZSI6IkphdmFJblVzZSIsImV4cCI6MTcxNDIyMDYwMSwiaWF0IjoxNjE5NTI2MjAxfQ.yjTgXqiqGH3F-ycq2I3Ec-v3l0mzVV8Rg_RijsR50do";

/// A mock implementation of [ApiService].
class MockApiService implements ApiService {
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
    return Future.value(User(
        id: "1",
        email: "user@email.com",
        firstName: "First",
        lastName: "Last",
        dateOfBirth: DateTime.now()));
  }

  @override
  Future<Credentials> login(String username, String password) {
    return Future.value(Credentials(
        mockToken,
        RefreshToken(mockToken,
            DateTime.now().add(Duration(days: 1500)).millisecondsSinceEpoch)));
  }

  @override
  Future<http.Response> logout() {
    return Future.value(http.Response("", 200));
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
