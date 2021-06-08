import 'package:bloc/bloc.dart';
import 'package:flutter_template/log/log.dart';
import 'package:flutter_template/user/user_manager.dart';

import 'login_state.dart';

export 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final UserManager userManager;

  LoginCubit(this.userManager) : super(AwaitUserInput());

  Future<void> onUserLogin(String username, String password) async {
    Log.d('LoginCubit - User login: username $username');
    emit(LoginInProgress());

    try {
      await userManager.login(username, password);
      emit(LoginSuccess());
    } catch (exp) {
      emit(LoginFailure(error: exp));
    }
  }
}
