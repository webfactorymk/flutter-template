export 'chopper/converters/response_to_type_converter.dart';

import 'package:chopper/chopper.dart';
import 'package:flutter_template/model/user/credentials.dart';

part 'user_auth_api_service.chopper.dart';

/// User re-authentication api service.
///
/// To obtain an instance use `serviceLocator.get<UserAuthApiService>()`
@ChopperApi()
abstract class UserAuthApiService extends ChopperService {

  static create([ChopperClient? client]) => _$UserAuthApiService(client);

  /// Refresh token.
  @Post(path: '/user/refresh-token')
  Future<Response<Credentials>> refreshToken(@Body() String refreshToken);
}
