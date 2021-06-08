import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

@immutable
abstract class AuthNavState extends Equatable {
  const AuthNavState._();

  const factory AuthNavState.loginUsername() = LoginUsernameNavState;

  const factory AuthNavState.loginPassword() = LoginUsernameNavState;

  const factory AuthNavState.signup() = SignupNavState;

  @override
  List<Object?> get props => [];

  @override
  String toString() {
    return this.runtimeType.toString();
  }
}

@immutable
class LoginUsernameNavState extends AuthNavState {
  const LoginUsernameNavState() : super._();
}

@immutable
class LoginPasswordNavState extends AuthNavState {
  const LoginPasswordNavState() : super._();
}

@immutable
class SignupNavState extends AuthNavState {
  const SignupNavState() : super._();
}
