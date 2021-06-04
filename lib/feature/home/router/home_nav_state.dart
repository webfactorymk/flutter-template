import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_template/model/task/task.dart';

@immutable
abstract class HomeNavState extends Equatable {
  const HomeNavState._();

  const factory HomeNavState.taskList() = TaskListNavState;

  const factory HomeNavState.taskDetail(Task task) = TaskDetailNavState;

  const factory HomeNavState.settings() = SettingsNavState;

  @override
  List<Object?> get props => [];

  @override
  String toString() {
    return this.runtimeType.toString();
  }
}

@immutable
class TaskListNavState extends HomeNavState {
  const TaskListNavState() : super._();
}

@immutable
class TaskDetailNavState extends HomeNavState {
  final Task task;

  const TaskDetailNavState(this.task) : super._();
}

@immutable
class SettingsNavState extends HomeNavState {
  const SettingsNavState() : super._();
}
