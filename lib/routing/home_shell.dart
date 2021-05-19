import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_template/data/repository/tasks/tasks_repository.dart';
import 'package:flutter_template/di/service_locator.dart';
import 'package:flutter_template/feature/home/task/bloc/tasks.dart';
import 'package:flutter_template/routing/home_router_delegate.dart';
import 'package:provider/provider.dart';

import 'back_button_dispatcher.dart';
import 'home_state.dart';

class HomeShell extends StatefulWidget {
  @override
  _HomeShellState createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  late HomeState homeState;
  late HomeRouterDelegate _routerDelegate;
  late TasksCubit tasksCubit;

  @override
  void initState() {
    super.initState();
    homeState = Provider.of<HomeState>(context, listen: false);
    _routerDelegate = HomeRouterDelegate(homeState);
    tasksCubit = TasksCubit(serviceLocator.get<TasksRepository>());
  }

  @override
  Widget build(BuildContext context) {
    final AppBackButtonDispatcher _backButtonDispatcher =
        AppBackButtonDispatcher(_routerDelegate);
    return BlocProvider(
      create: (BuildContext context) => tasksCubit..loadTasks("taskGroupId"),
      child: Router(
        routerDelegate: _routerDelegate,
        backButtonDispatcher: _backButtonDispatcher,
      ),
    );
  }
}
