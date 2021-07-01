import 'package:chopper/chopper.dart';
import 'package:flutter_template/model/task/api/create_task.dart';
import 'package:flutter_template/model/task/api/create_task_group.dart';
import 'package:flutter_template/model/task/task.dart';
import 'package:flutter_template/model/task/task_group.dart';

part 'chopper_tasks_api_service.chopper.dart';

/// Tasks api service.
///
/// To obtain an instance use `serviceLocator.get<TasksApiService>()`
@ChopperApi()
abstract class ChopperTasksApiService extends ChopperService {
  static create([ChopperClient? client]) => _$ChopperTasksApiService(client);

  /// Get all task groups for the logged in user.
  @Get(path: '/task-groups')
  Future<Response<List<TaskGroup>>> getTaskGroups();

  /// Find a task group by id.
  @Get(path: '/task-groups/{id}')
  Future<Response<TaskGroup>> getTaskGroup(@Path('id') String id);

  /// Find a task by id.
  @Get(path: '/tasks/{id}')
  Future<Response<Task>> getTask(@Path('id') String taskId);

  /// Find all tasks belonging to a task group.
  @Get(path: '/task-groups/{id}/tasks')
  Future<Response<List<Task>>> getTasks(@Path('id') String taskGroupId);

  /// Opens a previously "completed" task.
  @Put(path: '/tasks/{id}', optionalBody: true)
  Future<Response> reopenTask(@Path('id') String id);

  /// Mark a task as done.
  @Put(path: '/tasks/{id}', optionalBody: true)
  Future<Response> completeTask(@Path('id') String id);

  /// Creates a new [Task].
  @Post(path: '/tasks')
  Future<Response<Task>> createTask(@Body() CreateTask createTask);

  /// Creates a new [TaskGroup].
  @Post(path: '/task-groups')
  Future<Response<TaskGroup>> createTaskGroup(@Body() CreateTaskGroup ctg);

  /// Update a [TaskGroup].
  @Post(path: '/task-groups/update')
  Future<Response<TaskGroup>> updateTaskGroup(@Body() TaskGroup tg);

  /// Deletes all tasks.
  @Delete(path: '/tasks')
  Future<Response> deleteAllTasks();

  /// Deletes all task groups.
  @Delete(path: '/task-groups')
  Future<Response> deleteAllTaskGroups();
}
