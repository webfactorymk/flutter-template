import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_template/data/repository/tasks/tasks_repository.dart';
import 'package:flutter_template/di/service_locator.dart';
import 'package:flutter_template/feature/home/task_list/bloc/task_list_bloc.dart';
import 'package:flutter_template/feature/home/task_list/ui/task_list_view.dart';

class TaskListPage extends Page {
  @override
  Route createRoute(BuildContext context) {
    return MaterialPageRoute(
      settings: this,
      builder: (BuildContext context) => BlocProvider<TaskListBloc>(
        create: (BuildContext context) =>
            TaskListBloc(serviceLocator.get<TasksRepository>()),
        child: TaskListView(),
      ),
    );
  }
}
