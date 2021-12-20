import 'package:flutter_template/model/task/api/create_task.dart';
import 'package:flutter_template/model/task/api/create_task_group.dart';
import 'package:flutter_template/model/task/task.dart';
import 'package:flutter_template/model/task/task_group.dart';
import 'package:flutter_template/model/user/credentials.dart';
import 'package:flutter_template/model/user/user.dart';
import 'package:flutter_template/network/chopper/converters/json_type_converter.dart';
import 'package:flutter_template/network/chopper/converters/json_type_converter_builder.dart';

abstract class JsonTypeConverterProvider {
  static JsonTypeConverter? _instance;

  JsonTypeConverterProvider._();

  static getDefault() => _instance ??= JsonTypeConverterBuilder()
      .registerConverter<User>(
        toMap: (user) => user.toJson(),
        fromMap: (map) => User.fromJson(map),
      )
      .registerConverter<Credentials>(
        toMap: (credentials) => credentials.toJson(),
        fromMap: (map) => Credentials.fromJson(map),
      )
      .registerConverter<Task>(
        toMap: (task) => task.toJson(),
        fromMap: (map) => Task.fromJson(map),
      )
      .registerConverter<TaskGroup>(
        toMap: (taskGroup) => taskGroup.toJson(),
        fromMap: (map) => TaskGroup.fromJson(map),
      )
      .registerConverter<CreateTask>(
        toMap: (createTask) => createTask.toJson(),
        fromMap: (map) => CreateTask.fromJson(map),
      )
      .registerConverter<CreateTaskGroup>(
        toMap: (createTaskGroup) => createTaskGroup.toJson(),
        fromMap: (map) => CreateTaskGroup.fromJson(map),
      )
      .registerCustomConverter<DateTime>(
        toJsonElement: (dateTime) => dateTime.toIso8601String(),
        fromJsonElement: (dateTime) => DateTime.parse(dateTime),
      )
      .build();

//todo add more converters
//todo generate this class for each json serializable model
}
