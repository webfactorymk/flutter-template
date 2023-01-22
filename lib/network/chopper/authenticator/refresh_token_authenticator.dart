import 'dart:async';

import 'package:chopper/chopper.dart';
import 'package:flutter_template/network/chopper/authenticator/authenticator_helper_jwt.dart';

class RefreshTokenAuthenticator implements Authenticator {
  final AuthenticatorHelperJwt _authenticator;

  RefreshTokenAuthenticator(this._authenticator);

  @override
  FutureOr<Request?> authenticate(Request request, Response<dynamic> response,
      [Request? originalRequest]) {
    return _authenticator
        .interceptResponse(request, response)
        .catchError((_) => null);
  }
}
