import 'package:flutter_template/network/errors/unauthorized_user_exception.dart';
import 'package:flutter_template/user/user_manager.dart';

class UnauthorizedUserHandlerImpl implements UnauthorizedUserHandler {
  final UserManager _userManager;

  UnauthorizedUserHandlerImpl(this._userManager);

  @override
  void onUnauthorizedUserEvent() {
    _userManager.updateCredentials(null);
    // global_auth_bloc will pick up this change and navigate to login screen
  }
}
