import 'package:flutter/foundation.dart';
import 'package:flutter_template/model/task/task.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:flutter_template/model/task/task_status.dart';

part 'create_task.g.dart';

@JsonSerializable()
@immutable
class CreateTask {
  final String title;
  final String? description;
  @JsonKey(name: 'status')
  final TaskStatus taskStatus;

  CreateTask(
      {required this.title, this.description = "", required this.taskStatus});

  CreateTask.fromTask(Task task)
      : this.title = task.title,
        this.description = task.description,
        this.taskStatus = task.status;

  factory CreateTask.fromJson(Map<String, dynamic> json) =>
      _$CreateTaskFromJson(json);

  Map<String, dynamic> toJson() => _$CreateTaskToJson(this);

  @override
  String toString() {
    return 'CreateTask{'
        'title: $title, '
        'description: $description, '
        'taskStatus: $taskStatus'
        '}';
  }
}
