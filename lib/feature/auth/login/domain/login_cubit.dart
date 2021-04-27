import 'package:bloc/bloc.dart';
import 'package:flutter_template/log/logger.dart';
import 'package:flutter_template/user/user_manager.dart';

import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final UserManager userManager;

  LoginCubit(this.userManager) : super(LoginInitial());

  Future<void> onUserLogin(String username, String password) async {
    Logger.d('LoginCubit - User login: username $username');
    emit(LoginInProgress());

   // await userManager.login(username, password);
    emit(LoginSuccess());
  }
}
