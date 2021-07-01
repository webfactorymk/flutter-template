import 'package:equatable/equatable.dart';
import 'package:flutter_template/model/task/task.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'task_group.g.dart';

/// Collection of grouped [Task]s.
@JsonSerializable()
@immutable
class TaskGroup extends Equatable {
  final String id;
  final String name;
  final List<String> taskIds;

  const TaskGroup(this.id, this.name, this.taskIds);

  factory TaskGroup.fromJson(Map<String, dynamic> json) =>
      _$TaskGroupFromJson(json);

  Map<String, dynamic> toJson() => _$TaskGroupToJson(this);

  TaskGroup copy({String? id, String? name, List<String>? newTaskIds}) {
    return TaskGroup(
        id ?? this.id, name ?? this.name, newTaskIds ?? this.taskIds);
  }

  @override
  List<Object?> get props => [id, name, taskIds];

  @override
  String toString() {
    return 'TaskGroup{id: $id, name: $name, taskIds: $taskIds}';
  }
}
