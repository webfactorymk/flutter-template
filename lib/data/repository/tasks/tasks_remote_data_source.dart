import 'package:flutter_template/model/task/api/create_task.dart';
import 'package:flutter_template/model/task/api/create_task_group.dart';
import 'package:flutter_template/model/task/task.dart';
import 'package:flutter_template/model/task/task_group.dart';
import 'package:flutter_template/network/tasks_api_service.dart';

import 'tasks_data_source.dart';

/// Implementation of [TasksRepository] that uses [ApiService] to contact a remote server.
class TasksRemoteDataSource implements TasksDataSource {
  final TasksApiService _apiService;

  @override
  final String userId;

  TasksRemoteDataSource(this.userId, this._apiService);

  @override
  Future<void> completeTask(String taskId) => _apiService.completeTask(taskId);

  @override
  Future<void> reopenTask(String taskId) => _apiService.reopenTask(taskId);

  @override
  Future<List<TaskGroup>> getTaskGroups() => _apiService.getTaskGroups();

  @override
  Future<Task> getTask(String taskId) => _apiService.getTask(taskId);

  @override
  Future<List<Task>> getTasks(String taskGroupId) =>
      _apiService.getTasks(taskGroupId);

  @override
  Future<Map<TaskGroup, List<Task>>> getAllTasksGrouped() {
    return getTaskGroups()
        .asStream()
        .expand((taskGroups) => taskGroups)
        .asyncMap((taskGroup) {
      return getTasks(taskGroup.id)
          .asStream()
          .map((taskListForGroup) => new MapEntry(taskGroup, taskListForGroup))
          .first;
    }).fold<Map<TaskGroup, List<Task>>>(new Map<TaskGroup, List<Task>>(),
            (resultMap, entry) {
      resultMap.putIfAbsent(entry.key, () => entry.value);
      return resultMap;
    });
  }

  @override
  Future<Task> createTask(Task createTask) =>
      _apiService.createTask(CreateTask.fromTask(createTask));

  @override
  Future<TaskGroup> createTaskGroup(TaskGroup ctg) =>
      _apiService.createTaskGroup(CreateTaskGroup.fromTaskGroup(ctg));

  @override
  Future<void> deleteAllTaskGroups() => _apiService.deleteAllTaskGroups();

  @override
  Future<void> deleteAllData() {
    throw UnsupportedError('Only cached data can be cleared');
  }

  @override
  Future<TaskGroup> updateTaskGroup(final TaskGroup taskGroup) =>
      _apiService.updateTaskGroup(taskGroup);
}
