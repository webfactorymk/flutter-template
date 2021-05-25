import 'package:flutter_template/model/task/api/create_task.dart';
import 'package:flutter_template/model/task/api/create_task_group.dart';
import 'package:flutter_template/model/task/task.dart';
import 'package:flutter_template/model/task/task_group.dart';
import 'package:flutter_template/network/tasks_api_service.dart';

import 'tasks_dummy_data.dart';

class MockTasksApiService implements TasksApiService {
  @override
  Future<void> completeTask(String id) {
    // TODO: implement completeTask
    throw UnimplementedError();
  }

  @override
  Future<Task> createTask(CreateTask createTask) {
    // TODO: implement createTask
    throw UnimplementedError();
  }

  @override
  Future<TaskGroup> createTaskGroup(CreateTaskGroup ctg) {
    // TODO: implement createTaskGroup
    throw UnimplementedError();
  }

  @override
  Future<void> deleteAllTaskGroups() {
    // TODO: implement deleteAllTaskGroups
    throw UnimplementedError();
  }

  @override
  Future<void> deleteAllTasks() {
    // TODO: implement deleteAllTasks
    throw UnimplementedError();
  }

  @override
  Future<Task> getTask(String taskId) {
    // TODO: implement getTask
    throw UnimplementedError();
  }

  @override
  Future<TaskGroup> getTaskGroup(String id) {
    // TODO: implement getTaskGroup
    throw UnimplementedError();
  }

  @override
  Future<List<TaskGroup>> getTaskGroups() async {
    return DUMMY_TASK_GROUPS;
  }

  @override
  Future<List<Task>> getTasks(String taskGroupId) async {
    return DUMMY_TASKS;
  }

  @override
  Future<void> reopenTask(String id) {
    // TODO: implement reopenTask
    throw UnimplementedError();
  }
}
