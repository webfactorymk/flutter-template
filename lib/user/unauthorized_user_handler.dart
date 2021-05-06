import 'package:flutter_template/model/user/user_credentials.dart';
import 'package:single_item_storage/storage.dart';

import 'unauthorized_user_exception.dart';

/// Handles [UnauthorizedUserException]s.
class UnauthorizedUserHandler {
  final Storage<UserCredentials> _userStore;

  UnauthorizedUserHandler(this._userStore);

  Future<void> onUnauthorizedUserEvent() => _userStore.delete();
// user_manager and then global_auth_bloc will pick up this change
// in user store and navigate to login screen
}
