import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_template/model/task/task.dart';

@immutable
abstract class CreateTaskEvent extends Equatable {
  @override
  List<Object> get props => [];

  @override
  String toString() {
    return this.runtimeType.toString();
  }
}

/// Request for a [Task] to be created.
class CreateTask extends CreateTaskEvent {
  final Task task;

  CreateTask({required this.task});
}
