import 'package:flutter_template/data/repository/tasks/tasks_cache_data_source.dart';
import 'package:flutter_template/data/repository/tasks/tasks_remote_data_source.dart';
import 'package:flutter_template/model/task/api/create_task.dart';
import 'package:flutter_template/model/task/api/create_task_group.dart';
import 'package:flutter_template/model/task/task.dart';
import 'package:flutter_template/model/task/task_group.dart';
import 'package:flutter_template/network/tasks_api_service.dart';
import 'package:flutter_test/flutter_test.dart';

import 'tasks_data_source_base_test.dart';

void main() {
  executeTasksDataSourceBaseTests(() => new TasksRemoteDataSource(
        'userId',
        MockApiService(TasksCacheDataSource('userId')),
      ));
}

class MockApiService implements TasksApiService {
  final TasksCacheDataSource _cacheDataSource;

  MockApiService(this._cacheDataSource);

  @override
  Future<void> completeTask(String taskId) =>
      _cacheDataSource.completeTask(taskId);

  @override
  Future<void> reopenTask(String taskId) => _cacheDataSource.reopenTask(taskId);

  @override
  Future<Task> createTask(CreateTask createTask) =>
      _cacheDataSource.createTask(Task(
        id: 'task-' + createTask.title.substring(createTask.title.length - 1),
        title: createTask.title,
        description: createTask.description,
        status: createTask.taskStatus,
      ));

  @override
  Future<TaskGroup> createTaskGroup(CreateTaskGroup ctg) =>
      _cacheDataSource.createTaskGroup(TaskGroup(
          "task-group-" +
              ctg.name.substring(ctg.name.length - 1, ctg.name.length),
          ctg.name,
          ctg.taskIds));

  @override
  Future<void> deleteAllTaskGroups() => _cacheDataSource.deleteAllTaskGroups();

  @override
  Future<Task> getTask(String taskId) => _cacheDataSource.getTask(taskId);

  @override
  Future<TaskGroup> getTaskGroup(String id) => _cacheDataSource
      .getTaskGroups()
      .asStream()
      .expand((taskGroups) => taskGroups)
      .where((taskGroup) => taskGroup.id == id)
      .first;

  @override
  Future<List<TaskGroup>> getTaskGroups() => _cacheDataSource.getTaskGroups();

  @override
  Future<List<Task>> getTasks(String taskGroupId) =>
      _cacheDataSource.getTasks(taskGroupId);

  @override
  Future<void> deleteAllTasks() {
    throw UnimplementedError();
  }

  @override
  Future<TaskGroup> updateTaskGroup(TaskGroup taskGroup) {
    throw UnimplementedError();
  }
}
