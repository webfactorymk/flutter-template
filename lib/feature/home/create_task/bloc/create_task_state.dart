import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

@immutable
abstract class CreateTaskState extends Equatable {
  @override
  List<Object> get props => [];

  @override
  String toString() {
    return this.runtimeType.toString();
  }
}

/// The initial state / awaiting user input
class AwaitUserInput extends CreateTaskState {}

/// The task is being created
class CreateTaskInProgress extends CreateTaskState {}

/// The task is successfully created
class CreateTaskSuccess extends CreateTaskState {}

/// There was an error when creating the task
class CreateTaskFailure extends CreateTaskState {
  final dynamic error;

  CreateTaskFailure({this.error});

  @override
  String toString() {
    return 'CreateTaskFailure {error: $error}';
  }
}
