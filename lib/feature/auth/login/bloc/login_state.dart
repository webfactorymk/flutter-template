import 'package:equatable/equatable.dart';
import 'package:flutter_template/feature/auth/global_handler/global_auth_state.dart';

abstract class LoginState extends Equatable implements GlobalAuthState {
  @override
  List<Object> get props => [];
}

class LoginInitial extends LoginState {}

class LoginInProgress extends LoginState {}

class LoginSuccess extends LoginState {}

class LoginFailure extends LoginState {
  final dynamic error;

  LoginFailure({this.error});

  @override
  String toString() {
    return 'LoginFailure {error: $error}';
  }
}
