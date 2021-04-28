import 'package:bloc/bloc.dart';
import 'package:flutter_template/log/logger.dart';
import 'package:flutter_template/model/user/user.dart';
import 'package:flutter_template/network/api_service.dart';
import 'package:flutter_template/user/user_manager.dart';

import 'signup_state.dart';

class SignUpCubit extends Cubit<SignUpState> {
  final ApiService apiService;
  final UserManager userManager;

  SignUpCubit(this.apiService, this.userManager) : super(SignUpInitial());

  Future<void> onUserSigUp(String email, String password) async {
    Logger.d('SignUpCubit - User sign up: email $email');
    emit(SignUpInProgress());
    final User user = User(id: "id", email: email);

    await apiService
        .signUp(user)
        .then((_) => userManager.login(email, password));
    emit(SignUpSuccess());
  }
}
