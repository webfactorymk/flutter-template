import 'package:chopper/chopper.dart';
import 'package:flutter_template/model/user/credentials.dart';

part 'chopper_user_auth_api_service.chopper.dart';

/// User re-authentication api service.
///
/// To obtain an instance use `serviceLocator.get<UserAuthApiService>()`
@ChopperApi()
abstract class ChopperUserAuthApiService extends ChopperService {

  static create([ChopperClient? client]) => _$ChopperUserAuthApiService(client);

  /// Refresh token.
  @Post(path: '/user/refresh-token')
  Future<Response<Credentials>> refreshToken(@Body() String refreshToken);
}
