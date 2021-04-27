import 'package:equatable/equatable.dart';

abstract class LoginState extends Equatable {
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
    return 'LoginFailure{error: $error}';
  }
}
