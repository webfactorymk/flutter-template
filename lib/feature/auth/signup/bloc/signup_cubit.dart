import 'package:bloc/bloc.dart';
import 'package:flutter_template/log/logger.dart';
import 'package:flutter_template/model/user/user.dart';
import 'package:flutter_template/network/user_api_service.dart';
import 'package:flutter_template/user/user_manager.dart';

import 'signup_state.dart';
export 'signup_state.dart';

class SignupCubit extends Cubit<SignupState> {
  final UserApiService apiService;
  final UserManager userManager;

  SignupCubit(this.apiService, this.userManager) : super(AwaitUserInput());

  Future<void> onUserSignup(String email, String password) async {
    Logger.d('SignUpCubit - User sign up: email $email');
    emit(SignupInProgress());
    final User user = User(id: "id", email: email);

    await apiService
        .signUp(user)
        .then((_) => userManager.login(email, password));
    emit(SignupSuccess());
  }
}
