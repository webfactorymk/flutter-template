import 'package:chopper/chopper.dart';
import 'package:flutter_template/network/chopper/authenticator/authenticator_helper_jwt.dart';

/// [RequestInterceptor] that adds authorization header on each request.
class AuthInterceptor implements RequestInterceptor {
  final AuthenticatorHelperJwt _authenticator;

  AuthInterceptor(this._authenticator);

  @override
  Future<Request> onRequest(Request request) =>
      _authenticator.interceptRequest(request);
}
