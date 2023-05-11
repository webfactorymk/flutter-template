import 'package:flutter_template/model/task/task.dart';
import 'package:flutter_template/model/task/task_group.dart';

/// Main entry point for accessing and manipulating tasks data.
abstract class TasksDataSource {
  abstract final String userId;

  /// Get all task groups for the logged in user.
  Future<List<TaskGroup>> getTaskGroups();

  /// Get all tasks belonging to a task group.
  ///
  /// Throws [DataNotFoundException] unless ALL tasks are retrieved.
  Future<List<Task>> getTasks(String taskGroupId);

  /// Find a task by id.
  ///
  /// Throws [DataNotFoundException] if the tasks could not be found.
  Future<Task> getTask(String taskId);

  /// Mark a [Task] as done.
  ///
  /// Throws [DataNotFoundException] if the tasks could not be found.
  Future<void> completeTask(String taskId);

  /// Mark a [Task] as not done.
  ///
  /// Throws [DataNotFoundException] if the tasks could not be found.
  Future<void> reopenTask(String taskId);

  /// Gets all tasks grouped by TaskGroup.
  Future<Map<TaskGroup, List<Task>>> getAllTasksGrouped();

  /// Creates a new [Task]. [Task.id] is overwritten by server.
  Future<Task> createTask(Task createTask);

  /// Creates a new [TaskGroup]. [TaskGroup.id] is overwritten by server.
  Future<TaskGroup> createTaskGroup(TaskGroup createTaskGroup);

  /// Updates taskIds in given task group.
  Future<TaskGroup> updateTaskGroup(final TaskGroup taskGroup);

  /// Deletes all task groups.
  Future<void> deleteAllTaskGroups();

  /// Deletes all user data.
  Future<void> deleteAllData();
}
