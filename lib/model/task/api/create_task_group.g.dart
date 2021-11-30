// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_task_group.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateTaskGroup _$CreateTaskGroupFromJson(Map<String, dynamic> json) =>
    CreateTaskGroup(
      name: json['name'] as String,
      taskIds:
          (json['taskIds'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$CreateTaskGroupToJson(CreateTaskGroup instance) =>
    <String, dynamic>{
      'name': instance.name,
      'taskIds': instance.taskIds,
    };
