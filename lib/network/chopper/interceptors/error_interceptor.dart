import 'dart:async';

import 'package:chopper/chopper.dart';
import 'package:flutter_template/feature/force_update/force_update_exception.dart';
import 'package:flutter_template/feature/force_update/force_update_handler.dart';
import 'package:flutter_template/user/unauthorized_user_exception.dart';
import 'package:flutter_template/user/unauthorized_user_handler.dart';

/// [RequestInterceptor] that parses errors.
class ErrorInterceptor implements ResponseInterceptor {

  final UnauthorizedUserHandler _unauthorizedUserHandler;
  final ForceUpdateHandler _forceUpdateHandler;

  ErrorInterceptor(this._unauthorizedUserHandler, this._forceUpdateHandler);

  @override
  FutureOr<Response> onResponse(Response<dynamic> response) {

    // todo modify when implementing force update
    // if (response.statusCode == 412) {
    //   _forceUpdateHandler.onForceUpdateEvent();
    //   throw ForceUpdateException(response.base.reasonPhrase);
    // }

    // Unauthorized user after failed refresh token attempt
    if (response.statusCode == 401) {
      _unauthorizedUserHandler.onUnauthorizedUserEvent();
      throw UnauthorizedUserException(response.base.reasonPhrase);
    }

    return response;
  }
}
