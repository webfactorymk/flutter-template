
import 'package:flutter_template/log/logger.dart';
import 'package:flutter_template/model/user/credentials.dart';
import 'package:flutter_template/model/user/refresh_token.dart';
import 'package:flutter_template/network/auth_api_service.dart';
import 'package:flutter_template/network/errors/unauthorized_user_exception.dart';
import 'package:flutter_template/network/http/http_client.dart';
import 'package:flutter_template/network/http/http_exception_code.dart';
import 'package:flutter_template/network/network_util.dart';
import 'package:flutter_template/user/user_manager.dart';
import 'package:http/http.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:synchronized/synchronized.dart';

/// Detects 401 response code and attempts to re-authenticate the user.
///
/// If the user is unauthorized this component will only throw
/// `UnauthorizedUserException` without any additional handling.
class AuthenticatorJwt {
  static Lock _lock = Lock();

  final AuthApiService _apiService;
  late final UserManager _userManager;

  AuthenticatorJwt(this._apiService);

  set userManager(UserManager value) {
    _userManager = value;
  }

  /// Checks if the token is expired using the expiry token data
  /// and refreshes it if necessary.
  ///
  /// Use this to manually check and refresh the token.
  /// If the user is unauthorized you have to manually handle the case.
  ///
  /// Returns true if the token was refreshed, false otherwise.
  /// Throws error if the token is expired or doesn't exist and the
  /// refresh failed.
  /// Will return `UnauthorizedUserException` only when we're sure the
  /// refresh token is expired, otherwise it's different exception.
  /// If `onErrorReturn` is provided, the exception is not thrown and
  /// is replaced with the `onErrorReturn` result.
  Future<bool> refreshIfTokenExpired({bool onErrorReturn = false}) {
    Logger.d('Authenticator (manual) - Manual token check');
    return _lock.synchronized(() async {
      Logger.d('Authenticator (manual) - lock');

      // Get current token
      final Credentials? currentUser = (await _userManager.getLoggedInUser())?.credentials;
      final String? tokenCurrent = currentUser?.token;

      // Throw if a token does not exist
      if (tokenCurrent == null) {
        Logger.e('Authenticator (manual) - Token does not exist');
        throw Exception('Token does not exist');
      }

      // Check if token is expired
      bool isTokenExpired = JwtDecoder.isExpired(tokenCurrent);
      if (isTokenExpired) {
        Logger.d('Authenticator (manual) - Token expired');

        // Check if refresh token is expired
        _ensureRefreshTokenNotExpired(currentUser?.refreshToken);

        // Refresh the token
        Logger.d('Authenticator (manual) - Refreshing token...');
        final newCredentials = await _refreshToken(currentUser!.refreshToken);

        // Token refresh success. Save new token, update interceptor.
        Logger.d('Authenticator (manual) - Updating old token');
        await _userManager.updateCredentials(newCredentials);

        return true;
      } else {
        Logger.d('Authenticator (manual) - Token is not expired');
        return false;
      }
    }, timeout: Duration(seconds: 30)).catchError((_) => onErrorReturn,
        test: (error) {
      Logger.e('Authenticator (manual) - Exception thrown: $error');
      return onErrorReturn != null;
    }).whenComplete(() {
      Logger.d('Authenticator (manual) - lock released');
    });
  }

  /// Intercepts a network response and if status code is 401 refreshes the token.
  Future<StreamedResponse> interceptResponse({
    required StreamedResponse response,
    required Future<StreamedResponse> retryFn(),
  }) async {
    // Handle only 401 unauthorized requests
    if (response.statusCode != 401) {
      return response;
    }
    Logger.d('Authenticator (response) - '
        'Handling 401 unauthorized request: ${response.request?.url}');

    // Check current token
    final String? tokenUsed =
        response.request?.headers[authHeaderKey]?.substring('Bearer '.length);
    if (tokenUsed == null) {
      throw UnauthorizedUserException('Request w/o token - '
          'response reason: ${response.reasonPhrase} \n'
          'request: ${response.request} \n');
    }

    await _lock.synchronized(
      () async {
        Logger.d('Authenticator (response) - lock');

        // Check if a newer token exists than our current one
        final Credentials? currentUser = (await _userManager.getLoggedInUser())?.credentials;
        final String? tokenCurrent = currentUser?.token;
        if (tokenCurrent == null) {
          Logger.e('Authenticator (response) - User logged out!');
          throw UnauthorizedUserException('User logged out!');
        }
        if (tokenCurrent != null && tokenCurrent != tokenUsed) {
          Logger.d('Authenticator (response) - Refreshed token exists'
              '\nnewToken: $tokenCurrent'
              '\nusedToken: $tokenUsed');
          return; //retryFn called after lock
        }

        // Check if refresh token is expired
        _ensureRefreshTokenNotExpired(currentUser?.refreshToken);

        // Refresh the token
        Logger.d('Authenticator (response) - Refreshing token...');
        final newCredentials = await _refreshToken(currentUser!.refreshToken);

        // Token refresh success. Save new token, update interceptor.
        Logger.d(
            'Authenticator (response) - Token refresh success; updating old token');
        await _userManager.updateCredentials(newCredentials);

        Logger.d('Authenticator (response) - releasing lock');
      },
      timeout: Duration(seconds: 30),
    ).catchError((_) {}, test: (error) {
      Logger.e('Authenticator (response) - Exception thrown: $error');
      return false;
    }); //lock end
    Logger.d('Authenticator (response) - lock released');

    // Retry the request
    return await retryFn();
  }

