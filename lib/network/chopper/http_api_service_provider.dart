import 'package:chopper/chopper.dart';
import 'package:flutter_template/feature/force_update/force_update_handler.dart';
import 'package:flutter_template/model/user/user_credentials.dart';
import 'package:flutter_template/network/chopper/authenticator/authenticator_helper_jwt.dart';
import 'package:flutter_template/network/chopper/generated/chopper_tasks_api_service.dart';
import 'package:flutter_template/network/chopper/generated/chopper_user_api_service.dart';
import 'package:flutter_template/network/chopper/generated/chopper_user_auth_api_service.dart';
import 'package:flutter_template/network/chopper/interceptors/error_interceptor.dart';
import 'package:flutter_template/network/tasks_api_service.dart';
import 'package:flutter_template/network/user_api_service.dart';
import 'package:flutter_template/network/user_auth_api_service.dart';
import 'package:flutter_template/user/unauthorized_user_handler.dart';
import 'package:http/http.dart' as http;
import 'package:package_info/package_info.dart';
import 'package:single_item_storage/storage.dart';
import 'package:single_item_storage/stub_storage.dart';

import 'authenticator/refresh_token_authenticator.dart';
import 'converters/json_type_converter_provider.dart';
import 'interceptors/auth_interceptor.dart';
import 'interceptors/http_logger_interceptor.dart';
import 'interceptors/language_interceptor.dart';
import 'interceptors/version_interceptor.dart';

/// Utility class for creating and configuring the API services.
class HttpApiServiceProvider {
  final ChopperClient _defaultClient;
  final ChopperClient _unauthorizedClient;
  final AuthenticatorHelperJwt _authenticatorHelper;

  factory HttpApiServiceProvider({
    required String baseUrl,
    required Storage<UserCredentials> userStore,
    http.Client? httpClient,
    Storage<String> localeStore = const StubStorage<String>(),
    PackageInfo? packageInfo,
    Converter? converter,
    UnauthorizedUserHandler? unauthorizedUserHandler,
    ForceUpdateHandler? forceUpdateHandler,
  }) {
    converter ??= JsonTypeConverterProvider.getDefault();
    unauthorizedUserHandler ??= UnauthorizedUserHandler(userStore);
    forceUpdateHandler ??= ForceUpdateHandler();

    ChopperClient unauthorizedClient = ChopperClient(
      baseUrl: baseUrl,
      client: httpClient,
      services: [
        ChopperUserAuthApiService.create(),
      ],
      converter: converter,
      errorConverter: JsonConverter(),
      interceptors: [
        // Request
        HeadersInterceptor({'Cache-Control': 'no-cache'}),
        VersionInterceptor(packageInfo),
        // Both
        HttpLoggerInterceptor(),
        // Response
        ErrorInterceptor(
          unauthorizedUserHandler,
          forceUpdateHandler,
        ),
      ],
    );

    AuthenticatorHelperJwt authenticatorHelper = AuthenticatorHelperJwt(
      UserAuthApiService(
        unauthorizedClient.getService<ChopperUserAuthApiService>(),
      ),
      userStore,
    );

    ChopperClient defaultClient = ChopperClient(
      baseUrl: baseUrl,
      client: httpClient,
      services: [
        ChopperUserApiService.create(),
        ChopperTasksApiService.create(),
      ],
      authenticator: RefreshTokenAuthenticator(authenticatorHelper),
      converter: converter,
      errorConverter: JsonConverter(),
      interceptors: [
        // Request
        HeadersInterceptor({'Cache-Control': 'no-cache'}),
        VersionInterceptor(packageInfo),
        LanguageInterceptor(localeStore),
        AuthInterceptor(authenticatorHelper),
        // Both
        HttpLoggerInterceptor(),
        // Response
        ErrorInterceptor(
          UnauthorizedUserHandler(userStore),
          ForceUpdateHandler(),
        ),
      ],
    );

    return HttpApiServiceProvider.withClients(
        defaultClient, unauthorizedClient, authenticatorHelper);
  }

  HttpApiServiceProvider.withClients(
    ChopperClient defaultClient,
    ChopperClient unauthorizedClient,
    this._authenticatorHelper,
  )   : _defaultClient = defaultClient,
        _unauthorizedClient = unauthorizedClient;

  /// Returns properly configured singleton UserAuthApiService.
  AuthenticatorHelperJwt getAuthHelperJwt() => _authenticatorHelper;

  /// Returns singleton UserAuthApiService.
  UserAuthApiService getUserAuthApiService() => UserAuthApiService(
      _unauthorizedClient.getService<ChopperUserAuthApiService>());

  /// Returns singleton UserApiService.
  UserApiService getUserApiService() =>
      UserApiService(_defaultClient.getService<ChopperUserApiService>());

  /// Returns singleton TasksApiService.
  TasksApiService getTasksApiService() =>
      TasksApiService(_defaultClient.getService<ChopperTasksApiService>());
}
