import 'package:flutter_template/model/user/credentials.dart';
import 'package:flutter_template/model/user/user.dart';
import 'package:flutter_template/model/user/user_credentials.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../network/network_test_helper.dart';

void main() {
  final Credentials validCredentials = Credentials(
      NetworkTestHelper.validToken, NetworkTestHelper.validRefreshToken);
  final Credentials expiredTokenCredentials = Credentials(
      NetworkTestHelper.expiredToken, NetworkTestHelper.validRefreshToken);
  final Credentials expiredRefreshTokenCredentials = Credentials(
      NetworkTestHelper.validToken, NetworkTestHelper.expiredRefreshToken);
  final Credentials expiredCredentials = Credentials(
      NetworkTestHelper.expiredToken, NetworkTestHelper.expiredRefreshToken);
  final User user = User(id: 'id', email: 'test@example.com');

  late UserCredentials? userCredentials;

  setUp(() {});

  group('UserCredentials.isLoggedIn()', () {
    test('Valid credentials', () async {
      // arrange
      userCredentials = UserCredentials(user, validCredentials);

      // assert
      expect(userCredentials.isLoggedIn(), true);
    });

    test('Invalid credentials', () async {
      // arrange
      userCredentials = UserCredentials(user, null);

      // assert
      expect(userCredentials.isLoggedIn(), false);
    });

    test('On null instance', () async {
      // arrange
      userCredentials = null;

      // assert
      expect(userCredentials.isLoggedIn(), false);
    });

    test('Login, logout', () async {
      // arrange
      userCredentials = null;

      // assert
      expect(userCredentials.isLoggedIn(), false);

      // arrange
      userCredentials = UserCredentials(user, validCredentials);

      // assert
      expect(userCredentials.isLoggedIn(), true);

      // arrange
      userCredentials = UserCredentials(user, null);

      // assert
      expect(userCredentials.isLoggedIn(), false);
    });

    test('Token expired', () async {
      // arrange
      userCredentials = UserCredentials(user, expiredTokenCredentials);

      // assert
      expect(userCredentials.isLoggedIn(), true);
    });

    test('Refresh token expired', () async {
      // arrange
      userCredentials = UserCredentials(user, expiredRefreshTokenCredentials);

      // assert
      expect(userCredentials.isLoggedIn(), true);
    });

    test('Token and refresh token expired', () async {
      // arrange
      userCredentials = UserCredentials(user, expiredCredentials);

      // assert
      expect(userCredentials.isLoggedIn(), false);
    });
  });
}
