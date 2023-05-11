import 'dart:async';

import 'package:flutter_template/data/repository/tasks/tasks_data_source.dart';
import 'package:flutter_template/feature/home/task_list/bloc/task_list_state.dart';
import 'package:flutter_template/log/log.dart';
import 'package:flutter_template/model/task/task.dart';
import 'package:flutter_template/model/task/task_event.dart';
import 'package:flutter_template/model/task/task_group.dart';
import 'package:flutter_template/model/task/task_status.dart';
import 'package:flutter_template/util/updates_stream.dart';

export 'package:flutter_template/model/task/task.dart';
export 'package:flutter_template/model/task/task_group.dart';
export 'package:flutter_template/model/task/task_status.dart';

/// Implementation of [TasksDataSource] that uses both remote and cached data when available.
/// Provides data updates stream for a (declarative) UI layer.
///
/// See [taskGroupUpdatesStream] and [taskEventUpdatesStream] for updates stream.
///
/// To obtain an instance use `serviceLocator.get<TasksRepository>()`.
/// Mind that this component is user scoped and serviceLocator.get will
/// work only if there is a user logged in.
class TasksRepository with UpdatesStream<dynamic> implements TasksDataSource {
  final TasksDataSource _remoteDataSource;
  final TasksDataSource _cacheDataSource;

  @override
  final String userId;

  TasksRepository({
    required TasksDataSource remote,
    required TasksDataSource cache,
  })  : assert(remote.userId == cache.userId),
        userId = remote.userId,
        _remoteDataSource = remote,
        _cacheDataSource = cache {
    Log.d('TasksRepository - Init');
  }

  /// Returns a broadcast stream that tracks user's task groups.
  /// When a change occurs a list with the updated task groups is emitted.
  Stream<List<TaskGroup>> get taskGroupUpdatesStream =>
      updates.where((event) => event is List<TaskGroup>).cast();

  /// Returns a broadcast stream that tracks task updates.
  /// Emits a [TaskEvent] depending on the change.
  Stream<TaskEvent> get taskEventUpdatesStream =>
      updates.where((event) => event is TaskEvent).cast<TaskEvent>().distinct();

  Future<void> teardown() async {
    Log.d('TasksRepository - Teardown: Deleting local data');
    await closeUpdatesStream();
    await _cacheDataSource.deleteAllData();
  }

  @override
  Future<void> completeTask(String taskId) => _remoteDataSource
      .completeTask(taskId)
      .then((_) => _cacheDataSource.completeTask(taskId))
      .then((_) => addUpdate(new TaskStatusChangedEvent(taskId, DONE)));

  @override
  Future<void> reopenTask(String taskId) => _remoteDataSource
      .reopenTask(taskId)
      .then((_) => _cacheDataSource.reopenTask(taskId))
      .then((_) => addUpdate(new TaskStatusChangedEvent(taskId, NOT_DONE)));

  @override
  Future<Task> getTask(String taskId) => _cacheDataSource
          .getTask(taskId)
          .catchError((error) => _remoteDataSource.getTask(taskId))
          .then((task) {
        addUpdate(TasksUpdateEvent(affectedTasks: [task.id]));
        return task;
      });

  @override
  Future<List<Task>> getTasks(String taskGroupId) => _cacheDataSource
          .getTasks(taskGroupId)
          .catchError((error) => _remoteDataSource.getTasks(taskGroupId))
          .then((tasks) {
        addUpdate(TasksUpdateEvent(affectedTasks: tasks.map((t) => t.id)));
        return tasks;
      });

  @override
  Future<List<TaskGroup>> getTaskGroups() => _cacheDataSource
          .getTaskGroups()
          .catchError((error) => _remoteDataSource.getTaskGroups())
          .then((taskGroups) {
        addUpdate(taskGroups);
        return taskGroups;
      });

  @override
  Future<Map<TaskGroup, List<Task>>> getAllTasksGrouped() => _cacheDataSource
          .getAllTasksGrouped()
          .catchError((error) => _remoteDataSource.getAllTasksGrouped())
          .then((mappedTasks) async {
        for (var taskGroup in mappedTasks.keys) {
          await _cacheDataSource.createTaskGroup(taskGroup);
        }
        for (var task in mappedTasks.values.expand((element) => element)) {
          await _cacheDataSource.createTask(task);
        }
        return mappedTasks;
      }).then((mappedTasks) {
        addUpdate(List.of(mappedTasks.keys));
        addUpdate(TasksUpdateEvent(
            affectedTasks: mappedTasks.values.fold<List<Task>>(
                [],
                (resultList, tasksBatch) =>
                    resultList..addAll(tasksBatch)).map((task) => task.id)));
        return mappedTasks;
      });

  @override
  Future<Task> createTask(Task createTask) => _remoteDataSource
          .createTask(createTask)
          .then((serverValue) => _cacheDataSource.createTask(serverValue))
          .then((task) {
        addUpdate(TaskCreatedEvent(task));
        return task;
      });

  @override
  Future<TaskGroup> createTaskGroup(TaskGroup createTaskGroup) =>
      _remoteDataSource
          .createTaskGroup(createTaskGroup)
          .then((serverValue) => _cacheDataSource.createTaskGroup(serverValue))
          .whenComplete(() => getTaskGroups());

  @override
  Future<void> deleteAllTaskGroups() => _remoteDataSource
      .deleteAllTaskGroups()
      .then((_) => _cacheDataSource.deleteAllTaskGroups())
      .then((_) => addUpdate(<TaskGroup>[]));

  @override
  Future<void> deleteAllData() => _cacheDataSource.deleteAllData();

  @override
  Future<TaskGroup> updateTaskGroup(final TaskGroup taskGroup) =>
      _remoteDataSource
          .updateTaskGroup(taskGroup)
          .then((_) => _cacheDataSource.updateTaskGroup(taskGroup))
          .then((taskGroup) async {
        addUpdate(new TasksLoadSuccess(await getAllTasksGrouped()));
        return taskGroup;
      });
}
