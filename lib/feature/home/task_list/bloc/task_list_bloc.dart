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
    add(LoadTasks());
  }

  @override
  Stream<TaskListState> mapEventToState(TaskListEvent event) async* {
    if (event is LoadTasks) {
      Log.d('TasksCubit - Load all tasks');
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
        add(LoadTasks());
      } catch (error) {
        yield TaskOpFailure(state, event.task, error);
      }
    } else if (event is TaskReopened) {
      try {
        await _tasksRepository.reopenTask(event.task.id);
        add(LoadTasks());
      } catch (error) {
        yield TaskOpFailure(state, event.task, error);
      }
    } else if (event is TasksReordered) {
      yield TasksLoadInProgress();
      List<String> reorderedList = List.from(event.key.taskIds);
      String reorderedValue = reorderedList.removeAt(event.oldIndex);
      int newIndex = event.newIndex;
      if(event.newIndex > event.oldIndex) newIndex--;
      reorderedList.insert(newIndex, reorderedValue);

      await _tasksRepository
          .updateTaskGroup(event.key.copy(newTaskIds: reorderedList));

      Map<TaskGroup, List<Task>> orderedTasks =
          await _tasksRepository.getAllTasksGrouped();
      yield TasksLoadSuccess(orderedTasks);
    } else if (event is Logout) {
      await _userManager.logout();
    }
  }
}
