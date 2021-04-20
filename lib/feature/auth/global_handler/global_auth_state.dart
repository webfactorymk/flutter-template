import 'package:equatable/equatable.dart';

abstract class GlobalAuthState extends Equatable {
  @override
  List<Object> get props => [];
}

class AuthenticationInProgress extends GlobalAuthState {}

class AuthenticationSuccess extends GlobalAuthState {}

class AuthenticationFailure extends GlobalAuthState {
  final bool sessionExpired;

  AuthenticationFailure({this.sessionExpired = false});

  @override
  String toString() {
    return 'AuthenticationFailure{sessionExpired: $sessionExpired}';
  }
}
