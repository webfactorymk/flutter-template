import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_template/model/task/task.dart';
import 'package:flutter_template/model/task/task_status.dart';

@immutable
abstract class TaskEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

@immutable
class TaskStatusChangedEvent extends TaskEvent {
  final String taskId;
  final TaskStatus newTaskStatus;

  TaskStatusChangedEvent(this.taskId, this.newTaskStatus);

  @override
  List<Object?> get props => [taskId, newTaskStatus];

  @override
  String toString() {
    return 'TaskStatusChangedEvent{'
        'taskId: $taskId, '
        'newTaskStatus: $newTaskStatus'
        '}';
  }
}

@immutable
class TaskCreatedEvent extends TaskEvent {
  final Task newTask;

  TaskCreatedEvent(this.newTask);

  String get taskId => newTask.id;

  @override
  List<Object?> get props => [taskId];

  @override
  String toString() {
    return 'TaskCreatedEvent{newTask: $newTask}';
  }
}

@immutable
class TaskDeletedEvent extends TaskEvent {
  final String deletedTaskId;

  TaskDeletedEvent(this.deletedTaskId);

  @override
  List<Object?> get props => [deletedTaskId];

  @override
  String toString() {
    return 'TaskDeletedEvent{deletedTaskId: $deletedTaskId}';
  }
}

@immutable
class TasksUpdateEvent extends TaskEvent {
  final List<String> affectedTasks;

  TasksUpdateEvent({required Iterable<String> affectedTasks})
      : this.affectedTasks = affectedTasks.toList(growable: false);

  @override
  List<Object?> get props => [affectedTasks];

  @override
  String toString() {
    return 'TasksUpdateEvent{updatedTasksIds: $affectedTasks}';
  }
}

@immutable
class TaskErrorEvent implements Exception {
  final TaskEvent taskEvent;
  final Exception wrappedException;

  TaskErrorEvent(this.taskEvent, this.wrappedException);

  @override
  String toString() {
    return 'TaskErrorEvent{'
        'taskEvent: $taskEvent, '
        'wrappedException: $wrappedException'
        '}';
  }
}
