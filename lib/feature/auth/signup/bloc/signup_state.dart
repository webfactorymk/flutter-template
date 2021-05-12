import 'package:equatable/equatable.dart';

abstract class SignUpState extends Equatable {
  @override
  List<Object> get props => [];
}

class SignUpInitial extends SignUpState {}

class SignUpInProgress extends SignUpState {}

class SignUpSuccess extends SignUpState {}

class SignUpFailure extends SignUpState {
  final dynamic error;

  SignUpFailure({this.error});

  @override
  String toString() {
    return 'SignUpFailure {error: $error}';
  }
}
