// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_task.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateTask _$CreateTaskFromJson(Map<String, dynamic> json) => CreateTask(
      title: json['title'] as String,
      description: json['description'] as String? ?? "",
      taskStatus: $enumDecode(_$TaskStatusEnumMap, json['status']),
    );

Map<String, dynamic> _$CreateTaskToJson(CreateTask instance) =>
    <String, dynamic>{
      'title': instance.title,
      'description': instance.description,
      'status': _$TaskStatusEnumMap[instance.taskStatus]!,
    };

const _$TaskStatusEnumMap = {
  TaskStatus.notDone: 0,
  TaskStatus.done: 1,
};
