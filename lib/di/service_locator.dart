import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter_template/config/firebase_config.dart';
import 'package:flutter_template/config/flavor_config.dart';
import 'package:flutter_template/data/mock/mock_user_api_service.dart';
import 'package:flutter_template/di/user_scope_hook.dart';
import 'package:flutter_template/model/user/user_credentials.dart';
import 'package:flutter_template/network/chopper/authenticator/authenticator_helper_jwt.dart';
import 'package:flutter_template/network/chopper/http_api_service_provider.dart';
import 'package:flutter_template/network/tasks_api_service.dart';
import 'package:flutter_template/network/user_api_service.dart';
import 'package:flutter_template/network/user_auth_api_service.dart';
import 'package:flutter_template/notifications/firebase_user_hook.dart';
import 'package:flutter_template/notifications/notifications_manager.dart';
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
Future<void> setupGlobalDependencies() async {
  // Data

  final ObservedStorage<UserCredentials> userStorage =
      ObservedStorage<UserCredentials>(CachedStorage(SharedPrefsStorage(
    itemKey: 'model.user.user-credentials',
    fromMap: (map) => UserCredentials.fromJson(map),
    toMap: (user) => user.toJson(),
  )));

  // Network

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
    userApi = MockUserApiService();
  }

  // Firebase and Notifications
  final NotificationsManager notificationsManager = NotificationsManager();
  final firebaseUserHook = shouldConfigureFirebase()
      ? FirebaseUserHook(FirebaseCrashlytics.instance, notificationsManager)
      : StubHook<UserCredentials>();

  // User Manager
  final UserScopeHook userScopeHook = UserScopeHook();
  final UserManager userManager = UserManager(
    userApi,
    userStorage,
    loginHooks: [userScopeHook],
    updateHooks: [firebaseUserHook as UserUpdatesHook<UserCredentials>],
    logoutHooks: [
      firebaseUserHook as LogoutHook,
      userScopeHook,
    ],
  );

  // Platform comm
  final PlatformComm platformComm = PlatformComm.generalAppChannel()
    ..listenToNativeLogs();

  // UI
  final AppLifecycleObserver appLifecycleObserver = AppLifecycleObserver();

  serviceLocator
    ..registerSingleton<NotificationsManager>(notificationsManager)
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
