import 'package:flutter_template/model/user/credentials.dart';

abstract class AuthApiService {

  /// Refresh token.
  Future<Credentials> refreshToken(String refreshToken);
}