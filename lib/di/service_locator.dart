import 'package:connectivity/connectivity.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter_template/config/firebase_config.dart';
import 'package:flutter_template/config/flavor_config.dart';
import 'package:flutter_template/data/mock/mock_tasks_api_service.dart';
import 'package:flutter_template/data/mock/mock_user_api_service.dart';
import 'package:flutter_template/di/user_scope_hook.dart';
import 'package:flutter_template/feature/settings/preferences_helper.dart';
import 'package:flutter_template/model/user/user_credentials.dart';
import 'package:flutter_template/network/chopper/authenticator/authenticator_helper_jwt.dart';
import 'package:flutter_template/network/chopper/http_api_service_provider.dart';
import 'package:flutter_template/network/tasks_api_service.dart';
import 'package:flutter_template/network/user_api_service.dart';
import 'package:flutter_template/network/user_auth_api_service.dart';
import 'package:flutter_template/network/util/network_utils.dart';
import 'package:flutter_template/notifications/data/data_notification_consumer.dart';
import 'package:flutter_template/notifications/data/data_notification_consumer_factory.dart';
import 'package:flutter_template/notifications/fcm/firebase_user_hook.dart';
import 'package:flutter_template/notifications/fcm/fcm_notifications_listener.dart';
import 'package:flutter_template/notifications/local/local_notification_manager.dart';
import 'package:flutter_template/platform_comm/platform_comm.dart';
import 'package:flutter_template/user/user_event_hook.dart';
import 'package:flutter_template/user/user_manager.dart';
import 'package:flutter_template/util/app_lifecycle_observer.dart';
import 'package:get_it/get_it.dart';
import 'package:package_info/package_info.dart';
import 'package:single_item_secure_storage/single_item_secure_storage.dart';
import 'package:single_item_shared_prefs/single_item_shared_prefs.dart';
import 'package:single_item_storage/cached_storage.dart';
import 'package:single_item_storage/observed_storage.dart';
import 'package:single_item_storage/storage.dart';

final GetIt serviceLocator = GetIt.asNewInstance();

// Storage constants
const String preferredLocalizationKey = 'preferred-language';
const String preferredThemeModeKey = 'preferred-theme-mode';

// Build Version
const String buildVersionKey = 'build-version-key';

/// Sets up the app global (baseScope) component's dependencies.
///
/// This method is called before the app launches, suspending any further
/// execution until it finishes. To minimize the app loading time keep this
/// setup fast and simple.
Future<void> setupGlobalDependencies() async {
  // Data
  final ObservedStorage<UserCredentials> userStorage =
      ObservedStorage<UserCredentials>(CachedStorage(SecureStorage(
    itemKey: 'model.user.user-credentials',
    fromMap: (map) => UserCredentials.fromJson(map),
    toMap: (user) => user.toJson(),
    iosOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
  )));

  // Network
  final NetworkUtils networkUtils = NetworkUtils(Connectivity());
  final String baseUrlApi = FlavorConfig.values.baseUrlApi;

  HttpApiServiceProvider apiProvider = HttpApiServiceProvider(
    baseUrl: baseUrlApi,
    userStore: userStorage,
    packageInfo: await PackageInfo.fromPlatform(),
  );

  final AuthenticatorHelperJwt authHelperJwt = apiProvider.getAuthHelperJwt();
  UserApiService userApi = apiProvider.getUserApiService();
  final UserAuthApiService userAuthApi = apiProvider.getUserAuthApiService();
  TasksApiService tasksApi = apiProvider.getTasksApiService();

  if (FlavorConfig.isMock()) {
    userApi = MockUserApiService();
    tasksApi = MockTasksApiService();
  }

  // Notifications

  //// DataNotificationManager
  final dataNotificationConsumer = DataNotificationConsumerFactory.create();

  //// Local
  final localNotificationsManager = LocalNotificationsManager.create();

  //// Data Notification Handlers
  DataNotificationConsumerFactory.registerNewMessageHandlers(
    dataNotificationConsumer,
    localNotificationsManager,
    PlatformComm.generalAppChannel(), //maybe not use general
  );

  //// FCM
  final fcmNotificationsListener = FcmNotificationsListener(
    dataNotificationConsumer: dataNotificationConsumer,
    localNotificationsManager: localNotificationsManager,
    showInForeground: true,
    fcm: SharedPrefsStorage<String>.primitive(itemKey: fcmTokenKey),
    userApiService: userApi,
  );

  final firebaseUserHook = shouldConfigureFirebase()
      ? FirebaseUserHook(FirebaseCrashlytics.instance, fcmNotificationsListener)
      : StubUserEventHook<UserCredentials>();

  // User Manager
  final UserScopeHook userScopeHook = UserScopeHook();
  final UserManager userManager = UserManager(
    userApi,
    userStorage,
    userEventHooks: [
      firebaseUserHook,
      userScopeHook,
    ],
  );

  // Platform comm
  final PlatformComm platformComm = PlatformComm.generalAppChannel()
    ..listenToNativeLogs();

  // UI
  final AppLifecycleObserver appLifecycleObserver = AppLifecycleObserver();

  // Preferences
  final PreferencesHelper preferences = PreferencesHelper();

  // Build version
  final PackageInfo packageInfo = await PackageInfo.fromPlatform();
  final String buildVersion =
      'Build version ${packageInfo.version} (${packageInfo.buildNumber})';

  serviceLocator
    ..registerSingleton<LocalNotificationsManager>(localNotificationsManager)
    ..registerSingleton<DataNotificationConsumer>(dataNotificationConsumer)
    ..registerSingleton<FcmNotificationsListener>(fcmNotificationsListener)
    ..registerSingleton<Storage<UserCredentials>>(userStorage)
    ..registerSingleton<AuthenticatorHelperJwt>(authHelperJwt)
    ..registerSingleton<UserApiService>(userApi)
    ..registerSingleton<UserAuthApiService>(userAuthApi)
    ..registerSingleton<TasksApiService>(tasksApi)
    ..registerSingleton<UserManager>(userManager)
    ..registerSingleton<AppLifecycleObserver>(appLifecycleObserver)
    ..registerSingleton<PlatformComm>(platformComm)
    ..registerSingleton<NetworkUtils>(networkUtils)
    ..registerSingleton<PreferencesHelper>(preferences)
    ..registerSingleton<String>(buildVersion, instanceName: buildVersionKey)
    ..registerLazySingleton<Storage<String>>(
        () => SharedPrefsStorage<String>.primitive(
            itemKey: preferredLocalizationKey),
        instanceName: preferredLocalizationKey)
    ..registerLazySingleton<Storage<bool>>(
        () =>
            SharedPrefsStorage<bool>.primitive(itemKey: preferredThemeModeKey),
        instanceName: preferredThemeModeKey);
}

Future<void> teardown() async {
  try {
    await serviceLocator.get<UserManager>().teardown();
  } catch (exp) {}
}
