import 'package:bloc/bloc.dart';
import 'package:flutter_template/data/repository/tasks/tasks_repository.dart';
import 'package:flutter_template/feature/home/router/home_router_delegate.dart';
import 'package:flutter_template/log/logger.dart';

import 'task_list_event.dart';
import 'task_list_state.dart';

export 'task_list_event.dart';
export 'task_list_state.dart';

class TaskListBloc extends Bloc<TaskListEvent, TaskListState> {
  final TasksRepository _tasksRepository;

  TaskListBloc(this._tasksRepository) : super(TasksLoadInProgress()) {
    add(LoadTasks());
  }

  @override
  Stream<TaskListState> mapEventToState(TaskListEvent event) async* {
    if (event is LoadTasks) {
      Logger.d('TasksCubit - Load all tasks');
      yield TasksLoadInProgress();
      try {
        final tasks = await _tasksRepository.getAllTasksGrouped();
        yield TasksLoadSuccess(tasks);
      } catch (exp) {
        emit(TasksLoadFailure(error: exp));
      }
    } else if (event is TaskCompleted) {
      try {
        await _tasksRepository.completeTask(event.task.id);
      } catch (error) {
        yield TaskOpFailure(state, event.task, error);
      }
    } else if (event is TaskReopened) {
      try {
        await _tasksRepository.reopenTask(event.task.id);
      } catch (error) {
        yield TaskOpFailure(state, event.task, error);
      }
    }
  }
}
