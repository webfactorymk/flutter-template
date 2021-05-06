import 'package:flutter_template/config/firebase_config.dart';
import 'package:flutter_template/config/flavor_config.dart';
import 'package:flutter_template/model/user/user_credentials.dart';
import 'package:flutter_template/network/chopper/authenticator/authenticator_helper_jwt.dart';
import 'package:flutter_template/network/chopper/http_api_service_provider.dart';
import 'package:flutter_template/network/tasks_api_service.dart';
import 'package:flutter_template/network/user_api_service.dart';
import 'package:flutter_template/network/user_auth_api_service.dart';
import 'package:flutter_template/notifications/firebase_user_updates_hook.dart';
import 'package:flutter_template/platform_comm/platform_comm.dart';
import 'package:flutter_template/user/user_hooks.dart';
import 'package:flutter_template/user/user_manager.dart';
import 'package:flutter_template/util/app_lifecycle_observer.dart';
import 'package:get_it/get_it.dart';
import 'package:package_info/package_info.dart';
import 'package:single_item_shared_prefs/single_item_shared_prefs.dart';
import 'package:single_item_storage/cached_storage.dart';
import 'package:single_item_storage/observed_storage.dart';
import 'package:single_item_storage/storage.dart';

final GetIt serviceLocator = GetIt.asNewInstance();

/// Sets up the app component's dependencies.
///
/// This method is called before the app launches, suspending any further
/// execution until it finishes. To minimize the app loading time keep this
/// setup fast and simple.
Future<void> setupDependencies() async {
  // Data

  final ObservedStorage<UserCredentials> userStorage =
      ObservedStorage<UserCredentials>(CachedStorage(SharedPrefsStorage(
    itemKey: 'model.user.user-credentials',
    fromMap: (map) => UserCredentials.fromJson(map),
    toMap: (user) => user.toJson(),
  )));

  // Network

  // final RequestInterceptorJwt requestInterceptorJwt = RequestInterceptorJwt();
  // final ResponseInterceptorAuth responseInterceptorAuth =
  //     ResponseInterceptorAuth();
  // final ResponseInterceptorAppVersion responseInterceptorAppVersion =
  //     ResponseInterceptorAppVersion();
  // final LanguageRequestInterceptor languageRequestInterceptor =
  //     LanguageRequestInterceptor();
  // final RequestInterceptorAppVersion appVersionRequestInterceptor =
  //     RequestInterceptorAppVersion(await PackageInfo.fromPlatform());
  // final DataConverter dataConverter = JsonDataConverter();
  //
  // // Authenticator (refresh token)
  // final AuthenticatorApiService authService =
  //     HttpAuthenticatorApi(baseUrlApi, Client(), dataConverter);
  // final AuthenticatorJwt authenticator =
  //     AuthenticatorJwt(authService); //set user mgr
  // final ErrorHandler errorHandler = ErrorHandler();
  //
  // final UnauthorizedUserHandler unauthorizedUserHandler =
  // UnauthorizedUserHandlerImpl(userManager);
  // responseInterceptorAuth.unauthorizedUserHandler = unauthorizedUserHandler;
  // errorHandler.unauthorizedUserHandler = unauthorizedUserHandler;
  //
  // final Client httpClient = HttpClient(Client(), authenticator, errorHandler)
  //   ..addInterceptor(requestInterceptorJwt)
  //   ..addInterceptor(languageRequestInterceptor)
  //   ..addInterceptor(appVersionRequestInterceptor)
  //   ..addResponseInterceptor(responseInterceptorAuth)
  //   ..addResponseInterceptor(responseInterceptorAppVersion);

  final String baseUrlApi = FlavorConfig.values.baseUrlApi;

  HttpApiServiceProvider apiProvider = HttpApiServiceProvider(
    baseUrl: baseUrlApi,
    userStore: userStorage,
    packageInfo: await PackageInfo.fromPlatform(),
  );

  final AuthenticatorHelperJwt authHelperJwt = apiProvider.getAuthHelperJwt();
  UserApiService userApi = apiProvider.getUserApiService();
  final UserAuthApiService userAuthApi = apiProvider.getUserAuthApiService();
  final TasksApiService tasksApi = apiProvider.getTasksApiService();

  if (FlavorConfig.isMock()) {
    userApi = apiProvider.getMockUserApiService();
  }

  // Firebase
  final UserUpdatesHook<UserCredentials> firebaseUserHook =
      shouldConfigureFirebase()
          ? FirebaseUserHook()
          : StubHook<UserCredentials>();

  // Notifications
  //todo notifications manager, init handlers, mem leaks
  // final NotificationsManager notificationsManager = NotificationsManager(
  //   apiService,
  //   firebaseTokenStorage,
  // );

  // User Manager
  final UserManager userManager = UserManager(
    userApi,
    userStorage,
    updateHooks: [firebaseUserHook],
  );

  // Platform comm
  final PlatformComm platformComm = PlatformComm.generalAppChannel()
    ..listenToNativeLogs();

  // UI
  final AppLifecycleObserver appLifecycleObserver = AppLifecycleObserver();

  serviceLocator
    //..registerSingleton<TasksRepository>(tasksRepository)
    // ..registerSingleton<NotificationsManager>(notificationsManager)
    ..registerSingleton<Storage<UserCredentials>>(userStorage)
    ..registerSingleton<AuthenticatorHelperJwt>(authHelperJwt)
    ..registerSingleton<UserApiService>(userApi)
    ..registerSingleton<UserAuthApiService>(userAuthApi)
    ..registerSingleton<TasksApiService>(tasksApi)
    ..registerSingleton<UserManager>(userManager)
    ..registerSingleton<PlatformComm>(platformComm)
    ..registerSingleton<AppLifecycleObserver>(appLifecycleObserver);
}

//todo find a way to know when the app ends and call this
void teardown() async {
  try {
    await serviceLocator.get<UserManager>().teardown();
  } catch (exp) {}
}
