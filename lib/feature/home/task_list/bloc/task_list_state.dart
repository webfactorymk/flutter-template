import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_template/model/task/task.dart';
import 'package:flutter_template/model/task/task_group.dart';

@immutable
abstract class TaskListState extends Equatable {
  @override
  List<Object> get props => [];

  @override
  String toString() {
    return this.runtimeType.toString();
  }
}

/// The task list is being loaded
class TasksLoadInProgress extends TaskListState {}

/// The tasks are successfully loaded
class TasksLoadSuccess extends TaskListState {
  final Map<TaskGroup, List<Task>> tasksGrouped;
  final taskCount;

  TasksLoadSuccess(this.tasksGrouped)
      : taskCount = tasksGrouped.values.fold<int>(
            0, (previousValue, element) => previousValue + element.length);

  @override
  String toString() {
    return 'TasksLoadSuccess{tasksCount: $taskCount}';
  }
}

/// There was an error when loading the tasks
class TasksLoadFailure extends TaskListState {
  final dynamic error;

  TasksLoadFailure({this.error});

  @override
  String toString() {
    return 'TaskLoadFailure {error: $error}';
  }
}

/// A task operation failed
class TaskOpFailure extends TaskListState {
  final TaskListState prevState;
  final Task task;
  final dynamic error;

  TaskOpFailure(this.prevState, this.task, this.error);
}
