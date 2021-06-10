import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

@immutable
abstract class AuthNavState extends Equatable {
  const AuthNavState._();

  const factory AuthNavState.login() = LoginNavState;

  const factory AuthNavState.signupUsername() = SignupUsernameNavState;

  const factory AuthNavState.signupPassword() = SignupPasswordNavState;

  @override
  List<Object?> get props => [];

  @override
  String toString() {
    return this.runtimeType.toString();
  }
}

@immutable
class LoginNavState extends AuthNavState {
  const LoginNavState() : super._();
}

@immutable
class SignupUsernameNavState extends AuthNavState {
  const SignupUsernameNavState() : super._();
}

@immutable
class SignupPasswordNavState extends AuthNavState {
  const SignupPasswordNavState() : super._();
}