  /// Intercepts a network request before it's sent and refreshes the token if expired.
  Future<void> interceptRequest(Request request) async {
    // Check used token, if any
    final String? tokenUsed =
        request.headers[authHeaderKey]?.substring('Bearer '.length);
    if (tokenUsed == null) {
      Logger.d('Authenticator (request) - Info: Request w/o token: $request');
      return;
    }

    // Check if token is expired
    bool isTokenExpired = JwtDecoder.isExpired(tokenUsed);
    if (!isTokenExpired) {
      return;
    }

    Logger.d(
        'Authenticator (request) - Token expired. Pending renewal. ${request.url}');

    await _lock.synchronized(
      () async {
        Logger.d('Authenticator (request) - lock');

        // Check if a newer token exists (tokenCurrent) than our used one (tokenUsed)
        final Credentials? currentUser =
            (await _userManager.getLoggedInUser())?.credentials;
        final String? tokenCurrent = currentUser?.token;
        if (tokenCurrent == null) {
          Logger.e('Authenticator (request) - User logged out!');
          throw UnauthorizedUserException('User logged out!');
        }
        if (tokenCurrent != null && tokenCurrent != tokenUsed) {
          Logger.d('Authenticator (request) - Refreshed token exists'
              '\nnewToken: $tokenCurrent'
              '\nusedToken: $tokenUsed');
          Logger.d('Authenticator (request) - Swapping old token');
          _replaceAuthorizationHeader(request, tokenCurrent);
          return request;
        }

        // Check if refresh token is expired
        _ensureRefreshTokenNotExpired(currentUser?.refreshToken);

        // Refresh the token
        Logger.d('Authenticator (request) - Refreshing token...');
        final newCredentials = await _refreshToken(currentUser!.refreshToken);

        Logger.d('Authenticator (request) - Token refresh success');
        await _userManager.updateCredentials(newCredentials);

        Logger.d('Authenticator (request) - Swapping old token');
        _replaceAuthorizationHeader(request, newCredentials.token);

        Logger.d('Authenticator (request) - releasing lock');
      },
      timeout: Duration(seconds: TIMEOUT),
    ).catchError((_) {}, test: (error) {
      Logger.e('Authenticator (request) - Exception thrown: $error');
      return false;
    }).whenComplete(() {
      Logger.d('Authenticator (request) - lock released');
    });
  }

  void _ensureRefreshTokenNotExpired(RefreshToken? refreshToken) {
    final int now = DateTime.now().millisecondsSinceEpoch;
    if (refreshToken == null || refreshToken.expiresAt < now) {
      Logger.d('Authenticator (n/a) - Refresh token is expired!');
      throw UnauthorizedUserException('Refresh token expired! '
          '(token expiry time: ${refreshToken?.expiresAt}, '
          '(now: $now)');
    }
  }

  Future<Credentials> _refreshToken(RefreshToken refreshToken) async {
    final Credentials? newCredentials = await _apiService
        .refreshToken(refreshToken.token)
        .timeout(Duration(seconds: TIMEOUT))
        .catchError(
      (_) => Future.value(null as Credentials),
      test: (error) {
        // Errors getting result, even negative, will be propagated.
        // This is to prevent unnecessarily logging out the user (app offline, etc.)
        Logger.e('Authenticator (n/a) - Refresh token failed: $error');
        return error is UnauthorizedUserException ||
            (error is HttpExceptionCode &&
                (error.statusCode ?? 0) >= 400 &&
                (error.statusCode ?? 0) < 500);
      },
    );

    // Token refresh refused
    if (newCredentials == null) {
      Logger.e('Authenticator (n/a) - Unsuccessful token refresh');
      throw UnauthorizedUserException('Refresh token refused');
    }

    return newCredentials;
  }

  void _replaceAuthorizationHeader(Request request, String newToken) {
    if (request.headers.containsKey(authHeaderKey)) {
      request.headers[authHeaderKey] = authHeaderValue(newToken);
    }
  }
}
