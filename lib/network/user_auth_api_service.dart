import 'package:flutter_template/model/user/credentials.dart';
import 'package:flutter_template/network/chopper/converters/response_to_type_converter.dart';
import 'package:flutter_template/network/chopper/generated/chopper_user_auth_api_service.dart';

/// User re-authentication api service.
///
/// To obtain an instance use `serviceLocator.get<UserAuthApiService>()`
class UserAuthApiService {
  final ChopperUserAuthApiService _chopper;

  UserAuthApiService(this._chopper);

  /// Refresh token.
  Future<Credentials> refreshToken(String refreshToken) =>
      _chopper.refreshToken(refreshToken).toType();
}
