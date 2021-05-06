import 'package:flutter/foundation.dart';
import 'package:flutter_template/model/task/task.dart';
import 'package:flutter_template/model/task/task_status.dart';
import 'package:json_annotation/json_annotation.dart';

part 'complete_task.g.dart';

@JsonSerializable()
@immutable
class CompleteTask extends Task {
  CompleteTask(
    String id,
    String title,
    String description,
    TaskStatus taskStatus,
  ) : super(
            id: id,
            title: title,
            description: description,
            taskStatus: taskStatus);

  factory CompleteTask.fromTask(Task task) =>
      CompleteTask(task.id, task.title, task.description, TaskStatus.done);

  factory CompleteTask.fromJson(Map<String, dynamic> json) =>
      _$CompleteTaskFromJson(json);

  Map<String, dynamic> toJson() => _$CompleteTaskToJson(this);

  @override
  String toString() {
    return 'CompleteTask{'
        'id: $id, '
        'title: $title, '
        'description: $description, '
        'taskStatus: $taskStatus'
        '}';
  }
}
