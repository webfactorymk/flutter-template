import 'package:flutter_template/model/user/credentials.dart';
import 'package:flutter_template/model/user/refresh_token.dart';
import 'package:flutter_template/model/user/user.dart';
import 'package:flutter_template/network/user_api_service.dart';

const String mockToken =
    'eyJhbGciOiJIUzI1NiJ9.eyJJc3N1ZXIiOiJJc3N1ZXIiLCJVc2VybmFtZSI6IkphdmFJb'
    'lVzZSIsImV4cCI6MTcxNDIyMDYwMSwiaWF0IjoxNjE5NTI2MjAxfQ.yjTgXqiqGH3F-ycq'
    '2I3Ec-v3l0mzVV8Rg_RijsR50do';

class MockUserApiService implements UserApiService {
  Future<void> signUp(User user) => Future.delayed(Duration(seconds: 2));

  Future<Credentials> login(String username, String password) => Future.delayed(
      Duration(seconds: 2),
      () => Credentials(
          mockToken,
          RefreshToken(
              mockToken,
              DateTime.now()
                  .add(Duration(days: 1500))
                  .millisecondsSinceEpoch)));

  @override
  Future<User> getUserProfile({String? authHeader}) => Future.value(User(
      id: "1",
      email: "user@email.com",
      firstName: "First",
      lastName: "Last",
      dateOfBirth: DateTime.now()));

  @override
  Future<void> addNotificationsToken(String token) => Future.value();

  @override
  Future<void> deactivate() => Future.value();

  @override
  Future<void> logout() => Future.value();

  @override
  Future<void> resetPassword(String email) => Future.value();

  @override
  Future<User> updateUserProfile(User user) => Future.value(user);
}
