import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

  @override
  void initState() {
    super.initState();
    homeState = Provider.of<HomeState>(context, listen: false);
    _routerDelegate = HomeRouterDelegate(homeState);
    BlocProvider.of<TasksCubit>(context).loadTasks("taskGroupId");
  }

  @override
  Widget build(BuildContext context) {
    final AppBackButtonDispatcher _backButtonDispatcher =
        AppBackButtonDispatcher(_routerDelegate);
    return Scaffold(
      appBar: AppBar(),
      body: Router(
        routerDelegate: _routerDelegate,
        backButtonDispatcher: _backButtonDispatcher,
      ),
    );
  }
}
