import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_template/feature/auth/global_handler/global_auth_state.dart';
import 'package:flutter_template/log/logger.dart';
import 'package:flutter_template/model/user/user_credentials.dart';
import 'package:flutter_template/user/user_manager.dart';

/// Handles the global user authentication [state](AuthenticationState)
/// by monitoring user [updates].
class GlobalAuthCubit extends Cubit<GlobalAuthState> {
  final UserManager _userManager;
  StreamSubscription<UserCredentials?>? _userUpdatesSubscription;

  GlobalAuthCubit(this._userManager) : super(AuthenticationInProgress()) {
    Logger.d('GlobalAuthBloc - Subscribe to user updates');
    _userUpdatesSubscription = _userManager.updatesSticky.listen(
        (usrCredentials) => onUserAuthenticationUpdate(usrCredentials));
  }

  @visibleForTesting
  void onUserAuthenticationUpdate(UserCredentials? usrCredentials) {
    Logger.d('GlobalAuthBloc - Credentials update: $usrCredentials');
    if (usrCredentials.isLoggedIn()) {
      emit(AuthenticationSuccess());
    } else {
      emit(AuthenticationFailure(sessionExpired: usrCredentials?.user != null));
    }
  }

  @override
  Future<void> close() {
    Logger.d('GlobalAuthBloc - Unsubscribe from user updates');
    _userUpdatesSubscription?.cancel();
    return super.close();
  }
}
