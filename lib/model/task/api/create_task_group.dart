import 'package:flutter/foundation.dart';
import 'package:flutter_template/model/task/task_group.dart';
import 'package:json_annotation/json_annotation.dart';

part 'create_task_group.g.dart';

@JsonSerializable()
@immutable
class CreateTaskGroup {
  final String name;
  final List<String> taskIds;

  CreateTaskGroup({required this.name, required this.taskIds});

  CreateTaskGroup.fromTaskGroup(TaskGroup taskGroup)
      : this.name = taskGroup.name,
        this.taskIds = taskGroup.taskIds;

  factory CreateTaskGroup.fromJson(Map<String, dynamic> json) =>
      _$CreateTaskGroupFromJson(json);

  Map<String, dynamic> toJson() => _$CreateTaskGroupToJson(this);

  @override
  String toString() {
    return 'CreateTaskGroup{name: $name, taskIds: $taskIds}';
  }
}
