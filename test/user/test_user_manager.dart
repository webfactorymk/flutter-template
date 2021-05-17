import 'package:flutter_template/model/user/user_credentials.dart';
import 'package:flutter_template/network/user_api_service.dart';
import 'package:flutter_template/user/user_event_hook.dart';
import 'package:flutter_template/user/user_manager.dart';
import 'package:single_item_storage/observed_storage.dart';

class TestUserManager extends UserManager {
  TestUserManager(
    UserApiService apiService,
    ObservedStorage<UserCredentials> userStore, {
    Iterable<UserEventHook<UserCredentials>> userEventHooks = const [],
  }) : super(
          apiService,
          userStore,
          userEventHooks: userEventHooks,
        );

  @override
  Future<bool> isLoggedIn() => getLoggedInUser()
      .then((userCredentials) => userCredentials?.credentials != null);
}
