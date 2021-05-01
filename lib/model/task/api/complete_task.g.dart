// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'complete_task.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CompleteTask _$CompleteTaskFromJson(Map<String, dynamic> json) {
  return CompleteTask(
    json['id'] as String,
    json['title'] as String,
    json['description'] as String,
    _$enumDecode(_$TaskStatusEnumMap, json['taskStatus']),
  );
}

Map<String, dynamic> _$CompleteTaskToJson(CompleteTask instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'taskStatus': _$TaskStatusEnumMap[instance.taskStatus],
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
