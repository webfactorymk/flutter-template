import 'package:flutter/material.dart';
import 'package:flutter_template/model/task/api/create_task.dart';
import 'package:flutter_template/model/task/api/create_task_group.dart';
import 'package:flutter_template/model/task/task.dart';
import 'package:flutter_template/model/task/task_group.dart';
import 'package:flutter_template/network/tasks_api_service.dart';

import 'tasks_dummy_data.dart';

class MockTasksApiService implements TasksApiService {
  @override
  Future<void> completeTask(String id) =>
      Future.delayed(Duration(milliseconds: 100));

  @override
  Future<void> reopenTask(String id) =>
      Future.delayed(Duration(milliseconds: 100));

  @override
  Future<Task> createTask(CreateTask createTask) => Future.delayed(
      Duration(seconds: 1),
      () => Task(
            id: DateTime.now().toString(),
            title: createTask.title,
            description: createTask.description,
            status: createTask.taskStatus,
          ));

  @override
  Future<TaskGroup> createTaskGroup(CreateTaskGroup ctg) =>
      Future.value(TaskGroup(
        DateTime.now().toString(),
        ctg.name,
        ctg.taskIds,
      ));

  @override
  Future<void> deleteAllTaskGroups() => Future.value();

  @override
  Future<void> deleteAllTasks() => Future.value();

  @override
  Future<Task> getTask(String taskId) {
    throw UnimplementedError();
  }

  @override
  Future<TaskGroup> getTaskGroup(String id) {
    throw UnimplementedError();
  }

  @override
  Future<List<TaskGroup>> getTaskGroups() async {
    return DUMMY_TASK_GROUPS;
  }

  @override
  Future<List<Task>> getTasks(String taskGroupId) async {
    final taskIdsFromGroup = DUMMY_TASK_GROUPS
        .firstWhere((taskGroup) => taskGroup.id == taskGroupId)
        .taskIds;
    return DUMMY_TASKS
        .where((task) => taskIdsFromGroup.contains(task.id))
        .toList();
  }

  @override
  Future<TaskGroup> updateTaskGroup(TaskGroup taskGroup) =>
      Future.value(taskGroup);
}
