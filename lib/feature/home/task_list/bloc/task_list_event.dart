import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_template/model/task/task.dart';
import 'package:flutter_template/model/task/task_group.dart';

@immutable
abstract class TaskListEvent extends Equatable {
  @override
  List<Object> get props => [];

  @override
  String toString() {
    return this.runtimeType.toString();
  }
}

/// Requests the tasks to be loaded. Can be used for refreshing the list.
class LoadTasks extends TaskListEvent {}

/// Requests for a [Task] to be marked as completed.
class TaskCompleted extends TaskListEvent {
  final Task task;

  TaskCompleted(this.task);
}

/// Requests for a [Task] to be marked as not done.
class TaskReopened extends TaskListEvent {
  final Task task;

  TaskReopened(this.task);
}

/// Requests for reordering the tasks.
class TasksReordered extends TaskListEvent {
  final TaskGroup key;
  final int oldIndex;
  final int newIndex;

  TasksReordered(this.key, this.oldIndex, this.newIndex);
}

/// Triggers a logout event.
class Logout extends TaskListEvent {}
