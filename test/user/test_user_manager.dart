import 'package:flutter_template/model/user/user_credentials.dart';
import 'package:flutter_template/user/user_hooks.dart';
import 'package:flutter_template/user/user_manager.dart';

class TestUserManager extends UserManager {
  TestUserManager(
    apiService,
    userStore, {
    Iterable<LoginHook<UserCredentials>> loginHooks = const [],
    Iterable<LogoutHook> logoutHooks = const [],
    Iterable<UserUpdatesHook<UserCredentials>> updateHooks = const [],
  }) : super(
          apiService,
          userStore,
          loginHooks: loginHooks,
          logoutHooks: logoutHooks,
        );

  @override
  Future<bool> isLoggedIn() => getLoggedInUser()
      .then((userCredentials) => userCredentials?.credentials != null);
}
