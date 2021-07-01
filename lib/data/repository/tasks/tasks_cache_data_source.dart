import 'package:flutter_template/data/data_not_found_exception.dart';
import 'package:flutter_template/model/task/task.dart';
import 'package:flutter_template/model/task/task_group.dart';
import 'package:flutter_template/model/task/task_status.dart';

import 'tasks_data_source.dart';

/// Implementation of [TasksRepository] that uses stores tasks in memory.
class TasksCacheDataSource implements TasksDataSource {
  Map<String, TaskGroup>? _taskGroups;
  Map<String, Task>? _tasks;

  @override
  final String userId;

  TasksCacheDataSource(this.userId);

  @override
  Future<void> completeTask(String taskId) {
    return Future.microtask(() {
      final tasks = _tasks;
      if (tasks != null && tasks.containsKey(taskId)) {
        tasks[taskId] = tasks[taskId]!.changeStatus(TaskStatus.done);
      } else {
        throw DataNotFoundException("A task with id: '$taskId' was not found.");
      }
    });
  }

  @override
  Future<void> reopenTask(String taskId) {
    return Future.microtask(() {
      final tasks = _tasks;
      if (tasks != null && tasks.containsKey(taskId)) {
        tasks[taskId] = tasks[taskId]!.changeStatus(TaskStatus.notDone);
      } else {
        throw DataNotFoundException("A task with id: '$taskId' was not found.");
      }
    });
  }

  @override
  Future<Task> getTask(String taskId) {
    return Future.microtask(() =>
        (_tasks ?? const {})[taskId] ??
        (throw DataNotFoundException(
            "A task with id: '$taskId' was not found.")));
  }

  @override
  Future<List<TaskGroup>> getTaskGroups() {
    return Future.microtask(() =>
        _taskGroups?.values.toList(growable: false) ??
        (throw DataNotFoundException("Task groups not set.")));
  }

  @override
  Future<List<Task>> getTasks(String taskGroupId) {
    return Future.microtask(() {
      if (_taskGroups == null) {
        throw DataNotFoundException("Task groups not set.");
      }
      TaskGroup? taskGroup = _taskGroups![taskGroupId];
      if (taskGroup != null) {
        if (taskGroup.taskIds.isNotEmpty && _tasks == null) {
          throw DataNotFoundException("Tasks not set.");
        }
        List<Task> tasksForTaskGroup = [];
        Task? currentTask;
        for (String taskId in taskGroup.taskIds) {
          currentTask = _tasks![taskId];
          if (currentTask != null) {
            tasksForTaskGroup.add(currentTask);
          } else {
            throw DataNotFoundException(
                "Missing tasks for task group with id: '$taskGroupId'");
          }
        }
        return tasksForTaskGroup;
      } else {
        throw new DataNotFoundException(
            "A task group with id: $taskGroupId was not found.");
      }
    });
  }

  @override
  Future<Map<TaskGroup, List<Task>>> getAllTasksGrouped() async {
    if (_taskGroups == null || _tasks == null) {
      throw DataNotFoundException("Data not set.");
    }
    int taskCount = 0;
    _taskGroups!.values
        .forEach((taskGroup) => taskCount += taskGroup.taskIds.length);
    if (taskCount != _tasks!.values.length) {
      throw DataNotFoundException("Missing task groups in dataset.");
    }

    Map<TaskGroup, List<Task>> resultMap = new Map();
    for (TaskGroup taskGroup in _taskGroups!.values) {
      resultMap[taskGroup] = await getTasks(taskGroup.id);
    }
    return resultMap;
  }

  @override
  Future<Task> createTask(Task createTask) {
    return Future.microtask(() {
      if (_tasks == null) {
        _tasks = new Map();
      }
      _tasks![createTask.id] = createTask;
      return createTask;
    });
  }

  @override
  Future<TaskGroup> createTaskGroup(TaskGroup createTaskGroup) {
    return Future.microtask(() {
      if (_taskGroups == null) {
        _taskGroups = new Map();
      }
      _taskGroups![createTaskGroup.id] = createTaskGroup;
      return createTaskGroup;
    });
  }

  @override
  Future<void> deleteAllTaskGroups() =>
      Future.microtask(() => _taskGroups?.clear());

  @override
  Future<void> deleteAllData() => Future.microtask(() {
        _tasks?.clear();
        _taskGroups?.clear();
      });

  @override
  Future<TaskGroup> updateTaskGroup(final TaskGroup taskGroup) {
    return Future.microtask(
        () => (_taskGroups ?? const {})[taskGroup.id] = taskGroup);
  }
}
