import 'package:bloc/bloc.dart';
import 'package:flutter_template/log/log.dart';
import 'package:flutter_template/model/user/user.dart';
import 'package:flutter_template/network/user_api_service.dart';
import 'package:flutter_template/user/user_manager.dart';

import 'signup_state.dart';

export 'signup_state.dart';

class SignupCubit extends Cubit<SignupState> {
  final UserApiService apiService;
  final UserManager userManager;

  String? _username;
  String? _password;

  SignupCubit(this.apiService, this.userManager) : super(AwaitUsernameInput());

  Future<void> onUsernameEntered(String username) async {
    Log.d('SignUpCubit - User sign up: username $username');
    _username = username;
    emit(AwaitPasswordInput());
  }

  Future<void> onPasswordEntered(String password) async {
    Log.d('SignUpCubit - User sign up: username $_username');
    _password = password;
  }

  Future<void> onUserSignup() async {
    Log.d('SignUpCubit - User sign up: username $_username');
    emit(SignupInProgress());
    final User user = User(id: "id", email: _username!);

    await apiService
        .signUp(user)
        .then((_) => userManager.login(_username!, _password!));
    emit(SignupSuccess());
  }
}
