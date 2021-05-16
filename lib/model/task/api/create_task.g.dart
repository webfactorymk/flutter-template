// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_task.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateTask _$CreateTaskFromJson(Map<String, dynamic> json) {
  return CreateTask(
    title: json['title'] as String,
    description: json['description'] as String?,
    taskStatus: _$enumDecode(_$TaskStatusEnumMap, json['status']),
  );
}

Map<String, dynamic> _$CreateTaskToJson(CreateTask instance) =>
    <String, dynamic>{
      'title': instance.title,
      'description': instance.description,
      'status': _$TaskStatusEnumMap[instance.taskStatus],
    };

K _$enumDecode<K, V>(
  Map<K, V> enumValues,
  Object? source, {
  K? unknownValue,
}) {
  if (source == null) {
    throw ArgumentError(
      'A value must be provided. Supported values: '
      '${enumValues.values.join(', ')}',
    );
  }

  return enumValues.entries.singleWhere(
    (e) => e.value == source,
    orElse: () {
      if (unknownValue == null) {
        throw ArgumentError(
          '`$source` is not one of the supported values: '
          '${enumValues.values.join(', ')}',
        );
      }
      return MapEntry(unknownValue, enumValues.values.first);
    },
  ).key;
}

const _$TaskStatusEnumMap = {
  TaskStatus.notDone: 0,
  TaskStatus.done: 1,
};
