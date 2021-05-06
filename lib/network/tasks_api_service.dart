export 'chopper/converters/response_to_type_converter.dart';

import 'package:chopper/chopper.dart';
import 'package:flutter_template/model/task/api/complete_task.dart';
import 'package:flutter_template/model/task/api/create_task.dart';
import 'package:flutter_template/model/task/api/create_task_group.dart';
import 'package:flutter_template/model/task/api/reopen_task.dart';
import 'package:flutter_template/model/task/task.dart';
import 'package:flutter_template/model/task/task_group.dart';

part 'tasks_api_service.chopper.dart';

/// Tasks api service.
///
/// To obtain an instance use `serviceLocator.get<TasksApiService>()`
@ChopperApi()
abstract class TasksApiService extends ChopperService {

  static create([ChopperClient? client]) => _$TasksApiService(client);

  /// Get all task groups for the logged in user.
  @Get(path: '/task-groups')
  Future<Response<List<TaskGroup>>> getTaskGroups();

  /// Find a task group by id.
  @Get(path: '/task-groups/{id}')
  Future<Response<TaskGroup>> getTaskGroup(@Path('id') String id);

  /// Find a task by id.
  @Get(path: '/task/{id}')
  Future<Response<Task>> getTask(@Path('id') String taskId);

  /// Opens a previously "completed" task.
  @Put(path: '/task/{id}')
  Future<Response> reopenTask(@Path('id') String id, @Body() ReopenTask body);

  /// Mark a task as done.
  @Put(path: '/task/{id}')
  Future<Response> completeTask(@Path('id') String id, @Body() CompleteTask ct);

  /// Creates a new [Task].
  @Post(path: '/task')
  Future<Response<Task>> createTask(@Body() CreateTask createTask);

  /// Creates a new [TaskGroup].
  @Post(path: '/task-groups')
  Future<Response<TaskGroup>> createTaskGroup(@Body() CreateTaskGroup ctg);

  /// Deletes all tasks.
  @Delete(path: '/task')
  Future<Response> deleteAllTasks();

  /// Deletes all task groups.
  @Delete(path: '/task-groups')
  Future<Response> deleteAllTaskGroups();
}
