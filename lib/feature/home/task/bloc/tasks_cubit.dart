import 'package:bloc/bloc.dart';
import 'package:flutter_template/data/repository/tasks/tasks_repository.dart';
import 'package:flutter_template/log/logger.dart';
import 'package:flutter_template/model/task/task.dart';

import 'tasks_state.dart';

class TasksCubit extends Cubit<TasksState> {
  final TasksRepository tasksRepository;

  TasksCubit(this.tasksRepository) : super(TasksInitial());

  Future<void> loadTasks(String taskGroupId) async {
    Logger.d('TasksCubit - load tasks');
    emit(TasksLoadInProgress());

    List<Task> tasks = await tasksRepository.getTasks(taskGroupId);
    emit(TasksLoadSuccess(tasks));
  }
}
