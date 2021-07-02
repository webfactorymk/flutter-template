import 'package:flutter_template/data/data_not_found_exception.dart';
import 'package:flutter_template/data/repository/tasks/tasks_data_source.dart';
import 'package:flutter_template/model/task/task.dart';
import 'package:flutter_template/model/task/task_group.dart';

/// Stub implementation of [TasksDataSource].
class TasksStubDataSource implements TasksDataSource {
  @override
  String get userId => 'userId';

  @override
  Future<void> completeTask(String taskId) => Future.value();

  @override
  Future<void> reopenTask(String taskId) => Future.value();

  @override
  Future<Task> createTask(Task createTask) => Future.value(createTask);

  @override
  Future<TaskGroup> createTaskGroup(TaskGroup ctg) => Future.value(ctg);

  @override
  Future<void> deleteAllTaskGroups() => Future.value(createTask);

  @override
  Future<Map<TaskGroup, List<Task>>> getAllTasksGrouped() =>
      Future.error(DataNotFoundException());

  @override
  Future<Task> getTask(String taskId) => Future.error(DataNotFoundException());

  @override
  Future<List<TaskGroup>> getTaskGroups() =>
      Future.error(DataNotFoundException());

  @override
  Future<List<Task>> getTasks(String taskGroupId) =>
      Future.error(DataNotFoundException());

  @override
  Future<void> deleteAllData() => Future.value();

  @override
  Future<TaskGroup> updateTaskGroup(TaskGroup taskGroup) => Future.value();
}
