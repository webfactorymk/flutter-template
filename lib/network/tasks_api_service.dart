import 'package:flutter_template/model/task/api/create_task.dart';
import 'package:flutter_template/model/task/api/create_task_group.dart';
import 'package:flutter_template/model/task/task.dart';
import 'package:flutter_template/model/task/task_group.dart';
import 'package:flutter_template/network/chopper/converters/response_to_type_converter.dart';
import 'package:flutter_template/network/chopper/generated/chopper_tasks_api_service.dart';

/// Tasks api service.
///
/// To obtain an instance use `serviceLocator.get<TasksApiService>()`
class TasksApiService {
  final ChopperTasksApiService _chopper;

  TasksApiService(this._chopper);

  /// Get all task groups for the logged in user.
  Future<List<TaskGroup>> getTaskGroups() => _chopper.getTaskGroups().toType();

  /// Find a task group by id.
  Future<TaskGroup> getTaskGroup(String id) =>
      _chopper.getTaskGroup(id).toType();

  /// Find a task by id.
  Future<Task> getTask(String taskId) => _chopper.getTask(taskId).toType();

  /// Find all tasks belonging to a task group.
  Future<List<Task>> getTasks(String taskGroupId) =>
      _chopper.getTasks(taskGroupId).toType();

  /// Opens a previously "completed" task.
  Future<void> reopenTask(String id) => _chopper.reopenTask(id).toType();

  /// Mark a task as done.
  Future<void> completeTask(String id) => _chopper.completeTask(id).toType();

  /// Creates a new [Task].
  Future<Task> createTask(CreateTask createTask) =>
      _chopper.createTask(createTask).toType();

  /// Creates a new [TaskGroup].
  Future<TaskGroup> createTaskGroup(CreateTaskGroup ctg) =>
      _chopper.createTaskGroup(ctg).toType();

  Future<TaskGroup> updateTaskGroup(TaskGroup taskGroup) =>
      _chopper.updateTaskGroup(taskGroup).toType();

  /// Deletes all tasks.
  Future<void> deleteAllTasks() => _chopper.deleteAllTasks().toType();

  /// Deletes all task groups.
  Future<void> deleteAllTaskGroups() => _chopper.deleteAllTaskGroups().toType();
}
