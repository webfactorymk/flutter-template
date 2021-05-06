import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_template/model/task/task.dart';
import 'package:json_annotation/json_annotation.dart';

part 'task_group.g.dart';

/// Collection of grouped [Task]s.
@JsonSerializable()
@immutable
class TaskGroup extends Equatable {
  final String id;
  final String name;
  final List<String> taskIds;

  TaskGroup(this.id, this.name, this.taskIds);

  factory TaskGroup.fromJson(Map<String, dynamic> json) => _$TaskGroupFromJson(json);

  Map<String, dynamic> toJson() => _$TaskGroupToJson(this);

  @override
  List<Object?> get props => [id];

  @override
  String toString() {
    return 'TaskGroup{id: $id, name: $name, taskIds: $taskIds}';
  }
}
