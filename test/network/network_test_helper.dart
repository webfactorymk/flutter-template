import 'package:flutter_template/model/user/credentials.dart';
import 'package:flutter_template/model/user/refresh_token.dart';
import 'package:flutter_template/model/user/user.dart';
import 'package:flutter_template/model/user/user_credentials.dart';

class NetworkTestHelper {
  // Valid until 4th of May 2080.
  static final String validToken =
      'eyJhbGciOiJIUzI1NiJ9.eyJleHAiOjM0ODIwNTAzNzcsImlhdCI6MTYyMDEzMDM3N30.Hk3l8Ro7W8tLg8u5MJ2JToj7g67t8kgirtsu5ajhAL4';
  static final String expiredToken =
      'eyJhbGciOiJIUzI1NiJ9.eyJleHAiOjE1ODg1OTQzNzcsImlhdCI6MTU1Njk3MTk3N30.fkshAmwlsMGQ4jAFw4Axfoyl6VOcVntSB5XDfdDO9b0';

  static final RefreshToken validRefreshToken = RefreshToken(
      validToken,
      DateTime.now().millisecondsSinceEpoch * 5);

  static final RefreshToken expiredRefreshToken = RefreshToken(
      validToken,
      DateTime.now().subtract(Duration(days: 1)).millisecondsSinceEpoch);

  static final Credentials validCredentials =
      Credentials(validToken, validRefreshToken);
  static final Credentials expiredCredentials =
      Credentials(expiredToken, validRefreshToken);
  static final UserCredentials validUserCredentials =
      UserCredentials(User(id: 'username', email: 'email'), validCredentials);

  static final UserCredentials inValidUserCredentials =
      UserCredentials(User(id: 'username', email: 'email'), null);
  static final UserCredentials expiredUserCredentials =
      UserCredentials(User(id: 'username', email: 'email'), expiredCredentials);
}
