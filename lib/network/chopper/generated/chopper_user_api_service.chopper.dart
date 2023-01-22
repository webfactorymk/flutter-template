// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chopper_user_api_service.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// ignore_for_file: always_put_control_body_on_new_line, always_specify_types, prefer_const_declarations, unnecessary_brace_in_string_interps
class _$ChopperUserApiService extends ChopperUserApiService {
  _$ChopperUserApiService([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final definitionType = ChopperUserApiService;

  @override
  Future<Response<dynamic>> signUp(User user) {
    final $url = '/user/register';
    final $body = user;
    final $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<Credentials>> login(
    String username,
    String password,
  ) {
    final $url = '/user/login';
    final $body = <String, dynamic>{
      'username': username,
      'password': password,
    };
    final $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<Credentials, Credentials>(
      $request,
      requestConverter: FormUrlEncodedConverter.requestFactory,
    );
  }

  @override
  Future<Response<User>> getUserProfile({String? authHeader}) {
    final $url = '/user';
    final $headers = {
      if (authHeader != null) 'Authorization': authHeader,
    };

    final $request = Request(
      'GET',
      $url,
      client.baseUrl,
      headers: $headers,
    );
    return client.send<User, User>($request);
  }

  @override
  Future<Response<User>> updateUserProfile(User user) {
    final $url = '/user';
    final $body = user;
    final $request = Request(
      'PUT',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<User, User>($request);
  }

  @override
  Future<Response<void>> resetPassword(String email) {
    final $url = '/user/reset-password';
    final $body = email;
    final $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<void, void>($request);
  }

  @override
  Future<Response<dynamic>> addNotificationsToken(String token) {
    final $url = '/user/notifications-token';
    final $body = token;
    final $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<void>> logout() {
    final $url = '/user/logout';
    final $request = Request(
      'POST',
      $url,
      client.baseUrl,
    );
    return client.send<void, void>($request);
  }

  @override
  Future<Response<void>> deactivate() {
    final $url = '/user';
    final $request = Request(
      'DELETE',
      $url,
      client.baseUrl,
    );
    return client.send<void, void>($request);
  }
}
