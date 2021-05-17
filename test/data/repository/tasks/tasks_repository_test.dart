import 'dart:async';

import 'package:flutter_template/data/repository/tasks/tasks_cache_data_source.dart';
import 'package:flutter_template/data/repository/tasks/tasks_data_source.dart';
import 'package:flutter_template/data/repository/tasks/tasks_repository.dart';
import 'package:flutter_template/model/task/task_event.dart';
import 'package:flutter_template/model/task/task_group.dart';
import 'package:flutter_template/model/task/task_status.dart';
import 'package:flutter_test/flutter_test.dart';

import 'tasks_data_source_base_test.dart';
import 'tasks_stub_data_source.dart';

/// Tests for [TasksRepository].
void main() {
  late TasksRepository tasksRepository;
  late TasksDataSource tasksCacheDataSource;
  final TasksDataSource stubDataSource = new TasksStubDataSource();

  setUp(() {
    tasksCacheDataSource = TasksCacheDataSource('userId');
    tasksRepository = TasksRepository(
      cache: tasksCacheDataSource,
      remote: stubDataSource,
    );
  });

  tearDown(() async {
    await tasksRepository.teardown();
  });

  executeTasksDataSourceBaseTests(() =>
      TasksRepository(cache: tasksCacheDataSource, remote: stubDataSource));

  group("UpdatesStreamTests", () {
    test("IsStreamBroadcast", () {
      Stream<List<TaskGroup>> taskGroupUpdatesStream =
          tasksRepository.taskGroupUpdatesStream;
      Stream<TaskEvent> taskEventUpdatesStream =
          tasksRepository.taskEventUpdatesStream;

      expect(taskGroupUpdatesStream.isBroadcast, isTrue);
      expect(taskEventUpdatesStream.isBroadcast, isTrue);
    });

    test("TaskCreate-UpdatesStream", () async {
      tasksRepository.taskEventUpdatesStream.listen(expectAsync1((taskEvent) {
        print(taskEvent);
        expect(taskEvent, equals(TaskCreatedEvent(task1)));
      }));

      await tasksRepository.createTask(task1);
    }, timeout: Timeout(Duration(seconds: 1)));

    test("TaskStatusChangeEvent-UpdatesStream", () async {
      expect(
          tasksRepository.taskEventUpdatesStream,
          emitsInOrder([
            TaskCreatedEvent(task2),
            TaskStatusChangedEvent('task-2', TaskStatus.done)
          ]));

      await tasksRepository.createTask(task2);
      await tasksRepository.completeTask('task-2');
    }, timeout: Timeout(Duration(seconds: 1)));

    test("TaskGroupCreate-UpdatesStream", () async {
      expect(
          tasksRepository.taskGroupUpdatesStream,
          emitsInOrder([
            List.of([taskGroup1]),
          ]));

      await tasksRepository.createTaskGroup(taskGroup1);
    }, timeout: Timeout(Duration(seconds: 1)));

    test("TaskGroupCreateMultipleIdentical-UpdatesStream", () async {
      expect(
          tasksRepository.taskGroupUpdatesStream,
          emitsInOrder([
            List.of([taskGroup1]),
          ]));

      await tasksRepository.createTaskGroup(taskGroup1);
      await tasksRepository.createTaskGroup(taskGroup1);
    }, timeout: Timeout(Duration(seconds: 1)));

    test("TaskGroupDelete-UpdatesStream", () async {
      await tasksRepository.createTaskGroup(taskGroup1);

      expect(
          tasksRepository.taskGroupUpdatesStream,
          emitsInOrder([
            <TaskGroup>[],
          ]));

      await tasksRepository.deleteAllTaskGroups();
    }, timeout: Timeout(Duration(seconds: 1)));

    test("UpdatesStream-MultipleSubscribers", () async {
      expect(
          tasksRepository.taskGroupUpdatesStream,
          emitsInOrder([
            List.of([taskGroup1]),
          ]));
      expect(
          tasksRepository.taskGroupUpdatesStream,
          emitsInOrder([
            List.of([taskGroup1]),
          ]));

      await tasksRepository.createTaskGroup(taskGroup1);
    }, timeout: Timeout(Duration(seconds: 1)));

    test("UpdatesStream-OpenCloseOpen", () async {
      Stream<List<TaskGroup>> updatesStream =
          tasksRepository.taskGroupUpdatesStream;
      StreamSubscription<List<TaskGroup>>? subscription;
      subscription = updatesStream.listen(expectAsync1((taskGroups) {
        print(taskGroups);
        expect(taskGroups, List.of([taskGroup1]));
        subscription!.cancel();
      }));

      subscription.pause();

      await tasksRepository.createTaskGroup(taskGroup1);

      subscription.resume();
    }, timeout: Timeout(Duration(seconds: 1)));

    test("UpdatesStream-OpenCloseMultipleSubscribers", () async {
      tasksRepository.taskGroupUpdatesStream.listen(expectAsync1((taskGroups) {
        print(taskGroups);
        expect(taskGroups, List.of([taskGroup1]));
      }));
      var subscription = tasksRepository.taskGroupUpdatesStream
          .listen(expectAsync1((taskGroups) {
        print(taskGroups);
        fail("Must not be called.");
      }, count: 0));

      subscription.cancel();

      await tasksRepository.createTaskGroup(taskGroup1);
    }, timeout: Timeout(Duration(seconds: 1)));

    test("Distinct results-UpdatesStream", () async {
      expect(
          tasksRepository.taskEventUpdatesStream,
          emitsInOrder([
            TaskCreatedEvent(task2),
            TaskStatusChangedEvent('task-2', TaskStatus.done)
          ]));

      await tasksRepository.createTask(task2);
      await tasksRepository.createTask(task2);
      await tasksRepository.completeTask(task2.id);
    }, timeout: Timeout(Duration(seconds: 1)));
  });
}
