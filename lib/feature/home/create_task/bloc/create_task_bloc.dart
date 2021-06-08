import 'package:bloc/bloc.dart';
import 'package:flutter_template/data/repository/tasks/tasks_repository.dart';
import 'package:flutter_template/log/log.dart';

import 'create_task_event.dart';
import 'create_task_state.dart';

class CreateTaskBloc extends Bloc<CreateTaskEvent, CreateTaskState> {
  final TasksRepository _tasksRepository;

  CreateTaskBloc(this._tasksRepository) : super(CreateTaskInitial());

  @override
  Stream<CreateTaskState> mapEventToState(CreateTaskEvent event) async* {
    if (event is CreateTask) {
      Log.d('CreateTaskBloc - Create Task');
      yield CreateTaskInProgress();
      try {
        await _tasksRepository.createTask(event.task);
        yield CreateTaskSuccess();
      } catch (exp) {
        emit(CreateTaskFailure(error: exp));
      }
    }
  }
}
