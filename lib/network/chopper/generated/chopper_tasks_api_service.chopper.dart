// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chopper_tasks_api_service.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// ignore_for_file: always_put_control_body_on_new_line, always_specify_types, prefer_const_declarations, unnecessary_brace_in_string_interps
class _$ChopperTasksApiService extends ChopperTasksApiService {
  _$ChopperTasksApiService([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final definitionType = ChopperTasksApiService;

  @override
  Future<Response<List<TaskGroup>>> getTaskGroups() {
    final $url = '/task-groups';
    final $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<List<TaskGroup>, TaskGroup>($request);
  }

  @override
  Future<Response<TaskGroup>> getTaskGroup(String id) {
    final $url = '/task-groups/${id}';
    final $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<TaskGroup, TaskGroup>($request);
  }

  @override
  Future<Response<Task>> getTask(String taskId) {
    final $url = '/tasks/${taskId}';
    final $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<Task, Task>($request);
  }

  @override
  Future<Response<List<Task>>> getTasks(String taskGroupId) {
    final $url = '/task-groups/${taskGroupId}/tasks';
    final $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<List<Task>, Task>($request);
  }

  @override
  Future<Response<dynamic>> reopenTask(String id) {
    final $url = '/tasks/${id}';
    final $request = Request(
      'PUT',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> completeTask(String id) {
    final $url = '/tasks/${id}';
    final $request = Request(
      'PUT',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<Task>> createTask(CreateTask createTask) {
    final $url = '/tasks';
    final $body = createTask;
    final $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<Task, Task>($request);
  }

  @override
  Future<Response<TaskGroup>> createTaskGroup(CreateTaskGroup ctg) {
    final $url = '/task-groups';
    final $body = ctg;
    final $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<TaskGroup, TaskGroup>($request);
  }

  @override
  Future<Response<TaskGroup>> updateTaskGroup(TaskGroup tg) {
    final $url = '/task-groups/update';
    final $body = tg;
    final $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<TaskGroup, TaskGroup>($request);
  }

  @override
  Future<Response<dynamic>> deleteAllTasks() {
    final $url = '/tasks';
    final $request = Request(
      'DELETE',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> deleteAllTaskGroups() {
    final $url = '/task-groups';
    final $request = Request(
      'DELETE',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }
}
