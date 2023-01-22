// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chopper_user_auth_api_service.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// ignore_for_file: always_put_control_body_on_new_line, always_specify_types, prefer_const_declarations, unnecessary_brace_in_string_interps
class _$ChopperUserAuthApiService extends ChopperUserAuthApiService {
  _$ChopperUserAuthApiService([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final definitionType = ChopperUserAuthApiService;

  @override
  Future<Response<Credentials>> refreshToken(String refreshToken) {
    final $url = '/user/refresh-token';
    final $body = refreshToken;
    final $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<Credentials, Credentials>($request);
  }
}
