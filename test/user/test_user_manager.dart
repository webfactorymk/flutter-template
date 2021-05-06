import 'package:flutter_template/model/user/user_credentials.dart';
import 'package:flutter_template/network/user_api_service.dart';
import 'package:flutter_template/user/user_hooks.dart';
import 'package:flutter_template/user/user_manager.dart';
import 'package:single_item_storage/observed_storage.dart';

class TestUserManager extends UserManager {
  TestUserManager(
    UserApiService apiService,
    ObservedStorage<UserCredentials> userStore, {
    Iterable<LoginHook<UserCredentials>> loginHooks = const [],
    Iterable<LogoutHook> logoutHooks = const [],
    Iterable<UserUpdatesHook<UserCredentials>> updateHooks = const [],
  }) : super(
          apiService,
          userStore,
          loginHooks: loginHooks,
          logoutHooks: logoutHooks,
          updateHooks: updateHooks,
        );

  @override
  Future<bool> isLoggedIn() => getLoggedInUser()
      .then((userCredentials) => userCredentials?.credentials != null);
}
