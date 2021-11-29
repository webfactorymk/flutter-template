import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter_template/data/repository/tasks/tasks_repository.dart';
import 'package:flutter_template/log/log.dart';
import 'package:flutter_template/user/user_manager.dart';

import 'task_list_event.dart';
import 'task_list_state.dart';

export 'task_list_event.dart';
export 'task_list_state.dart';

class TaskListBloc extends Bloc<TaskListEvent, TaskListState> {
  final TasksRepository _tasksRepository;
  final UserManager _userManager;

  TaskListBloc(this._tasksRepository, this._userManager)
      : super(TasksLoadInProgress()) {
    on<LoadTasks>(_onLoadTasks);
    on<TaskCompleted>(_onTaskCompleted);
    on<TaskReopened>(_onTaskReopened);
    on<TasksReordered>(_onTasksReordered);
    on<Logout>(_onLogout);
  }

  FutureOr<void> _onLoadTasks(
      LoadTasks event, Emitter<TaskListState> emit) async {
    Log.d('TasksCubit - Load all tasks');
    emit(TasksLoadInProgress());
    try {
      final tasks = await _tasksRepository.getAllTasksGrouped();
      emit(TasksLoadSuccess(tasks));
    } catch (exp) {
      emit(TasksLoadFailure(error: exp));
    }
  }

  FutureOr<void> _onTaskCompleted(
      TaskCompleted event, Emitter<TaskListState> emit) async {
    try {
      await _tasksRepository.completeTask(event.task.id);
      add(LoadTasks());
    } catch (error) {
      emit(TaskOpFailure(state, event.task, error));
    }
  }

  FutureOr<void> _onTaskReopened(
      TaskReopened event, Emitter<TaskListState> emit) async {
    try {
      await _tasksRepository.reopenTask(event.task.id);
      add(LoadTasks());
    } catch (error) {
      emit(TaskOpFailure(state, event.task, error));
    }
  }

  FutureOr<void> _onTasksReordered(
      TasksReordered event, Emitter<TaskListState> emit) async {
    emit(TasksLoadInProgress());
    List<String> reorderedList = List.from(event.key.taskIds);
    String reorderedValue = reorderedList.removeAt(event.oldIndex);
    int newIndex = event.newIndex;
    if (event.newIndex > event.oldIndex) newIndex--;
    reorderedList.insert(newIndex, reorderedValue);

    await _tasksRepository
        .updateTaskGroup(event.key.copy(newTaskIds: reorderedList));

    Map<TaskGroup, List<Task>> orderedTasks =
        await _tasksRepository.getAllTasksGrouped();
    emit(TasksLoadSuccess(orderedTasks));
  }

  FutureOr<void> _onLogout(Logout event, Emitter<TaskListState> emit) async {
    await _userManager.logout();
  }
}
