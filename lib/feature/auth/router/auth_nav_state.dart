import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

@immutable
abstract class AuthNavState extends Equatable {
  const AuthNavState._(this.prevState);

  const factory AuthNavState.login() = LoginNavState;

  const factory AuthNavState.signupUsername(AuthNavState prevState) =
      SignupUsernameNavState;

  const factory AuthNavState.signupPassword(AuthNavState prevState) =
      SignupPasswordNavState;

  final AuthNavState? prevState;

  @override
  List<Object?> get props => [];

  @override
  String toString() {
    return this.runtimeType.toString() + '(prevState: $prevState)';
  }
}

@immutable
class LoginNavState extends AuthNavState {
  const LoginNavState() : super._(null);
}

@immutable
class SignupUsernameNavState extends AuthNavState {
  const SignupUsernameNavState(AuthNavState prevState) : super._(prevState);
}

@immutable
class SignupPasswordNavState extends AuthNavState {
  const SignupPasswordNavState(AuthNavState prevState) : super._(prevState);
}
