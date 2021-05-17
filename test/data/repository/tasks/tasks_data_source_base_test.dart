import 'package:flutter_template/data/data_not_found_exception.dart';
import 'package:flutter_template/data/repository/tasks/tasks_data_source.dart';
import 'package:flutter_template/model/task/task.dart';
import 'package:flutter_template/model/task/task_group.dart';
import 'package:flutter_template/model/task/task_status.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {}

final TaskGroup taskGroup1 = new TaskGroup(
  "task-group-1",
  "Task Group 1",
  List.of(["task-1"]),
);

final TaskGroup taskGroup2 = new TaskGroup(
  "task-group-2",
  "Task Group 2",
  List.of(["task-2", "task-3"]),
);

final TaskGroup taskGroupEmpty = new TaskGroup(
  "task-group-3",
  "Task Group 3",
  [],
);

final Task task1 = new Task(id: "task-1", title: "Task 1", status: DONE);
final Task task2 = new Task(id: "task-2", title: "Task 2", status: NOT_DONE);
final Task task3 = new Task(id: "task-3", title: "Task 3", status: DONE);

/// Base tests for [TasksDataSource]. Grouped in 4 categories: create, read, update, and delete.
void executeTasksDataSourceBaseTests(TasksDataSource createTasksDataSource()) {
  late TasksDataSource tasksDataSource;

  setUp(() {
    tasksDataSource = createTasksDataSource();
  });

  group("Create items", () {
    test("Task-SaveOneFindOne", () async {
      var savedTask = await tasksDataSource.createTask(task1);
      var retrievedTask = await tasksDataSource.getTask("task-1");

      expect(savedTask, equals(task1));
      expect(retrievedTask, equals(task1));
    });

    test("TaskGroup-SaveOneFindOne", () async {
      var savedTaskGroup = await tasksDataSource.createTaskGroup(taskGroup1);
      var retrievedTaskGroup = await tasksDataSource
          .getTaskGroups()
          .asStream()
          .expand((list) => list)
          .first;

      expect(savedTaskGroup, equals(taskGroup1));
      expect(retrievedTaskGroup, equals(taskGroup1));
    });

    test("Task-SaveDuplicate", () async {
      await tasksDataSource.createTaskGroup(taskGroup1);
      await tasksDataSource.createTask(task1);
      await tasksDataSource.createTask(task1);

      var retrievedTasks = await tasksDataSource.getTasks("task-group-1");

      expect(retrievedTasks, hasLength(equals(1)));
      expect(retrievedTasks.first, equals(task1));
    });

    test("TaskGroup-SaveDuplicate", () async {
      await tasksDataSource.createTaskGroup(taskGroup1);
      await tasksDataSource.createTaskGroup(taskGroup1);

      var retrievedTaskGroups = await tasksDataSource.getTaskGroups();

      expect(retrievedTaskGroups, hasLength(equals(1)));
      expect(retrievedTaskGroups.first, equals(taskGroup1));
    });
  });

  group("Find items", () {
    //Find one and find many are unintentionally tested in SaveOne and SaveMany tests.

    test("TaskGroup-FindEmpty", () async {
      await tasksDataSource.createTaskGroup(taskGroup1);
      await tasksDataSource.deleteAllTaskGroups();

      var taskGroups = await tasksDataSource.getTaskGroups();

      expect(taskGroups, isEmpty);
    });

    test("Task-FindNonExisting", () {
      expect(() => tasksDataSource.getTask("non-existing_id"),
          throwsA(isInstanceOf<DataNotFoundException>()));
    });

    test("TaskGroup-FindNonExisting", () {
      expect(() => tasksDataSource.getTaskGroups(),
          throwsA(isInstanceOf<DataNotFoundException>()));
    });

    test("Task-FindByTaskGroup", () async {
      await tasksDataSource.createTaskGroup(taskGroup2);
      await tasksDataSource.createTask(task2);
      await tasksDataSource.createTask(task3);

      var retrievedTasks = await tasksDataSource.getTasks("task-group-2");

      expect(retrievedTasks, hasLength(equals(2)));
      expect(retrievedTasks, equals(List.of([task2, task3])));
    });

    test("Task-FindNoneInEmptyTaskGroup", () async {
      await tasksDataSource.createTaskGroup(taskGroupEmpty);

      var retrievedTasks = await tasksDataSource.getTasks("task-group-3");

      expect(retrievedTasks, isEmpty);
    });

    test("Task-ThrowErrorIfTasksInGroupAreMissing", () async {
      await tasksDataSource.createTaskGroup(taskGroup2);
      await tasksDataSource.createTask(task2);

      expect(() => tasksDataSource.getTasks("task-group-2"),
          throwsA(isInstanceOf<DataNotFoundException>()));
    });

    test("Task-ThrowErrorIfAllTasksInGroupAreMissing", () async {
      await tasksDataSource.createTaskGroup(taskGroup2);

      expect(() => tasksDataSource.getTasks("task-group-2"),
          throwsA(isInstanceOf<DataNotFoundException>()));
    });

    test("Task-ThrowErrorIfTaskGroupsAreMissing", () async {
      await tasksDataSource.createTaskGroup(taskGroup2);
      await tasksDataSource.createTask(task1);
      await tasksDataSource.createTask(task2);
      await tasksDataSource.createTask(task3);

      expect(() => tasksDataSource.getAllTasksGrouped(),
          throwsA(isInstanceOf<DataNotFoundException>()));
    }, skip: "No way to know this when data comes from backend.");

    test("FindGroupedTasks", () async {
      await tasksDataSource.createTaskGroup(taskGroup1);
      await tasksDataSource.createTaskGroup(taskGroup2);
      await tasksDataSource.createTask(task1);
      await tasksDataSource.createTask(task2);
      await tasksDataSource.createTask(task3);

      Map<TaskGroup, List<Task>> actualValues =
          await tasksDataSource.getAllTasksGrouped();
      Map<TaskGroup, List<Task>> expectedValues = {
        taskGroup1: List.of([task1]),
        taskGroup2: List.of([task2, task3])
      };

      expect(actualValues, equals(expectedValues));
    });
  });

  group("Delete items", () {
    test("DeleteNonExisting", () async {
      await tasksDataSource.deleteAllTaskGroups();
    });

    test("TaskGroup-DeleteAll", () async {
      await tasksDataSource.createTaskGroup(taskGroup1);
      await tasksDataSource.createTaskGroup(taskGroup2);

      await tasksDataSource.deleteAllTaskGroups();
      var retrievedTaskGroups = await tasksDataSource.getTaskGroups();

      expect(retrievedTaskGroups, isEmpty);
    });
  });

  group("Update items", () {
    test("Task-Complete", () async {
      await tasksDataSource.createTask(task1); //pending

      await tasksDataSource.completeTask("task-1"); //done

      var updatedTask = await tasksDataSource.getTask("task-1");
      expect(updatedTask.status, equals(TaskStatus.done));
    });

    test("Task-Reopen", () async {
      await tasksDataSource.createTask(task1); //pending

      await tasksDataSource.reopenTask("task-1"); //pending

      var updatedTask = await tasksDataSource.getTask("task-1");
      expect(updatedTask.status, equals(TaskStatus.notDone));
    });

    test("TaskGroup-AddTask", () async {
      //todo
    }, skip: "Not implemented yet.");

    test("TaskGroup-RemoveTask", () async {
      //todo
    }, skip: "Not implemented yet.");
  });
}
