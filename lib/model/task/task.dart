import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_template/model/task/task_status.dart';
import 'package:flutter_template/util/check_result.dart';
import 'package:json_annotation/json_annotation.dart';

part 'task.g.dart';

/// A task as part of a TO-DO list.
@JsonSerializable()
@immutable
class Task extends Equatable {
  final String id;
  final String title;
  final String description;
  final TaskStatus taskStatus;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.taskStatus,
  });

  factory Task.fromJson(Map<String, dynamic> json) => _$TaskFromJson(json);

  Map<String, dynamic> toJson() => _$TaskToJson(this);

  Task copy({
    String? title,
    String? description,
    TaskStatus? taskStatus,
  }) =>
      Task(
        id: this.id,
        title: title ?? this.title,
        description: description ?? this.description,
        taskStatus: taskStatus ?? this.taskStatus,
      );

  @checkResult
  Task changeStatus(TaskStatus newTaskStatus) {
    return new Task(
      id: id,
      title: title,
      description: description,
      taskStatus: newTaskStatus,
    );
  }

  @override
  List<Object?> get props => [id];

  @override
  String toString() {
    return 'Task{'
        'id: $id, '
        'title: $title, '
        'description: $description, '
        'taskStatus: $taskStatus'
        '}';
  }
}
