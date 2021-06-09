import 'package:equatable/equatable.dart';

abstract class SignupState extends Equatable {
  @override
  List<Object> get props => [Object()];

  @override
  String toString() {
    return this.runtimeType.toString();
  }
}

class AwaitUsernameInput extends SignupState {}

class AwaitPasswordInput extends SignupState {}

class SignupInProgress extends SignupState {}

class SignupSuccess extends SignupState {}

class SignupFailure extends SignupState {
  final dynamic error;

  SignupFailure({this.error});

  @override
  String toString() {
    return 'SignUpFailure {error: $error}';
  }
}
