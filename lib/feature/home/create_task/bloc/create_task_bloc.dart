import 'package:bloc/bloc.dart';
import 'package:flutter_template/data/repository/tasks/tasks_repository.dart';
import 'package:flutter_template/log/log.dart';

import 'create_task_state.dart';

class CreateTaskCubit extends Cubit<CreateTaskState> {
  final TasksRepository _tasksRepository;

  CreateTaskCubit(this._tasksRepository) : super(AwaitUserInput());

  Future<void> onCreateTask(Task task) async {
    Log.d('CreateTaskBloc - Create Task');
    emit(CreateTaskInProgress());
    try {
      await _tasksRepository.createTask(task);
      emit(CreateTaskSuccess());
    } catch (exp) {
      emit(CreateTaskFailure(error: exp));
    }
  }
}
