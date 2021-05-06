import 'package:flutter/foundation.dart';
import 'package:flutter_template/model/task/task.dart';
import 'package:flutter_template/model/task/task_status.dart';
import 'package:json_annotation/json_annotation.dart';

part 'reopen_task.g.dart';

@JsonSerializable()
@immutable
class ReopenTask extends Task {
  ReopenTask(
    String id,
    String title,
    String description,
    TaskStatus taskStatus,
  ) : super(
            id: id,
            title: title,
            description: description,
            taskStatus: taskStatus);

  factory ReopenTask.fromTask(Task task) =>
      ReopenTask(task.id, task.title, task.description, TaskStatus.done);

  factory ReopenTask.fromJson(Map<String, dynamic> json) =>
      _$ReopenTaskFromJson(json);

  Map<String, dynamic> toJson() => _$ReopenTaskToJson(this);

  @override
  String toString() {
    return 'ReopenTask{'
        'id: $id, '
        'title: $title, '
        'description: $description, '
        'taskStatus: $taskStatus'
        '}';
  }
}
