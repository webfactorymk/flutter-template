import 'package:chopper/chopper.dart';
import 'package:flutter_template/model/user/credentials.dart';
import 'package:flutter_template/model/user/user_credentials.dart';
import 'package:flutter_template/network/chopper/authenticator/authenticator_helper_jwt.dart';
import 'package:flutter_template/network/util/http_util.dart';
import 'package:single_item_storage/storage.dart';

/// [RequestInterceptor] that adds authorization header on each request.
class AuthInterceptor implements RequestInterceptor {
  final Storage<UserCredentials> _userStore;
  final AuthenticatorHelperJwt _authenticator;

  AuthInterceptor(this._userStore, this._authenticator);

  @override
  Future<Request> onRequest(Request request) async {
    final Credentials? credentials = (await _userStore.get())?.credentials;
    if (credentials != null) {
      String? newTokenMaybe = await _authenticator.refreshIfTokenExpired(
        credentials: credentials,
        onError: (_) => null,
      );
      return applyHeader(
        request,
        authHeaderKey,
        authHeaderValue(newTokenMaybe ?? credentials.token),
        override: true,
      );
    } else {
      return request;
    }
  }
}
