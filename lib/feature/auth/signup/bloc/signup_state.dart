import 'package:equatable/equatable.dart';

abstract class SignupState extends Equatable {
  @override
  List<Object> get props => [Object()];

  @override
  String toString() {
    return this.runtimeType.toString();
  }
}

abstract class AwaitUserInput extends SignupState {
  final String username;

  AwaitUserInput(this.username);
}

class AwaitUsernameInput extends AwaitUserInput {
  AwaitUsernameInput(String username) : super(username);
}

class AwaitPasswordInput extends AwaitUserInput {
  AwaitPasswordInput(String username) : super(username);
}

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
