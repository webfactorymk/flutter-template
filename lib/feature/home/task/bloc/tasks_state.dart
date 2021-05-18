import 'package:equatable/equatable.dart';
import 'package:flutter_template/model/task/task.dart';

abstract class TasksState extends Equatable {
  @override
  List<Object> get props => [];
}

class TasksInitial extends TasksState {}

class TasksLoadInProgress extends TasksState {}

class TasksLoadSuccess extends TasksState {
  final List<Task> tasks;

  TasksLoadSuccess(this.tasks);
}

class TasksLoadFailure extends TasksState {
  final dynamic error;

  TasksLoadFailure({this.error});

  @override
  String toString() {
    return 'TaskLoadFailure {error: $error}';
  }
}
